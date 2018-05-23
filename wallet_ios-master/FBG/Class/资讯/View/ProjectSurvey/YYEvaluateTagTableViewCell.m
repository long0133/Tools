//
//  YYEvaluateTagTableViewCell.m
//  FBG
//
//  Created by yy on 2018/4/8.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYEvaluateTagTableViewCell.h"
#import "DBHGradeView.h"

#import "YYEvaluateTagsData.h"
#import "DBHSelectScrollView.h"
#import "YYEvaluateAnalysisTableViewCell.h"
#import "YYEvaluateDetailAnalysisModel.h"
@import Charts;

@interface YYEvaluateTagTableViewCell()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet D5FlowButtonView *tagView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagViewHeightConstraint;

@property (weak, nonatomic) IBOutlet DBHSelectScrollView *titleScrollView;
@property (weak, nonatomic) IBOutlet UIButton *showChartBtn;
@property (weak, nonatomic) IBOutlet UIView *chartBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chartBgHeightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *chartTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *selectedTipView;
@property (weak, nonatomic) IBOutlet UIButton *closeSelectedTipBtn;
@property (weak, nonatomic) IBOutlet UILabel *selectedLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectedTipLabel;

@property (assign, nonatomic) NSInteger dayOrWeekIndex;


@property (weak, nonatomic) IBOutlet UILabel *recommendUnitLabel;
@property (weak, nonatomic) IBOutlet UILabel *disRecommendUnitLabel;

@property (weak, nonatomic) IBOutlet UILabel *upMaxLabel;
@property (weak, nonatomic) IBOutlet UILabel *upMiddleLabel;
@property (weak, nonatomic) IBOutlet UILabel *middleLabel;
@property (weak, nonatomic) IBOutlet UILabel *downMiddleMaxLabel;
@property (weak, nonatomic) IBOutlet UILabel *downMaxLabel;

@property (weak, nonatomic) IBOutlet UIView *barChartView;

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation YYEvaluateTagTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.showChartBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.showChartBtn setTitle:DBHGetStringWithKeyFromTable(@"Hide Chart", nil) forState:UIControlStateNormal];
    [self.showChartBtn setTitle:DBHGetStringWithKeyFromTable(@"Show Chart", nil) forState:UIControlStateSelected];
    
    self.chartTitleLabel.text = DBHGetStringWithKeyFromTable(@"Zoom", nil);
    self.closeSelectedTipBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.selectedLabel.text = DBHGetStringWithKeyFromTable(@"Selected", nil);
    
    self.titleScrollView.titles = @[@"Day", @"Week"];
    self.titleScrollView.topLineColor = WHITE_COLOR;
    
    self.selectedTipView.hidden = YES;
    
    self.recommendUnitLabel.text = DBHGetStringWithKeyFromTable(@"Recommend ", nil);
    self.disRecommendUnitLabel.text = DBHGetStringWithKeyFromTable(@"Not Recommend", nil);
    
    self.middleLabel.text = @"0";
    
    WEAKSELF
    [self.titleScrollView setSelectedBlock:^(int index) {
        if (weakSelf.selectBlock) {
            weakSelf.selectBlock(index);
        }
    }];
    
    UITableView *scrollTableView = [[UITableView alloc] init];
    scrollTableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
    CGFloat margin = 6;
    scrollTableView.frame = CGRectMake(margin, 0, SCREEN_WIDTH - 72 - margin * 2, self.barChartView.height);
    scrollTableView.delegate = self;
    scrollTableView.dataSource = self;
    
    scrollTableView.showsVerticalScrollIndicator = NO;
    scrollTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    scrollTableView.backgroundColor = self.barChartView.backgroundColor;
    
    [scrollTableView registerNib:[UINib nibWithNibName:NSStringFromClass([YYEvaluateAnalysisTableViewCell class]) bundle:nil] forCellReuseIdentifier:EVALUATE_ANALYSIS_CELL_ID];
    _tableView = scrollTableView;

    [self.barChartView addSubview:_tableView];

}

#pragma mark ---- set data -------
- (void)setAnalysisArray:(NSMutableArray *)analysisArray {
    if ([_analysisArray isEqualToArray:analysisArray]) {
        return;
    }
    
    _analysisArray = analysisArray;
    
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        NSInteger max = 10;
        for (YYEvaluateDetailAnalysisModel *model in analysisArray) {
            NSInteger up = model.like;
            NSInteger down = model.very_dissatisfied;
            
            if (up > max) {
                max = up;
            }
            
            if (down > max) {
                max = down;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSInteger resultMax =  10;
            NSInteger resultMiddle = [self middleByMax:max resultMax:&resultMax];
            self.upMaxLabel.text = [NSString stringWithFormat:@"%@", @(resultMax)];
            self.downMaxLabel.text = [NSString stringWithFormat:@"%@", @(resultMax)];
            
            self.upMiddleLabel.text = [NSString stringWithFormat:@"%@", @(resultMiddle)];
            self.downMiddleMaxLabel.text = [NSString stringWithFormat:@"%@", @(resultMiddle)];
            
            [self.tableView reloadData];
        });
    });
}

- (NSInteger)middleByMax:(NSInteger)max resultMax:(NSInteger *)resultMax {
    if (max < 10) {
        *resultMax = 10;
    } else if (max < 100) {
        *resultMax = (NSInteger) ceil(max / 10.0) * 10;
    } else if (max < 1000) {
        *resultMax = (NSInteger) ceil(max / 100.0) * 100;
    } else if (max < 10000) {
        *resultMax = (NSInteger) ceil(max / 1000.0) * 1000;
    } else {
        *resultMax = (NSInteger) ceil(max / 10000.0) * 10000;
    }
    NSInteger mid = *resultMax / 2;
    return mid;
}

- (void)setTagsData:(YYEvaluateTagsData *)tagsData withDelegate:(id<D5FlowButtonViewDelegate>)delegate {
    [tagsData setData:tagsData viewWidth:CGRectGetWidth(self.tagView.frame)];
    
    self.tagViewHeightConstraint.constant = tagsData.height;
    
    if (tagsData.buttonList.count > 0) {
        [self.tagView setData:tagsData.buttonList withDelegate:delegate];
    }
}

#pragma mark ---- UITableView -------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.analysisArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YYEvaluateAnalysisTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EVALUATE_ANALYSIS_CELL_ID forIndexPath:indexPath];
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    
    WEAKSELF
    [cell setSelectedBlock:^(NSInteger num, NSInteger type, NSString *dateStr) {
        weakSelf.selectedTipView.hidden = NO;
        
        NSString *resultDateStr = [NSDate dateStrFromStr:dateStr formatter:@"MM.dd"];
        weakSelf.selectedTipLabel.text = [NSString stringWithFormat:@" %@ %@%ld%@", resultDateStr, DBHGetStringWithKeyFromTable(type == 1 ? @"Not Recommend & Comment" : @"Recommend & Comment", nil), num, DBHGetStringWithKeyFromTable(@" ", nil)];
        
        if (weakSelf.commentBlock) {
            weakSelf.commentBlock(dateStr, type);
        }
    }];
    NSInteger row = indexPath.row;
    if (row < self.analysisArray.count) {
        YYEvaluateDetailAnalysisModel *model = self.analysisArray[row];
        [cell setModel:model withMax:self.upMaxLabel.text.integerValue];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35;
}

#pragma mark ---- responds -------
- (IBAction)respondsToShowChartBtn:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    WEAKSELF
    BOOL isSelected = sender.isSelected;
    if (isSelected) { // 隐藏
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.chartBgHeightConstraint.constant = 0;
        } completion:^(BOOL finished) {
            weakSelf.chartBgView.hidden = YES;
            [weakSelf.contentView layoutIfNeeded];
            
            if (weakSelf.clickBlock) {
                weakSelf.clickBlock(isSelected);
            }
        }];
    } else { // 显示
        self.chartBgView.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.chartBgHeightConstraint.constant = CHART_BGVIEW_DEFAULT_HEIGHT;
        } completion:^(BOOL finished) {
            [weakSelf.contentView layoutIfNeeded];
            
            if (weakSelf.clickBlock) {
                weakSelf.clickBlock(isSelected);
            }
        }];
    }
}

- (IBAction)respondsToCloseTipBtn:(UIButton *)sender {
    self.selectedTipView.hidden = YES;
}

@end
