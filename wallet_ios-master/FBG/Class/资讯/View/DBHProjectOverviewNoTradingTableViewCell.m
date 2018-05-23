//
//  DBHProjectOverviewNoTradingTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/30.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHProjectOverviewNoTradingTableViewCell.h"

#import <Charts/Charts-Swift.h>

#import "DBHProjectDetailInformationDataModels.h"

@interface DBHProjectOverviewNoTradingTableViewCell ()<ChartViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *orangeView;
@property (nonatomic, strong) UILabel *firstLabel;
@property (nonatomic, strong) UIView *greenView;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) UIView *darkGreenView;
@property (nonatomic, strong) UILabel *thirdLabel;
@property (nonatomic, strong) PieChartView *pieChartView;

@end

@implementation DBHProjectOverviewNoTradingTableViewCell

#pragma mark ------ Lifecycle ------
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.isHideBottomLineView = YES;
        
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.contentView addSubview:self.titleLabel];
//    [self.contentView addSubview:self.orangeView];
//    [self.contentView addSubview:self.firstLabel];
//    [self.contentView addSubview:self.greenView];
//    [self.contentView addSubview:self.secondLabel];
//    [self.contentView addSubview:self.darkGreenView];
//    [self.contentView addSubview:self.thirdLabel];
    [self.contentView addSubview:self.pieChartView];
    
    WEAKSELF
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(AUTOLAYOUTSIZE(15));
        make.top.offset(AUTOLAYOUTSIZE(0));
    }];
//    [self.orangeView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.offset(AUTOLAYOUTSIZE(12.5));
//        make.left.equalTo(weakSelf.titleLabel);
//        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(AUTOLAYOUTSIZE(22));
//    }];
//    [self.firstLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.orangeView.mas_right).offset(AUTOLAYOUTSIZE(4.5));
//        make.centerY.equalTo(weakSelf.orangeView);
//    }];
//    [self.greenView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.size.equalTo(weakSelf.orangeView);
//        make.left.equalTo(weakSelf.orangeView);
//        make.top.equalTo(weakSelf.orangeView.mas_bottom).offset(AUTOLAYOUTSIZE(16.5));
//    }];
//    [self.secondLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.firstLabel);
//        make.centerY.equalTo(weakSelf.greenView);
//    }];
//    [self.darkGreenView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.size.equalTo(weakSelf.orangeView);
//        make.left.equalTo(weakSelf.orangeView);
//        make.top.equalTo(weakSelf.greenView.mas_bottom).offset(AUTOLAYOUTSIZE(16.5));
//    }];
//    [self.thirdLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.firstLabel);
//        make.centerY.equalTo(weakSelf.darkGreenView);
//    }];
    [self.pieChartView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView);
        make.centerX.bottom.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom);
        make.bottom.equalTo(weakSelf.contentView);
    }];
    
//    self.firstLabel.text = @"25%用于团队建设";
//    self.secondLabel.text = @"50%用于产品开发";
//    self.thirdLabel.text = @"25%用于社区运营";
}

#pragma mark ------ ChartViewDelegate ------

#pragma mark ------ Getters And Setters ------
- (void)setProjectDetailModel:(DBHProjectDetailInformationModelData *)projectDetailModel {
    _projectDetailModel = projectDetailModel;
    
    NSMutableArray *values = [NSMutableArray array];
    NSMutableArray *pointColors = [NSMutableArray array];
    PieChartDataSet *dataSet;
    
    NSInteger count =  _projectDetailModel.categoryStructure.count;
    for (NSInteger i = 0; i < count; i++) {
        DBHProjectDetailInformationModelCategoryStructure *model = _projectDetailModel.categoryStructure[i];
        PieChartDataEntry *pieChartDataEntry = [[PieChartDataEntry alloc] initWithValue:model.percentage label:[NSString stringWithFormat:@"%ld%% %@", (NSInteger)model.percentage, model.desc] data:[NSString stringWithFormat:@"%ld", i]];
        
        [values addObject:pieChartDataEntry];
        [pointColors addObject:[UIColor colorWithHexString:[model.colorValue substringFromIndex:1]]];
    }
    
    dataSet = [[PieChartDataSet alloc] initWithValues:values label:nil];
    dataSet.selectionShift = 0;
    dataSet.drawIconsEnabled = NO;
    dataSet.sliceSpace = 0; // 相邻区块之间的间距
    dataSet.iconsOffset = CGPointMake(0, 100);
    // add a lot of colors
    
    dataSet.colors = pointColors;
 
    PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
    
    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
    pFormatter.numberStyle = NSNumberFormatterPercentStyle;
    pFormatter.maximumFractionDigits = 1;
    pFormatter.multiplier = @1.f;
    pFormatter.percentSymbol = @" %";
    [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:pFormatter]];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.f]];
    [data setValueTextColor:UIColor.clearColor];
    
    self.pieChartView.data = data;
    
    [self.pieChartView animateWithXAxisDuration:1.0f easingOption:ChartEasingOptionEaseOutExpo];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = BOLDFONT(15);
        _titleLabel.text = @"";
        _titleLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _titleLabel;
}
- (UIView *)orangeView {
    if (!_orangeView) {
        _orangeView = [[UIView alloc] init];
        _orangeView.backgroundColor = COLORFROM16(0xFF713D, 1);
    }
    return _orangeView;
}
- (UILabel *)firstLabel {
    if (!_firstLabel) {
        _firstLabel = [[UILabel alloc] init];
        _firstLabel.font = FONT(14);
        _firstLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _firstLabel;
}
- (UIView *)greenView {
    if (!_greenView) {
        _greenView = [[UIView alloc] init];
        _greenView.backgroundColor = COLORFROM16(0x0A9234, 1);
    }
    return _greenView;
}
- (UILabel *)secondLabel {
    if (!_secondLabel) {
        _secondLabel = [[UILabel alloc] init];
        _secondLabel.font = FONT(14);
        _secondLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _secondLabel;
}
- (UIView *)darkGreenView {
    if (!_darkGreenView) {
        _darkGreenView = [[UIView alloc] init];
        _darkGreenView.backgroundColor = COLORFROM16(0x005031, 1);
    }
    return _darkGreenView;
}
- (UILabel *)thirdLabel {
    if (!_thirdLabel) {
        _thirdLabel = [[UILabel alloc] init];
        _thirdLabel.font = FONT(14);
        _thirdLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _thirdLabel;
}
- (PieChartView *)pieChartView {
    if (!_pieChartView) {
        _pieChartView = [[PieChartView alloc] init];
        
        CGFloat margin = 50;
        [_pieChartView setExtraOffsetsWithLeft:AUTOLAYOUTSIZE(margin) top:0 right:AUTOLAYOUTSIZE(margin) bottom:-AUTOLAYOUTSIZE(300)]; // 饼状图距离边缘的间隙
        
        _pieChartView.drawHoleEnabled = YES; // 饼状图是否是空心
        _pieChartView.holeRadiusPercent = 0.5; // 空心半径占比
        _pieChartView.drawSliceTextEnabled = NO; // 是否显示区块文本
        _pieChartView.delegate = self;
        _pieChartView.descriptionText = @""; // 饼状图描述
        _pieChartView.userInteractionEnabled = NO;
        
        _pieChartView.legend.drawInside = NO;
        _pieChartView.legend.xEntrySpace = AUTOLAYOUTSIZE(10); //图标左边距离
        _pieChartView.legend.yEntrySpace = AUTOLAYOUTSIZE(16.5); //文字行间距
        _pieChartView.legend.yOffset = AUTOLAYOUTSIZE(10); //文字距顶部距离
        _pieChartView.legend.xOffset = AUTOLAYOUTSIZE(12);
        _pieChartView.legend.maxSizePercent = 0; // 图例在饼状图中的大小占比, 这会影响图例的宽高
        _pieChartView.legend.formToTextSpace = AUTOLAYOUTSIZE(5); // 文本与图标间隔
        _pieChartView.legend.font = FONT(12); // 字体大小
        _pieChartView.legend.textColor = COLORFROM16(0x333333, 1); // 字体颜色
//        _pieChartView.legend.position = ChartLegendPositionBelowChartCenter; // 图例在饼状图中的位置
//        _pieChartView.legend.form = ChartLegendFormSquare; // 图示样式: 方形、线条、圆形
        _pieChartView.legend.formSize = AUTOLAYOUTSIZE(12); // 图示大小
        _pieChartView.legend.orientation = ChartLegendOrientationVertical; //文字排列方向 垂直
        _pieChartView.legend.horizontalAlignment = ChartLegendHorizontalAlignmentLeft; // 文本的位置
        _pieChartView.legend.verticalAlignment = ChartLegendVerticalAlignmentTop;
        _pieChartView.drawCenterTextEnabled = YES; // 是否显示中间文字
        NSMutableAttributedString *centerText = [[NSMutableAttributedString alloc] initWithString:@"ICO"];
        [centerText setAttributes:@{NSFontAttributeName:FONT(13),
                                    NSForegroundColorAttributeName:COLORFROM16(0x333333, 1)}
                            range:NSMakeRange(0, centerText.length)];
        _pieChartView.centerAttributedText = centerText;
    }
    return _pieChartView;
}

@end
