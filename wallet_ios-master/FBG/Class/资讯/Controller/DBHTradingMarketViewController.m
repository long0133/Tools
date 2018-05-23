//
//  DBHTradingMarketViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/31.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHTradingMarketViewController.h"

#import "DBHTradingMarketTableViewCell.h"

#import "DBHTradingMarketDataModels.h"

static NSString *const kDBHTradingMarketTableViewCellIdentifier = @"kDBHTradingMarketTableViewCellIdentifier";

@interface DBHTradingMarketViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *grayLineView;
@property (nonatomic, strong) UIButton *yourOpinionButton;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation DBHTradingMarketViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getInfomation];
}

#pragma mark ------ UI ------
- (void)setUI {
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
    DBHTradingMarketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHTradingMarketTableViewCellIdentifier forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (row < self.dataSource.count) {
        DBHTradingMarketModelData *data = self.dataSource[row];
        
        KKWebView *webView = [[KKWebView alloc] initWithUrl:data.url];
        webView.title = data.pair;
        [self.navigationController pushViewController:webView animated:YES];
    }
}

#pragma mark ------ Data ------
/**
 获取TradingView数据
 */
- (void)getInfomation {
    WEAKSELF
    [PPNetworkHelper GET:[NSString stringWithFormat:@"ico/markets/%@/all", self.title] baseUrlType:3 parameters:nil hudString:nil responseCache:^(id responseCache) {
        if (weakSelf.dataSource.count) {
            return ;
        }
        
        [weakSelf.dataSource removeAllObjects];
        
        for (NSDictionary *dic in responseCache) {
            DBHTradingMarketModelData *model = [DBHTradingMarketModelData modelObjectWithDictionary:dic];
            
            [weakSelf.dataSource addObject:model];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    } success:^(id responseObject) {
        [weakSelf.dataSource removeAllObjects];
        
        for (NSDictionary *dic in responseObject) {
            DBHTradingMarketModelData *model = [DBHTradingMarketModelData modelObjectWithDictionary:dic];
            
            [weakSelf.dataSource addObject:model];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"No Data", nil)];
    } specialBlock:^{
        
    }];
}

#pragma mark ------ Event Responds ------
/**
 你的观点
 */
- (void)respondsToYourOpinionButton {
    // 聊天室
    if (!self.chatRoomId.length) {
        // 聊天室不存在
        [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"The project has no chat room", nil)];
        return ;
    }
    EaseMessageViewController *chatViewController = [[EaseMessageViewController alloc] initWithConversationChatter:self.chatRoomId conversationType:EMConversationTypeChatRoom];
    chatViewController.title = self.title;
    [self.navigationController pushViewController:chatViewController animated:YES];
}

#pragma mark ------ Getters And Setters ------
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = BACKGROUNDCOLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
        
        _tableView.rowHeight = AUTOLAYOUTSIZE(63.5);
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHTradingMarketTableViewCell class] forCellReuseIdentifier:kDBHTradingMarketTableViewCellIdentifier];
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

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
