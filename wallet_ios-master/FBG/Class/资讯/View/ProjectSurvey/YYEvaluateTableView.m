//
//  YYEvaluateTableView.m
//  CSJF
//
//  Created by cqdingwei@163.com on 2017/5/18.
//  Copyright © 2017年 dingwei. All rights reserved.
//

#import "YYEvaluateTableView.h"
#import "YYEvaluateSynthesisModel.h"
#import "YYEvaluateGradeTableViewCell.h"
#import "YYRecommendScaleTableViewCell.h"
#import "YYEvaluateTagTableViewCell.h"
#import "DBHProjectCommentModel.h"
#import "DBHCommentDetailTableViewCell.h"
#import "YYComentDetailListModel.h"
#import "DBHCommentDetailViewController.h"

#define COMMENTS_STORYBOARD_NAME @"Comments"

#define FOOTER_DEFAULT_HEIGHT 10

@interface YYEvaluateTableView () <UITableViewDelegate, UITableViewDataSource, D5FlowButtonViewDelegate>

@property (nonatomic, assign) BOOL isHideChart;
@property (nonatomic, assign) BOOL isShowHeaderView;

@end

@implementation YYEvaluateTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.dataSource = self;
        self.delegate = self;
        
        [self registerNib:[UINib nibWithNibName:EVALUATE_GRADE_CELL_NAME bundle:nil] forCellReuseIdentifier:EVALUATE_GRADE_CELL_ID];
        [self registerNib:[UINib nibWithNibName:RECOMMEND_SCALE_CELL_NAME bundle:nil] forCellReuseIdentifier:RECOMMEND_SCALE_CELL_ID];
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([YYEvaluateTagTableViewCell class]) bundle:nil] forCellReuseIdentifier:EVALUATE_TAG_CELL_ID];
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([DBHCommentDetailTableViewCell class]) bundle:nil] forCellReuseIdentifier:COMMENT_DETAIL_CELL_ID];
        
        self.estimatedSectionHeaderHeight = 0;
        self.estimatedSectionFooterHeight = 0;
        self.estimatedRowHeight = 0;
        
        self.sectionFooterHeight = 0;
        self.sectionHeaderHeight = 0;
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.alwaysBounceVertical = YES;
        
        self.contentInset = UIEdgeInsetsMake(0, 0, AUTOLAYOUTSIZE(63), 0);
        
        self.tableHeaderView = nil;
        self.tableFooterView = nil;
    }
    return self;
}

#pragma mark *** UIScrollViewDelegate ***
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"scroll ---- %f  %@", scrollView.contentOffset.y, [NSDate date]);

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
    
    [self judgeIsShow];
}

- (void)judgeIsShow {
    if (self.indexPathsForVisibleRows.count > 0) {
        NSInteger section = self.indexPathsForVisibleRows.firstObject.section;
        if (section >= 2) {
            self.isShowHeaderView = YES;
        } else {
            self.isShowHeaderView = NO;
        }
    }
}

#pragma mark *** UITableViewDataSource ***
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 3) {
        return self.commmentsModel.data.count;
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    switch (section) {
        case 0:
            if (self.myCommentModel && self.myCommentModel.is_category_comment > 0) {
                return CELL_HIDE_HEIGHT + MYGRADEBG_HEIGHT;
            } else {
                return CELL_HIDE_HEIGHT;
            }
            break;
        case 1:
            return 96;
            break;
        case 2: {
            CGFloat height = 91 + self.tagsData.height;
            if (!self.isHideChart) {
                height = height + CHART_BGVIEW_DEFAULT_HEIGHT;
            }
            return  height;
            break;
        }
        case 3: {
            NSInteger row = indexPath.row;
            if (row < self.commmentsModel.data.count) {
                DBHProjectCommentDetailModel *detailModel = self.commmentsModel.data[row];
                return detailModel.height;
            }
            return 0;
            break;
        }
            
            
        default:
            break;
    }
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return AUTOLAYOUTSIZE(FOOTER_DEFAULT_HEIGHT);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (section == 0) {
        YYEvaluateGradeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EVALUATE_GRADE_CELL_ID forIndexPath:indexPath];
        if (self.model) {
            cell.model = self.model;
        }
        cell.myCommentModel = self.myCommentModel;
        return cell;
    }
    
    if (section == 1) {
        YYRecommendScaleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RECOMMEND_SCALE_CELL_ID forIndexPath:indexPath];
        if (self.model) {
            cell.model = self.model;
        }
        return cell;
    }
    
    if (section == 2) {
        YYEvaluateTagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EVALUATE_TAG_CELL_ID forIndexPath:indexPath];
        cell.analysisArray = [NSMutableArray arrayWithArray:self.analysisArray];
        WEAKSELF
        [cell setTagsData:self.tagsData withDelegate:self];
        [cell setClickBlock:^(BOOL isHide) {
            weakSelf.isHideChart = isHide;
            [weakSelf reloadData];
        }];
        
        [cell setSelectBlock:^(NSInteger index) {
            if (weakSelf.selectBlock) {
                weakSelf.selectBlock(index);
            }
        }];
        
        [cell setCommentBlock:^(NSString *startDate, NSInteger type) {
            if (weakSelf.commentBlock) {
                weakSelf.commentBlock(startDate, type);
            }
        }];
        return cell;
    }
    
    if (section == 3) {
        DBHCommentDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:COMMENT_DETAIL_CELL_ID forIndexPath:indexPath];
        cell.from = CellFromList;
        NSInteger row = indexPath.row;
        if (row < self.commmentsModel.data.count) {
            DBHProjectCommentDetailModel *model = self.commmentsModel.data[row];
            cell.detailModel = model;
        }
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"simpleCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"simpleCell"];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AUTOLAYOUTSIZE(FOOTER_DEFAULT_HEIGHT))];
    footerView.backgroundColor = COLORFROM16(0xF8F8F8, 1);
    return footerView;
}

#pragma mark *** UITableViewDelegate ***
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    if (section == 3) {
        NSInteger row = indexPath.row;
        if (row < self.commmentsModel.data.count) {
            DBHProjectCommentDetailModel *commentDetailModel = self.commmentsModel.data[row];
            UIStoryboard *sb = [UIStoryboard storyboardWithName:COMMENTS_STORYBOARD_NAME bundle:nil];
            DBHCommentDetailViewController *detailVC = [sb instantiateViewControllerWithIdentifier:COMMENTDETAIL_STORYBOARD_ID];
            detailVC.detailModel = commentDetailModel;
            [[self parentController].navigationController pushViewController:detailVC animated:YES];
        }
    }
}

#pragma mark ----- Flow Delegate -------
- (void)flowButtonClicked:(NSInteger)index {
    if (self.tagBlock) {
        self.tagBlock(index);
    }
}

#pragma mark ----- Setter and Getter -------
- (void)setIsShowHeaderView:(BOOL)isShowHeaderView {
    if (isShowHeaderView == _isShowHeaderView) {
        return;
    }

    _isShowHeaderView = isShowHeaderView;
    if (self.showBlock) {
        self.showBlock(isShowHeaderView);
    }
}

- (void)setCurrentSelectedTagIndex:(NSInteger)currentSelectedTagIndex {
    _currentSelectedTagIndex = currentSelectedTagIndex;
    
    self.tagsData.currentSelectedTagIndex = currentSelectedTagIndex;
    [self updateData];
}

- (void)updateData {
    [self reloadData];
    [self layoutIfNeeded];
}

- (void)setModel:(YYEvaluateSynthesisModel *)model {
    _model = model;
    
    [self updateData];
}

- (void)setTagsData:(YYEvaluateTagsData *)tagsData {
    _tagsData = tagsData;

    [self updateData];
}

- (void)setAnalysisArray:(NSArray *)analysisArray {
    if ([analysisArray isEqualToArray:_analysisArray]) {
        return;
    }
    
    _analysisArray = analysisArray;
    
    [self updateData];
}

- (void)setMyCommentModel:(DBHProjectCommentModel *)myCommentModel {
    if ([_myCommentModel isEqual:myCommentModel]) {
        return;
    }
    _myCommentModel = myCommentModel;
    [self updateData];
}

- (void)setCommmentsModel:(YYComentDetailListModel *)commmentsModel {
//    commmentsModel.data = [NSMutableArray arrayWithArray:[NSArray arraySortedByArr:[NSMutableArray arrayWithArray:commmentsModel.data]]];
    _commmentsModel = commmentsModel;
    [self updateData];
//
//    CGRect frame = [self rectForSection:3];
//    CGFloat y = frame.origin.y - (self.tagsData.height + 73);
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.contentOffset = CGPointMake(self.contentOffset.x, y);
//    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGRect frame = [self rectForSection:3];
        CGFloat height = self.tagsData.height + 83;
        NSLog(@"----❤️ scroll --- %f -- %f", frame.size.height, self.height - height);
        
        if (frame.size.height > self.height - height) {
            frame.origin.y -= height;
        }
        
        [self scrollRectToVisible:frame animated:NO];
    });
}

#pragma mark *** other ***
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
