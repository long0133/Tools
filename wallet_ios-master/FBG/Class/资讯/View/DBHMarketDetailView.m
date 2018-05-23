//
//  DBHMarketDetailView.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/24.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHMarketDetailView.h"

#import "DBHQuotationReminderPromptView.h"

#import "DBHMarketDetailMoneyRealTimePriceModelData.h"
#import "UIView+Tool.h"

@interface DBHMarketDetailView ()

@property (nonatomic, strong) UILabel *currentPriceLabel;
@property (nonatomic, strong) UIButton *remindButton;
@property (nonatomic, strong) UILabel *changeLabel;
@property (nonatomic, strong) UILabel *maxPriceLabel;
@property (nonatomic, strong) UILabel *volumeTransactionLabel;
@property (nonatomic, strong) UILabel *minPriceLabel;
@property (nonatomic, strong) UILabel *changeValueLabel;
@property (nonatomic, strong) UILabel *maxPriceValueLabel;
@property (nonatomic, strong) UILabel *volumeTransactionValueLabel;
@property (nonatomic, strong) UILabel *minPriceValueLabel;
@property (nonatomic, strong) DBHQuotationReminderPromptView *quotationReminderPromptView;

@end

@implementation DBHMarketDetailView

#pragma mark ------ Lifecycle ------
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = WHITE_COLOR;
        
        [self setUI];
        [self setData];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self addSubview:self.currentPriceLabel];
    [self addSubview:self.remindButton];
    [self addSubview:self.changeLabel];
    [self addSubview:self.maxPriceLabel];
    [self addSubview:self.volumeTransactionLabel];
    [self addSubview:self.minPriceLabel];
    [self addSubview:self.changeValueLabel];
    [self addSubview:self.maxPriceValueLabel];
    [self addSubview:self.volumeTransactionValueLabel];
    [self addSubview:self.minPriceValueLabel];
    
    WEAKSELF
    [self.currentPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(AUTOLAYOUTSIZE(15));
        make.top.offset(AUTOLAYOUTSIZE(20));
        make.height.offset(AUTOLAYOUTSIZE(25));
    }];
    [self.remindButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(44));
        make.height.offset(AUTOLAYOUTSIZE(26));
        make.centerY.equalTo(weakSelf.currentPriceLabel);
        make.right.equalTo(weakSelf);
    }];
    [self.changeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.currentPriceLabel.mas_bottom);
        make.width.equalTo(weakSelf).multipliedBy(0.24);
        make.left.equalTo(weakSelf.currentPriceLabel);
        make.height.equalTo(weakSelf.changeLabel);
    }];
    [self.maxPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.changeLabel);
        make.left.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.changeLabel);
    }];
    [self.volumeTransactionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.changeLabel.mas_bottom);
        make.size.equalTo(weakSelf.changeLabel);
        make.left.equalTo(weakSelf.changeLabel);
        make.bottom.equalTo(weakSelf);
    }];
    [self.minPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.changeLabel);
        make.left.equalTo(weakSelf.maxPriceLabel);
        make.centerY.equalTo(weakSelf.volumeTransactionLabel);
    }];
    [self.changeValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.changeLabel.mas_right);
        make.centerY.equalTo(weakSelf.changeLabel);
    }];
    [self.maxPriceValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.maxPriceLabel.mas_right);
        make.centerY.equalTo(weakSelf.maxPriceLabel);
    }];
    [self.volumeTransactionValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.volumeTransactionLabel.mas_right);
        make.centerY.equalTo(weakSelf.volumeTransactionLabel);
    }];
    [self.minPriceValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.minPriceLabel.mas_right);
        make.centerY.equalTo(weakSelf.minPriceLabel);
    }];
}

#pragma mark ------ Data ------
/**
 行情提醒
 */
- (void)remindSetWithMaxPrice:(NSString *)maxPrice minPrice:(NSString *)minPrice {
    BOOL isReminder = maxPrice.doubleValue || minPrice.doubleValue;
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:@(isReminder) forKey:@"is_market_follow"];
    if (isReminder) {
        [paramters setObject:maxPrice forKey:@"market_hige"];
        [paramters setObject:minPrice forKey:@"market_lost"];
    }
    
    WEAKSELF
    [PPNetworkHelper PUT:[NSString stringWithFormat:@"category/%@/follow", self.projectId] baseUrlType:3 parameters:[paramters copy] hudString:nil success:^(id responseObject) {
        weakSelf.isMarketFollow = @"1";
        weakSelf.max = responseObject[@"market_hige"];
        weakSelf.min = responseObject[@"market_lost"];
        [LCProgressHUD showSuccess:DBHGetStringWithKeyFromTable(@"Set Success", nil)];
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    }];
}

#pragma mark ------ Event Responds ------
/**
 行情提醒
 */
- (void)respondsToRemindButton {
    if (![UserSignData share].user.isLogin) {
        UIViewController *vc = [self parentController];
        [[AppDelegate delegate] goToLoginVC:vc];
    } else {
        NSString *usdPrice = [NSString stringWithFormat:@"$%.2lf", _model.price.doubleValue];
        self.quotationReminderPromptView.price = usdPrice;
        self.quotationReminderPromptView.maxPrice = self.max;
        self.quotationReminderPromptView.minPrice = self.min;
        [[UIApplication sharedApplication].keyWindow addSubview:self.quotationReminderPromptView];
        
        WEAKSELF
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.quotationReminderPromptView animationShow];
        });
    }
}

#pragma mark ------ Private Methods ------
- (void)setData {
    // 设置占位数据
    DBHMarketDetailMoneyRealTimePriceModelData *model = [[DBHMarketDetailMoneyRealTimePriceModelData alloc] init];
    model.price = @"0";
    model.priceCny = @"0";
    model.change24h = @"0";
    model.changeCny24h = @"0";
    model.maxPrice24h = @"0";
    model.maxPriceCny24h = @"0";
    model.volume = @"0";
    model.volumeCny = @"0";
    model.minPrice24h = @"0";
    model.minPriceCny24h = @"0";
    
    self.model = model;
}

#pragma mark ------ Getters And Setters ------
- (void)setModel:(DBHMarketDetailMoneyRealTimePriceModelData *)model {
    _model = model;
    
    NSString *usdPrice = [NSString stringWithFormat:@"$%.2lf", _model.price.doubleValue];
    NSString *cnyPrice = [NSString stringWithFormat:@"￥%.2lf", _model.priceCny.doubleValue];
    self.quotationReminderPromptView.price = usdPrice;
    
    NSMutableAttributedString *currentPriceAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", usdPrice, cnyPrice]];
    [currentPriceAttributedString addAttributes:@{NSFontAttributeName:BOLDFONT(20), NSForegroundColorAttributeName:COLORFROM16(0x333333, 1)} range:NSMakeRange(0, usdPrice.length)];
    self.currentPriceLabel.attributedText = currentPriceAttributedString;
    
    NSString *change = [NSString stringWithFormat:@"%.2lf", [UserSignData share].user.walletUnitType == 1 ? _model.changeCny24h.doubleValue : _model.change24h.doubleValue];
    self.changeValueLabel.text = [NSString stringWithFormat:@"%@%@%%", change.doubleValue > 0 ? @"+" : @"", change];
    self.changeValueLabel.textColor = change.doubleValue > 0 ? COLORFROM16(0x2D9518, 1) : COLORFROM16(0xFF680F, 1);
    
    NSString *money = [UserSignData share].user.walletUnitType == 1 ? @"¥" : @"$";
    NSString *maxPrice = [NSString stringWithFormat:@"%.2lf", [UserSignData share].user.walletUnitType == 1 ? _model.maxPriceCny24h.doubleValue : _model.maxPrice24h.doubleValue];
    self.maxPriceValueLabel.text = [NSString stringWithFormat:@"%@%@", money, maxPrice];
    
    NSString *volumeTransaction = [NSString getDealNumwithstring:[NSString stringWithFormat:@"%.2lf", [UserSignData share].user.walletUnitType == 1 ? _model.volumeCny.doubleValue : _model.volumeCny.doubleValue]];
    self.volumeTransactionValueLabel.text = [NSString stringWithFormat:@"%@%@", money, volumeTransaction];
    
    NSString *minPrice = [NSString stringWithFormat:@"%.2lf", [UserSignData share].user.walletUnitType == 1 ? _model.minPriceCny24h.doubleValue : _model.minPrice24h.doubleValue];
    self.minPriceValueLabel.text = [NSString stringWithFormat:@"%@%@", money, minPrice];
}
- (void)setIsMarketFollow:(NSString *)isMarketFollow {
    _isMarketFollow = isMarketFollow;
    
    [self.remindButton setImage:[UIImage imageNamed:[_isMarketFollow isEqualToString:@"1"] ? @"shishihangqing_xiaoxi" : @"shishihangqing_xiaoxi copy"] forState:UIControlStateNormal];
}

- (UILabel *)currentPriceLabel {
    if (!_currentPriceLabel) {
        _currentPriceLabel = [[UILabel alloc] init];
        _currentPriceLabel.font = FONT(14);
        _currentPriceLabel.textColor = COLORFROM16(0xAAAAAA, 1);
    }
    return _currentPriceLabel;
}
- (UIButton *)remindButton {
    if (!_remindButton) {
        _remindButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_remindButton setImage:[UIImage imageNamed:@"shishihangqing_xiaoxi"] forState:UIControlStateNormal];
        [_remindButton addTarget:self action:@selector(respondsToRemindButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _remindButton;
}
- (UILabel *)changeLabel {
    if (!_changeLabel) {
        _changeLabel = [[UILabel alloc] init];
        _changeLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(14)];
        _changeLabel.text = DBHGetStringWithKeyFromTable(@"Change", nil);
        _changeLabel.textColor = COLORFROM16(0xADADAD, 1);
    }
    return _changeLabel;
}
- (UILabel *)maxPriceLabel {
    if (!_maxPriceLabel) {
        _maxPriceLabel = [[UILabel alloc] init];
        _maxPriceLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(14)];
        _maxPriceLabel.text = DBHGetStringWithKeyFromTable(@"High", nil);
        _maxPriceLabel.textColor = COLORFROM16(0xADADAD, 1);
    }
    return _maxPriceLabel;
}
- (UILabel *)volumeTransactionLabel {
    if (!_volumeTransactionLabel) {
        _volumeTransactionLabel = [[UILabel alloc] init];
        _volumeTransactionLabel.text = DBHGetStringWithKeyFromTable(@"Volume", nil);
        _volumeTransactionLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(14)];
        _volumeTransactionLabel.textColor = COLORFROM16(0xADADAD, 1);
    }
    return _volumeTransactionLabel;
}
- (UILabel *)minPriceLabel {
    if (!_minPriceLabel) {
        _minPriceLabel = [[UILabel alloc] init];
        _minPriceLabel.text = DBHGetStringWithKeyFromTable(@"Low", nil);
        _minPriceLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(14)];
        _minPriceLabel.textColor = COLORFROM16(0xADADAD, 1);
    }
    return _minPriceLabel;
}
- (UILabel *)changeValueLabel {
    if (!_changeValueLabel) {
        _changeValueLabel = [[UILabel alloc] init];
        _changeValueLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(14)];
        _changeValueLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _changeValueLabel;
}
- (UILabel *)maxPriceValueLabel {
    if (!_maxPriceValueLabel) {
        _maxPriceValueLabel = [[UILabel alloc] init];
        _maxPriceValueLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(14)];
        _maxPriceValueLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _maxPriceValueLabel;
}
- (UILabel *)volumeTransactionValueLabel {
    if (!_volumeTransactionValueLabel) {
        _volumeTransactionValueLabel = [[UILabel alloc] init];
        _volumeTransactionValueLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(14)];
        _volumeTransactionValueLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _volumeTransactionValueLabel;
}
- (UILabel *)minPriceValueLabel {
    if (!_minPriceValueLabel) {
        _minPriceValueLabel = [[UILabel alloc] init];
        _minPriceValueLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(14)];
        _minPriceValueLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _minPriceValueLabel;
}
- (DBHQuotationReminderPromptView *)quotationReminderPromptView {
    if (!_quotationReminderPromptView) {
        _quotationReminderPromptView = [[DBHQuotationReminderPromptView alloc] init];
        
        WEAKSELF
        [_quotationReminderPromptView commitBlock:^(NSString *maxValue, NSString *minValue) {
            [weakSelf remindSetWithMaxPrice:maxValue minPrice:minValue];
        }];
    }
    return _quotationReminderPromptView;
}

@end
