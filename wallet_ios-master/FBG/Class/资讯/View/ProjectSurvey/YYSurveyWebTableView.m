//
//  YYSurveyWebTableView.m
//  ToolsDemoByYangBo
//
//  Created by cqdingwei@163.com on 17/3/8.
//  Copyright © 2017年 yangbo. All rights reserved.
//

#import "YYSurveyWebTableView.h"
#import "DBHProjectDetailInformationDataModels.h"
#import "YbWebView.h"

static NSString *const kYYSurveyWebTableViewCell = @"kYYSurveyWebTableViewCell";

@interface YYSurveyWebTableView () <UITableViewDelegate, UITableViewDataSource, YbWebViewDelegate>

@property (nonatomic, strong) YbWebView *ybWebview;

@property (nonatomic, assign) CGFloat heightOfCell;

@end

@implementation YYSurveyWebTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.dataSource = self;
        self.delegate = self;
        self.alwaysBounceVertical = YES;
        
        _heightOfCell = SURVEY_SECTION1_HEIGHT(SCREEN_HEIGHT, SURVEY_HEADER_HEIGHT, SURVEY_DEFAULT_Y);
    }
    return self;
}

#pragma mark *** UIScrollViewDelegate ***
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    OffsetType type = self.mainVC.offsetType;
    
    if (scrollView.contentOffset.y <= 0) {
        self.offsetType = OffsetTypeMin;
    } else {
        self.offsetType = OffsetTypeCenter;
    }
    
    if (type == OffsetTypeMin) {
        scrollView.contentOffset = CGPointZero;
    }
    if (type == OffsetTypeCenter) {
        scrollView.contentOffset = CGPointZero;
    }
}

#pragma mark *** YbWebViewDelegate ***
- (void)ybWebView:(YbWebView *)ybWebView finishLoadWithHeight:(CGFloat)height {
    _heightOfCell = height;
    
    [self reloadData];
}

- (void)setProjectDetailModel:(DBHProjectDetailInformationModelData *)projectDetailModel {
    _projectDetailModel = projectDetailModel;
    
    NSString *htmlStr = projectDetailModel.categoryPresentation.content;
    if ([htmlStr containsString:@"<!doctype html>"]) {
        htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"<!doctype html>" withString:@"<!doctype html><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, maximum-scale=5.0, user-scalable=0\">"];
    }
    
    if (htmlStr != nil) {
        [self.ybWebview loadWithHTMLStr:htmlStr];
    }
}

#pragma mark *** UITableViewDataSource ***
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _heightOfCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kYYSurveyWebTableViewCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kYYSurveyWebTableViewCell];
       
        [cell.contentView addSubview:self.ybWebview];
        [self.ybWebview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView);
        }];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
    
}

#pragma mark *** UITableViewDelegate ***
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark *** other ***
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (YbWebView *)ybWebview {
    if (!_ybWebview) {
        _ybWebview = [YbWebView new];
        _ybWebview.delegate = self;
    }
    return _ybWebview;
}

@end
