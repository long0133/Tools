//
//  DBHWalletPageViewController.m
//  FBG
//
//  Created by yy on 2018/3/15.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHWalletPageViewController.h"
#import "SystemConvert.h"

#import "PPNetworkCache.h"

#import "DBHWalletManagerViewController.h"
#import "DBHWalletDetailViewController.h"
#import "DBHWalletDetailWithETHViewController.h"

#import "DBHWalletLookPromptView.h"
#import "DBHHomePageHeaderView.h"
#import "DBHHomePageView.h"
#import "DBHHomePageTableViewCell.h"


#import "DBHWalletDetailTokenInfomationDataModels.h"

#import "DBHAddWalletPromptView.h"
#import "DBHSelectWalletTypeOnePromptView.h"
#import "DBHSelectWalletTypeTwoPromptView.h"
#import "DBHImportWalletViewController.h"
#import "DBHImportWalletWithETHViewController.h"
#import "DBHCreateWalletViewController.h"
#import "DBHCreateWalletWithETHViewController.h"
#import "DBHShowAddWalletViewController.h"
#import "RTDragCellTableView.h"
#import "YYWalletConversionListModel.h"

#define WALLET_LIST_KEY(userName) [NSString stringWithFormat:@"WALLET_LIST_%@_%@", userName, [APP_APIEHEAD isEqualToString:APIEHEAD1] ? @"APPKEYCHAIN" : @"TESTAPPKEYCHIN"]
#define WALLET_LIST @"wallet_list"
#define NEO_MODEL @"neo_model"
#define ETH_MODEL @"eth_model"
#define GAS_MODEL @"gas_model"
#define NEO_WALLET_LIST @"neo_wallet_list"
#define ETH_WALLET_LIST @"eth_wallet_list"

static NSString *const kDBHHomePageTableViewCellIdentifier = @"kDBHHomePageTableViewCellIdentifier";

@interface DBHWalletPageViewController ()<RTDragCellTableViewDataSource, RTDragCellTableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) DBHHomePageHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DBHHomePageView *homePageView;
@property (nonatomic, strong) DBHWalletLookPromptView *walletLookPromptView;

@property (nonatomic, strong) DBHWalletDetailTokenInfomationModelData *neoModel;
@property (nonatomic, strong) DBHWalletDetailTokenInfomationModelData *gasModel;
@property (nonatomic, strong) DBHWalletDetailTokenInfomationModelData *ethModel;

@property (nonatomic, strong) NSMutableArray *walletsArray; // 钱包列表
@property (nonatomic, strong) NSMutableArray *tokensArray;

@property (nonatomic, strong) NSMutableArray *neowalletsArray; // NEO钱包列表
@property (nonatomic, strong) NSMutableArray *ethwalletsArray; // ETH钱包列表

@property (nonatomic, strong) NSMutableArray *dataSource; // 代币列表

@property (nonatomic, strong) UILabel *allAssetsLabel;
@property (nonatomic, strong) UIButton *hideZeroBtn;

@property (nonatomic, assign) BOOL isHideZero;

@property (nonatomic, assign) NSInteger type; // 0:添加钱包 1:导入钱包
@property (nonatomic, assign) NSInteger walletType; // 0:NEO 1:ETH

@property (nonatomic, strong) NSMutableArray *noZeroDatasource; // 没有为0的代币列表

@property (nonatomic, strong) NSString *cacheSortTokenKey;
@property (nonatomic, assign) BOOL isSuccess;

@end

@implementation DBHWalletPageViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideZeroHasChanged) name:NOTIFICATION_NAME_ISHIDEZERO object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getWalletList) name:NOTIFICATION_NAME_REFRESHWALLETLIST object:nil];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setUI];
    [self addRefresh];
    [self getDataFromCache];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage getImageFromColor:WHITE_COLOR Rect:CGRectMake(0, 0, SCREENWIDTH, STATUSBARHEIGHT + 44)] forBarMetrics:UIBarMetricsDefault];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark ------ UI ------
- (void)setUI {
    WEAKSELF
    [self.view addSubview:self.headerView];
    [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.height.offset(AUTOLAYOUTSIZE(385));
        make.centerX.equalTo(weakSelf.view);
        make.top.offset(0);
    }];
    
    [self.view addSubview:self.allAssetsLabel];
    [self.allAssetsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(AUTOLAYOUTSIZE(33));
        make.top.equalTo(weakSelf.headerView.mas_bottom);
        make.height.offset(AUTOLAYOUTSIZE(20));
    }];
    
    [self.view addSubview:self.hideZeroBtn];
    [self.hideZeroBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-AUTOLAYOUTSIZE(33));
        make.top.equalTo(weakSelf.headerView.mas_bottom);
        make.height.offset(AUTOLAYOUTSIZE(20));
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.hideZeroBtn.mas_bottom);
        make.bottom.equalTo(weakSelf.view);
    }];
    
    [self.view addSubview:self.homePageView];
    [self.homePageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.height.offset(AUTOLAYOUTSIZE(77) + STATUSBARHEIGHT);
        make.centerX.equalTo(weakSelf.view);
        make.top.offset(0);
    }];
    [self judgeIsShowGuide];
    [self judgeIsHideZero];
}

- (void)judgeIsShowGuide {
    BOOL isShow = [[NSUserDefaults standardUserDefaults] boolForKey:IS_SHOW_WALLET_GUIDE];
    if (!isShow) {
        [self addGuideView];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_SHOW_WALLET_GUIDE];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)addGuideView {
    [self.view layoutIfNeeded];
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect frame = [UIScreen mainScreen].bounds;
    UIView *bgView = [[UIView alloc] initWithFrame:frame];
    
    bgView.backgroundColor = COLORFROM16(0x323232, 0.8);
    
    UIImageView *circleImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wallet_guide_circle"]];
    CGFloat width = AUTOLAYOUTSIZE(75);
    circleImg.contentMode = UIViewContentModeScaleAspectFit;
    
    CGRect assetFrame = self.headerView.assetButton.frame;
    
    circleImg.frame = CGRectMake(CGRectGetMidX(assetFrame) - width / 2, CGRectGetMidY(assetFrame) - width / 2, width, width);
    circleImg.contentMode = UIViewContentModeScaleAspectFit;
    [bgView addSubview:circleImg];
    
    UIImageView *arrowImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wallet_guide_arrow"]];
    
    arrowImg.contentMode = UIViewContentModeScaleAspectFit;
    
    arrowImg.frame = CGRectMake(CGRectGetMinX(circleImg.frame) + 5, CGRectGetMaxY(circleImg.frame) + 5, width, 30);
    [bgView addSubview:arrowImg];
    
    UIImageView *tipImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:DBHGetStringWithKeyFromTable(@"wallet_guide_tip_en", nil)]];
    
    tipImg.contentMode = UIViewContentModeScaleAspectFit;
    width = AUTOLAYOUTSIZE(200);
    tipImg.frame = CGRectMake(CGRectGetMidX(frame) - width / 2, CGRectGetMaxY(arrowImg.frame) + 6, width, 44);
    [bgView addSubview:tipImg];
    
    
    UIButton *iKownBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    width = AUTOLAYOUTSIZE(100);
    
    CGRect btnFrame = iKownBtn.frame;
    btnFrame.origin.x = CGRectGetMidX(tipImg.frame) - width / 2;
    btnFrame.origin.y = CGRectGetMaxY(tipImg.frame) + 38;
    btnFrame.size.width = width;
    btnFrame.size.height = 36;
    
    iKownBtn.frame = btnFrame;
    
    iKownBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [iKownBtn setImage:[UIImage imageNamed:DBHGetStringWithKeyFromTable(@"info_guide_ikown_en", nil)] forState:UIControlStateNormal];
    [iKownBtn addTarget:self action:@selector(iKownClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [bgView addSubview:iKownBtn];
    [keyWindow addSubview:bgView];
}

- (void)judgeIsHideZero {
    self.isHideZero = [[NSUserDefaults standardUserDefaults] boolForKey:IS_HIDE_ZERO_KEY];
    self.hideZeroBtn.selected = self.isHideZero;
}

- (void)hideZeroHasChanged {
    [self judgeIsHideZero];
    [self.tableView reloadData];
}

#pragma mark ------ RespondsToSelector ------
- (void)iKownClicked:(UIButton *)btn {
    [btn.superview removeFromSuperview];
}

- (void)respondsToHideZeroBtn:(UIButton *)btn {
    btn.selected = !btn.isSelected;
    
    self.isHideZero = btn.isSelected;
    [[NSUserDefaults standardUserDefaults] setBool:self.isHideZero forKey:IS_HIDE_ZERO_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.tableView reloadData];
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.isHideZero ? self.noZeroDatasource.count : self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHHomePageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHHomePageTableViewCellIdentifier forIndexPath:indexPath];
    NSInteger row = indexPath.row;
    NSInteger count = self.isHideZero ? self.noZeroDatasource.count : self.dataSource.count;
    
    if (row < count) {
        cell.model = self.isHideZero ? self.noZeroDatasource[row] : self.dataSource[row];
    }
    
    return cell;
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHWalletDetailTokenInfomationModelData *model = self.isHideZero ? self.noZeroDatasource[indexPath.row] : self.dataSource[indexPath.row];
    NSString *type = model.typeName;
    
    NSString *dbTypeStr = @"NEO";
    if ([NSObject isNulllWithObject:type]) { // neo 或者 eth
        dbTypeStr = model.flag;
    } else {
        dbTypeStr = type;
    }
    
    self.walletLookPromptView.tokenName = model.name;
    
    NSMutableArray *data = ([dbTypeStr isEqualToString:@"NEO"]) ? [self.neowalletsArray mutableCopy] : [self.ethwalletsArray mutableCopy];
    self.walletLookPromptView.dataSource = data;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.walletLookPromptView];
    
    WEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.walletLookPromptView animationShow];
    });
    
}

- (NSArray *)originalArrayDataForTableView:(RTDragCellTableView *)tableView{
    return self.isHideZero ? self.noZeroDatasource : self.dataSource;
}

- (void)tableView:(RTDragCellTableView *)tableView moveObjectFrom:(NSInteger)fromIndex to:(NSInteger)toIndex {
    if (self.isHideZero) {
        DBHWalletDetailTokenInfomationModelData *exchangeAfterModel = self.noZeroDatasource[fromIndex];
        DBHWalletDetailTokenInfomationModelData *exchangeBeforeModel = self.noZeroDatasource[toIndex];
        if ([self.dataSource containsObject:exchangeAfterModel] && [self.dataSource containsObject:exchangeBeforeModel]) {
            NSInteger index1 = [self.dataSource indexOfObject:exchangeAfterModel];
            NSInteger index2 = [self.dataSource indexOfObject:exchangeBeforeModel];
            
            [self.dataSource removeObjectAtIndex:index2];
            [self.dataSource insertObject:exchangeBeforeModel atIndex:index1];
        }
    } else {
        self.noZeroDatasource = [NSMutableArray arrayWithArray:self.dataSource];
        WEAKSELF
        [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @autoreleasepool {
                DBHWalletDetailTokenInfomationModelData *model = (DBHWalletDetailTokenInfomationModelData *)obj;
                if (![model.flag isEqualToString:@"NEO"] && ![model.flag isEqualToString:@"Gas"] && ![model.flag isEqualToString:@"ETH"]) {
                    NSString *bala = model.balance;
                    if (bala.doubleValue == 0 && [weakSelf.noZeroDatasource containsObject:model]) { // 为0 且存在在数组中 移除
                        [weakSelf.noZeroDatasource removeObject:model];
                    }
                }
            }
        }];
    }
}


/**
 cell位置改变了才调用
 
 @param tableView tableView
 */
- (void)cellDidEndMovingInTableView:(RTDragCellTableView *)tableView {
    NSMutableArray *flagArr = [NSMutableArray array];
    [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @autoreleasepool {
            DBHWalletDetailTokenInfomationModelData *model = (DBHWalletDetailTokenInfomationModelData *)obj;
            if (![NSObject isNulllWithObject:model.flag]) {
                [flagArr addObject:model.flag];
            }
        }
    }];
    
    // 上传数据  self.datasource的顺序
    NSDictionary *dict = @{@"list" : flagArr};
    [self sortedTokenList:dict];
}

- (void)tableView:(RTDragCellTableView *)tableView newArrayDataForDataSource:(NSArray *)newArray{
    if (self.isHideZero) {
        self.noZeroDatasource = [NSMutableArray arrayWithArray:newArray];
    } else {
        self.dataSource = [NSMutableArray arrayWithArray:newArray];
    }
}

#pragma mark ------ UIScrollViewDelegate ------
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    UIPanGestureRecognizer *pan = scrollView.panGestureRecognizer;
    //获取到拖拽的速度 >0 向下拖动 <0 向上拖动
    CGFloat velocity = [pan velocityInView:scrollView].y;
    
    WEAKSELF
    if (velocity <- 5) {
        //向上拖动，隐藏导航栏
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(weakSelf.view);
            make.centerX.equalTo(weakSelf.view);
            make.top.equalTo(weakSelf.homePageView.mas_bottom);
            make.bottom.equalTo(weakSelf.view);
        }];
        
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.homePageView.hidden = NO;
            weakSelf.headerView.hidden = YES;
            
            weakSelf.allAssetsLabel.hidden = YES;
            //            weakSelf.amountLabel.hidden = YES;
            weakSelf.hideZeroBtn.hidden = YES;
            [weakSelf.view layoutIfNeeded];
        }];
    }else if (velocity > 5) {
        //向下拖动，显示导航栏
        
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(weakSelf.view);
            make.centerX.equalTo(weakSelf.view);
            make.top.equalTo(weakSelf.hideZeroBtn.mas_bottom);
            make.bottom.equalTo(weakSelf.view);
        }];
        
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.homePageView.hidden = YES;
            weakSelf.headerView.hidden = NO;
            
            weakSelf.allAssetsLabel.hidden = NO;
            //            weakSelf.amountLabel.hidden = NO;
            weakSelf.hideZeroBtn.hidden = NO;
            [weakSelf.view layoutIfNeeded];
        }];
    }else if(velocity == 0){
        //停止拖拽
    }
}

#pragma mark ------ Data ------

/**
 上传排序的顺序
 
 @param param param
 */
- (void)sortedTokenList:(NSDictionary *)param {
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        WEAKSELF
        [PPNetworkHelper PUT:@"user-gnt-sort-all" baseUrlType:1 parameters:param hudString:nil success:^(id responseObject) {
            if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                NSArray *sortedTokenFlags = responseObject[@"wallet_gnt_sort"];
                [weakSelf cacheSortedTokenFlags:sortedTokenFlags];
            }
        } failure:^(NSString *error) {
            
        }];
    });
}

- (void)cacheSortedTokenFlags:(NSArray *)flags {
    UserModel *user = [UserSignData share].user;
    user.sortedTokenFlags = flags;
    [[UserSignData share] storageData:user];
}

- (void)getDataFromCache {
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        NSString *lastUserEmail = [[NSUserDefaults standardUserDefaults] objectForKey:LAST_USER_EMAIL];
        NSDictionary *data = [PPNetworkCache getResponseCacheForKey:WALLET_LIST_KEY(lastUserEmail)];
        if (![NSObject isNulllWithObject:data] && [data isKindOfClass:[NSDictionary class]]) {
            NSArray *walletList = data[WALLET_LIST];
            self.dataSource = [NSMutableArray arrayWithArray:walletList];
            
            self.neoModel = data[NEO_MODEL];
            self.ethModel = data[ETH_MODEL];
            self.gasModel = data[GAS_MODEL];
            
            self.neowalletsArray = data[NEO_WALLET_LIST];
            self.ethwalletsArray = data[ETH_WALLET_LIST];
            [self getFinalData];
        } else {
            [self showDataWithArray:nil];
        }
    });
}
/**
 获取钱包列表
 */
- (void)getWalletList {
    self.isSuccess = NO;
    if (![UserSignData share].user.isLogin) {
        [self endRefresh];
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        WEAKSELF
        [PPNetworkHelper GET:@"wallet" baseUrlType:1 parameters:nil hudString:nil success:^(id responseObject) { // 不endrefresh 去获取代币中处理
            [weakSelf handleWalletResponse:responseObject];
        } failure:^(NSString *error) {
            [weakSelf endRefresh];
            [LCProgressHUD showFailure: error];
        }];
    });
}

- (void)handleWalletResponse:(id)responseObj {
    BOOL isEndRefresh = YES;
    if (![NSObject isNulllWithObject:responseObj]) { // 不为空
        NSArray *list = responseObj[LIST];
        
        NSMutableArray *tempArr = nil;
        if (![NSObject isNulllWithObject:list] && list.count != 0) { // 不为空
            isEndRefresh = NO; //TODO
            tempArr = [NSMutableArray array];
            for (NSDictionary *dict in list) {
                @autoreleasepool {
                    DBHWalletManagerForNeoModelList *model = [DBHWalletManagerForNeoModelList mj_objectWithKeyValues:dict];
                    model.isLookWallet = [NSString isNulllWithObject:[PDKeyChain load:KEYCHAIN_KEY(model.address)]];
                    model.isBackUpMnemonnic = [[UserSignData share].user.walletIdsArray containsObject:@(model.listIdentifier)];
                    [tempArr addObject:model];
                }
            }
        }
        self.walletsArray = tempArr;
    }
    
    if (isEndRefresh) {
        [self endRefresh];
    }
}

- (void)setWalletsArray:(NSMutableArray *)walletsArray {
    _walletsArray = walletsArray;
    if (![NSObject isNulllWithObject:walletsArray] && walletsArray.count > 0) {
        [self getTokenData];
    } else {
        dispatch_async(dispatch_get_global_queue(
                                                 DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                                 0), ^{
            [self showDataWithArray:nil];
        });
    }
}

- (void)showDataWithArray:(NSArray *)array {
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:array];
    
    [tempArr insertObject:self.neoModel atIndex:0];
    [tempArr insertObject:self.ethModel atIndex:1];
    
    if (self.gasModel.balance.doubleValue > 0) {
        [tempArr insertObject:self.gasModel atIndex:2];
    }
    
    [self handleArray:tempArr];
}

- (void)handleArray:(NSMutableArray *)array {
    __block NSMutableArray *sortArr = [NSMutableArray array];
    
    NSArray *sortedFlags = [UserSignData share].user.sortedTokenFlags;
    if (![NSObject isNulllWithObject:sortedFlags] && sortedFlags.count > 0) {
        for (int i = 0; i < sortedFlags.count; i ++) {
            NSString *flag = sortedFlags[i];
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                DBHWalletDetailTokenInfomationModelData *model = (DBHWalletDetailTokenInfomationModelData *)obj;
                if ([model.flag isEqualToString:flag]) { // 放在对应的index上
                    [sortArr addObject:model];
                    [array removeObject:model];
                }
            }];
        }
    }
    
    [sortArr addObjectsFromArray:array];
    self.dataSource = sortArr;
    
    if (self.isSuccess) {
        [self cacheDataSourceToLocal];
    }
    
    [self getFinalData];
}

- (void)cacheDataSourceToLocal {
    NSDictionary *dict = @{
                           WALLET_LIST : self.dataSource,
                           NEO_MODEL : self.neoModel,
                           ETH_MODEL : self.ethModel,
                           GAS_MODEL : self.gasModel,
                           NEO_WALLET_LIST : self.neowalletsArray,
                           ETH_WALLET_LIST : self.ethwalletsArray
                           };
    
    NSString *lastUserEmail = [[NSUserDefaults standardUserDefaults] objectForKey:LAST_USER_EMAIL];
    [PPNetworkCache saveResponseCache:dict forKey:WALLET_LIST_KEY(lastUserEmail)];
}

- (void)getFinalData {
    WEAKSELF
    __block NSString *tokenTotal = @"0";
    
    self.noZeroDatasource = [NSMutableArray arrayWithArray:self.dataSource];
    [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @autoreleasepool {
            DBHWalletDetailTokenInfomationModelData *model = (DBHWalletDetailTokenInfomationModelData *)obj;
            if (![model.flag isEqualToString:NEO] && ![model.flag isEqualToString:GAS] && ![model.flag isEqualToString:ETH]) {
                
                NSString *tokenPrice = [UserSignData share].user.walletUnitType == 1 ? model.priceCny : model.priceUsd;
                tokenPrice = [NSString DecimalFuncWithOperatorType:2 first:model.balance secend:tokenPrice value:8];
                
                tokenTotal = [NSString DecimalFuncWithOperatorType:0 first:tokenTotal secend:tokenPrice value:8];
                
                NSString *bala = model.balance;
                if (bala.doubleValue == 0 && [weakSelf.noZeroDatasource containsObject:model]) { // 为0 且存在在数组中 移除
                    [weakSelf.noZeroDatasource removeObject:model];
                }
            }
        }
    }];
    
//    NSString *neoPrice = [UserSignData share].user.walletUnitType == 1 ? self.neoModel.priceCny : self.neoModel.priceUsd;
//    NSString *gasPrice = [UserSignData share].user.walletUnitType == 1 ? self.gasModel.priceCny : self.gasModel.priceUsd;
    
    NSString *neoPrice = [NSString DecimalFuncWithOperatorType:2 first:self.neoModel.balance secend:[UserSignData share].user.walletUnitType == 1 ? self.neoModel.priceCny : self.neoModel.priceUsd value:8];
    
    NSString *gasPrice = [NSString DecimalFuncWithOperatorType:2 first:self.gasModel.balance secend:[UserSignData share].user.walletUnitType == 1 ? self.gasModel.priceCny : self.gasModel.priceUsd value:8];
    
    NSString *ethPrice = [NSString DecimalFuncWithOperatorType:2 first:self.ethModel.balance secend:[UserSignData share].user.walletUnitType == 1 ? self.ethModel.priceCny : self.ethModel.priceUsd value:8];
    
    NSString *gasNeo = [NSString DecimalFuncWithOperatorType:0 first:neoPrice secend:gasPrice value:8];
    NSString *ethDB = [NSString DecimalFuncWithOperatorType:0 first:ethPrice secend:tokenTotal value:8];
    NSString *totalAsset = [NSString DecimalFuncWithOperatorType:0 first:gasNeo secend:ethDB value:8];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.homePageView.totalAsset = [NSString stringWithFormat:@"%.2lf", totalAsset.doubleValue];
        self.headerView.totalAsset = [NSString stringWithFormat:@"%.2lf", totalAsset.doubleValue];
        
        [self.tableView reloadData];
    });
}

- (void)getTokenData {
    NSMutableArray *walletsIdArr = [NSMutableArray array];
    
    // 创建全局并行
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    for (DBHWalletManagerForNeoModelList *model in self.walletsArray) {
        [walletsIdArr addObject:@(model.listIdentifier)];
        
        dispatch_group_enter(group);
        dispatch_group_async(group, queue, ^{
            [PPNetworkHelper GET:[NSString stringWithFormat:@"conversion/%ld", (NSInteger)model.listIdentifier] baseUrlType:1 parameters:nil hudString:nil responseCache:^(id responseCache) {
            } success:^(id responseObject) {
                dispatch_group_leave(group);
             } failure:^(NSString *error) {
                 dispatch_group_leave(group);
             } specialBlock:nil];
        });
        
    }
    
    NSMutableDictionary * parametersDic = [NSMutableDictionary dictionary];
    [parametersDic setObject:[walletsIdArr toJSONStringForArray] forKey:@"wallet_ids"];
    
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        WEAKSELF
        [PPNetworkHelper GET:@"conversion" baseUrlType:1 parameters:parametersDic hudString:nil success:^(id responseObject) {
            [weakSelf handleConversionReponse:responseObject];
            dispatch_group_leave(group);
        } failure:^(NSString *error) {
            [weakSelf handleConversionReponse:nil];
            dispatch_group_leave(group);
            NSLog(@"✘✘✘✘✘✘ ---conversion error----✘✘✘✘✘✘---- %@", error);
        }];
    });
    
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self endRefresh];
        });
        
        self.isSuccess = YES;
        [self calculateTokenData];
    });
}

- (void)handleConversionReponse:(id)responseObj {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (![NSObject isNulllWithObject:responseObj]) {
            NSArray *dataArray = responseObj[LIST];
            if (![NSObject isNulllWithObject:dataArray] && dataArray.count > 0) {
                NSString *tempETHBalance = @"0";
                NSString *tempETHPriceCny = @"0";
                NSString *tempETHPriceUsd = @"0";
                NSString *tempNEOBalance = @"0";
                NSString *tempNEOPriceCny = @"0";
                NSString *tempNEOPriceUsd = @"0";
                
                for (NSDictionary *dict in dataArray) {
                    @autoreleasepool {
                        DBHWalletManagerForNeoModelList *model = [DBHWalletManagerForNeoModelList mj_objectWithKeyValues:dict];
                        
                        NSString *price_cny = model.category.cap.priceCny;
                        NSString *price_usd = model.category.cap.priceUsd;
                        NSString *balance = model.balance;
                        
                        NSString *second = balance;
                        if (model.categoryId == 1) { //ETH
                            NSString *temp = @"0";
                            if (![NSObject isNulllWithObject:balance] && balance.length > 2) {
                                temp = [NSString numberHexString:[balance substringFromIndex:2]];
                            }
                            second = [NSString DecimalFuncWithOperatorType:3 first:temp secend:@"1000000000000000000" value:8];
                            
                            tempETHBalance = [NSString DecimalFuncWithOperatorType:0 first:tempETHBalance secend:second value:8];
                            tempETHPriceCny = price_cny;
                            tempETHPriceUsd = price_usd;
                            
                            // 代币数量统计
                            for (DBHWalletManagerForNeoModelList *walletModel in self.walletsArray) {
                                if (walletModel.listIdentifier == model.listIdentifier) {
                                    [walletModel.tokenStatistics setObject:second forKey:ETH];
                                }
                            }
                        } else {
                            tempNEOBalance = [NSString DecimalFuncWithOperatorType:0 first:tempNEOBalance secend:second value:8];
                            tempNEOPriceCny = price_cny;
                            tempNEOPriceUsd = price_usd;
                            
                            // 代币数量统计
                            for (DBHWalletManagerForNeoModelList *walletModel in self.walletsArray) {
                                if (walletModel.listIdentifier == model.listIdentifier) {
                                    [walletModel.tokenStatistics setObject:second forKey:NEO];
                                }
                            }
                        }
                    }
                }
                
                [self setModel:self.ethModel balance:tempETHBalance priceCny:tempETHPriceCny priceUsd:tempETHPriceUsd];
                [self setModel:self.neoModel balance:tempNEOBalance priceCny:tempNEOPriceCny priceUsd:tempNEOPriceUsd];
                return;
            }
        }
        [self showDataWithArray:nil];
    });
}

- (void)calculateTokenData {
    [self.tokensArray removeAllObjects];
    
    NSString *gasBalance, *gasPriceCny, *gasPriceUsd = @"0";
    
    NSMutableArray *tempNeoWalletArr = [NSMutableArray array];
    NSMutableArray *tempETHWalletArr = [NSMutableArray array];
    for (DBHWalletManagerForNeoModelList *walletModel in self.walletsArray) {
        @autoreleasepool {
            NSString *key = [NSString stringWithFormat:@"conversion/%ld/", (NSInteger)walletModel.listIdentifier];
            NSDictionary *responseObject = [PPNetworkCache getResponseCacheForKey:key];
            BOOL isETH = (walletModel.categoryId) == 1;
            if (![NSObject isNulllWithObject:responseObject]) {
            
                NSString *typeName = walletModel.category.name;
                
    //           ----------- gas信息 -----------
                if (!isETH) { // NEO 才获取GAS
                    NSDictionary *record = responseObject[RECORD];
                    NSString *priceCny, *priceUsd, *balance = @"0";
                    
                    if (![NSObject isNulllWithObject:record]) {
                        DBHWalletManagerForNeoModelList *recordModel = [DBHWalletManagerForNeoModelList mj_objectWithKeyValues:record];
                        NSArray *gnt = recordModel.gnt;
                        
                        if (![NSObject isNulllWithObject:gnt] && gnt.count > 0) {
                            YYWalletRecordGntModel *gasGntModel = gnt.firstObject;
                            priceCny = gasGntModel.cap.priceCny;
                            priceUsd = gasGntModel.cap.priceUsd;
                            balance = gasGntModel.balance;
                        }
                    }
                    self.gasModel.typeName = typeName;
                    
                    gasBalance = [NSString DecimalFuncWithOperatorType:0 first:balance secend:gasBalance value:8];

                    gasPriceCny = priceCny;
                    gasPriceUsd = priceUsd;
                    
                    [walletModel.tokenStatistics setObject:balance forKey:GAS];
                }
                
    //           ----------- 代币列表 -----------
                NSArray *list = responseObject[LIST];
                
                for (NSDictionary *dict in list) {
                    @autoreleasepool {
                        YYWalletConversionListModel *listModel = [YYWalletConversionListModel mj_objectWithKeyValues:dict];
                        
                        NSString *price_cny = listModel.gnt_category.cap.priceCny;
                        NSString *price_usd = listModel.gnt_category.cap.priceUsd;
                        
                        NSString *symbol = listModel.symbol;
                        NSString *name = listModel.name;
                        NSString *balance = listModel.balance;
                        NSInteger decimals = listModel.decimals;
                        NSInteger index = [self foundModelWithArray:[self.tokensArray copy] name:name];
                        if (index >= 0) { // 找到
                            if (index < self.tokensArray.count) {
                                DBHWalletDetailTokenInfomationModelData *model = self.tokensArray[index];
                                model.symbol = symbol;
                                
                                if (![NSObject isNulllWithObject:balance]) {
                                    NSString *temp, *second = @"0";
                                    if (isETH) {
                                        if (balance.length > 2) {
                                            temp = [NSString numberHexString:[balance substringFromIndex:2]];
                                        }
                                        second = [NSString DecimalFuncWithOperatorType:3 first:temp secend:[NSString stringWithFormat:@"%lf", pow(10, decimals)] value:8];
                                        
                                        model.balance = [NSString DecimalFuncWithOperatorType:0 first:model.balance secend:second value:8];
                                        
                                        NSLog(@"priceCny = %f  second = %f", model.priceCny.doubleValue, second.doubleValue);
                                        [walletModel.tokenStatistics setObject:second forKey:model.name];
                                    } else {
                                        NSData *data = [self convertHexStrToData:balance];
                                        temp = [NSString stringWithFormat:@"%lf", [self getBalanceWithByte:(Byte *)data.bytes length:data.length] / pow(10, decimals)];
                                        second = temp;
                                        
                                        model.decimals = [NSString stringWithFormat:@"%@", @(decimals)];
                                        model.balance = [NSString DecimalFuncWithOperatorType:0 first:model.balance secend:second value:8];
                                        
                                        [walletModel.tokenStatistics setObject:second forKey:model.name];
                                    }
                                }
                                
                                [self.tokensArray replaceObjectAtIndex:index withObject:model];
                            }
                        } else { // 没找到
                            DBHWalletDetailTokenInfomationModelData *model = [[DBHWalletDetailTokenInfomationModelData alloc] init];
                            model.address = listModel.gnt_category.address;
                            model.symbol = symbol;
                            model.typeName = typeName;
                            model.name = listModel.gnt_category.name;
                            model.icon = listModel.gnt_category.icon;
                            model.flag = model.name;
                            
                            model.priceCny = price_cny;
                            model.priceUsd = price_usd;
                            
                            if (![NSObject isNulllWithObject:balance]) {
                                NSString *temp, *second = @"0";
                                if (isETH) { //ETH
                                    if (balance.length > 2) {
                                        temp = [NSString numberHexString:[balance substringFromIndex:2]];
                                    }
                                    second = [NSString DecimalFuncWithOperatorType:3 first:temp secend:[NSString stringWithFormat:@"%lf", pow(10, decimals)] value:8];
                                    
                                    NSLog(@"priceCny = %f  second = %f", model.priceCny.doubleValue, model.balance.doubleValue);
                                    // 代币数量统计
                                    [walletModel.tokenStatistics setObject:second forKey:model.name];
                                } else { //NEO
                                    NSData *data = [self convertHexStrToData:balance];
                                    temp = [NSString stringWithFormat:@"%lf", [self getBalanceWithByte:(Byte *)data.bytes length:data.length] / pow(10, decimals)];
                                    second = temp;
                                    
                                    model.decimals = [NSString stringWithFormat:@"%@", @(decimals)];
                                   
                                    [walletModel.tokenStatistics setObject:second forKey:model.name];
                                }
                                model.balance = second;
                            }
                            [self.tokensArray addObject:model];
                        }
                    }
                }
            }
            if (isETH) {
                [tempETHWalletArr addObject:walletModel];
            } else {
                [tempNeoWalletArr addObject:walletModel];
            }
        }
    }
    
    self.ethwalletsArray = tempETHWalletArr;
    self.neowalletsArray = tempNeoWalletArr;
    
    [self setModel:self.gasModel balance:gasBalance priceCny:gasPriceCny priceUsd:gasPriceUsd];
    [self showDataWithArray:self.tokensArray];
}

#pragma mark ------ Private Methods ------

- (void)setModel:(DBHWalletDetailTokenInfomationModelData *)model balance:(NSString *)balance priceCny:(NSString *)priceCny priceUsd:(NSString *)priceUsd {
    model.balance = balance;
    model.priceUsd = priceUsd;
    model.priceCny = priceCny;
}

/**
 添加刷新
 */
- (void)addRefresh {
    WEAKSELF
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getWalletList];
    }];
}
/**
 结束刷新
 */
- (void)endRefresh {
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
}

/**
 从数组中查找name
 
 @param array 数组
 @param name name
 */
- (NSInteger)foundModelWithArray:(NSArray *)array name:(NSString *)name {
    for (NSInteger i = 0; i < array.count; i ++) {
        DBHWalletDetailTokenInfomationModelData *model = array[i];
        
        if ([model.name isEqualToString:name]) {
            return i;
        }
    }
    
    return -1;
}

/**
 将16进制的字符串转换成NSData
 */
- (NSData *)convertHexStrToData:(NSString *)str {
    NSString *balance = [NSString stringWithFormat:@"%@", str];
    if (!balance || [balance length] == 0) {
        
        return nil;
        
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    
    NSRange range;
    
    if ([balance length] %2 == 0) {
        
        range = NSMakeRange(0,2);
        
    } else {
        
        range = NSMakeRange(0,1);
        
    }
    
    for (NSInteger i = range.location; i < [balance length]; i += 2) {
        
        unsigned int anInt;
        
        NSString *hexCharStr = [balance substringWithRange:range];
        
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        
        
        [scanner scanHexInt:&anInt];
        
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        
        [hexData appendData:entity];
        
        
        
        range.location += range.length;
        
        range.length = 2;
        
    }
    
    return [hexData copy];
}
/**
 byte转换成余额
 */
- (unsigned long long)getBalanceWithByte:(Byte *)byte length:(NSInteger)length {
    Byte newByte[length];
    for (NSInteger i = 0; i < length; i++) {
        newByte[i] = byte[length - i - 1];
    }
    
    NSString *hexStr = @"";
    for(int i=0;i < length;i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",newByte[i]&0xff]; // 16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    NSLog(@"bytes 的16进制数为:%@",hexStr);
    NSScanner * scanner = [NSScanner scannerWithString:hexStr];
    
    unsigned long long balance;
    
    [scanner scanHexLongLong:&balance];
    
    return balance;
}

#pragma mark ------ Getters And Setters ------
- (BOOL)isZh {
    return [UserSignData share].user.walletUnitType == 1;
}

- (NSString *)cacheSortTokenKey {
    if (!_cacheSortTokenKey) {
        _cacheSortTokenKey = [NSString stringWithFormat:@"user-gnt-sort-all_%@", [UserSignData share].user.token];
    }
    return _cacheSortTokenKey;
}

- (DBHHomePageHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[DBHHomePageHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, AUTOLAYOUTSIZE(385))];
        _headerView.totalAsset = @"0.00";
        WEAKSELF
        [_headerView clickButtonBlock:^(NSInteger type) {
            switch (type) {
                case 0: {
                    // 资讯
                    
                    break;
                }
                case 1: {
                    // 个人中心
                    //                    DBHMyViewController *myViewController = [[DBHMyViewController alloc] init];
                    //                    [weakSelf.navigationController pushViewController:myViewController animated:YES];
                    
                    break;
                }
                case 2: {
                    // 资产
                    if (![UserSignData share].user.isLogin) {
                        [[AppDelegate delegate] goToLoginVC:self];
                    } else {
                        DBHWalletManagerViewController *walletManagerViewController = [[DBHWalletManagerViewController alloc] init];
                        [weakSelf.navigationController pushViewController:walletManagerViewController animated:YES];
                    }
                    
                    break;
                }
                case 3: { // 显示/隐藏资产按钮
                    [weakSelf.homePageView refreshAsset];
                    break;
                }
                    
                default: {
                    
                    break;
                }
            }
        }];
    }
    return _headerView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[RTDragCellTableView alloc] init];
        _tableView.backgroundColor = BACKGROUNDCOLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.rowHeight = AUTOLAYOUTSIZE(60);
        
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        _tableView.sectionHeaderHeight = 0;
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHHomePageTableViewCell class] forCellReuseIdentifier:kDBHHomePageTableViewCellIdentifier];
    }
    return _tableView;
}
- (DBHHomePageView *)homePageView {
    if (!_homePageView) {
        _homePageView = [[DBHHomePageView alloc] init];
        _homePageView.totalAsset = @"0.00";
        _homePageView.hidden = YES;
        
        WEAKSELF
        [_homePageView clickButtonBlock:^(NSInteger type) {
            switch (type) {
                case 0: {
                    // 资讯
                    
                    break;
                }
                case 1: {
                    // 个人中心
                    //                    DBHMyViewController *myViewController = [[DBHMyViewController alloc] init];
                    //                    [weakSelf.navigationController pushViewController:myViewController animated:YES];
                    
                    break;
                }
                case 2: {
                    // 资产
                    DBHWalletManagerViewController *walletManagerViewController = [[DBHWalletManagerViewController alloc] init];
                    [weakSelf.navigationController pushViewController:walletManagerViewController animated:YES];
                    
                    break;
                }
                case 3: {
                    [weakSelf.headerView refreshAsset];
                    break;
                }
                    
                default: {
                    
                    break;
                }
            }
        }];
    }
    return _homePageView;
}
- (DBHWalletLookPromptView *)walletLookPromptView {
    if (!_walletLookPromptView) {
        _walletLookPromptView = [[DBHWalletLookPromptView alloc] init];
        
        WEAKSELF
        [_walletLookPromptView selectedBlock:^(DBHWalletManagerForNeoModelList *model) {
            // 钱包详情
            if (model.category.categoryIdentifier == 1) {
                // ETH
                DBHWalletDetailWithETHViewController *walletDetailWithETHViewController = [[DBHWalletDetailWithETHViewController alloc] init];
                walletDetailWithETHViewController.ethWalletModel = model;
                   [weakSelf.navigationController pushViewController:walletDetailWithETHViewController animated:YES];
            } else {
                // NEO
                DBHWalletDetailViewController *walletDetailViewController = [[DBHWalletDetailViewController alloc] init];
                walletDetailViewController.neoWalletModel = model;
                [weakSelf.navigationController pushViewController:walletDetailViewController animated:YES];
            }
        }];
        
        [_walletLookPromptView addOrImportWalletBlock:^{
            
            DBHShowAddWalletViewController *vc = [[DBHShowAddWalletViewController alloc] init];
            vc.nc = weakSelf.navigationController;
            
            NSString *tokenName = weakSelf.walletLookPromptView.tokenName;
            if ([tokenName isEqualToString:NEO]) {
                vc.type = WalletTypeNEO;
            } else if ([tokenName isEqualToString:ETH]) {
                vc.type = WalletTypeETH;
            }
            
            MyNavigationController *naviVC = [[MyNavigationController alloc] initWithRootViewController:vc];
            naviVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [weakSelf presentViewController:naviVC animated:NO completion:^{
                [vc animateShow:YES completion:nil];
            }];
            //            [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.addWalletPromptView];
            //
            //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //                [weakSelf.addWalletPromptView animationShow];
            //            });
        }];
    }
    return _walletLookPromptView;
}

- (UILabel *)allAssetsLabel {
    if (!_allAssetsLabel) {
        _allAssetsLabel = [[UILabel alloc] init];
        _allAssetsLabel.text = DBHGetStringWithKeyFromTable(@"All assets", nil);
        _allAssetsLabel.textColor = COLORFROM16(0xC1BEBE, 1);
        _allAssetsLabel.font = BOLDFONT(10);
    }
    return _allAssetsLabel;
}

- (DBHWalletDetailTokenInfomationModelData *)neoModel {
    if (!_neoModel) {
        _neoModel = [[DBHWalletDetailTokenInfomationModelData alloc] init];
        _neoModel.name = @"NEO";
        _neoModel.icon = @"NEO_add";
        _neoModel.balance = @"0";
        _neoModel.priceCny = @"0";
        _neoModel.priceUsd = @"0";
        _neoModel.flag = @"NEO";
    }
    return _neoModel;
}

- (DBHWalletDetailTokenInfomationModelData *)gasModel {
    if (!_gasModel) {
        _gasModel = [[DBHWalletDetailTokenInfomationModelData alloc] init];
        _gasModel.name = GAS;
        _gasModel.icon = @"NEO_add";
        _gasModel.balance = @"0";
        _gasModel.priceCny = @"0";
        _gasModel.priceUsd = @"0";
        _gasModel.flag = GAS;
    }
    return _gasModel;
}

- (DBHWalletDetailTokenInfomationModelData *)ethModel {
    if (!_ethModel) {
        _ethModel = [[DBHWalletDetailTokenInfomationModelData alloc] init];
        _ethModel.name = @"ETH";
        _ethModel.icon = @"ETH_add";
        _ethModel.balance = @"0";
        _ethModel.priceCny = @"0";
        _ethModel.priceUsd = @"0";
        _ethModel.flag = @"ETH";
    }
    return _ethModel;
}

- (NSMutableArray *)tokensArray {
    if (!_tokensArray) {
        _tokensArray = [NSMutableArray array];
    }
    return _tokensArray;
}

- (NSMutableArray *)neowalletsArray {
    if (!_neowalletsArray) {
        _neowalletsArray = [NSMutableArray array];
    }
    return _neowalletsArray;
}

- (NSMutableArray *)ethwalletsArray {
    if (!_ethwalletsArray) {
        _ethwalletsArray = [NSMutableArray array];
    }
    return _ethwalletsArray;
}

- (UIButton *)hideZeroBtn {
    if (!_hideZeroBtn) {
        _hideZeroBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_hideZeroBtn addTarget:self action:@selector(respondsToHideZeroBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_hideZeroBtn setImage:[UIImage imageNamed:@"hide_zero_selected"] forState:UIControlStateSelected];
        [_hideZeroBtn setImage:[UIImage imageNamed:@"hide_zero_normal"] forState:UIControlStateNormal];
        [_hideZeroBtn setImage:[UIImage imageNamed:@"hide_zero_normal"] forState:UIControlStateHighlighted];
        [_hideZeroBtn setImage:[UIImage imageNamed:@"hide_zero_selected"] forState:UIControlStateSelected | UIControlStateHighlighted]; //选中后的高亮状态
        
        _hideZeroBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [_hideZeroBtn setTitle:DBHGetStringWithKeyFromTable(@"Hide 0 Tokens", nil) forState:UIControlStateNormal];
        [_hideZeroBtn setTitleColor:COLORFROM16(0xC1BEBE, 1) forState:UIControlStateNormal];
        
        _hideZeroBtn.titleLabel.font = BOLDFONT(10);
        
        CGFloat margin = AUTOLAYOUTSIZE(3);
        [_hideZeroBtn setImageEdgeInsets:UIEdgeInsetsMake(margin, 0, margin, -margin)];
        
    }
    return _hideZeroBtn;
}

@end
