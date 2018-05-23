//
//  DBHInWeHotViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/29.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHInWeHotViewController.h"

#import "KKWebView.h"
#import "DBHFunctionalUnitLookViewController.h"

#import "DBHProjectHomeHeaderView.h"
#import "DBHProjectHomeTypeTwoTableViewCell.h"
#import "DBHProjectHomeTypeThreeTableViewCell.h"

#import "DBHProjectHomeNewsDataModels.h"
#import "DBHInWeHistoryViewController.h"
#import "DBHIotificationTableViewCell.h"
#import "DBHInWeHotHistoricalInformationViewController.h"

static NSString *const kDBHProjectHomeTypeTwoTableViewCellIdentifier = @"kDBHProjectHomeTypeTwoTableViewCellIdentifier";
static NSString *const kDBHProjectHomeTypeThreeTableViewCellIdentifer = @"kDBHProjectHomeTypeThreeTableViewCellIdentifer";
static NSString *const kDBHIotificationTableViewCell = @"kDBHIotificationTableViewCell";

@interface DBHInWeHotViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *grayLineView;
//@property (nonatomic, strong) UIButton *yourOpinionButton;

@property (nonatomic, strong) UIButton *historyInfoBtn;

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger currentPage; // 当前页
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) BOOL isScrollBottom;

@end

@implementation DBHInWeHotViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    [self addRefresh];
    
    self.currentPage = 1;
    self.isScrollBottom = NO;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getInfomation];
    });
}

#pragma mark ------ UI ------
- (void)setUI {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"xiangmuzhuye_ren_ico"] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToPersonBarButtonItem)];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.grayLineView];
//    [self.view addSubview:self.yourOpinionButton];
    [self.view addSubview:self.historyInfoBtn];
    
    WEAKSELF
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.grayLineView.mas_top);
//        make.bottom.equalTo(weakSelf.view);
    }];
    [self.grayLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.height.offset(AUTOLAYOUTSIZE(1));
        make.centerX.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.historyInfoBtn.mas_top);
    }];

    [self.historyInfoBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.height.offset(AUTOLAYOUTSIZE(47));
        make.centerX.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view);
    }];
//    [self.yourOpinionButton mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(weakSelf.view);
//        make.height.offset(AUTOLAYOUTSIZE(47));
//        make.centerX.bottom.equalTo(weakSelf.view);
//    }];
}

#pragma mark ------ UITableViewDataSource ------
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isScrollBottom == NO) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.dataSource.count - 1] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        if (indexPath.section == self.dataSource.count - 1) {
            self.isScrollBottom = YES;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHProjectHomeNewsModelData *model = nil;
    if (indexPath.section < self.dataSource.count) {
        model = self.dataSource[indexPath.section];
    }
    
    if (model.type == 1 || model.type == 12) { //纯文本
        DBHProjectHomeTypeThreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHProjectHomeTypeThreeTableViewCellIdentifer forIndexPath:indexPath];
        cell.model = model;

        return cell;
    } else if (model.type == 16) { //文本标题
        DBHIotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHIotificationTableViewCell forIndexPath:indexPath];
        cell.model = model;
        
        return cell;
    } else { //图文
        DBHProjectHomeTypeTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHProjectHomeTypeTwoTableViewCellIdentifier forIndexPath:indexPath];
        cell.model = model;
        
        return cell;
    }
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHProjectHomeNewsModelData *model = self.dataSource[indexPath.section];
    KKWebView *webView = [[KKWebView alloc] initWithUrl:[NSString stringWithFormat:@"%@%ld", [APP_APIEHEAD isEqualToString:APIEHEAD1] ? APIEHEAD4 : TESTAPIEHEAD4, (NSInteger)model.dataIdentifier]];
    webView.title = model.title;
    webView.imageStr = model.img;
    webView.isHaveShare = YES;
        webView.infomationId = [NSString stringWithFormat:@"%ld", (NSInteger)model.dataIdentifier];
    [self.navigationController pushViewController:webView animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    DBHProjectHomeNewsModelData *model = self.dataSource[section];
    DBHProjectHomeHeaderView *headerView = [[DBHProjectHomeHeaderView alloc] init];
    headerView.isAdd = YES;
    headerView.time = model.createdAt;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return AUTOLAYOUTSIZE(42);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHProjectHomeNewsModelData *model = self.dataSource[indexPath.section];
    NSInteger type = model.type;
    if (type == 1 || type == 12) {
        return AUTOLAYOUTSIZE(60);
    }
    if (type == 16) {
        return AUTOLAYOUTSIZE(150);
    }
    return AUTOLAYOUTSIZE(215.5);
}

#pragma mark ------ Data ------
/**
 获取Inwe热点数据
 */
- (void)getInfomation {
    WEAKSELF
//    NSString *type;
//    switch (self.type) {
//        case 0:
//            type = @"inwe_hot";
//            break;
//        case 1:
//            type = @"is_scroll";
//            break;
//        case 2:
//            type = @"type=1";
//            break;
//
//        default:
//            break;
//    }
    
    NSString *param = @"is_not_category&type=[1,2,3,6,16]";
    if (self.functionalUnitType == 1) {
        param = @"type=[12,13,14,15]";
    }
    
    [PPNetworkHelper GET:[NSString stringWithFormat:@"article?%@&per_page=5&page=%ld", param, self.currentPage] baseUrlType:3 parameters:nil hudString:nil responseCache:^(id responseCache) {
        if (weakSelf.dataSource.count) {
            return ;
        }
        
        [weakSelf.dataSource removeAllObjects];
        NSArray *dataArray = responseCache[@"data"];
        for (NSInteger i = dataArray.count - 1; i >= 0; i--) {
            DBHProjectHomeNewsModelData *model = [DBHProjectHomeNewsModelData modelObjectWithDictionary:dataArray[i]];
            
            [weakSelf.dataSource addObject:model];
        }
        
        weakSelf.dataSource = [NSArray arraySortedByArr:weakSelf.dataSource];
        
        [weakSelf.tableView reloadData];
        if (weakSelf.dataSource.count > 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf scrollViewToBottom:NO];
            });
        }
    } success:^(id responseObject) {
        [weakSelf endRefresh];
        
        if (weakSelf.currentPage == 1) {
            [weakSelf.dataSource removeAllObjects];
        }
        
        NSMutableArray *dataArray = [NSMutableArray array];
        NSArray *array = responseObject[@"data"];
        for (NSInteger i = array.count - 1; i >= 0; i--) {
            DBHProjectHomeNewsModelData *model = [DBHProjectHomeNewsModelData modelObjectWithDictionary:array[i]];
            
            [dataArray addObject:model];
        }
        
        if (weakSelf.currentPage == 1) {
            [weakSelf.dataSource addObjectsFromArray:dataArray];
        } else if (dataArray.count) {
            [weakSelf.dataSource insertObjects:dataArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, dataArray.count)]];
        }
        
        weakSelf.dataSource = [NSArray arraySortedByArr:weakSelf.dataSource];
        
        
        [weakSelf.tableView reloadData];
        if (weakSelf.dataSource.count > 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (weakSelf.currentPage == 1) {
                    [weakSelf scrollViewToBottom:NO];
                } else if (dataArray.count) {
                    [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:dataArray.count] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }
            });
        }
    } failure:^(NSString *error) {
        [weakSelf endRefresh];
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
                if ([group.subject containsString:@"SYS_MSG_INWEHOT"]) {
                    EaseMessageViewController *chatViewController = [[EaseMessageViewController alloc] initWithConversationChatter:group.groupId conversationType:EMConversationTypeGroupChat];
                    chatViewController.title = self.title;
                    [self.navigationController pushViewController:chatViewController animated:YES];
                }
            }
        }
    }
}

/**
 历史资讯
 */
- (void)respondsToHistoricInfoButton {
    if (self.functionalUnitType == 0) {
        DBHInWeHistoryViewController *vc = [[DBHInWeHistoryViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        DBHInWeHotHistoricalInformationViewController *inWeHotHistoricalInformationViewController = [[DBHInWeHotHistoricalInformationViewController alloc] init];
        inWeHotHistoricalInformationViewController.functionalUnitType = self.functionalUnitType;
        [self.navigationController pushViewController:inWeHotHistoricalInformationViewController animated:YES];
    }
}

#pragma mark ------ Private Methods ------
/**
 滑动到底部
 */
- (void)scrollViewToBottom:(BOOL)animated
{
    if (self.tableView.contentSize.height > self.tableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height + self.tableView.contentInset.bottom);
        [self.tableView setContentOffset:offset animated:animated];
    }
}
/**
 添加刷新
 */
- (void)addRefresh {
    WEAKSELF
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.dataSource.count < weakSelf.currentPage * 5) {
            [weakSelf endRefresh];
            
            return ;
        }
        
        weakSelf.currentPage += 1;
        [weakSelf getInfomation];
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

#pragma mark ------ Getters And Setters ------
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = COLORFROM10(235, 235, 235, 1);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        _tableView.tableFooterView = nil; //[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AUTOLAYOUTSIZE(47))];
        
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
        
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, AUTOLAYOUTSIZE(140), 0);
        
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHProjectHomeTypeTwoTableViewCell class] forCellReuseIdentifier:kDBHProjectHomeTypeTwoTableViewCellIdentifier];
        [_tableView registerClass:[DBHProjectHomeTypeThreeTableViewCell class] forCellReuseIdentifier:kDBHProjectHomeTypeThreeTableViewCellIdentifer];
        [_tableView registerClass:[DBHIotificationTableViewCell class] forCellReuseIdentifier:kDBHIotificationTableViewCell];
        
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

//- (UIButton *)yourOpinionButton {
//    if (!_yourOpinionButton) {
//        _yourOpinionButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _yourOpinionButton.titleLabel.font = FONT(14);
//        [_yourOpinionButton setTitle:DBHGetStringWithKeyFromTable(@"Your Opinion", nil) forState:UIControlStateNormal];
//        [_yourOpinionButton setTitleColor:COLORFROM16(0x626262, 1) forState:UIControlStateNormal];
//        [_yourOpinionButton addTarget:self action:@selector(respondsToYourOpinionButton) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _yourOpinionButton;
//}

- (UIButton *)historyInfoBtn {
    if (!_historyInfoBtn) {
        _historyInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _historyInfoBtn.titleLabel.font = FONT(14);
        _historyInfoBtn.backgroundColor = WHITE_COLOR;
        [_historyInfoBtn setTitle:DBHGetStringWithKeyFromTable(@"History", nil) forState:UIControlStateNormal];
        [_historyInfoBtn setTitleColor:COLORFROM16(0x626262, 1) forState:UIControlStateNormal];
        [_historyInfoBtn addTarget:self action:@selector(respondsToHistoricInfoButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _historyInfoBtn;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
