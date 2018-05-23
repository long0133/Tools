//
//  DBHTradingMarketCharTableViewCell.m
//  FBG
//
//  Created by yy on 2018/3/16.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHTradingMarketCharTableViewCell.h"
#import "DBHProjectDetailInformationModelCategoryUser.h"
#import "FBG-Swift.h"
#import "DBHMarketDetailViewModel.h"

@interface DBHTradingMarketCharTableViewCell()

@property (nonatomic, strong) DBHTradingMarketView *tradingMarketView;

@property (nonatomic, copy) NSString *projectId;

@end

@implementation DBHTradingMarketCharTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.contentView addSubview:self.tradingMarketView];
    WEAKSELF
    [self.tradingMarketView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.width.height.equalTo(weakSelf.contentView);
    }];
}

- (void)setDetailModel:(DBHProjectDetailInformationModelData *)detailModel infoModel:(DBHInformationModelData *)infoModel {
    self.tradingMarketView.yourOpinion = DBHGetStringWithKeyFromTable(@"Your Opinion", nil);
    self.tradingMarketView.chatRoomId = [NSString stringWithFormat:@"%ld", (NSInteger)detailModel.roomId];
    self.tradingMarketView.projectId = [NSString stringWithFormat:@"%ld", (NSInteger)infoModel.dataIdentifier];
    self.tradingMarketView.isMarketFollow = detailModel.categoryUser.isMarketFollow ? @"1" : @"0";
    self.tradingMarketView.max = detailModel.categoryUser.marketHige;
    self.tradingMarketView.min = detailModel.categoryUser.marketLost;
    self.tradingMarketView.titleStr = detailModel.unit;
    
    [self.tradingMarketView refreshTitleStr];
    
    [self refreshChartData];
}

- (DBHTradingMarketView *)tradingMarketView {
    if (!_tradingMarketView) {
        _tradingMarketView = [[DBHTradingMarketView alloc] init];
    }
    return _tradingMarketView;
}

- (void)refreshChartData {
    [self.tradingMarketView refreshKLineViewData];
}

- (void)setTimerNil {
    [self.tradingMarketView.marketDetailViewModel setTimernil];
}
@end
