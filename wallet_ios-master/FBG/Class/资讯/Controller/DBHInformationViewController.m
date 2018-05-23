//
//  DBHInformationViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/19.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHInformationViewController.h"

#import <HyphenateLite/HyphenateLite.h>

#import "DBHSearchViewController.h"
#import "DBHPaymentReceivedViewController.h"
#import "DBHProjectHomeViewController.h"
#import "DBHProjectHomeNoTradingViewController.h"
#import "DBHInWeHotViewController.h"
#import "DBHTradingViewViewController.h"
#import "DBHExchangeNoticeViewController.h"
#import "DBHCandyBowlViewController.h"
#import "DBHTraderClockViewController.h"
#import "DBHNotificationViewController.h"
#import "DBHCreateWalletViewController.h"
#import "DBHImportWalletViewController.h"
#import "YYRedPacketViewController.h"

#import "DBHInformationTitleView.h"
#import "DBHMenuView.h"
#import "DBHInformationHeaderView.h"
#import "DBHAddWalletPromptView.h"
#import "DBHSelectWalletTypeOnePromptView.h"
#import "DBHSelectWalletTypeTwoPromptView.h"
#import "DBHInformationTableViewCell.h"

#import "DBHInformationDataModels.h"
#import "DBHInformationForICODataModels.h"
#import "DBHImportWalletWithETHViewController.h"
#import "DBHCreateWalletWithETHViewController.h"
#import "DBHShowAddWalletViewController.h"
#import "DBHInfoScrollTableViewCell.h"
#import "DBHUnLoginTableCell.h"
#import "DBHCheckVersionModel.h"

#import "DBHProjectHomeNewsModelData.h"
#import "DBHRankViewController.h"

#import "ScanVC.h"

static NSString *const kDBHInformationTableViewCellIdentifier = @"kDBHInformationTableViewCellIdentifier";
static NSString *const kDBHInfoScrollTableViewCell = @"kDBHInfoScrollTableViewCell";
static NSString *const kDBHUnLoginTableCell = @"kDBHUnLoginTableCell";

@interface DBHInformationViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, EMChatManagerDelegate>

@property (nonatomic, strong) DBHInformationTitleView *informationTitleView;
@property (nonatomic, strong) DBHMenuView *menuView;
@property (nonatomic, strong) DBHInformationHeaderView *informationHeaderView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) BOOL isShowLoopScroll;
@property (nonatomic, strong) NSArray *menuArray; // 菜单选项
@property (nonatomic, copy) NSArray *titleArray; // 功能组件标题
@property (nonatomic, strong) NSMutableArray *conversationCacheArray; // 功能组件会话列表
@property (nonatomic, strong) NSMutableArray *conversationArray; // 功能组件会话列表
@property (nonatomic, strong) NSMutableArray *contentArray; // 功能组件最新消息
@property (nonatomic, strong) NSMutableArray *timeArray; // 功能组件最新消息时间
@property (nonatomic, strong) NSMutableArray *noReadArray; // 未读消息数量
@property (nonatomic, copy) NSArray *titleGroupNameArray; // 功能组件对应环信的组名
//@property (nonatomic, strong) NSMutableArray *functionalUnitArray; // 功能组件
@property (nonatomic, strong) NSMutableArray *dataSource; // 项目
@property (nonatomic, strong) NSMutableArray *icoArray; // ico

@property (nonatomic, assign) NSInteger type; // 0:添加钱包 1:导入钱包
@property (nonatomic, assign) NSInteger walletType; // 0:NEO 1:ETH

@property (nonatomic, strong) NSMutableArray *loopTitles;
@property (nonatomic, strong) NSMutableArray *loopImages;

@property (nonatomic, strong) NSMutableArray *scrollInfoDatasource;

@property (nonatomic, strong) DBHInfoScrollTableViewCell *cell;

@end


@implementation DBHInformationViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![self isReview]) {
        [[DBHCheckVersionModel sharedInstance] checkVersion:nil];
    }
    
    [self setUI];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (BOOL)isReview {
    return [[NSUserDefaults standardUserDefaults] boolForKey:CHECK_STATUS];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage getImageFromColor:WHITE_COLOR Rect:CGRectMake(0, 0, SCREENWIDTH, STATUSBARHEIGHT + 44)] forBarMetrics:UIBarMetricsDefault];
    [super viewWillAppear:animated];
    // 注册消息回调
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackground) name:@"enter_backgroud" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForeground) name:@"enter_foreground" object:nil];
    [self enterForeground];
    
    [self getScrollInformation];
    [self getFunctionalUnit];
}

- (void)enterBackground {
    if (self.cell) {
        [self.cell invalidateTimers];
    }
}

- (void)enterForeground {
    if (self.cell) {
        [self.cell scrollToZero];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self enterBackground];
    //移除消息回调
    [[EMClient sharedClient].chatManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark ------ UI ------
- (void)setUI {
    self.navigationItem.titleView = self.informationTitleView;
    
    WEAKSELF
    [self.view addSubview:self.tableView];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.view);
        make.center.equalTo(weakSelf.view);
    }];
    
    [self judgeIsShowGuide];
    self.isShowLoopScroll = YES;
}

- (void)judgeIsShowGuide {
    BOOL isShow = [[NSUserDefaults standardUserDefaults] boolForKey:IS_SHOW_INFO_GUIDE];
    if (!isShow) {
        [self addGuideView];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_SHOW_INFO_GUIDE];
    }
}

- (void)addGuideView {
    [self.view layoutIfNeeded];
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect frame = [UIScreen mainScreen].bounds;
    UIView *bgView = [[UIView alloc] initWithFrame:frame];
    
    bgView.backgroundColor = COLORFROM16(0x323232, 0.8);
    //    STATUSBARHEIGHT
    /* 箭头img */
    UIImageView *arrowImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"info_guide_arrow"]];
    
    CGFloat width = AUTOLAYOUTSIZE(30);
    arrowImg.contentMode = UIViewContentModeScaleAspectFit;
    CGRect moreBtnframe = self.informationTitleView.moreButton.frame;
    arrowImg.frame = CGRectMake(CGRectGetMidX(moreBtnframe) - CGRectGetWidth(moreBtnframe) / 2, CGRectGetMaxY(moreBtnframe) + STATUSBARHEIGHT - AUTOLAYOUTSIZE(12), width, width);
    
    //(origin = (x = 320, y = 0), size = (width = 39, height = 40))
    /* 提示img */
    UIImageView *tipImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed: DBHGetStringWithKeyFromTable(@"info_guide_tip_en", nil)]];
    
    tipImg.contentMode = UIViewContentModeScaleAspectFit;
    
    CGRect arrowImgframe = arrowImg.frame;
    CGRect tipFrame =  tipImg.frame;
    tipFrame.size.height = 90;
    tipFrame.size.width = AUTOLAYOUTSIZE(155);
    tipFrame.origin.y = CGRectGetMaxY(arrowImgframe) - 5;
    tipFrame.origin.x = CGRectGetMinX(arrowImgframe) - tipFrame.size.width + 5;
    tipImg.frame = tipFrame;
    
    UIButton *iKownBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    width = AUTOLAYOUTSIZE(100);
    
    CGRect btnFrame = iKownBtn.frame;
    btnFrame.origin.x = CGRectGetMidX(tipFrame) - width / 2;
    btnFrame.origin.y = CGRectGetMaxY(tipFrame) + 28;
    btnFrame.size.width = width;
    btnFrame.size.height = 36;
    
    iKownBtn.frame = btnFrame;
    
    iKownBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [iKownBtn setImage:[UIImage imageNamed:DBHGetStringWithKeyFromTable(@"info_guide_ikown_en", nil)] forState:UIControlStateNormal];
    [iKownBtn addTarget:self action:@selector(iKownClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [bgView addSubview:arrowImg];
    [bgView addSubview:tipImg];
    [bgView addSubview:iKownBtn];
    
    [keyWindow addSubview:bgView];
}

- (void)iKownClicked:(UIButton *)btn {
    [btn.superview removeFromSuperview];
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2; //!self.informationHeaderView.currentSelectedIndex ? 2 : 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    
    if (self.informationHeaderView.currentSelectedIndex == 0 && ![UserSignData share].user.isLogin) { // 第一个
        return 1; // 未登录cell
    }
    
    NSMutableArray *dataArray = self.dataSource[self.informationHeaderView.currentSelectedIndex];
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /**if (!indexPath.section && !self.informationHeaderView.currentSelectedIndex) { // 前五个
     cell.functionalUnitTitle = self.functionalUnitArray[indexPath.row];
     cell.content = self.contentArray[indexPath.row];
     cell.time = self.timeArray[indexPath.row];
     cell.noReadNumber = self.noReadArray[indexPath.row];
     cell.isHasNum = YES;
     } else { // 收藏的或者交易中/正在进行/即将开始/已结束 */
    
    if (indexPath.section == 0) { // 轮播
        DBHInfoScrollTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHInfoScrollTableViewCell forIndexPath:indexPath];
//        cell.isShowScroll = self.isShowLoopScroll;
        if (self.loopImages.count > 0 || self.loopTitles.count > 0) { //必要
            [cell setTitles:self.loopTitles images:self.loopImages models:self.scrollInfoDatasource];
        }
        
        WEAKSELF
        [cell setBlock:^ {
            if (weakSelf.isShowLoopScroll) { // 现在是显示
                [weakSelf hideImageScroll:YES];
            } else { // 现在是隐藏
                [weakSelf hideImageScroll:NO];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.tableView setContentOffset:CGPointMake(0,0) animated:YES];
                });
            }
        }];
        _cell = cell;
        return cell;
    }
    
   
    if (self.informationHeaderView.currentSelectedIndex == 0 && ![UserSignData share].user.isLogin) { // 第一个  // 自选未登录
        DBHUnLoginTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHUnLoginTableCell forIndexPath:indexPath];
        
        return cell;
    }
    
    
    // 登录后的 自选/项目
    DBHInformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHInformationTableViewCellIdentifier forIndexPath:indexPath];
    NSMutableArray *array1 = self.icoArray[self.informationHeaderView.currentSelectedIndex]; // 交易行情数据
    NSMutableArray *array2 = self.dataSource[self.informationHeaderView.currentSelectedIndex];

    cell.currentSelectedTitleIndex = self.informationHeaderView.currentSelectedIndex;
    
    if (indexPath.row < array1.count) {
        cell.icoModel = self.icoArray[self.informationHeaderView.currentSelectedIndex][indexPath.row];
    }
    if (indexPath.row < array2.count) {
        cell.model = self.dataSource[self.informationHeaderView.currentSelectedIndex][indexPath.row];
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0.01)];
    }
    return self.informationHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }
    
    return CGRectGetHeight(self.informationHeaderView.frame);
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /**if (!indexPath.section && !self.informationHeaderView.currentSelectedIndex) {
     // 标识为已读
     if (![self.conversationArray[indexPath.row] isKindOfClass:[NSString class]]) {
     EMConversation *conversation = self.conversationArray[indexPath.row];
     [conversation markAllMessagesAsRead:nil];
     }
     
     switch ([self.titleArray indexOfObject:self.functionalUnitArray[indexPath.row]]) {
     case 0: {
     // InWe热点
     DBHInWeHotViewController *inWeHotViewController = [[DBHInWeHotViewController alloc] init];
     inWeHotViewController.title = DBHGetStringWithKeyFromTable(self.functionalUnitArray[indexPath.row], nil);
     inWeHotViewController.functionalUnitType = 0;
     inWeHotViewController.conversation = self.conversationArray[indexPath.row];
     [self.navigationController pushViewController:inWeHotViewController animated:YES];
     break;
     }
     case 1: {
     // TradingView
     DBHTradingViewViewController *tradingViewViewController = [[DBHTradingViewViewController alloc] init];
     tradingViewViewController.title = DBHGetStringWithKeyFromTable(self.functionalUnitArray[indexPath.row], nil);
     tradingViewViewController.functionalUnitType = 1;
     tradingViewViewController.conversation = self.conversationArray[indexPath.row];
     [self.navigationController pushViewController:tradingViewViewController animated:YES];
     break;
     }
     case 2: {
     // 交易所公告
     DBHExchangeNoticeViewController *exchangeNoticeViewController = [[DBHExchangeNoticeViewController alloc] init];
     exchangeNoticeViewController.title = DBHGetStringWithKeyFromTable(self.functionalUnitArray[indexPath.row], nil);
     exchangeNoticeViewController.functionalUnitType = 2;
     exchangeNoticeViewController.conversation = self.conversationArray[indexPath.row];
     [self.navigationController pushViewController:exchangeNoticeViewController animated:YES];
     break;
     }
     //            case 3: {
     //                // CandyBowl
     //                DBHCandyBowlViewController *candyBowlViewController = [[DBHCandyBowlViewController alloc] init];
     //                candyBowlViewController.title = DBHGetStringWithKeyFromTable(self.functionalUnitArray[indexPath.row], nil);
     //                candyBowlViewController.functionalUnitType = 3;
     //                candyBowlViewController.conversation = self.conversationArray[indexPath.row];
     //                [self.navigationController pushViewController:candyBowlViewController animated:YES];
     //                break;
     //            }
     case 3: {
     // 交易提醒
     [self goToTradeClockVC:self.functionalUnitArray[indexPath.row] conversation:self.conversationArray[indexPath.row]];
     
     break;
     }
     case 4: {
     // 通知
     [self goToNotificationVC:self.functionalUnitArray[indexPath.row] conversation:self.conversationArray[indexPath.row]];
     break;
     }
     
     default:
     break;
     }
     } else {*/
    if (indexPath.section == 0) {
        //TODO
    } else if (self.informationHeaderView.currentSelectedIndex == 0 && ![UserSignData share].user.isLogin) {
        // 未登录cell
    } else {
        DBHInformationModelData *projectModel = self.dataSource[self.informationHeaderView.currentSelectedIndex][indexPath.row];
        
        if (projectModel.type == 1) {
            // 交易中项目
            DBHProjectHomeViewController *projectHomeViewController = [[DBHProjectHomeViewController alloc] init];
            projectHomeViewController.projectModel = projectModel;
            [self.navigationController pushViewController:projectHomeViewController animated:YES];
        } else {
            // 其他项目
            DBHProjectHomeNoTradingViewController *projectHomeNoTradingViewController = [[DBHProjectHomeNoTradingViewController alloc] init];
            projectHomeNoTradingViewController.projectModel = projectModel;
            [self.navigationController pushViewController:projectHomeNoTradingViewController animated:YES];
        }
        
        if (projectModel.categoryUser.isFavoriteDot) {
            projectModel.categoryUser.isFavoriteDot = NO;
            [self.tableView reloadData];
            
            dispatch_async(dispatch_get_global_queue(
                                                     DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                                     0), ^{
                [self readMessage:indexPath.row];
            });
        }
        
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || (self.informationHeaderView.currentSelectedIndex == 0 && ![UserSignData share].user.isLogin)) {
        return NO;
    }
    return self.informationHeaderView.currentSelectedIndex ? NO : YES;
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || (self.informationHeaderView.currentSelectedIndex == 0 && ![UserSignData share].user.isLogin)) {
        return nil;
    }
    // 取消收藏
    WEAKSELF
    UITableViewRowAction *cancelColletAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:DBHGetStringWithKeyFromTable(/**!indexPath.section ? @"Delete" : */@"Cancel Collection", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        /** if (!indexPath.section) {
         // 删除功能组件
         [UserSignData share].user.functionalUnitArray[[self.titleArray indexOfObject:self.functionalUnitArray[indexPath.row]]] = @"1";
         [[UserSignData share] storageData:[UserSignData share].user];
         [weakSelf.functionalUnitArray removeObjectAtIndex:indexPath.row];
         [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
         } else {*/
        // 取消收藏
        [weakSelf cancelColletWithRow:indexPath.row];
        //        }
    }];
    //删除按钮颜色
    
    cancelColletAction.backgroundColor = MAIN_ORANGE_COLOR;
    
    return @[cancelColletAction];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return AUTOLAYOUTSIZE(SCROLL_LOOP_HEIGHT + 31);
    }
    
    if (self.informationHeaderView.currentSelectedIndex == 0 && ![UserSignData share].user.isLogin) {
        return CGRectGetHeight(tableView.frame) - CGRectGetMaxY(self.informationHeaderView.frame);
    }
    return AUTOLAYOUTSIZE(63.5);
}

#pragma mark ------ UIScrollViewDelegate ------
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGFloat offsetY = scrollView.contentOffset.y;
    NSLog(@"offsetY = %f", offsetY);
    if (self.isShowLoopScroll) {
        // 现在是显示
        if (offsetY > AUTOLAYOUTSIZE(45)) { //上 隐藏
            [self hideImageScroll:YES];
        } else { // 负数 或者小于45
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableView setContentOffset:CGPointMake(0,0) animated:YES];
            });
        }
    } else {
        // 现在是隐藏
        if (offsetY < AUTOLAYOUTSIZE(120)) {
            [self hideImageScroll:NO];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableView setContentOffset:CGPointMake(0,0) animated:YES];
            });
        }
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (self.isShowLoopScroll && offsetY <= 0) { //显示而且没拖动
        // 显示titlelabel
        if (self.cell) {
            [self.cell titleLabelIsShow:YES];
        }
    } else {
        // 显示titleSCROLLVIEW
        if (self.cell) {
            [self.cell titleLabelIsShow:NO];
        }
    }
    
}

- (void)hideImageScroll:(BOOL)isHide {
    self.tableView.contentInset = UIEdgeInsetsMake(isHide ? -AUTOLAYOUTSIZE(SCROLL_LOOP_HEIGHT) : 0, 0, 0, 0) ;
    self.isShowLoopScroll = !isHide;
    
    [self.tableView reloadData];
}

#pragma mark ------ EMChatManagerDelegate ------
/**
 收到消息
 */
- (void)messagesDidReceive:(NSArray *)aMessages {
    NSLog(@"infor messagesDidReceive  ");
    for (EMMessage *msg in aMessages) {
        switch (msg.chatType) {
            case EMChatTypeChat: {
                // 单聊
                if ([msg.conversationId isEqualToString:@"sys_msg"]) {
                    [UserSignData share].user.functionalUnitArray[4] = @"0";
                    [[UserSignData share] storageData:[UserSignData share].user];
                }
                break;
            }
            case EMChatTypeGroupChat: {
                // 群聊
                EMError *error = nil;
                EMGroup *group = [[EMClient sharedClient].groupManager getGroupSpecificationFromServerWithId:msg.conversationId error:&error];
                if (!error) {
                    NSInteger index = [self.titleGroupNameArray indexOfObject:[group.subject substringToIndex:group.subject.length - 3]];
                    if (index < 0 || index > 4) {
                        return;
                    }
                    
                    if (index == 3) { // 交易所公告 要放在动态里面去
                        index = 0;
                    }
                    if ([[UserSignData share].user.functionalUnitArray[index] isEqualToString:@"1"]) {
                        [UserSignData share].user.functionalUnitArray[index] = @"0";
                        [[UserSignData share] storageData:[UserSignData share].user];
                        return;
                    }
                }
                break;
            }
            case EMChatTypeChatRoom: {
                // 聊天室
                return;
                break;
            }
                
            default:
                break;
        }
    }
    [self getFunctionalUnit];
    //    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark ------ Data ------

/**
 获取项目列表
 */
- (void)getProjectList:(BOOL)isShowLoading {
    NSInteger currentIndex = self.informationHeaderView.currentSelectedIndex;
    if (currentIndex == 0 && ![UserSignData share].user.isLogin) {
        return;
    }
    
    NSString *str = nil;
    if (isShowLoading) {
        str = DBHGetStringWithKeyFromTable(@"Loading...", nil);
    }
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        [PPNetworkHelper GET:!currentIndex ? @"category?user_favorite&per_page=100" : @"category?per_page=100"  baseUrlType:3 parameters:nil hudString:str responseCache:^(id responseCache) {
            [weakSelf.dataSource[currentIndex] removeAllObjects];
            if (currentIndex == 0 && ![UserSignData share].user.isLogin) { // 第一个
                
            } else {
                for (NSDictionary *dic in responseCache[@"data"]) {
                    DBHInformationModelData *model = [DBHInformationModelData modelObjectWithDictionary:dic];
                    
                    if (currentIndex != 0) {
                        model.categoryUser.isFavoriteDot = NO;
                    }
                    
                    if (model.categoryUser.isTop) {
                        [weakSelf.dataSource[currentIndex] insertObject:model atIndex:0];
                    } else {
                        [weakSelf.dataSource[currentIndex] addObject:model];
                    }
                }
            }
            
            [weakSelf.tableView reloadData];
        } success:^(id responseObject) {
            [weakSelf.dataSource[currentIndex] removeAllObjects];
            
            for (NSDictionary *dic in responseObject[@"data"]) {
                DBHInformationModelData *model = [DBHInformationModelData modelObjectWithDictionary:dic];
                
                if (currentIndex != 0) {
                    model.categoryUser.isFavoriteDot = NO;
                }
                if (model.categoryUser.isTop) {
                    [weakSelf.dataSource[currentIndex] insertObject:model atIndex:0];
                } else {
                    [weakSelf.dataSource[currentIndex] addObject:model];
                }
            }
            
            NSMutableArray *dataArray = weakSelf.dataSource[currentIndex];
            if (dataArray.count && (!currentIndex || currentIndex == 1)) {
                [weakSelf getICOData];
            }
            
            [weakSelf.informationHeaderView stopAnimation];
            [weakSelf.tableView reloadData];
        } failure:^(NSString *error) {
            [weakSelf.informationHeaderView stopAnimation];
            [LCProgressHUD showFailure:error];
        } specialBlock:nil];
    });
}
- (void)getICOData {
    NSMutableArray *icoList = [NSMutableArray array];
    for (DBHInformationModelData *model in self.dataSource[self.informationHeaderView.currentSelectedIndex]) {
        [icoList addObject:model.unit];
    }
    NSDictionary *paramters = @{@"ico_list":icoList,
                                @"currency":@"cny"};
    
    WEAKSELF
    [PPNetworkHelper POST:@"ico/ranks" baseUrlType:3 parameters:paramters hudString:nil responseCache:^(id responseCache) {
        [weakSelf.icoArray[self.informationHeaderView.currentSelectedIndex] removeAllObjects];
        
        for (DBHInformationModelData *model in weakSelf.dataSource[self.informationHeaderView.currentSelectedIndex]) {
            DBHInformationModelIco *icoModel = [DBHInformationModelIco modelObjectWithDictionary:responseCache[model.unit]];
            [weakSelf.icoArray[self.informationHeaderView.currentSelectedIndex] addObject:icoModel];
        }
        
        [weakSelf.tableView reloadData];
    } success:^(id responseObject) {
        [weakSelf.icoArray[self.informationHeaderView.currentSelectedIndex] removeAllObjects];
        
        for (DBHInformationModelData *model in weakSelf.dataSource[self.informationHeaderView.currentSelectedIndex]) {
            DBHInformationModelIco *icoModel = [DBHInformationModelIco modelObjectWithDictionary:responseObject[model.unit]];
            [weakSelf.icoArray[self.informationHeaderView.currentSelectedIndex] addObject:icoModel];
        }
        
        [weakSelf.tableView reloadData];
    } failure:^(NSString *error) {
        
    } special:^{
        
    }];
}
/**
 取消收藏
 */
- (void)cancelColletWithRow:(NSInteger)row {
    DBHInformationModelData *projectModel = self.dataSource[self.informationHeaderView.currentSelectedIndex][row];
    NSDictionary *paramters = @{@"enable":[NSNumber numberWithBool:false]};
    
    WEAKSELF
    [PPNetworkHelper PUT:[NSString stringWithFormat:@"category/%ld/collect", (NSInteger)projectModel.dataIdentifier] baseUrlType:3 parameters:paramters hudString:nil success:^(id responseObject) {
        projectModel.categoryUser.isFavorite = NO;
        projectModel.categoryUser.isFavoriteDot = NO; // <#取消收藏已改#>
        [weakSelf.dataSource[self.informationHeaderView.currentSelectedIndex] removeObjectAtIndex:row];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
        });
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    }];
}
- (void)readMessage:(NSInteger)row {
    DBHInformationModelData *projectModel = self.dataSource[self.informationHeaderView.currentSelectedIndex][row];
//    if (!projectModel.categoryUser.isFavoriteDot) {
//        return;
//    }
    NSDictionary *paramters = @{@"enable":[NSNumber numberWithBool:false]};
//    WEAKSELF
    [PPNetworkHelper PUT:[NSString stringWithFormat:@"category/%ld/undot", (NSInteger)projectModel.dataIdentifier] baseUrlType:3 parameters:paramters hudString:nil success:^(id responseObject) {
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    }];
}

#pragma mark ------ Private Methods ------
/**
 跳转指定VC
 */
- (void)goToTradeClockVC:(NSString *)str conversation:(EMConversation *)conversation {
    if (![UserSignData share].user.isLogin) {
        [[AppDelegate delegate] goToLoginVC:self];
    } else {
        DBHTraderClockViewController *traderClockViewController = [[DBHTraderClockViewController alloc] init];
        traderClockViewController.title = DBHGetStringWithKeyFromTable(str, nil);
        traderClockViewController.functionalUnitType = 3;
        traderClockViewController.conversation = conversation;
        [self.navigationController pushViewController:traderClockViewController animated:YES];
    }
}

- (void)goToNotificationVC:(NSString *)str conversation:(EMConversation *)conversation {
    if (![UserSignData share].user.isLogin) {
        [[AppDelegate delegate] goToLoginVC:self];
    } else {
        DBHNotificationViewController *notificationViewController = [[DBHNotificationViewController alloc] init];
        notificationViewController.title = DBHGetStringWithKeyFromTable(str, nil);
        notificationViewController.functionalUnitType = 4;
        notificationViewController.conversation = conversation;
        [self.navigationController pushViewController:notificationViewController animated:YES];
    }
}

/**
 获取轮播信息
 */
- (void)getScrollInformation {
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        [PPNetworkHelper GET:@"article?is_scroll&page=1&per_page=5" baseUrlType:3 parameters:nil hudString:nil responseCache:^(id responseCache) {
            [weakSelf handleScrollInformation:responseCache];
        } success:^(id responseObject) {
            [weakSelf handleScrollInformation:responseObject];
        } failure:^(NSString *error) {
            [LCProgressHUD showFailure:error.description];
        } specialBlock:^{
            if (![UserSignData share].user.isLogin) {
                return ;
            }
        }];
    });
}

- (void)handleScrollInformation:(id)dict {
    if ([NSObject isNulllWithObject:dict]) {
        return;
    }
    
    [self.scrollInfoDatasource removeAllObjects];
    
    NSArray *dataArray = dict[@"data"];
    
    NSMutableArray *titles = [NSMutableArray array];
    NSMutableArray *images = [NSMutableArray array];
    if (dataArray.count > 0) {
        for (NSDictionary *data in dataArray) {
            DBHProjectHomeNewsModelData *model = [DBHProjectHomeNewsModelData modelObjectWithDictionary:data];
            [self.scrollInfoDatasource addObject:model];
            NSString *imgStr = model.img;
            if (!model.img || model.img.length == 0) {
                imgStr = @"fenxiang_jietu";
            }
            [images addObject:imgStr];
            
            NSString *title = @"";
            if (model.title.length > 0) {
                title = model.title;
            }
            [titles addObject:title];
        }
    }
    
    if (images.count == 0) {
        _loopImages = nil;
    } else {
        self.loopImages = images;
    }
    
    if (titles.count == 0) {
        _loopTitles = nil;
    } else {
        self.loopTitles = titles;
    }
    [self.tableView reloadData];
}

/**
 获取功能组件
 */
- (void)getFunctionalUnit {
    self.conversationArray = [@[/*@"", */@"", @"", @"", @"", @""] mutableCopy];
    self.contentArray = [@[/*@"", */@"", @"", @"", @"", @""] mutableCopy];
    self.timeArray = [@[/*@"", */@"", @"", @"", @"", @""] mutableCopy];
    self.noReadArray = [@[/*@"0", */@"0", @"0", @"0", @"0", @"0"] mutableCopy];
    
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    
    for (EMConversation *conversation in conversations) {
        if (conversation.type == EMConversationTypeGroupChat) {
            // 群组
            EMError *error = nil;
            EMGroup *group = [[EMClient sharedClient].groupManager getGroupSpecificationFromServerWithId:conversation.conversationId error:&error];
            if (!error) {
                NSInteger index = [self.titleGroupNameArray indexOfObject:[group.subject substringToIndex:group.subject.length - 3]];
                if (index >= 0 && index < self.titleGroupNameArray.count) {
                    // 找到
                    if (conversation.latestMessage) {
                        NSDate *messageDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)conversation.latestMessage.timestamp];
                        EMTextMessageBody *messageContent = (EMTextMessageBody *)conversation.latestMessage.body;
                        self.conversationArray[index] = conversation;
                        self.conversationCacheArray[index] = conversation;
                        self.contentArray[index] = messageContent.text;
                        self.timeArray[index] = [messageDate formattedTime];
                        self.noReadArray[index] = [NSString stringWithFormat:@"%d", conversation.unreadMessagesCount];
                    }
                }
            }
        }
        
        if (conversation.type == EMConversationTypeChat) {
            // 单聊
            if ([conversation.conversationId isEqualToString:@"sys_msg"]) {
                if (conversation.latestMessage) {
                    NSDate *messageDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)conversation.latestMessage.timestamp];
                    EMTextMessageBody *messageContent = (EMTextMessageBody *)conversation.latestMessage.body;
                    if (self.conversationArray.count > 4) {
                        self.conversationArray[4] = conversation;
                    }
                    
                    if (self.conversationCacheArray.count > 4) {
                        self.conversationCacheArray[4] = conversation;
                    }
                    
                    
                    NSString *time = [NSString timeExchangeWithType:@"yyyy-MM-dd hh:mm" timestamp:conversation.latestMessage.timestamp];
                    
                    if (messageContent.text.length) {
                        if (self.contentArray.count > 4) {
                            self.contentArray[4] = [messageContent.text stringByReplacingOccurrencesOfString:@":date" withString:time];
                        }
                    }
                    if (self.timeArray.count > 4) {
                        self.timeArray[4] = [messageDate formattedTime];
                    }
                    
                    if (self.noReadArray.count > 4) {
                        self.noReadArray[4] = [NSString stringWithFormat:@"%d", conversation.unreadMessagesCount];
                    }
                }
            }
        }
    }
    
    NSInteger count = 0;
    for (NSInteger i = 0; i < [UserSignData share].user.functionalUnitArray.count; i++) {
        NSString *tag = [UserSignData share].user.functionalUnitArray[i];
        if ([tag isEqualToString:@"0"]) {
        } else {
            [self.conversationArray removeObjectAtIndex:i - count];
            [self.contentArray removeObjectAtIndex:i - count];
            [self.timeArray removeObjectAtIndex:i - count];
            [self.noReadArray removeObjectAtIndex:i - count];
            count += 1;
        }
    }
    
    self.informationHeaderView.noReadArray = self.noReadArray;
    [self getProjectList:NO];
}

#pragma mark ------ Getters And Setters ------
- (DBHInformationTitleView *)informationTitleView {
    if (!_informationTitleView) {
        _informationTitleView = [[DBHInformationTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44)];
        
        WEAKSELF
        [_informationTitleView clickButtonBlock:^(NSInteger type) {
            if (!type) {
                // 搜索
                DBHSearchViewController *searchViewController = [[DBHSearchViewController alloc] init];
                [weakSelf.navigationController pushViewController:searchViewController animated:YES];
            } else {
                // +号按钮
                [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.menuView];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.menuView animationShow];
                });
            }
        }];
    }
    return _informationTitleView;
}
- (DBHMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[DBHMenuView alloc] init];
        _menuView.dataSource = self.menuArray;
        
        WEAKSELF
        [_menuView selectedBlock:^(NSInteger index) {
            switch (index) {
                 //   /**
                 case 0: { // InWe红包
                    if (![UserSignData share].user.isLogin) {
                        [[AppDelegate delegate] goToLoginVC:weakSelf];
                    } else {
                        YYRedPacketViewController *vc = [[YYRedPacketViewController alloc] init];
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    }
                    break;
                }
            
                case 1: { // 扫一扫
                    ScanVC * vc = [[ScanVC alloc] init];
                    //                    vc.delegate = self;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                    
                    break;
                }
                 //  */
//                case 0: {
                case 2: {
                    // 添加钱包
                    if (![UserSignData share].user.isLogin) {
                        [[AppDelegate delegate] goToLoginVC:weakSelf];
                    } else {
                        DBHShowAddWalletViewController *vc = [[DBHShowAddWalletViewController alloc] init];
                        vc.nc = weakSelf.navigationController;
                        
                        MyNavigationController *naviVC = [[MyNavigationController alloc] initWithRootViewController:vc];
                        naviVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
                        [weakSelf presentViewController:naviVC animated:NO completion:^{
                            [vc animateShow:YES completion:nil];
                        }];
                    }
                    break;
                }
//                case 1: {
                case 3: {
                    // 收付款
                    if (![UserSignData share].user.isLogin) {
                        [[AppDelegate delegate] goToLoginVC:weakSelf];
                    } else {
                        DBHPaymentReceivedViewController *paymentReceivedViewController = [[DBHPaymentReceivedViewController alloc] init];
                        [weakSelf.navigationController pushViewController:paymentReceivedViewController animated:YES];
                    }
                    break;
                }
                    
                default:
                    break;
            }
        }];
    }
    return _menuView;
}
- (DBHInformationHeaderView *)informationHeaderView {
    if (!_informationHeaderView) {
        _informationHeaderView = [[DBHInformationHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, AUTOLAYOUTSIZE(136.5))];
        
        WEAKSELF
        [_informationHeaderView selectTypeBlock:^(BOOL isStartAnimation) {
            if (isStartAnimation && (weakSelf.informationHeaderView.currentSelectedIndex != 0 || [UserSignData share].user.isLogin)) {
                if (![PPNetworkHelper hasConnectedNetwork]) {
                    [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"The current network is not available, please check your network Settings.", nil)];
                    [weakSelf.informationHeaderView stopAnimation];
                    return;
                }
                
                [weakSelf.informationHeaderView startAnimation];
            }
            
            [weakSelf.tableView reloadData];
            if (weakSelf.informationHeaderView.currentSelectedIndex != 0 || [UserSignData share].user.isLogin) {
                dispatch_async(dispatch_get_global_queue(
                                                         DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                                         0), ^{
                    
                    [weakSelf getScrollInformation];
                    [weakSelf getProjectList:YES];
                });
            }
        }];
        [_informationHeaderView clickFunctionalUnitBlock:^(NSInteger functionalUnitType) {
            // 标识为已读
            if (![self.conversationArray[functionalUnitType] isKindOfClass:[NSString class]]) {
                EMConversation *conversation = self.conversationArray[functionalUnitType];
                [conversation markAllMessagesAsRead:nil];
            }
            
            [UserSignData share].user.functionalUnitArray[functionalUnitType] = @"0";
            [[UserSignData share] storageData:[UserSignData share].user];
            // 点击功能组件
            switch (functionalUnitType) {
                case 0: {
                    // 动态
                    DBHInWeHotViewController *inWeHotViewController = [[DBHInWeHotViewController alloc] init];
                    inWeHotViewController.title = DBHGetStringWithKeyFromTable(self.titleArray[functionalUnitType], nil);
                    inWeHotViewController.functionalUnitType = 0;
                    [weakSelf.navigationController pushViewController:inWeHotViewController animated:YES];
                    break;
                }
                case 1: {
                    // TradingView --> 观点
                    DBHInWeHotViewController *inWeHotViewController = [[DBHInWeHotViewController alloc] init];
                    inWeHotViewController.title = DBHGetStringWithKeyFromTable(self.titleArray[functionalUnitType], nil);
                    inWeHotViewController.functionalUnitType = 1;
                    [weakSelf.navigationController pushViewController:inWeHotViewController animated:YES];
                    break;
                }
                case 2: {
                    // 交易所公告 --> 期望
                    DBHTradingViewViewController *tradingViewViewController = [[DBHTradingViewViewController alloc] init];
                    tradingViewViewController.title = DBHGetStringWithKeyFromTable(self.titleArray[functionalUnitType], nil);
                    tradingViewViewController.functionalUnitType = 2;
                    [weakSelf.navigationController pushViewController:tradingViewViewController animated:YES];
                    break;
                }
                    //                case 3: {
                    //                    // CandyBowl
                    //                    DBHCandyBowlViewController *candyBowlViewController = [[DBHCandyBowlViewController alloc] init];
                    //                    candyBowlViewController.title = DBHGetStringWithKeyFromTable(self.titleArray[functionalUnitType], nil);
                    //                    candyBowlViewController.functionalUnitType = 3;
                    //                    [weakSelf.navigationController pushViewController:candyBowlViewController animated:YES];
                    //                    break;
                    //                }
                case 3: {
                    // 交易提醒 --> 排行
//                    [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Coming Soon", nil)];
                    //                            [self goToTradeClockVC:self.titleArray[functionalUnitType] conversation:self.conversationCacheArray[functionalUnitType]];
                    
                    DBHRankViewController *rankViewController = [[DBHRankViewController alloc] init];
                    rankViewController.title = DBHGetStringWithKeyFromTable(self.titleArray[functionalUnitType], nil);
//                    rankViewController.functionalUnitType = 2;
                    [weakSelf.navigationController pushViewController:rankViewController animated:YES];
                    break;
                    
                    break;
                }
                case 4: {
                    // 通知
                    [self goToNotificationVC:self.titleArray[functionalUnitType] conversation:self.conversationCacheArray[functionalUnitType]];
                    break;
                }
                    
                default:
                    break;
            }
        }];
    }
    return _informationHeaderView;
}
           
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = WHITE_COLOR;
        //        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
//        _tableView.contentInset = UIEdgeInsetsMake(-, 0, 0, 0);
        
        _tableView.rowHeight = AUTOLAYOUTSIZE(63.5);
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, AUTOLAYOUTSIZE(0.01))];
        
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
        
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHInformationTableViewCell class] forCellReuseIdentifier:kDBHInformationTableViewCellIdentifier];
        [_tableView registerClass:[DBHInfoScrollTableViewCell class] forCellReuseIdentifier:kDBHInfoScrollTableViewCell];
        [_tableView registerClass:[DBHUnLoginTableCell class] forCellReuseIdentifier:kDBHUnLoginTableCell];
    }
    return _tableView;
}

- (NSArray *)menuArray {
    if (!_menuArray) {
        _menuArray = @[
      //  /**
                        @"Red  Packet",
                       @"Scan QR Code",
       //  */
                       @"Add Wallet",
                       @"Payment"];
    }
    return _menuArray;
}
- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"Dynamism",
                        @"Viewpoint",
                        @"Expectation",
                        //                        @"Candybowl",
                        @"Ranking",
                        @"Notice"];
    }
    return _titleArray;
}
- (NSMutableArray *)conversationArray {
    if (!_conversationArray) {
        _conversationArray = [NSMutableArray array];
        [self addNilElementWithArr:_conversationArray];
    }
    return _conversationArray;
}
- (NSMutableArray *)conversationCacheArray {
    if (!_conversationCacheArray) {
        _conversationCacheArray = [NSMutableArray array];
        [self addNilElementWithArr:_conversationCacheArray];
    }
    return _conversationCacheArray;
}
- (NSMutableArray *)contentArray {
    if (!_contentArray) {
        _contentArray = [NSMutableArray array];
    }
    return _contentArray;
}
- (NSMutableArray *)timeArray {
    if (!_timeArray) {
        _timeArray = [NSMutableArray array];
        [self addNilElementWithArr:_timeArray];
    }
    return _timeArray;
}

- (NSMutableArray *)noReadArray {
    if (!_noReadArray) {
        _noReadArray = [NSMutableArray array];
        [self addNilElementWithArr:_noReadArray];
    }
    return _noReadArray;
}

- (void)addNilElementWithArr:(NSMutableArray *)arr {
    for (int i = 0; i < self.titleGroupNameArray.count; i ++) {
        [arr addObject:@""];
    }
}

- (void)addNilArrWithArr:(NSMutableArray *)arr {
    for (int i = 0; i < self.titleGroupNameArray.count; i ++) {
        [arr addObject:[NSMutableArray array]];
    }
}

- (NSArray *)titleGroupNameArray {
    if (!_titleGroupNameArray) { //TODO
        _titleGroupNameArray = @[@"SYS_MSG_INWEHOT", @"SYS_MSG_VIEWPOINT", @"SYS_MSG_TRADING", @"SYS_MSG_EXCHANGENOTICE"/*, @"SYS_MSG_CANDYBOW"*/, @"SYS_MSG"];
    }
    return _titleGroupNameArray;
}
//- (NSMutableArray *)functionalUnitArray {
//    if (!_functionalUnitArray) {
//        _functionalUnitArray = [NSMutableArray array];
//    }
//    return _functionalUnitArray;
//}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        [self addNilArrWithArr:_dataSource];
    }
    return _dataSource;
}

- (NSMutableArray *)scrollInfoDatasource {
    if (!_scrollInfoDatasource) {
        _scrollInfoDatasource = [NSMutableArray array];
    }
    return _scrollInfoDatasource;
}

- (NSMutableArray *)icoArray {
    if (!_icoArray) {
        _icoArray = [NSMutableArray array];
        [self addNilArrWithArr:_icoArray];
    }
    return _icoArray;
}

- (NSMutableArray *)loopTitles {
    if (!_loopTitles) {
        _loopTitles = [NSMutableArray array];
        
        NSArray *titlesStrings = @[@"", @""];
        [_loopTitles addObjectsFromArray:titlesStrings];
    }
    return _loopTitles;
}

- (NSMutableArray *)loopImages {
    if (!_loopImages) {
        _loopImages = [NSMutableArray array];
        
        NSArray *imagesURLStrings = @[
                                      @"fenxiang_jietu",
                                      @"fenxiang_jietu"
                                      ];
        [_loopImages addObjectsFromArray:imagesURLStrings];
    }
    return _loopImages;
}

@end



