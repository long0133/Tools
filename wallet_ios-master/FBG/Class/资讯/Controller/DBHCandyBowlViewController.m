//
//  DBHCandyBowlViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/29.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHCandyBowlViewController.h"

#import "DBHFunctionalUnitLookViewController.h"
#import "DBHCandyBowlDetailViewController.h"

#import "DBHCandyBowlHeaderView.h"
#import "DBHCandyBowlTableViewCell.h"

#import "DBHCandyBowlDataModels.h"

static NSString *const kDBHCandyBowlTableViewCellIdentifier = @"kDBHCandyBowlTableViewCellIdentifier";

@interface DBHCandyBowlViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) DBHCandyBowlHeaderView *candyBowlHeaderView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *grayLineView;
@property (nonatomic, strong) UIButton *yourOpinionButton;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *month;
@property (nonatomic, copy) NSString *day;
@property (nonatomic, strong) NSMutableArray *monthDataSource;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation DBHCandyBowlViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.dateFormatter setDateFormat:@"yyyy"];
    self.year = [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    [self.dateFormatter setDateFormat:@"MM"];
    self.month = [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    [self.dateFormatter setDateFormat:@"dd"];
    self.day = [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    
    [self setUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getMontyExchangeNotice];
    [self getExchangeNotice];
}

#pragma mark ------ UI ------
- (void)setUI {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"xiangmuzhuye_ren_ico"] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToPersonBarButtonItem)];
    
    [self.view addSubview:self.tableView];
//    [self.view addSubview:self.grayLineView];
    //[self.view addSubview:self.yourOpinionButton];
    
    WEAKSELF
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view);
//        make.bottom.equalTo(weakSelf.grayLineView.mas_top);
        make.bottom.equalTo(weakSelf.view);
    }];
//    [self.grayLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(weakSelf.view);
//        make.height.offset(AUTOLAYOUTSIZE(1));
//        make.centerX.equalTo(weakSelf.view);
//        make.bottom.equalTo(weakSelf.yourOpinionButton.mas_top);
//    }];
    //    [self.yourOpinionButton mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(weakSelf.view);
//        make.height.offset(AUTOLAYOUTSIZE(47));
//        make.centerX.bottom.equalTo(weakSelf.view);
//    }];
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHCandyBowlTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHCandyBowlTableViewCellIdentifier forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHCandyBowlDetailViewController *candyBowlDetailViewController = [[DBHCandyBowlDetailViewController alloc] init];
    candyBowlDetailViewController.model = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:candyBowlDetailViewController animated:YES];
}

#pragma mark ------ Data ------
/**
 获取CandyBowl
 */
- (void)getMontyExchangeNotice {
    WEAKSELF
    NSDictionary *paramters = @{@"year":@(self.year.integerValue),
                                @"month":@(self.month.integerValue)};
    [PPNetworkHelper GET:@"candy_bow" baseUrlType:3 parameters:paramters hudString:nil responseCache:^(id responseCache) {
        [weakSelf.monthDataSource removeAllObjects];
        
        for (NSDictionary *dic in responseCache[LIST][@"data"]) {
            DBHCandyBowlModelData *model = [DBHCandyBowlModelData modelObjectWithDictionary:dic];
            
            [weakSelf.monthDataSource addObject:[NSString stringWithFormat:@"%ld", (NSInteger)model.day]];
        }
        
        weakSelf.candyBowlHeaderView.monthArray = [weakSelf.monthDataSource copy];
    } success:^(id responseObject) {
        [weakSelf.monthDataSource removeAllObjects];
        
        for (NSDictionary *dic in responseObject[LIST][@"data"]) {
            DBHCandyBowlModelData *model = [DBHCandyBowlModelData modelObjectWithDictionary:dic];
            
            [weakSelf.monthDataSource addObject:[NSString stringWithFormat:@"%ld", (NSInteger)model.day]];
        }
        
        weakSelf.candyBowlHeaderView.monthArray = [weakSelf.monthDataSource copy];
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    } specialBlock:nil];
}
/**
 获取CandyBowl
 */
- (void)getExchangeNotice {
    WEAKSELF
    NSDictionary *paramters = @{@"year":@(self.year.integerValue),
                                @"month":@(self.month.integerValue),
                                @"day":@(self.day.integerValue)};
    [PPNetworkHelper GET:@"candy_bow" baseUrlType:3 parameters:paramters hudString:nil responseCache:^(id responseCache) {
        [weakSelf.dataSource removeAllObjects];

        for (NSDictionary *dic in responseCache[LIST][@"data"]) {
            DBHCandyBowlModelData *model = [DBHCandyBowlModelData modelObjectWithDictionary:dic];

            [weakSelf.dataSource addObject:model];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.candyBowlHeaderView.isNoData = !weakSelf.dataSource.count;
            [weakSelf.tableView reloadData];
        });
    } success:^(id responseObject) {
        [weakSelf.dataSource removeAllObjects];

        for (NSDictionary *dic in responseObject[LIST][@"data"]) {
            DBHCandyBowlModelData *model = [DBHCandyBowlModelData modelObjectWithDictionary:dic];

            [weakSelf.dataSource addObject:model];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.candyBowlHeaderView.isNoData = !weakSelf.dataSource.count;
            [weakSelf.tableView reloadData];
        });
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    } specialBlock:nil];
}

#pragma mark ------ Event Responds ------
/**
 项目查看
 */
- (void)respondsToPersonBarButtonItem {
    DBHFunctionalUnitLookViewController *functionalUnitLookViewController = [[DBHFunctionalUnitLookViewController alloc] init];
    functionalUnitLookViewController.title = self.title;
    functionalUnitLookViewController.functionalUnitType = self.functionalUnitType;
    [self.navigationController pushViewController:functionalUnitLookViewController animated:YES];
}
/**
 你的观点
 */
- (void)respondsToYourOpinionButton {
    if ([self.conversation isKindOfClass:[EMConversation class]]) {
        // 内存中有会话
        EaseMessageViewController *chatViewController = [[EaseMessageViewController alloc] initWithConversationChatter:self.conversation.conversationId conversationType:self.conversation.type];
        chatViewController.title = self.title;
        [self.navigationController pushViewController:chatViewController animated:YES];
    } else {
        // 内存中没有会话
        EMError *error = nil;
        NSArray *myGroups = [[EMClient sharedClient].groupManager getJoinedGroupsFromServerWithPage:1 pageSize:50 error:&error];
        if (!error) {
            for (EMGroup *group in myGroups) {
                if ([group.subject containsString:@"SYS_MSG_CANDYBOW"]) {
                    EaseMessageViewController *chatViewController = [[EaseMessageViewController alloc] initWithConversationChatter:group.groupId conversationType:EMConversationTypeGroupChat];
                    chatViewController.title = self.title;
                    [self.navigationController pushViewController:chatViewController animated:YES];
                }
            }
        }
    }
}

#pragma mark ------ Getters And Setters ------
- (DBHCandyBowlHeaderView *)candyBowlHeaderView {
    if (!_candyBowlHeaderView) {
        _candyBowlHeaderView = [[DBHCandyBowlHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, AUTOLAYOUTSIZE(396.5))];
        
        WEAKSELF
        [_candyBowlHeaderView selectedDateBlock:^(NSDate *date) {
            [weakSelf.dateFormatter setDateFormat:@"yyyy"];
            weakSelf.year = [self.dateFormatter stringFromDate:date];
            [weakSelf.dateFormatter setDateFormat:@"MM"];
            weakSelf.month = [self.dateFormatter stringFromDate:date];
            [weakSelf.dateFormatter setDateFormat:@"dd"];
            weakSelf.day = [self.dateFormatter stringFromDate:date];
            
            [weakSelf getExchangeNotice];
        }];
        [_candyBowlHeaderView monthChangeBlock:^{
            [weakSelf getMontyExchangeNotice];
        }];
    }
    return _candyBowlHeaderView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = BACKGROUNDCOLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.tableHeaderView = self.candyBowlHeaderView;
        
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
        
        _tableView.rowHeight = AUTOLAYOUTSIZE(91);
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHCandyBowlTableViewCell class] forCellReuseIdentifier:kDBHCandyBowlTableViewCellIdentifier];
    }
    return _tableView;
}
- (UIView *)grayLineView {
    if (!_grayLineView) {
        _grayLineView = [[UIView alloc] init];
        _grayLineView.backgroundColor = COLORFROM16(0xDEDEDE, 1);
    }
    return _grayLineView;
}
- (UIButton *)yourOpinionButton {
    if (!_yourOpinionButton) {
        _yourOpinionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _yourOpinionButton.titleLabel.font = FONT(14);
        [_yourOpinionButton setTitle:DBHGetStringWithKeyFromTable(@"Your Opinion", nil) forState:UIControlStateNormal];
        [_yourOpinionButton setTitleColor:COLORFROM16(0x626262, 1) forState:UIControlStateNormal];
        [_yourOpinionButton addTarget:self action:@selector(respondsToYourOpinionButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _yourOpinionButton;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}
- (NSMutableArray *)monthDataSource {
    if (!_monthDataSource) {
        _monthDataSource = [NSMutableArray array];
    }
    return _monthDataSource;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
