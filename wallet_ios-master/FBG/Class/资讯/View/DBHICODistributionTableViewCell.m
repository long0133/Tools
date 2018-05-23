//
//  DBHICODistributionTableViewCell.m
//  FBG
//
//  Created by yy on 2018/3/21.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHICODistributionTableViewCell.h"
#import <Charts/Charts-Swift.h>

#import "DBHProjectDetailInformationDataModels.h"

#import "DBHPieChartFormTableViewCell.h"
#import "DBHProjectDetailInformationModelData.h"

static NSString *const kDBHPieChartFormTableViewCell = @"kDBHPieChartFormTableViewCell";

@interface DBHICODistributionTableViewCell()<UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) PieChartView *pieChartView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation DBHICODistributionTableViewCell

#pragma mark ------ Lifecycle ------
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.isHideBottomLineView = YES;
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.contentView addSubview:self.tableView];
    WEAKSELF
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(AUTOLAYOUTSIZE(ICO_DISTRIBUTION_HEIGHT)));
        make.centerX.width.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.contentView).offset(AUTOLAYOUTSIZE(10));
    }];
    
    [self.contentView addSubview:self.pieChartView];
    [self.pieChartView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.tableView.mas_bottom).offset(AUTOLAYOUTSIZE(20));
        make.bottom.equalTo(weakSelf.contentView);
    }];
}

- (void)setProjectDetailModel:(DBHProjectDetailInformationModelData *)projectDetailModel {
    _projectDetailModel = projectDetailModel;
    
    self.dataSource = [NSMutableArray arrayWithArray:_projectDetailModel.categoryStructure];
    
    WEAKSELF
    CGFloat height = self.dataSource.count * ICO_DISTRIBUTION_HEIGHT;
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(AUTOLAYOUTSIZE(height)));
        make.centerX.width.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.contentView).offset(AUTOLAYOUTSIZE(10));
    }];
    
    NSMutableArray *values = [NSMutableArray array];
    NSMutableArray *pointColors = [NSMutableArray array];
    PieChartDataSet *dataSet;
    
    NSInteger count =  _projectDetailModel.categoryStructure.count;
    for (NSInteger i = 0; i < count; i++) {
        DBHProjectDetailInformationModelCategoryStructure *model = _projectDetailModel.categoryStructure[i];
        PieChartDataEntry *pieChartDataEntry = [[PieChartDataEntry alloc] initWithValue:model.percentage label:nil data:nil];
        
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

#pragma mark ------ UITableView Datasource ------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHPieChartFormTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHPieChartFormTableViewCell forIndexPath:indexPath];
    if (indexPath.row < self.dataSource.count) {
        DBHProjectDetailInformationModelCategoryStructure *model = self.dataSource[indexPath.row];
        NSString *percent = [NSString stringWithFormat:@"%.0f", model.percentage];
        NSString *content = model.desc;
        UIColor *color = [UIColor colorWithHexString:[model.colorValue substringFromIndex:1]];
        [cell setColor:color percent:percent content:content];
    }
    return cell;
}

#pragma mark ------ Getters And Setters ------
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = WHITE_COLOR;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.rowHeight = AUTOLAYOUTSIZE(ICO_DISTRIBUTION_HEIGHT);
        
        _tableView.dataSource = self;
        
        [_tableView registerClass:[DBHPieChartFormTableViewCell class] forCellReuseIdentifier:kDBHPieChartFormTableViewCell];
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (PieChartView *)pieChartView {
    if (!_pieChartView) {
        _pieChartView = [[PieChartView alloc] init];
        
        CGFloat margin = 40;
        [_pieChartView setExtraOffsetsWithLeft:AUTOLAYOUTSIZE(margin) top:0 right:AUTOLAYOUTSIZE(margin) bottom:0]; // 饼状图距离边缘的间隙
        
        _pieChartView.drawHoleEnabled = YES; // 饼状图是否是空心
        _pieChartView.holeRadiusPercent = 0.5; // 空心半径占比
        _pieChartView.drawSliceTextEnabled = NO; // 是否显示区块文本

        _pieChartView.descriptionText = @""; // 饼状图描述
        _pieChartView.userInteractionEnabled = NO;
        
         _pieChartView.legend.formSize = 0;  //图示大小
        
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
