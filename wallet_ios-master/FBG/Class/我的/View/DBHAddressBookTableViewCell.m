//
//  DBHAddressBookTableViewCell.m
//  Trinity
//
//  Created by 邓毕华 on 2017/12/28.
//  Copyright © 2017年 邓毕华. All rights reserved.
//

#import "DBHAddressBookTableViewCell.h"

#import "DBHAddressBookModelList.h"

@interface DBHAddressBookTableViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *addressLabel;

@end

@implementation DBHAddressBookTableViewCell

#pragma mark ------ Lifecycle ------
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bottomLineViewColor = COLORFROM16(0xFBF1F1, 1);
        self.bottomLineWidth = SCREENWIDTH - AUTOLAYOUTSIZE(46);
        
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.addressLabel];
    
    WEAKSELF
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(AUTOLAYOUTSIZE(15));
        make.top.offset(AUTOLAYOUTSIZE(8));
    }];
    [self.addressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLabel);
        make.right.offset(- AUTOLAYOUTSIZE(15));
        make.bottom.offset(- AUTOLAYOUTSIZE(6));
    }];
}

#pragma mark ------ Getters And Setters ------
- (void)setModel:(DBHAddressBookModelList *)model {
    _model = model;
    
    self.nameLabel.text = _model.name;
    self.addressLabel.text = _model.address;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = FONT(14);
        _nameLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _nameLabel;
}
- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.font = FONT(13);
        _addressLabel.textColor = COLORFROM16(0xC1BFBF, 1);
    }
    return _addressLabel;
}

@end
