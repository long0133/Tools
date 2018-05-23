//
//  YYRedPacketViewController.m
//  FBG
//
//  Created by yy on 2018/4/17.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketViewController.h"
#import "YYRedPacketHomeHeaderView.h"
#import "YYRedPacketSendFirstViewController.h"

#import "YYRedPacketSection0TableViewCell.h"
#import "YYRedPacketSection1TableViewCell.h"
#import "YYRedPacketSendHistoryViewController.h"
#import "YYRedPacketOpenedHistoryViewController.h"
#import "YYRedPacketDetailViewController.h"

#define HEADER_VIEW_HEIGHT 223

#define REDPACKET_HOME_KEY(lastUserEmail) [NSString stringWithFormat:@"REDPACKET_HOME_%@_%@", lastUserEmail, [APP_APIEHEAD isEqualToString:APIEHEAD1] ? @"APPKEYCHAIN" : @"TESTAPPKEYCHIN"]

#define DATASOURCE_LIST @"datasource_list"
#define SENT_COUNT_MODEL @"sent_count_model"
#define ETH_WALLET_LIST @"eth_wallet_list"

@interface YYRedPacketViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) UITableView *tableView;
@property (nonatomic, weak) YYRedPacketHomeHeaderView *headerView;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) YYRedPacketSentCountModel *countModel;

@end

@implementation YYRedPacketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    [self getDataFromCache];
    [self getWalletList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}

- (void)setNavigationTintColor {
    self.navigationController.navigationBar.tintColor = WHITE_COLOR;
}

- (void)setUI {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:DBHGetStringWithKeyFromTable(@"Opened Record", nil) style:UIBarButtonItemStylePlain target:self action:@selector(respondsToRecordBarButtonItem)];
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    
    tableView.tableHeaderView = nil;
    tableView.sectionHeaderHeight = 0;
    
    tableView.tableFooterView = nil;
    tableView.sectionFooterHeight = 0;
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YYRedPacketSection0TableViewCell class]) bundle:nil] forCellReuseIdentifier:REDPACKET_SECTION0_CELL_ID];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YYRedPacketSection1TableViewCell class]) bundle:nil] forCellReuseIdentifier:REDPACKET_SECTION1_CELL_ID];
    
    tableView.contentInset = UIEdgeInsetsMake(0, 0, -20, 0);
    
    tableView.delegate = self;
    tableView.dataSource = self;
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _tableView = tableView;
    [self.view addSubview:_tableView];
    
    WEAKSELF
    [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(weakSelf.view);
        make.top.offset(- 44);
    }];
}

#pragma mark ------- Cache ---------
/**
 缓存的key

 @return key
 */
- (NSString *)keyForCacheData {
    NSString *lastUserEmail = [[NSUserDefaults standardUserDefaults] objectForKey:LAST_USER_EMAIL];
    return REDPACKET_HOME_KEY(lastUserEmail);
}

/**
 从缓存中获取数据

 @return 一个不为空的NSMutableDictionary
 */
- (NSMutableDictionary *)dataFromCache {
    NSMutableDictionary *data = [PPNetworkCache getResponseCacheForKey:[self keyForCacheData]];
    if (![NSObject isNulllWithObject:data]) {
        return data;
    }
    return [NSMutableDictionary dictionary];
}

/**
 将data存入指定key的值

 @param data value
 @param key key
 */
- (void)cacheData:(id)data withKey:(NSString *)key {
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        NSMutableDictionary *cacheData = [self dataFromCache];
        if (![NSObject isNulllWithObject:data]) {
            [cacheData setObject:data forKey:key];
            
            NSString *keyForCacheData = [self keyForCacheData];
            [PPNetworkCache saveResponseCache:cacheData forKey:keyForCacheData];
        }
    });
}

/**
 从缓存中获取数据并显示
 */
- (void)getDataFromCache {
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        NSMutableDictionary *data = [self dataFromCache];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.ethWalletsArray = data[ETH_WALLET_LIST];
            self.countModel = data[SENT_COUNT_MODEL];
            self.dataSource = data[DATASOURCE_LIST];
        });
    });
}

#pragma mark ------- Data ---------
/**
 获取钱包列表
 */
- (void)getWalletList {
    if (![UserSignData share].user.isLogin) {
        return;
    }
    
    [LCProgressHUD showLoading:DBHGetStringWithKeyFromTable(@"Loading...", nil)];
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        WEAKSELF
        [PPNetworkHelper GET:@"wallet" baseUrlType:1 parameters:nil hudString:nil success:^(id responseObject) {
            [weakSelf handleResponse:responseObject type:0];
        } failure:^(NSString *error) {
            [LCProgressHUD hide];
            [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"Load failed", nil)];
        }];
    });
}

/**
 获取已发送的红包列表 和 发送的红包总个数
 */
- (void)getData {
    if (![UserSignData share].user.isLogin) {
        return;
    }
    
    NSString *urlStr = @"redbag/send_record?per_page=10";
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        
        NSMutableArray *tempAddrArr = [NSMutableArray array];
        for (DBHWalletManagerForNeoModelList *model in self.ethWalletsArray) {
            @autoreleasepool {
                NSString *addr = model.address;
                if (![NSObject isNulllWithObject:addr]) {
                    [tempAddrArr addObject:addr];
                }
            }
        }

        NSDictionary *params = @{
                                 @"wallet_addrs" : tempAddrArr
                                 };
        
        WEAKSELF
        [PPNetworkHelper POST:urlStr baseUrlType:3 parameters:params hudString:nil success:^(id responseObject) {
            [LCProgressHUD hide];
            [weakSelf handleResponse:responseObject type:1];
        } failure:^(NSString *error) {
            [LCProgressHUD hide];
            [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"Load failed", nil)];
        }];
        
        [PPNetworkHelper POST:@"redbag/send_count" baseUrlType:3 parameters:params hudString:nil success:^(id responseObject) {
            [LCProgressHUD hide];
            [weakSelf handleResponse:responseObject type:2];
        } failure:^(NSString *error) {
            [LCProgressHUD hide];
            [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"Load failed", nil)];
        }];
    });
}

- (void)handleResponse:(id)responseObj type:(NSInteger)type {
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        if (type == 0) {
            [self walletListResponse:responseObj];
        } else if (type == 1) { // 我发送的红包列表
            [self sentListResponse:responseObj];
        } else if (type == 2) { // 发送的红包个数
            [self sentCountResponse:responseObj];
        }
    });
}

/**
 钱包列表的返回处理

 @param responseObj 返回体
 */
- (void)walletListResponse:(id)responseObj {
    NSMutableArray *tempArr = nil;
    BOOL isHasData = NO;
    if (![NSObject isNulllWithObject:responseObj]) {
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            NSArray *list = responseObj[LIST];
            
            if (![NSObject isNulllWithObject:list] && list.count != 0) { // 不为空
                tempArr = [NSMutableArray array];
                isHasData = YES;
                for (NSDictionary *dict in list) {
                    @autoreleasepool {
                        DBHWalletManagerForNeoModelList *model = [DBHWalletManagerForNeoModelList mj_objectWithKeyValues:dict];
                        BOOL isLookWallet = [NSString isNulllWithObject:[PDKeyChain load:KEYCHAIN_KEY(model.address)]];
                        if (model.categoryId == 1 && !isLookWallet) { //ETH 且不是观察钱包
                            model.isLookWallet = isLookWallet;
                            model.isBackUpMnemonnic = [[UserSignData share].user.walletIdsArray containsObject:@(model.listIdentifier)];
                            [tempArr addObject:model];
                        }
                    }
                }
            }
        }
    }
    self.ethWalletsArray = tempArr;
    [self cacheData:tempArr withKey:ETH_WALLET_LIST];
    
    if (tempArr.count > 0) {
        [self getData];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [LCProgressHUD hide];
        });
    }
}

/**
 已发送的红包列表返回处理

 @param responseObj 返回体
 */
- (void)sentListResponse:(id)responseObj {
    NSMutableArray *tempArr = nil;
    if (![NSObject isNulllWithObject:responseObj]) {
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            YYRedPacketMySentModel *sentModel = [YYRedPacketMySentModel mj_objectWithKeyValues:responseObj];
            NSArray *dataArray = sentModel.data;
            if (![NSObject isNulllWithObject:dataArray] &&
                [dataArray isKindOfClass:[NSArray class]] &&
                dataArray.count > 0) {
                
                tempArr = [NSMutableArray array];
                for (YYRedPacketMySentListModel *listModel in dataArray) {
                    [tempArr addObject:listModel];
                }
            }
        }
    }
    self.dataSource = tempArr;
    [self cacheData:tempArr withKey:DATASOURCE_LIST];
}
/**
 已发送的红包个数返回处理
 
 @param responseObj 返回体
 */
- (void)sentCountResponse:(id)responseObj {
    YYRedPacketSentCountModel *model = nil;
    if (![NSObject isNulllWithObject:responseObj]) {
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            model = [YYRedPacketSentCountModel mj_objectWithKeyValues:responseObj];
        }
    }
    self.countModel = model;
    [self cacheData:model withKey:SENT_COUNT_MODEL];
}

#pragma mark ----- RespondsToSelector ---------
- (void)respondsToRecordBarButtonItem {
    YYRedPacketOpenedHistoryViewController *vc = [[YYRedPacketOpenedHistoryViewController alloc]
                                                  init];
    vc.ethWalletsArray = self.ethWalletsArray;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)respondsToMoreBtn {
    YYRedPacketSendHistoryViewController *vc = [[YYRedPacketSendHistoryViewController alloc] init];
    vc.dataSource = self.dataSource;
    vc.ethWalletsArray = self.ethWalletsArray;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ----- UITableView ---------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = self.dataSource.count;
    if (count > 5) {
        return 6;
    } else {
        return self.dataSource.count + 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (row == 0) {
        YYRedPacketSection0TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REDPACKET_SECTION0_CELL_ID forIndexPath:indexPath];
        cell.model = self.countModel;
        return cell;
    }
  
    YYRedPacketSection1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REDPACKET_SECTION1_CELL_ID forIndexPath:indexPath];
    if (row - 1 < self.dataSource.count) {
        [cell setModel:self.dataSource[row - 1] from:CellFromSentHistory];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     NSInteger row = indexPath.row;
    if (row == 0) {
        return;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YYRedPacketDetailViewController *vc = [[UIStoryboard storyboardWithName:REDPACKET_STORYBOARD_NAME bundle:nil] instantiateViewControllerWithIdentifier:REDPACKET_DETAIL_STORYBOARD_ID];
    if (row - 1 < self.dataSource.count) {
         YYRedPacketMySentListModel *sentModel = self.dataSource[row - 1];
        vc.model = sentModel;
    }
    vc.ethWalletsArr = self.ethWalletsArray;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return REDPACKET_SECTION0_CELL_HEIGHT;
    }
    
    return REDPACKET_SECTION1_CELL_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.headerView.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.dataSource.count == 0) {
        return nil;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    view.backgroundColor = WHITE_COLOR;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setTitle:DBHGetStringWithKeyFromTable(@"Check transfer Record", nil) forState:UIControlStateNormal];
    [btn setTitleColor:COLORFROM16(0xDF565B, 1) forState:UIControlStateNormal];
    [btn setBorderWidth:1 color:COLORFROM16(0xDF565B, 1)];
    
    btn.titleLabel.font = FONT(13);
    
    CGFloat width = [NSString getWidthtWithString:btn.currentTitle fontSize:13] + 100;
    btn.frame = CGRectMake(0, 0, width, 36);
    btn.center = view.center;
    [btn addTarget:self action:@selector(respondsToMoreBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:btn];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.dataSource.count == 0) {
        return 0;
    }
    return 60;
}

#pragma mark ------- Push To VC ---------
- (void)pushToSendRedPacketVC {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:REDPACKET_STORYBOARD_NAME bundle:nil];
    YYRedPacketSendFirstViewController *vc = [sb instantiateViewControllerWithIdentifier:REDPACKET_SEND_FIRST_STORYBOARD_ID];
    vc.ethWalletsArr = self.ethWalletsArray;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ----- Setters And Getters ---------
- (YYRedPacketHomeHeaderView *)headerView {
    if (!_headerView) {
        YYRedPacketHomeHeaderView *headerView = [[YYRedPacketHomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 223 - 20 + STATUS_HEIGHT)];
        WEAKSELF
        [headerView setClickBlock:^{
            [weakSelf pushToSendRedPacketVC];
        }];
        
        _headerView = headerView;
    }
    return _headerView;
}

- (void)setDataSource:(NSMutableArray *)dataSource {
    if ([_dataSource isEqualToArray:dataSource]) {
        return;
    }
    _dataSource = dataSource;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)setCountModel:(YYRedPacketSentCountModel *)countModel {
    if ([_countModel isEqual:countModel]) {
        return;
    }
    _countModel = countModel;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}
@end
