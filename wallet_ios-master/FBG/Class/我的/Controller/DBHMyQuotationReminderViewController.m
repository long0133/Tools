//
//  DBHMyQuotationReminderViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/23.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHMyQuotationReminderViewController.h"

#import "DBHQuotationReminderPromptView.h"
#import "DBHMyQuotationReminderTableViewCell.h"

#import "DBHInformationDataModels.h"

static NSString *const kDBHMyQuotationReminderTableViewCellIdentifier = @"kDBHMyQuotationReminderTableViewCellIdentifier";

@interface DBHMyQuotationReminderViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DBHQuotationReminderPromptView *quotationReminderPromptView;

@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation DBHMyQuotationReminderViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = DBHGetStringWithKeyFromTable(@"My Notifications", nil);
    self.view.backgroundColor = LIGHT_WHITE_BGCOLOR;
    
    [self setUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getQuotationReminderList];
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.view addSubview:self.tableView];
    
    WEAKSELF
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.view);
        make.center.equalTo(weakSelf.view);
    }];
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHMyQuotationReminderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHMyQuotationReminderTableViewCellIdentifier forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAKSELF
    // 编辑
    UITableViewRowAction *editColletAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:DBHGetStringWithKeyFromTable(@"Edit", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        DBHInformationModelData *model = self.dataSource[indexPath.row];
        weakSelf.selectedRow = indexPath.row;
        weakSelf.quotationReminderPromptView.maxPrice = model.categoryUser.marketHige;
        weakSelf.quotationReminderPromptView.minPrice = model.categoryUser.marketLost;
        [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.quotationReminderPromptView];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.quotationReminderPromptView animationShow];
        });
    }];
    editColletAction.backgroundColor = COLORFROM16(0x008C55, 1);
    
    // 删除
    UITableViewRowAction *deleteColletAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:DBHGetStringWithKeyFromTable(@"Cancel Collection", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        weakSelf.selectedRow = indexPath.row;
        [weakSelf remindSetWithMaxPrice:@"0" minPrice:@"0"];
    }];
    deleteColletAction.backgroundColor = MAIN_ORANGE_COLOR;
    
    return @[deleteColletAction, editColletAction];
}

#pragma mark ------ Data ------
/**
 获取行情提醒列表
 */
- (void)getQuotationReminderList {
    WEAKSELF
    [PPNetworkHelper GET:@"category?user_follow" baseUrlType:3 parameters:nil hudString:nil responseCache:^(id responseCache) {
        if (weakSelf.dataSource.count) {
            return ;
        }
        [weakSelf.dataSource removeAllObjects];
        
        for (NSDictionary *dic in responseCache[@"data"]) {
            DBHInformationModelData *model = [DBHInformationModelData modelObjectWithDictionary:dic];
            
            [weakSelf.dataSource addObject:model];
        }
        
        [weakSelf.tableView reloadData];
    } success:^(id responseObject) {
        [weakSelf.dataSource removeAllObjects];
        
        for (NSDictionary *dic in responseObject[@"data"]) {
            DBHInformationModelData *model = [DBHInformationModelData modelObjectWithDictionary:dic];
            
            [weakSelf.dataSource addObject:model];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    } specialBlock:^{
        
    }];
}
/**
 行情提醒
 */
- (void)remindSetWithMaxPrice:(NSString *)maxPrice minPrice:(NSString *)minPrice {
    BOOL isReminder = maxPrice.doubleValue || minPrice.doubleValue;
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:@(isReminder) forKey:@"is_market_follow"];
    if (isReminder) {
        [paramters setObject:maxPrice.length ? maxPrice : @"0" forKey:@"market_hige"];
        [paramters setObject:minPrice.length ? minPrice : @"0" forKey:@"market_lost"];
    }
    
    DBHInformationModelData *model = self.dataSource[self.selectedRow];
    WEAKSELF
    [PPNetworkHelper PUT:[NSString stringWithFormat:@"category/%ld/follow", (NSInteger)model.dataIdentifier] baseUrlType:3 parameters:[paramters copy] hudString:nil success:^(id responseObject) {
        if (isReminder) {
            [LCProgressHUD showSuccess:DBHGetStringWithKeyFromTable(@"Set Success", nil)];
            [weakSelf getQuotationReminderList];
        } else {
            [weakSelf.dataSource removeObjectAtIndex:weakSelf.selectedRow];
            [weakSelf.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.selectedRow inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    }];
}

#pragma mark ------ Getters And Setters ------
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = WHITE_COLOR;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
        _tableView.rowHeight = AUTOLAYOUTSIZE(70.5);
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHMyQuotationReminderTableViewCell class] forCellReuseIdentifier:kDBHMyQuotationReminderTableViewCellIdentifier];
    }
    return _tableView;
}
- (DBHQuotationReminderPromptView *)quotationReminderPromptView {
    if (!_quotationReminderPromptView) {
        _quotationReminderPromptView = [[DBHQuotationReminderPromptView alloc] init];
        
        WEAKSELF
        [_quotationReminderPromptView commitBlock:^(NSString *maxValue, NSString *minValue) {
            [weakSelf remindSetWithMaxPrice:maxValue minPrice:minValue];
        }];
    }
    return _quotationReminderPromptView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
