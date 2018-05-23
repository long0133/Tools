//
//  DBHHomePageViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/5.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHHomePageViewController.h"

#import "PPNetworkCache.h"

#import "DBHWalletManagerViewController.h"
//#import "DBHMyViewController.h"
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

static NSString *const kDBHHomePageTableViewCellIdentifier = @"kDBHHomePageTableViewCellIdentifier";

@interface DBHHomePageViewController ()<RTDragCellTableViewDataSource, RTDragCellTableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) DBHHomePageHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DBHHomePageView *homePageView;
@property (nonatomic, strong) DBHWalletLookPromptView *walletLookPromptView;

@property (nonatomic, strong) DBHWalletDetailTokenInfomationModelData *neoModel;
@property (nonatomic, strong) DBHWalletDetailTokenInfomationModelData *gasModel;
@property (nonatomic, strong) DBHWalletDetailTokenInfomationModelData *ethModel;
@property (nonatomic, strong) NSMutableArray *walletListArray; // 钱包列表
@property (nonatomic, strong) NSMutableArray *neoWalletListArray; // NEO钱包列表
@property (nonatomic, strong) NSMutableArray *ethWalletListArray; // ETH钱包列表
@property (nonatomic, strong) NSMutableArray *cacheneoWalletListArray; // 缓存钱包列表
@property (nonatomic, strong) NSMutableArray *dataSource; // 代币列表

@property (nonatomic, strong) UILabel *allAssetsLabel;
//@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UIButton *hideZeroBtn;

@property (nonatomic, assign) BOOL isHideZero;

@property (nonatomic, assign) NSInteger type; // 0:添加钱包 1:导入钱包
@property (nonatomic, assign) NSInteger walletType; // 0:NEO 1:ETH

@property (nonatomic, strong) NSMutableArray *noZeroDatasource; // 没有为0的代币列表

@property (nonatomic, strong) NSString *cacheSortTokenKey;

@end

@implementation DBHHomePageViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setUI];
    [self addRefresh];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self getWalletList];
    [self judgeIsHideZero];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage getImageFromColor:WHITE_COLOR Rect:CGRectMake(0, 0, SCREENWIDTH, STATUSBARHEIGHT + 44)] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark ------ UI ------
- (void)setUI {
    WEAKSELF
//    [self.view addSubview:self.amountLabel];
    
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
    
//    [self.amountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.right.offset(-AUTOLAYOUTSIZE(20));
//        make.top.equalTo(weakSelf.headerView.mas_bottom);
//        make.height.offset(AUTOLAYOUTSIZE(20));
//    }];
    
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
    if (![UserSignData share].user.isLogin) {
        [[AppDelegate delegate] goToLoginVC:self];
    } else {
        DBHWalletDetailTokenInfomationModelData *model = self.isHideZero ? self.noZeroDatasource[indexPath.row] : self.dataSource[indexPath.row];
        NSString *type = model.typeName;
        
        NSString *dbTypeStr = @"NEO";
        if ([NSObject isNulllWithObject:type]) { // neo 或者 eth
            dbTypeStr = model.flag;
        } else {
            dbTypeStr = type;
        }
        
        self.walletLookPromptView.tokenName = model.name;
     
        NSMutableArray *data = ([dbTypeStr isEqualToString:@"NEO"]) ? [self.neoWalletListArray mutableCopy] : [self.ethWalletListArray mutableCopy];
        self.walletLookPromptView.dataSource = data;
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.walletLookPromptView];
        
        WEAKSELF
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.walletLookPromptView animationShow];
        });
    }
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
            DBHWalletDetailTokenInfomationModelData *model = (DBHWalletDetailTokenInfomationModelData *)obj;
            if (![model.flag isEqualToString:@"NEO"] && ![model.flag isEqualToString:@"Gas"] && ![model.flag isEqualToString:@"ETH"]) {
                NSString *bala = model.balance;
                if (bala.doubleValue == 0 && [weakSelf.noZeroDatasource containsObject:model]) { // 为0 且存在在数组中 移除
                    [weakSelf.noZeroDatasource removeObject:model];
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
    NSLog(@"cellDidEndMovingInTableView");
    
    NSMutableArray *flagArr = [NSMutableArray array];
    [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DBHWalletDetailTokenInfomationModelData *model = (DBHWalletDetailTokenInfomationModelData *)obj;
        if (![NSObject isNulllWithObject:model.flag]) {
            [flagArr addObject:model.flag];
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

/**
 获取钱包列表
 */
- (void)getWalletList {
    [self.cacheneoWalletListArray removeAllObjects];
    [self.walletListArray removeAllObjects];
    
    if (![UserSignData share].user.isLogin) {
        [self endRefresh];
        _dataSource = nil;
        
        [self dataStatistics];
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        WEAKSELF
        [PPNetworkHelper GET:@"wallet" baseUrlType:1 parameters:nil hudString:nil responseCache:^(id responseCache) {
            [weakSelf endRefresh];
            [weakSelf.walletListArray removeAllObjects];
            if (![UserSignData share].user.isLogin) {
            } else {
                NSArray *list = responseCache[LIST];
                if (list.count > 0) { //缓存中有数据
                    for (NSDictionary *dic in list) {
                        DBHWalletManagerForNeoModelList *model = [DBHWalletManagerForNeoModelList mj_objectWithKeyValues:dic];
                        
                        model.isLookWallet = [NSString isNulllWithObject:[PDKeyChain load:KEYCHAIN_KEY(model.address)]];
                        model.isBackUpMnemonnic = [[UserSignData share].user.walletIdsArray containsObject:@(model.listIdentifier)];
                        [weakSelf.walletListArray addObject:model];
                    }
                } else { //没数据
                    weakSelf.ethModel = nil;
                    weakSelf.neoModel = nil;
                    weakSelf.gasModel = nil;
                    
                    [weakSelf.neoWalletListArray removeAllObjects];
                    [weakSelf.ethWalletListArray removeAllObjects];
                }
            }
            
            [weakSelf getTokenData];
        } success:^(id responseObject) {
            [weakSelf endRefresh];
            
            [weakSelf.cacheneoWalletListArray removeAllObjects];
            
            NSArray *list = responseObject[LIST];
            if (list.count > 0) { //有数据
                for (NSDictionary *dic in list) {
                    DBHWalletManagerForNeoModelList *model = [DBHWalletManagerForNeoModelList mj_objectWithKeyValues:dic];
                    
                    model.isLookWallet = [NSString isNulllWithObject:[PDKeyChain load:KEYCHAIN_KEY(model.address)]];
                    model.isBackUpMnemonnic = [[UserSignData share].user.walletIdsArray containsObject:@(model.listIdentifier)];
                    [weakSelf.cacheneoWalletListArray addObject:model];
                }
            } else { // 无数据
                weakSelf.ethModel = nil;
                weakSelf.neoModel = nil;
                weakSelf.gasModel = nil;
                
                [weakSelf.neoWalletListArray removeAllObjects];
                [weakSelf.ethWalletListArray removeAllObjects];
                
                [weakSelf.walletListArray removeAllObjects];
            }
            
            [weakSelf getTokenData];
        } failure:^(NSString *error) {
            [weakSelf endRefresh];
            [LCProgressHUD showFailure: error];
        } specialBlock:^{
            if (![UserSignData share].user.isLogin) {
                return ;
            }
        }];
    });
}
/**
 获取代币数据
 */
- (void)getTokenData {
    NSMutableArray *walletIdArray = [NSMutableArray array];
    if (self.walletListArray.count > 0) {
        for (DBHWalletManagerForNeoModelList *model in self.walletListArray) {
            [walletIdArray addObject:@(model.listIdentifier)];
        }
    } else if (self.cacheneoWalletListArray.count > 0) {
        for (DBHWalletManagerForNeoModelList *model in self.cacheneoWalletListArray) {
            [walletIdArray addObject:@(model.listIdentifier)];
        }
    }
    
    if (walletIdArray.count == 0) {
        [self dataStatistics];
        return;
    }
    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:[walletIdArray toJSONStringForArray] forKey:@"wallet_ids"];
    
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        WEAKSELF
        [PPNetworkHelper GET:@"conversion" baseUrlType:1 parameters:parametersDic hudString:nil responseCache:^(id responseCache) {
            NSArray *dataArray = responseCache[LIST];
            if (dataArray.count > 0) {
                weakSelf.ethModel.balance = @"0";
                weakSelf.ethModel.priceCny = @"0";
                weakSelf.ethModel.priceUsd = @"0";
                for (NSDictionary *dic in dataArray) {
                    NSString *category_id = dic[@"category_id"];
                    if (category_id.integerValue == 1) {
                        // ETH
                        NSDictionary *category = dic[@"category"];
                        NSString *price_cny = @"0";
                        NSString *price_usd = @"0";
                        if (category != nil) {
                            NSDictionary *cap = category[CAP];
                            if (![cap isEqual:[NSNull null]]) {
                                price_cny = cap[PRICE_CNY];
                                price_usd = cap[PRICE_USD];
                            }
                        }
                        
                        NSString * price_ether;
                        if (![NSString isNulllWithObject:[dic objectForKey:BALANCE]])  {
                            price_ether = [NSString DecimalFuncWithOperatorType:3 first:[NSString numberHexString:[[dic objectForKey:BALANCE] substringFromIndex:2]] secend:@"1000000000000000000" value:8];
                        } else {
                            price_ether = [NSString DecimalFuncWithOperatorType:3 first:@"0" secend:@"1000000000000000000" value:8];
                        }
                        weakSelf.ethModel.balance = [NSString DecimalFuncWithOperatorType:0 first:weakSelf.ethModel.balance secend:price_ether value:8];
                        weakSelf.ethModel.priceCny = [NSString DecimalFuncWithOperatorType:2 first:weakSelf.ethModel.balance secend:price_cny value:2];
                        weakSelf.ethModel.priceUsd = [NSString DecimalFuncWithOperatorType:2 first:weakSelf.ethModel.balance secend:price_usd value:2];
                        
                        // 代币数量统计
                        
                        for (DBHWalletManagerForNeoModelList *model in weakSelf.walletListArray) {
                            NSString *walletId = dic[@"id"];
                            if (model.listIdentifier == walletId.integerValue) {
                                [model.tokenStatistics setObject:price_ether forKey:@"ETH"];
                            }
                        }
                        for (DBHWalletManagerForNeoModelList *model in weakSelf.cacheneoWalletListArray) {
                            NSString *walletId = dic[@"id"];
                            if (model.listIdentifier == walletId.integerValue) {
                                [model.tokenStatistics setObject:price_ether forKey:@"ETH"];
                            }
                        }
                    }
                }
            }
            
            [weakSelf dataStatistics];
        } success:^(id responseObject) {
            NSArray *dataArray = responseObject[LIST];
            if (dataArray.count > 0) {
                weakSelf.ethModel.balance = @"0";
                weakSelf.ethModel.priceCny = @"0";
                weakSelf.ethModel.priceUsd = @"0";
                for (NSDictionary *dic in dataArray) {
                    NSString *category_id = dic[@"category_id"];
                    if (category_id.integerValue == 1) { // ETH
                        NSString *price_cny = @"0";
                        NSString *price_usd = @"0";
                        
                        NSDictionary *category = dic[@"category"];
                        if (category != nil) {
                            NSDictionary *cap = category[CAP];
                            if (![cap isEqual:[NSNull null]]) {
                                price_cny = cap[PRICE_CNY];
                                price_usd = cap[PRICE_USD];
                            }
                        }
                        
                        NSString * price_ether;
                        if (![NSString isNulllWithObject:[dic objectForKey:BALANCE]]) {
                            price_ether = [NSString DecimalFuncWithOperatorType:3 first:[NSString numberHexString:[[dic objectForKey:BALANCE] substringFromIndex:2]] secend:@"1000000000000000000" value:8];
                        } else {
                            price_ether = [NSString DecimalFuncWithOperatorType:3 first:@"0" secend:@"1000000000000000000" value:8];
                        }
                        weakSelf.ethModel.balance = [NSString DecimalFuncWithOperatorType:0 first:weakSelf.ethModel.balance secend:price_ether value:8];
                        weakSelf.ethModel.priceCny = [NSString DecimalFuncWithOperatorType:2 first:weakSelf.ethModel.balance secend:price_cny value:2];
                        weakSelf.ethModel.priceUsd = [NSString DecimalFuncWithOperatorType:2 first:weakSelf.ethModel.balance secend:price_usd value:2];
                        
                        // 代币数量统计
                        for (DBHWalletManagerForNeoModelList *model in weakSelf.walletListArray) {
                            NSString *walletId = dic[@"id"];
                            if (model.listIdentifier == walletId.integerValue) {
                                [model.tokenStatistics setObject:price_ether forKey:@"ETH"];
                            }
                        }
                        for (DBHWalletManagerForNeoModelList *model in weakSelf.cacheneoWalletListArray) {
                            NSString *walletId = dic[@"id"];
                            if (model.listIdentifier == walletId.integerValue) {
                                [model.tokenStatistics setObject:price_ether forKey:@"ETH"];
                            }
                        }
                    }
                }
            }
            
            [weakSelf dataStatistics];
        } failure:^(NSString *error)
         {
             [LCProgressHUD showFailure:error];
         } specialBlock:nil];
    });
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_queue_t queue=dispatch_queue_create(NULL, DISPATCH_QUEUE_SERIAL);
    //获取代币余额列表
    for (DBHWalletManagerForNeoModelList *model in self.walletListArray)  {
        dispatch_group_async(group, queue, ^
                             {
                                 //获取代币余额列表
                                 [PPNetworkHelper GET:[NSString stringWithFormat:@"conversion/%ld", (NSInteger)model.listIdentifier] baseUrlType:1 parameters:nil hudString:nil responseCache:^(id responseCache)
                                  {
                                  } success:^(id responseObject)
                                  {
                                     
                                      dispatch_semaphore_signal(semaphore);
                                  } failure:^(NSString *error)
                                  {
                                      dispatch_semaphore_signal(semaphore);
                                  } specialBlock:nil];
                                 dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                             });
    }
    WEAKSELF
    dispatch_group_notify(group, queue, ^{
        //所有请求返回数据后执行
        weakSelf.walletListArray = [weakSelf.cacheneoWalletListArray mutableCopy];
        [weakSelf dataStatistics];
    });
}

#pragma mark ------ Private Methods ------
/**
 数据统计
 */
- (void)dataStatistics {
    self.neoModel.balance = @"0";
    self.neoModel.priceCny = @"0";
    self.neoModel.priceUsd = @"0";
    self.gasModel.balance = @"0";
    self.gasModel.priceCny = @"0";
    self.gasModel.priceUsd = @"0";
    
    NSInteger limitValue = 2; // 开始时本地添加的条目数
    if (self.dataSource.count >= limitValue) {
        [self.dataSource replaceObjectAtIndex:0 withObject:self.neoModel];
        [self.dataSource replaceObjectAtIndex:1 withObject:self.ethModel];
        [self.dataSource removeObjectsInRange:NSMakeRange(limitValue, self.dataSource.count - limitValue)];
    }
    
    [self.neoWalletListArray removeAllObjects];
    [self.ethWalletListArray removeAllObjects];
    
    NSString *sum = @"0";
    for (DBHWalletManagerForNeoModelList *walletModel in self.walletListArray) {
        if (walletModel.category.categoryIdentifier == 1) {
            // ETH
            [self.ethWalletListArray addObject:walletModel];
        } else {
            // NEO
            [self.neoWalletListArray addObject:walletModel];
        }
        NSString *key = [NSString stringWithFormat:@"conversion/%ld/", (NSInteger)walletModel.listIdentifier];
        if (![NSString isNulllWithObject:[PPNetworkCache getResponseCacheForKey:key]]) { // 缓存的代币列表 TNC
            NSDictionary *responseObject = [PPNetworkCache getResponseCacheForKey:key];
            if ([NSObject isNulllWithObject:responseObject]) {
                break;
            }
            
            if (walletModel.category.categoryIdentifier == 1) {
                // ETH
                if ([[responseObject objectForKey:LIST] count] > 0) {
                    for (NSDictionary *dic in [responseObject objectForKey:LIST]) {
                        if ([NSObject isNulllWithObject:dic]) {
                            break;
                        }
                        
                        NSString *price_cny = [[[dic objectForKey:GNT_CATEGORY] objectForKey:CAP] objectForKey:PRICE_CNY];
                        NSString *price_usd = [[[dic objectForKey:GNT_CATEGORY] objectForKey:CAP] objectForKey:PRICE_CNY];
                        NSString *symbol = dic[@"symbol"];
                        if ([NSObject isNulllWithObject:dic[GNT_CATEGORY][CAP]]) {
                            price_cny = @"0";
                            price_usd = @"0";
                        }
                        NSInteger index = [self foundNeoModelWithArray:[self.dataSource copy] name:dic[NAME]];
                        if (index >= 0) {
                            if (index < self.dataSource.count) {
                                // 找到
                                DBHWalletDetailTokenInfomationModelData *model = self.dataSource[index];
                                model.symbol = symbol;
                                if (![NSString isNulllWithObject:[dic objectForKey:BALANCE]]) {
                                    NSString *decimals = dic[DECIMALS];
                                    NSString *balance = [dic objectForKey:BALANCE];
                                    NSString *ether = [NSString DecimalFuncWithOperatorType:3 first:[NSString numberHexString:[balance substringFromIndex:2]] secend:[NSString stringWithFormat:@"%lf", pow(10, decimals.doubleValue)] value:8];
                                    model.balance = [NSString DecimalFuncWithOperatorType:0 first:model.balance secend:ether value:4];
                                    model.priceCny = [NSString DecimalFuncWithOperatorType:0 first:model.priceCny secend:[NSString DecimalFuncWithOperatorType:2 first:model.balance secend:price_cny value:2] value:2];
                                    model.priceUsd = [NSString DecimalFuncWithOperatorType:0 first:model.priceUsd secend:[NSString DecimalFuncWithOperatorType:2 first:model.balance secend:price_usd value:2] value:2];
                                    
                                    NSString *price = [NSString DecimalFuncWithOperatorType:2 first:model.balance secend:[UserSignData share].user.walletUnitType == 1 ? model.priceCny : model.priceUsd value:5];
                                    sum = [NSString DecimalFuncWithOperatorType:0 first:sum secend:price value:5];
                                    // 代币数量统计
                                    [walletModel.tokenStatistics setObject:model.balance forKey:model.name];
                                }
                            
                                [self.dataSource replaceObjectAtIndex:index withObject:model];
                            }
                        } else {
                            // 没找到
                            DBHWalletDetailTokenInfomationModelData *model = [[DBHWalletDetailTokenInfomationModelData alloc] init];
                            model.address = dic[GNT_CATEGORY][@"address"];
                            model.symbol = symbol;
                            NSString *typeName = walletModel.category.name;
                            model.typeName = typeName;
                            
                            model.name = dic[GNT_CATEGORY][NAME];
                            model.icon = dic[GNT_CATEGORY][@"icon"];
                            
                            if (![NSString isNulllWithObject:dic[BALANCE]]) {
                                NSString *decimals = dic[DECIMALS];
                                model.balance = [NSString DecimalFuncWithOperatorType:3 first:[NSString numberHexString:[dic[BALANCE] substringFromIndex:2]] secend:[NSString stringWithFormat:@"%lf", pow(10, decimals.doubleValue)] value:8];
                            } else {
                                model.balance = @"0.0000";
                            }
                            
                            NSString *price_cny = [[[dic objectForKey:GNT_CATEGORY] objectForKey:CAP] objectForKey:PRICE_CNY];
                            NSString *price_usd = [[[dic objectForKey:GNT_CATEGORY] objectForKey:CAP] objectForKey:PRICE_USD];
                            if ([NSObject isNulllWithObject:dic[GNT_CATEGORY][CAP]]) {
                                price_cny = @"0";
                                price_usd = @"0";
                            }
                            model.priceCny = [NSString DecimalFuncWithOperatorType:2 first:model.balance secend:price_cny value:2];
                            model.priceUsd = [NSString DecimalFuncWithOperatorType:2 first:model.balance secend:price_usd value:2];
                            model.flag = dic[GNT_CATEGORY][NAME];
                            
                            NSString *price = [NSString DecimalFuncWithOperatorType:2 first:model.balance secend:[UserSignData share].user.walletUnitType == 1 ? model.priceCny : model.priceUsd value:5];
                            sum = [NSString DecimalFuncWithOperatorType:0 first:sum secend:price value:5];
                            
                            // 代币数量统计
                            [walletModel.tokenStatistics setObject:model.balance forKey:model.name];
                            [self.dataSource addObject:model];
                        }
                    }
                }
            } else {
                // NEO
                NSDictionary *record = responseObject[RECORD];
                
                NSString *neoNumber = [NSString stringWithFormat:@"%@", record[BALANCE]];
                
                NSString *neoPriceForCny = @"0";
                NSString *neoPriceForUsd = @"0";
                if (![record isEqual:[NSNull null]]) {
                    NSDictionary *cap = record[CAP];
                    if (![cap isEqual:[NSNull null]]) {
                        neoPriceForCny = cap[PRICE_CNY];
                        neoPriceForUsd = cap[PRICE_USD];
                    }
                }
                
                self.neoModel.balance = [NSString stringWithFormat:@"%.4lf", self.neoModel.balance.doubleValue + neoNumber.doubleValue];
                self.neoModel.priceCny = neoPriceForCny;
                self.neoModel.priceUsd = neoPriceForUsd;
                
                NSArray *gny = record[GNT];
                NSDictionary *gas = gny.firstObject;
                
                NSString *gasPriceForCny = @"0";
                NSString *gasPriceForUsd = @"0";
                if (![gas isEqual:[NSNull null]]) {
                    NSDictionary *cap = gas[CAP];
                    if (![cap isEqual:[NSNull null]]) {
                        gasPriceForCny = cap[PRICE_CNY];
                        gasPriceForUsd = cap[PRICE_USD];
                    }
                }
                
                NSString *gasNumber = [NSString stringWithFormat:@"%@", gas[BALANCE]];
                self.gasModel.balance = [NSString stringWithFormat:@"%.8lf", self.gasModel.balance.doubleValue + gasNumber.doubleValue];
                self.gasModel.priceCny = gasPriceForCny;
                self.gasModel.priceUsd = gasPriceForUsd;
                self.gasModel.flag = @"Gas";
                
                NSString *typeName = walletModel.category.name;
                self.gasModel.typeName = typeName;
                
                // 代币数量统计
                [walletModel.tokenStatistics setObject:neoNumber forKey:self.neoModel.name];
                [walletModel.tokenStatistics setObject:gasNumber forKey:self.gasModel.name];
                
                for (NSDictionary * dic in [responseObject objectForKey:LIST]) { // 代币列表
                    NSString *symbol = dic[@"symbol"];
                    NSString *price_cny = [[[dic objectForKey:GNT_CATEGORY] objectForKey:CAP] objectForKey:PRICE_CNY];
                    NSString *price_usd = [[[dic objectForKey:GNT_CATEGORY] objectForKey:CAP] objectForKey:PRICE_CNY];
                    if ([NSObject isNulllWithObject:dic[GNT_CATEGORY][CAP]]) {
                        price_cny = @"0";
                        price_usd = @"0";
                    }
                    NSInteger index = [self foundNeoModelWithArray:[self.dataSource copy] name:dic[NAME]];
                    if (index >= 0) {
                        if (index < self.dataSource.count) {
                            // 找到
                            DBHWalletDetailTokenInfomationModelData *tokenModel = self.dataSource[index];
                            NSString *balance = @"0";
                            tokenModel.symbol = symbol;
                            if (![NSString isNulllWithObject:[dic objectForKey:BALANCE]])
                            {
                                NSData *data = [self convertHexStrToData:dic[BALANCE]];
                                NSString *decimals = dic[DECIMALS];
                                tokenModel.decimals = decimals;
                                balance = [NSString stringWithFormat:@"%lf", [self getBalanceWithByte:(Byte *)data.bytes length:data.length] / pow(10, decimals.doubleValue)];
                                tokenModel.balance = [NSString stringWithFormat:@"%@", @(tokenModel.balance.doubleValue + balance.doubleValue)];
                            }
                        
                            [self.dataSource replaceObjectAtIndex:index withObject:tokenModel];
                        
                            // 代币数量统计
                            [walletModel.tokenStatistics setObject:balance forKey:tokenModel.name];
                        }
                    } else {
                        // 没找到
                        DBHWalletDetailTokenInfomationModelData *tokenModel = [[DBHWalletDetailTokenInfomationModelData alloc] initWithDictionary:dic];
                        tokenModel.flag = tokenModel.name;
                        tokenModel.symbol = symbol;
                        tokenModel.icon = [[dic objectForKey:GNT_CATEGORY] objectForKey:@"icon"];
                        
                        NSString *typeName = walletModel.category.name;
                        tokenModel.typeName = typeName;
                        if (![NSString isNulllWithObject:[dic objectForKey:BALANCE]]) {
                            NSData *data = [self convertHexStrToData:dic[BALANCE]];
                            NSString *decimals = dic[DECIMALS];
                            tokenModel.decimals = decimals;
                            tokenModel.balance = [NSString stringWithFormat:@"%lf", [self getBalanceWithByte:(Byte *)data.bytes length:data.length] / pow(10, decimals.doubleValue)];
                        }
                        else {
                            tokenModel.balance = @"0";
                        }
                        if ([NSObject isNulllWithObject:dic[GNT_CATEGORY][CAP]]) {
                            price_cny = @"0";
                            price_usd = @"0";
                        }
                        tokenModel.priceCny = price_cny;
                        tokenModel.priceUsd = price_usd;
                        
                        [self.dataSource addObject:tokenModel];
                        
                        // 代币数量统计
                        [walletModel.tokenStatistics setObject:tokenModel.balance forKey:tokenModel.name];
                    }
                }
            }
        }
    }
    
    if (self.gasModel.balance.doubleValue > 0.0f) { // 如果有gas,则显示
        if (self.dataSource.count > 0) {
            if (self.dataSource.count >= limitValue) {
                [self.dataSource insertObject:self.gasModel atIndex:limitValue];
            } else {
                [self.dataSource addObject:self.gasModel];
            }
        }
    } else if ([self.dataSource containsObject:self.gasModel]) { //如果没有gas且已显示，则删除
        [self.dataSource removeObject:self.gasModel];
    }
    
    WEAKSELF
    
    __block NSString *tokenTotal = @"0";
    NSArray *sortedFlags = [UserSignData share].user.sortedTokenFlags;
    if (sortedFlags.count > 0) {
        __block NSMutableArray *sortArr = [NSMutableArray array];
        for (int i = 0; i < sortedFlags.count; i ++) {
            NSString *flag = sortedFlags[i];
            [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                DBHWalletDetailTokenInfomationModelData *model = (DBHWalletDetailTokenInfomationModelData *)obj;
                if ([model.flag isEqualToString:flag]) { // 放在对应的index上
                    [sortArr addObject:model];
                    [weakSelf.dataSource removeObject:model];
                }
            }];
        }
        
        [sortArr addObjectsFromArray:self.dataSource];
        self.dataSource = sortArr;
    }
    
    self.noZeroDatasource = [NSMutableArray arrayWithArray:self.dataSource];
    [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DBHWalletDetailTokenInfomationModelData *model = (DBHWalletDetailTokenInfomationModelData *)obj;
        if (![model.flag isEqualToString:@"NEO"] && ![model.flag isEqualToString:@"Gas"] && ![model.flag isEqualToString:@"ETH"]) {
            NSString *tokenPrice = [NSString DecimalFuncWithOperatorType:2 first:model.balance secend:[UserSignData share].user.walletUnitType == 1 ? model.priceCny : model.priceUsd value:2];
            tokenTotal = [NSString DecimalFuncWithOperatorType:0 first:tokenTotal secend:tokenPrice value:2];
            
            NSString *bala = model.balance;
            if (bala.doubleValue == 0 && [weakSelf.noZeroDatasource containsObject:model]) { // 为0 且存在在数组中 移除
                [weakSelf.noZeroDatasource removeObject:model];
            }
        }
    }];
    
    NSString *neoPrice = [NSString DecimalFuncWithOperatorType:2 first:weakSelf.neoModel.balance secend:[UserSignData share].user.walletUnitType == 1 ? weakSelf.neoModel.priceCny : weakSelf.neoModel.priceUsd value:2];
    NSString *gasPrice = [NSString DecimalFuncWithOperatorType:2 first:weakSelf.gasModel.balance secend:[UserSignData share].user.walletUnitType == 1 ? weakSelf.gasModel.priceCny : weakSelf.gasModel.priceUsd value:2];
    NSString *ethPrice = @"0";
    if (weakSelf.ethModel) {
        ethPrice = [UserSignData share].user.walletUnitType == 1 ? weakSelf.ethModel.priceCny : weakSelf.ethModel.priceUsd;
    }
    
    NSString *gasNeo = [NSString DecimalFuncWithOperatorType:0 first:neoPrice secend:gasPrice value:2];
    NSString *ethDB = [NSString DecimalFuncWithOperatorType:0 first:ethPrice secend:tokenTotal value:2];
    
    NSString *type = [UserSignData share].user.walletUnitType == 1 ? @"¥" : @"$";
    
    NSString *totalAsset = [NSString DecimalFuncWithOperatorType:0 first:gasNeo secend:ethDB value:2];
//    totalAsset = [totalAsset isEqualToString:@"0"] ? @"0.00" : totalAsset;

    if ([NSObject isNulllWithObject:totalAsset]) {
        totalAsset = @"0.00";
    }
    if ([[NSThread currentThread] isMainThread]) {
        weakSelf.homePageView.totalAsset = [NSString stringWithFormat:@"%@ %.2lf", type, totalAsset.doubleValue];
        weakSelf.headerView.totalAsset = [NSString stringWithFormat:@"%@ %.2lf", type, totalAsset.doubleValue];
        
        [weakSelf.tableView reloadData];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.homePageView.totalAsset = [NSString stringWithFormat:@"%@ %.2lf", type, totalAsset.doubleValue];
            weakSelf.headerView.totalAsset = [NSString stringWithFormat:@"%@ %.2lf", type, totalAsset.doubleValue];
            
            [weakSelf.tableView reloadData];
        });
    }
}


/**
 从数组中查找name
 
 @param array 数组
 @param name name
 */
- (NSInteger)foundNeoModelWithArray:(NSArray *)array name:(NSString *)name {
    for (NSInteger i = 0; i < array.count; i++) {
        DBHWalletDetailTokenInfomationModelData *model = array[i];
        
        if ([model.name isEqualToString:name]) {
            return i;
        }
    }
    
    return -1;
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
- (NSString *)cacheSortTokenKey {
    if (!_cacheSortTokenKey) {
        _cacheSortTokenKey = [NSString stringWithFormat:@"user-gnt-sort-all_%@", [UserSignData share].user.token];
    }
    return _cacheSortTokenKey;
}

- (DBHHomePageHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[DBHHomePageHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, AUTOLAYOUTSIZE(385))];
        
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
        _gasModel.name = @"Gas";
        _gasModel.icon = @"NEO_add";//@"NEO_project_icon_Gas";
        _gasModel.balance = @"0";
        _gasModel.priceCny = @"0";
        _gasModel.priceUsd = @"0";
        _gasModel.flag = @"Gas";
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
- (NSMutableArray *)cacheneoWalletListArray {
    if (!_cacheneoWalletListArray) {
        _cacheneoWalletListArray = [NSMutableArray array];
    }
    return _cacheneoWalletListArray;
}
- (NSMutableArray *)walletListArray {
    if (!_walletListArray) {
        _walletListArray = [NSMutableArray array];
    }
    return _walletListArray;
}
- (NSMutableArray *)neoWalletListArray {
    if (!_neoWalletListArray) {
        _neoWalletListArray = [NSMutableArray array];
    }
    return _neoWalletListArray;
}
- (NSMutableArray *)ethWalletListArray {
    if (!_ethWalletListArray) {
        _ethWalletListArray = [NSMutableArray array];
    }
    return _ethWalletListArray;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        
        [_dataSource addObject:self.neoModel];
        [_dataSource addObject:self.ethModel];
    }
    return _dataSource;
}

- (NSMutableArray *)noZeroDatasource {
    if (!_noZeroDatasource) {
        _noZeroDatasource = [NSMutableArray array];
    }
    return _noZeroDatasource;
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

//- (UILabel *)amountLabel {
//    if (!_amountLabel) {
//        _amountLabel = [[UILabel alloc] init];
//        _amountLabel.text = DBHGetStringWithKeyFromTable(@"Hide 0 Tokens", nil);
//        _amountLabel.textColor = COLORFROM16(0xC1BEBE, 1);
//        _amountLabel.font = BOLDFONT(10);
//    }
//    return _amountLabel;
//}
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
