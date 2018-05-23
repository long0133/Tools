//
//  DBHProjectSurveyViewController.m
//  FBG
//  项目概况
//  Created by yy on 2018/3/15.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHProjectSurveyViewController.h"
#import "DBHProjectOverviewForProjectInfomtaionTableViewCell.h"
#import "YYSurveyInfoTableView.h"
#import "YYEvaluateTableView.h"
#import "YYProjectSurveySection1TableViewCell.h"
#import "DBHSelectScrollView.h"
#import "YYSurveyWebTableView.h"
#import "DBHProjectDetailInformationDataModels.h"
#import "DBHProjectCommentModel.h"
#import "DBHCommentSendSuccessViewController.h"
#import "DBHBaseNavigationController.h"
#import "DBHProjectCommentSendViewController.h"
#import "YYEvaluateSynthesisModel.h"
#import "YYEvaluateTagModel.h"
#import "DBHProjectCommentDetailModel.h"
#import "YYComentDetailListModel.h"
#import "YYEvaluateGradeHeaderView.h"
#import "YYEvaluateDetailAnalysisModel.h"

#define MYCOMMENTS_STORYBOARD_NAME @"MyComments"

#define TYPE_DAY @"day"
#define TYPE_WEEK @"week"

typedef enum _request_status {
    YYGetCommnetsRequestStatusNo = -1,
    YYGetCommnetsRequestStatusIng,
    YYGetCommnetsRequestStatusSuccess,
    YYGetCommnetsRequestStatusFailed
}YYGetCommnetsRequestStatus;

static NSString *const kDBHProjectOverviewForProjectInfomtaionTableViewCell = @"kDBHProjectOverviewForProjectInfomtaionTableViewCell";
static NSString *const kYYProjectSurveySection1Cell = @"kYYProjectSurveySection1Cell";

@interface DBHProjectSurveyViewController () <UITableViewDelegate, UITableViewDataSource, D5FlowButtonViewDelegate> {
    UIScrollView *subScrollView;
    YYEvaluateTableView *evaluateTableView;
    YYSurveyInfoTableView *infoTableView;
    YYSurveyWebTableView *webView;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DBHSelectScrollView *titleScrollView;
@property (nonatomic, strong) NSArray *titleStrArray;
@property (nonatomic, strong) YYEvaluateSynthesisModel *synthModel; // 综合评价
@property (nonatomic, strong) YYEvaluateTagsData *tagsData;
@property (nonatomic, strong) DBHProjectCommentModel *myCommentModel;
@property (nonatomic, strong) YYComentDetailListModel *commentsModel;
@property (nonatomic, strong) NSArray *analysisArray;

@property (nonatomic, strong) YYEvaluateGradeHeaderView *headerView;

@property (nonatomic, assign) int currentShowIndex;
@property (nonatomic, assign) NSInteger currentSelectedTagIndex;
@property (nonatomic, assign) BOOL selectedTagFromCell;

@property (nonatomic, assign) NSInteger dayOrWeekType;
@property (nonatomic, assign) BOOL isRequestMyComment; // 是否请求过我的评价

@end

@implementation DBHProjectSurveyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.projectDetailModel.unit;
    self.view.backgroundColor = COLORFROM16(0xF6F6F6, 1);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:DBHGetStringWithKeyFromTable(@" Comment", nil) style:UIBarButtonItemStylePlain target:self action:@selector(respondsToGradeButton)];
    
    [self.view addSubview:self.tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scroeHasChanged:) name:PROJECT_SCORE_CHANGED object:self.projectDetailModel];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentHasChanged) name:COMMENT_HAS_CHANGED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hasAddedComment) name:COMMENT_HAS_ADDED object:nil];
    
    self.currentShowIndex = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self getEvaluateData:NO];
}

- (void)hasAddedComment {
    [self getDataFrom:0];
    
    NSString *urlStr = [NSString stringWithFormat:@"category/%@/rough_analysis", @(self.projectDetailModel.dataIdentifier)];
    [self getSynthEvaluateData:urlStr urlType:1];
    
    urlStr = [NSString stringWithFormat:@"category/%@/comment_tags", @(self.projectDetailModel.dataIdentifier)];
    [self getSynthEvaluateData:urlStr urlType:2];
    
    [self getAnalysisList:self.dayOrWeekType == 1 ? TYPE_WEEK : TYPE_DAY];
    [self getDetailCommentList:nil];
}

- (void)scroeHasChanged:(NSNotification *)notification {
    if ([notification.object isEqual:self.projectDetailModel]) {
         NSDictionary *dict = notification.userInfo;
        if (![NSObject isNulllWithObject:dict]) {
            NSString *score = dict[@"score"];
            self.projectDetailModel.categoryScore.value = score.doubleValue;
            [self.tableView reloadData];
        }
    }
}

- (void)commentHasChanged {
    [self getDetailCommentList:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark ---- data -----
- (void)getDataFrom:(NSInteger)from {
    if (![UserSignData share].user.isLogin) {
        return;
    }
    NSString *urlStr = [NSString stringWithFormat:@"category/%@/get_cur_user_comment", @(self.projectDetailModel.dataIdentifier)];
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        WEAKSELF
        [PPNetworkHelper GET:urlStr baseUrlType:3 parameters:nil hudString:nil success:^(id responseObject) {
            weakSelf.isRequestMyComment = YES;
            [weakSelf handleResponse:responseObject from:from];
        } failure:^(NSString *error) {
            weakSelf.isRequestMyComment = YES;
            [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"Load failed", nil)];
        }];
    });
}

/**
 获取数据

 @param urlStr url
 @param urlType 1:项目综合评价  2:获取评价标签
 */
- (void)getSynthEvaluateData:(NSString *)urlStr urlType:(NSInteger)urlType {
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        WEAKSELF
        [PPNetworkHelper GET:urlStr baseUrlType:3 parameters:nil hudString:DBHGetStringWithKeyFromTable(@"Loading...", nil) responseCache:^(id responseCache) {
            [weakSelf handleSynthResponse:responseCache urlType:urlType];
        } success:^(id responseObject) {
            [weakSelf handleSynthResponse:responseObject urlType:urlType];
        } failure:^(NSString *error) {
            [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"Load failed", nil)];
        } specialBlock:nil];
    });
}

- (void)getEvaluateData:(BOOL)isNeedJudge {
    if (self.currentShowIndex == 1) { // 用户评价
        if (isNeedJudge) {
            if (!self.synthModel) { // 请求
                NSString *urlStr = [NSString stringWithFormat:@"category/%@/rough_analysis", @(self.projectDetailModel.dataIdentifier)];
                [self getSynthEvaluateData:urlStr urlType:1];
            }
        } else {
            NSString *urlStr = [NSString stringWithFormat:@"category/%@/rough_analysis", @(self.projectDetailModel.dataIdentifier)];
            [self getSynthEvaluateData:urlStr urlType:1];
        }
        
        if (isNeedJudge) {
            if (!self.tagsData) {
                NSString *urlStr = [NSString stringWithFormat:@"category/%@/comment_tags", @(self.projectDetailModel.dataIdentifier)];
                [self getSynthEvaluateData:urlStr urlType:2];
            }
        } else {
            NSString *urlStr = [NSString stringWithFormat:@"category/%@/comment", @(self.projectDetailModel.dataIdentifier)];
            [self getSynthEvaluateData:urlStr urlType:2];
        }
        
        if (isNeedJudge) {
            if (!self.commentsModel) {
                [self getDetailCommentList:nil];
            }
        } else {
            [self getDetailCommentList:nil];
        }
        
        if (isNeedJudge) {
            if (!self.myCommentModel) {
                [self getDataFrom:0];
            }
        } else {
            [self getDataFrom:0];
        }
        
        if (isNeedJudge) {
            if (!self.analysisArray) {
                [self getAnalysisList:TYPE_DAY];
            }
        } else {
            [self getAnalysisList:TYPE_DAY];
        }
    }
}

- (void)getAnalysisList:(NSString *)type {
    if ([type isEqualToString:TYPE_DAY]) {
        self.dayOrWeekType = 0;
    } else {
        self.dayOrWeekType = 1;
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"category/%@/detail_analysis/%@", @(self.projectDetailModel.dataIdentifier), type];
    [self getSynthEvaluateData:urlStr urlType:4];
}

- (void)getDetailCommentList:(NSString *)startDate {
    NSString *filter = nil;
    switch (self.currentSelectedTagIndex) {
        case 1:
            filter = @"popular";
            break;
        case 2:
            filter = @"recently";
            break;
        case 3:
            filter = @"most";
            break;
        case 4:
            filter = @"negative";
            break;
        case 5:
            filter = @"positive";
            break;
        case 6:
            filter = @"invest";
            break;
        case 7:
            filter = @"observe";
            break;
        case 8:
            filter = @"invested";
            break;
    }
    
    NSString *endDateStr = startDate;
    if (self.dayOrWeekType == 1) { // 周  延后一周的时间
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *date = [dateFormatter dateFromString:startDate];
        NSDate *endDate = [self getPriousorLaterDateFromDate:date withWeek:1];
        endDateStr = [dateFormatter stringFromDate:endDate];
    }
    
    if ([NSObject isNulllWithObject:filter]) {
        filter = @"";
    }
    if ([NSObject isNulllWithObject:startDate]) {
        startDate = @"";
    }
    if ([NSObject isNulllWithObject:endDateStr]) {
        endDateStr = @"";
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"category/%@/comment?filter=%@&start=%@&end=%@", @(self.projectDetailModel.dataIdentifier), filter, endDateStr, startDate];
    [self getSynthEvaluateData:urlStr urlType:3];
}

- (NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withWeek:(int)week {

    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:[[NSDate alloc] init]];
    
    components = [cal components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    
    [components setDay:([components day] - 7)];
    NSDate *lastWeek = [cal dateFromComponents:components];
    

    
//    NSDateComponents *comps = [[NSDateComponents alloc] init];
//
//    [comps setWeekOfMonth:1];
//
//    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//
//    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
//
    return lastWeek;
    
    
    
}



- (void)handleSynthResponse:(id)responseObj urlType:(NSInteger)urlType {
    if ([NSObject isNulllWithObject:responseObj]) {
        return;
    }
   
    if (urlType == 1) {
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            YYEvaluateSynthesisModel *model = [YYEvaluateSynthesisModel mj_objectWithKeyValues:responseObj];
            self.synthModel = model;
        }
    } else if (urlType == 2) {
        if ([responseObj isKindOfClass:[NSArray class]]) {
            NSArray *arr = responseObj;
            YYEvaluateTagsData *data = [YYEvaluateTagsData new];
            if (arr.count > 0) {
                NSMutableArray *tempArr = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    YYEvaluateTagModel *model = [YYEvaluateTagModel mj_objectWithKeyValues:dict];
                    [tempArr addObject:model];
                }
                data.contentArr = tempArr;
            }
            data.currentSelectedTagIndex = self.currentSelectedTagIndex;
            self.tagsData = data;
        }
    } else if (urlType == 3) { // 评价列表
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            YYComentDetailListModel *detailModel = [YYComentDetailListModel mj_objectWithKeyValues:responseObj];
            self.commentsModel = detailModel;
        }
    } else if (urlType == 4) { // 详细评价
        if ([responseObj isKindOfClass:[NSArray class]]) {
            NSMutableArray *tempArr = [NSMutableArray array];
            for (NSDictionary *dict in responseObj) {
                @autoreleasepool {
                    YYEvaluateDetailAnalysisModel *model = [YYEvaluateDetailAnalysisModel mj_objectWithKeyValues:dict];
                    [tempArr addObject:model];
                }
            }
            
            NSArray *reversedArray = [[tempArr reverseObjectEnumerator] allObjects];
            self.analysisArray = reversedArray;
        }
    }
}
                   
- (void)handleResponse:(id)responseObj from:(NSInteger)from {
    if ([NSObject isNulllWithObject:responseObj]) {
        return;
    }
    
    if ([responseObj isKindOfClass:[NSDictionary class]]) {
        DBHProjectCommentModel *model = [DBHProjectCommentModel mj_objectWithKeyValues:responseObj];
        self.myCommentModel = model;
    }
    if (from == 1) { // 写评价
        if (self.myCommentModel && self.myCommentModel.is_category_comment) {
            [self performSelectorOnMainThread:@selector(pushToSendSuccessVC:) withObject:self.myCommentModel waitUntilDone:NO];
        } else {
            [self performSelectorOnMainThread:@selector(pushToSendVC) withObject:self.myCommentModel waitUntilDone:NO];
        }
    }
}

- (void)pushToSendVC {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:COMMENTSEND_STORYBOARD_NAME bundle:nil];
    DBHProjectCommentSendViewController *sendVC = [sb instantiateViewControllerWithIdentifier:COMMENTSEND_STORYBOARD_ID];
    sendVC.projectDetailModel = self.projectDetailModel;
    [self.navigationController pushViewController:sendVC animated:YES];
}

- (void)pushToSendSuccessVC:(DBHProjectCommentModel *)model {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:MYCOMMENTS_STORYBOARD_NAME bundle:nil];
    DBHCommentSendSuccessViewController *vc = [sb instantiateViewControllerWithIdentifier:COMMENTSENDSUCCESS_STORYBOARD_ID];
    DBHBaseNavigationController *nav = [[DBHBaseNavigationController alloc] initWithRootViewController:vc];
    vc.title = DBHGetStringWithKeyFromTable(@"Submitted", nil);
    vc.model = model;
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark ------ respondsToSelectors -------
/**
 写评价
 */
- (void)respondsToGradeButton {
    if (![UserSignData share].user.isLogin) {
        [[AppDelegate delegate] goToLoginVC:self];
        return;
    }
    
    if (self.isRequestMyComment) {
        if (self.myCommentModel && self.myCommentModel.is_category_comment) {
            [self performSelectorOnMainThread:@selector(pushToSendSuccessVC:) withObject:self.myCommentModel waitUntilDone:NO];
        } else {
            [self performSelectorOnMainThread:@selector(pushToSendVC) withObject:self.myCommentModel waitUntilDone:NO];
        }
    } else {
        [self getDataFrom:1];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([scrollView isEqual:subScrollView]) {
        evaluateTableView.scrollEnabled = NO;
        infoTableView.scrollEnabled = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isEqual:subScrollView]) {
        NSInteger index = scrollView.contentOffset.x / SCREEN_WIDTH;
        [self.titleScrollView scrollToIndex:index];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([scrollView isEqual:subScrollView]) {
        evaluateTableView.scrollEnabled = YES;
        infoTableView.scrollEnabled = YES;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidScroll ----- %f", scrollView.contentOffset.y);
    if ([scrollView isEqual:self.tableView]) {
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.height - 0.5)) {
            self.offsetType = OffsetTypeMax;
        } else if (scrollView.contentOffset.y <= 0) {
            self.offsetType = OffsetTypeMin;
        } else {
            self.offsetType = OffsetTypeCenter;
        }
        
        if (self.titleScrollView.currentSelectedIndex == 0 && infoTableView.offsetType == OffsetTypeCenter) {
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentSize.height - scrollView.height);
        }
        
        if (self.titleScrollView.currentSelectedIndex == 1 && evaluateTableView.offsetType == OffsetTypeCenter) {
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentSize.height - scrollView.height);
        }
        
        if (self.titleScrollView.currentSelectedIndex == 2 && webView.offsetType == OffsetTypeCenter) {
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentSize.height - scrollView.height);
        }
    }
}

#pragma mark *** UITableViewDataSource ***
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) return AUTOLAYOUTSIZE(SURVEY_SECTION0_HEIGHT);
    return SURVEY_SECTION1_HEIGHT(SCREEN_HEIGHT, SURVEY_HEADER_HEIGHT, SURVEY_DEFAULT_Y);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return AUTOLAYOUTSIZE(SURVEY_HEADER_HEIGHT);
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        DBHProjectOverviewForProjectInfomtaionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHProjectOverviewForProjectInfomtaionTableViewCell forIndexPath:indexPath];
        cell.projectDetailModel = self.projectDetailModel;
        cell.model = self.synthModel;
        return cell;
    } else {
        YYProjectSurveySection1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kYYProjectSurveySection1Cell forIndexPath:indexPath];
        cell.projectDetailModel = self.projectDetailModel;
        subScrollView = cell.subScrollView;
        infoTableView = cell.infoTableView;
        evaluateTableView = cell.evaluateTableView;
        
        WEAKSELF
        [evaluateTableView setTagBlock:^(NSInteger index) {
            weakSelf.selectedTagFromCell = YES;
            weakSelf.currentSelectedTagIndex = index;
        }];
        
        [evaluateTableView setCommentBlock:^(NSString *startDate, NSInteger type) {
            if (type == 1) { // 不推荐
                weakSelf.currentSelectedTagIndex = 4;
            } else { // 推荐
                weakSelf.currentSelectedTagIndex = 5;
            }
            [weakSelf getDetailCommentList:startDate];
        }];
        
        [evaluateTableView setSelectBlock:^(NSInteger index) {
            [weakSelf getAnalysisList:(index == 1) ? TYPE_WEEK : TYPE_DAY];
        }];
        
        [evaluateTableView setShowBlock:^(BOOL isShow) {
            [weakSelf showHederView:isShow toView:cell.subScrollView];
        }];
        webView = cell.webView;
        cell.subScrollView.delegate = self;
        cell.mainVC = self;
        return cell;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return self.titleScrollView;
    }
    return nil;
}

- (void)flowButtonClicked:(NSInteger)index {
    self.selectedTagFromCell = NO;
    self.currentSelectedTagIndex = index;
}

- (void)showHederView:(BOOL)isShow toView:(UIView *)view {
    if (isShow) {
        if (![view.subviews containsObject:self.headerView]) {
            [view insertSubview:self.headerView aboveSubview:evaluateTableView];
        }
        self.headerView.hidden = NO;
    } else {
        self.headerView.hidden = YES;
    }
}

#pragma mark ------ setter and getter -------
- (void)setSynthModel:(YYEvaluateSynthesisModel *)synthModel {
    _synthModel = synthModel;
    
    evaluateTableView.model = synthModel;
    self.headerView.synthModel = synthModel;
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)setTagsData:(YYEvaluateTagsData *)tagsData {
    _tagsData = tagsData;
    
    [self.headerView setTagsData:tagsData withDelegate:self];
    self.headerView.height = self.tagsData.height + 63;
    evaluateTableView.tagsData = tagsData;
}

- (void)setMyCommentModel:(DBHProjectCommentModel *)myCommentModel {
    _myCommentModel = myCommentModel;
    
    evaluateTableView.myCommentModel = myCommentModel;
}

- (void)setCommentsModel:(YYComentDetailListModel *)commentsModel {
    if ([_commentsModel isEqual:commentsModel]) {
        return;
    }
    _commentsModel = commentsModel;
    
    evaluateTableView.commmentsModel = commentsModel;
}

- (void)setAnalysisArray:(NSArray *)analysisArray {
    _analysisArray = analysisArray;
    
    evaluateTableView.analysisArray = analysisArray;
}

- (void)setCurrentSelectedTagIndex:(NSInteger)currentSelectedTagIndex {
    _currentSelectedTagIndex = currentSelectedTagIndex;
    
    if (self.selectedTagFromCell) {
        self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, self.tableView.contentSize.height - self.tableView.height);
        self.offsetType = OffsetTypeMax;
    } else {
        evaluateTableView.currentSelectedTagIndex = currentSelectedTagIndex;
    }
    self.tagsData.currentSelectedTagIndex = currentSelectedTagIndex;
    [self.headerView setTagsData:self.tagsData withDelegate:self];
    
    [self getDetailCommentList:nil];
}

- (void)setCurrentShowIndex:(int)currentShowIndex {
    _currentShowIndex = currentShowIndex;
    
    [subScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * currentShowIndex, 0)];
    [self getEvaluateData:YES];
}

- (YYEvaluateGradeHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[YYEvaluateGradeHeaderView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, 60)];
    }
    return _headerView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat y = AUTOLAYOUTSIZE(SURVEY_DEFAULT_Y);
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, SCREEN_HEIGHT - y) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = WHITE_COLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView registerClass:[DBHProjectOverviewForProjectInfomtaionTableViewCell class] forCellReuseIdentifier:kDBHProjectOverviewForProjectInfomtaionTableViewCell];
        
        [_tableView registerClass:[YYProjectSurveySection1TableViewCell class] forCellReuseIdentifier:kYYProjectSurveySection1Cell];
    }
    return _tableView;
}

- (DBHSelectScrollView *)titleScrollView  {
    if (!_titleScrollView) {
        _titleScrollView = [[DBHSelectScrollView alloc] initWithTitles:self.titleStrArray currentSelectedIndex:0];
        _titleScrollView.backgroundViewColor = COLORFROM16(0xF6F6F6, 1);
        _titleScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, AUTOLAYOUTSIZE(SURVEY_HEADER_HEIGHT));
        
        WEAKSELF
        [_titleScrollView setSelectedBlock:^(int index) {
            weakSelf.currentShowIndex = index;
        }];
    }
    return _titleScrollView;
}


- (NSArray *)titleStrArray {
    if (!_titleStrArray) {
        _titleStrArray = [NSArray arrayWithObjects:DBHGetStringWithKeyFromTable(@"Information", nil),
                          DBHGetStringWithKeyFromTable(@"Evaluation", nil),
                          DBHGetStringWithKeyFromTable(@"Overview", nil), nil];
    }
    return _titleStrArray;
}

@end

