
//
//  DBHCandyBowlDetailViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/2/28.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHCandyBowlDetailViewController.h"

#import "DBHCandyBowlModelData.h"

@interface DBHCandyBowlDetailViewController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation DBHCandyBowlDetailViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = DBHGetStringWithKeyFromTable(@"Detail", nil);
    
    [self setUI];
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.contentLabel];
    
    WEAKSELF
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view).offset(- AUTOLAYOUTSIZE(30));
        make.centerX.equalTo(weakSelf.view);
        make.top.offset(AUTOLAYOUTSIZE(24));
    }];
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.titleLabel);
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(AUTOLAYOUTSIZE(16));
    }];
}

#pragma mark ------ Getters And Setters ------
- (void)setModel:(DBHCandyBowlModelData *)model {
    _model = model;
    
    self.titleLabel.text = _model.name;
    self.contentLabel.text = _model.desc;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = BOLDFONT(15);
        _titleLabel.textColor = COLORFROM16(0x000000, 1);
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = FONT(13);
        _contentLabel.textColor = COLORFROM16(0x333333, 1);
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

@end
