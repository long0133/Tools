//
//  YYProjectSurveySection1TableViewCell.m
//  FBG
//
//  Created by yy on 2018/4/6.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYProjectSurveySection1TableViewCell.h"
#import "MultstageScrollViewHeader.h"

@interface YYProjectSurveySection1TableViewCell()

@property (nonatomic, strong) UIScrollView *subScrollView;
@property (nonatomic, strong) YYEvaluateTableView *evaluateTableView;
@property (nonatomic, strong) YYSurveyInfoTableView *infoTableView;
@property (nonatomic, strong) YYSurveyWebTableView *webView;

@end

@implementation YYProjectSurveySection1TableViewCell

#pragma mark ------ Lifecycle ------
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.isHideBottomLineView = YES;
        
        [self addSubview:self.subScrollView];
        
        [self.subScrollView addSubview:self.infoTableView];
        [self.subScrollView addSubview:self.evaluateTableView];
        [self.subScrollView addSubview:self.webView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setMainVC:(DBHProjectSurveyViewController *)mainVC {
    _mainVC = mainVC;
    
    self.infoTableView.mainVC = mainVC;
    self.webView.mainVC = mainVC;
    self.evaluateTableView.mainVC = mainVC;
}

- (void)setProjectDetailModel:(DBHProjectDetailInformationModelData *)projectDetailModel {
    _projectDetailModel = projectDetailModel;
    
    self.infoTableView.projectDetailModel = projectDetailModel;
    self.webView.projectDetailModel =  projectDetailModel;
    self.evaluateTableView.projectDetailModel =  projectDetailModel;
}

- (CGFloat)height {
    return SURVEY_SECTION1_HEIGHT(SCREEN_HEIGHT, SURVEY_HEADER_HEIGHT, SURVEY_DEFAULT_Y);
}

- (UIScrollView *)subScrollView {
    if (!_subScrollView) {
        _subScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [self height])];
        _subScrollView.bounces = NO;
        [_subScrollView setContentSize:CGSizeMake(SCREEN_WIDTH * 3, 1)];
        _subScrollView.pagingEnabled = YES;
        _subScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _subScrollView;
}

- (YYSurveyInfoTableView *)infoTableView {
    if (!_infoTableView) {
        _infoTableView = [[YYSurveyInfoTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [self height]) style:UITableViewStyleGrouped];
        _infoTableView.backgroundColor = COLORFROM16(0xF6F6F6, 1);
        _infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _infoTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        _infoTableView.tableFooterView = nil;
        
        _infoTableView.sectionHeaderHeight = 0;
        _infoTableView.sectionFooterHeight = 0;
        
        _infoTableView.estimatedRowHeight = 0;
        _infoTableView.estimatedSectionHeaderHeight = 0;
        _infoTableView.estimatedSectionFooterHeight = 0;
    }
    return _infoTableView;
}

- (YYEvaluateTableView *)evaluateTableView {
    if (!_evaluateTableView) {
        _evaluateTableView = [[YYEvaluateTableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, [self height]) style:UITableViewStylePlain];
        _evaluateTableView.backgroundColor = [UIColor whiteColor];
    }
    return _evaluateTableView;
}

- (YYSurveyWebTableView *)webView {
    if (!_webView) {
         _webView = [[YYSurveyWebTableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH, [self height])];
    }
    return _webView;
}

@end
