//
//  DBHProjectLookForProjectInfomationTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/26.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHProjectLookForProjectInfomationTableViewCell.h"

#import "DBHGradeView.h"

#import "DBHProjectDetailInformationDataModels.h"

@interface DBHProjectLookForProjectInfomationTableViewCell ()

@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UIView *iconBackView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *projectGradeLabel;
@property (nonatomic, strong) DBHGradeView *gradeView;
@property (nonatomic, strong) UILabel *gradeLabel;
@property (nonatomic, strong) UIView *firstLineView;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UILabel *stateValueLabel;
@property (nonatomic, strong) UIView *secondLineView;
@property (nonatomic, strong) UILabel *projectSkypeLabel;
@property (nonatomic, strong) UILabel *projectSkypeValueLabel;
@property (nonatomic, strong) UIImageView *firstMoreImageView;
@property (nonatomic, strong) UIButton *projectSkypeButton;
@property (nonatomic, strong) UIView *thirdLineView;
@property (nonatomic, strong) UILabel *historicalInformationLabel;
@property (nonatomic, strong) UIImageView *secondMoreImageView;
@property (nonatomic, strong) UIButton *historicalInformationButton;
@property (nonatomic, strong) UIView *communityProjectBackView;
@property (nonatomic, strong) UILabel *communityProjectLabel;

@property (nonatomic, copy) ClickTypeButtonBlock clickTypeButtonBlock;
@property (nonatomic, copy) NSArray *menuArray; // 项目状态

@end

@implementation DBHProjectLookForProjectInfomationTableViewCell

#pragma mark ------ Lifecycle ------
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.contentView addSubview:self.boxView];
    [self.contentView addSubview:self.iconBackView];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.projectGradeLabel];
    [self.contentView addSubview:self.gradeView];
    [self.contentView addSubview:self.gradeLabel];
    [self.contentView addSubview:self.firstLineView];
    [self.contentView addSubview:self.stateLabel];
    [self.contentView addSubview:self.stateValueLabel];
    [self.contentView addSubview:self.secondLineView];
    [self.contentView addSubview:self.projectSkypeLabel];
    [self.contentView addSubview:self.projectSkypeValueLabel];
    [self.contentView addSubview:self.firstMoreImageView];
    [self.contentView addSubview:self.projectSkypeButton];
    [self.contentView addSubview:self.thirdLineView];
    [self.contentView addSubview:self.historicalInformationLabel];
    [self.contentView addSubview:self.secondMoreImageView];
    [self.contentView addSubview:self.historicalInformationButton];
    [self.contentView addSubview:self.communityProjectBackView];
    [self.contentView addSubview:self.communityProjectLabel];
    
    WEAKSELF
    [self.boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView);
        make.height.offset(AUTOLAYOUTSIZE(83));
        make.centerX.top.equalTo(weakSelf.contentView);
    }];
    [self.iconBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(45));
        make.left.offset(AUTOLAYOUTSIZE(15));
        make.centerY.equalTo(weakSelf.boxView);
    }];
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(44));
        make.center.equalTo(weakSelf.iconBackView);
    }];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconBackView.mas_right).offset(AUTOLAYOUTSIZE(14));
        make.top.offset(AUTOLAYOUTSIZE(22));
    }];
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLabel);
        make.top.equalTo(weakSelf.nameLabel.mas_bottom).offset(AUTOLAYOUTSIZE(3));
    }];
    [self.projectGradeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconBackView);
        make.height.offset(AUTOLAYOUTSIZE(50.5));
        make.top.equalTo(weakSelf.boxView.mas_bottom);
    }];
    [self.gradeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(56.5));
        make.height.equalTo(weakSelf.projectGradeLabel);
        make.left.offset(AUTOLAYOUTSIZE(78));
        make.centerY.equalTo(weakSelf.projectGradeLabel);
    }];
    [self.gradeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.gradeView.mas_right).offset(AUTOLAYOUTSIZE(2.5));
        make.centerY.equalTo(weakSelf.projectGradeLabel);
    }];
    [self.firstLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView).offset(- AUTOLAYOUTSIZE(30));
        make.height.offset(AUTOLAYOUTSIZE(1));
        make.centerX.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.projectGradeLabel.mas_bottom);
    }];
    [self.stateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconBackView);
        make.height.equalTo(weakSelf.projectGradeLabel);
        make.top.equalTo(weakSelf.firstLineView.mas_bottom);
    }];
    [self.stateValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.gradeView);
        make.centerY.equalTo(weakSelf.stateLabel);
    }];
    [self.secondLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.firstLineView);
        make.centerX.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.stateLabel.mas_bottom);
    }];
    [self.projectSkypeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(60));
        make.left.equalTo(weakSelf.iconBackView);
        make.height.equalTo(weakSelf.projectGradeLabel);
        make.top.equalTo(weakSelf.secondLineView.mas_bottom);
    }];
    [self.projectSkypeValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.gradeView);
        make.centerY.equalTo(weakSelf.projectSkypeLabel);
    }];
    [self.firstMoreImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(4.5));
        make.height.offset(AUTOLAYOUTSIZE(8.5));
        make.right.offset(- AUTOLAYOUTSIZE(15));
        make.centerY.equalTo(weakSelf.projectSkypeLabel);
    }];
    [self.projectSkypeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView);
        make.height.equalTo(weakSelf.projectSkypeLabel);
        make.centerX.equalTo(weakSelf.contentView);
        make.centerY.equalTo(weakSelf.projectSkypeLabel);
    }];
    [self.thirdLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.firstLineView);
        make.centerX.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.projectSkypeButton.mas_bottom);
    }];
    [self.historicalInformationLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconBackView);
        make.height.equalTo(weakSelf.projectGradeLabel);
        make.top.equalTo(weakSelf.thirdLineView.mas_bottom);
    }];
    [self.secondMoreImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.firstMoreImageView);
        make.right.equalTo(weakSelf.firstMoreImageView);
        make.centerY.equalTo(weakSelf.historicalInformationLabel);
    }];
    [self.historicalInformationButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.projectSkypeButton);
        make.centerX.equalTo(weakSelf.contentView);
        make.centerY.equalTo(weakSelf.historicalInformationLabel);
    }];
    [self.communityProjectBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView);
        make.height.offset(AUTOLAYOUTSIZE(37));
        make.centerX.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.historicalInformationLabel.mas_bottom);
    }];
    [self.communityProjectLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconBackView);
        make.centerY.equalTo(weakSelf.communityProjectBackView);
    }];
}

#pragma mark ------ Event Responds ------
/**
 项目官网
 */
- (void)respondsToProjectSkypeButton {
    self.clickTypeButtonBlock(0);
}
/**
 历史资讯
 */
- (void)respondsToHistoricalInformationButton {
    self.clickTypeButtonBlock(1);
}

#pragma mark ------ Public Methods ------
- (void)clickTypeButtonBlock:(ClickTypeButtonBlock)clickTypeButtonBlock {
    self.clickTypeButtonBlock = clickTypeButtonBlock;
}

#pragma mark ------ Getters And Setters ------
- (void)setProjectDetailModel:(DBHProjectDetailInformationModelData *)projectDetailModel {
    _projectDetailModel = projectDetailModel;
    
    [self.iconImageView sdsetImageWithURL:_projectDetailModel.img placeholderImage:nil];
    self.nameLabel.text = [NSString stringWithFormat:@"%@（%@）", _projectDetailModel.unit, _projectDetailModel.name];
    self.contentLabel.text = _projectDetailModel.industry;
    self.gradeView.grade = _projectDetailModel.categoryScore.value;
    self.gradeLabel.text = [NSString stringWithFormat:@"%.1lf", _projectDetailModel.categoryScore.value/*, DBHGetStringWithKeyFromTable(_projectDetailModel.categoryUser.score.doubleValue ? @"Has Score" : @"Not Score", nil)*/];
    
    int type = _projectDetailModel.type;
    if (type > 0 && type <= self.menuArray.count) {
        self.stateValueLabel.text = DBHGetStringWithKeyFromTable(self.menuArray[type - 1], nil);
    }
    
    self.projectSkypeValueLabel.text = _projectDetailModel.website;
    
    NSLog(@"线程%@", [NSThread currentThread]);
}

- (UIView *)boxView {
    if (!_boxView) {
        _boxView = [[UIView alloc] init];
        _boxView.backgroundColor = COLORFROM16(0xFAFAFA, 1);
    }
    return _boxView;
}
- (UIView *)iconBackView {
    if (!_iconBackView) {
        _iconBackView = [[UIView alloc] init];
        _iconBackView.backgroundColor = COLORFROM16(0xF8F4F4, 1);
        _iconBackView.layer.cornerRadius = AUTOLAYOUTSIZE(5);
    }
    return _iconBackView;
}
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImageView;
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = BOLDFONT(14);
        _nameLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _nameLabel;
}
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = FONT(11);
        _contentLabel.textColor = COLORFROM16(0xB4B4B4, 1);
    }
    return _contentLabel;
}
- (UILabel *)projectGradeLabel {
    if (!_projectGradeLabel) {
        _projectGradeLabel = [[UILabel alloc] init];
        _projectGradeLabel.font = FONT(13);
        _projectGradeLabel.text = DBHGetStringWithKeyFromTable(@"Rating", nil);
        _projectGradeLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _projectGradeLabel;
}
- (DBHGradeView *)gradeView {
    if (!_gradeView) {
        _gradeView = [[DBHGradeView alloc] init];
    }
    return _gradeView;
}
- (UILabel *)gradeLabel {
    if (!_gradeLabel) {
        _gradeLabel = [[UILabel alloc] init];
        _gradeLabel.font = FONT(11);
        _gradeLabel.textColor = COLORFROM16(0x838383, 1);
    }
    return _gradeLabel;
}
- (UIView *)firstLineView {
    if (!_firstLineView) {
        _firstLineView = [[UIView alloc] init];
        _firstLineView.backgroundColor = COLORFROM16(0xF6F6F6, 1);
    }
    return _firstLineView;
}
- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.font = FONT(13);
        _stateLabel.text = DBHGetStringWithKeyFromTable(@"Status", nil);
        _stateLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _stateLabel;
}
- (UILabel *)stateValueLabel {
    if (!_stateValueLabel) {
        _stateValueLabel = [[UILabel alloc] init];
        _stateValueLabel.font = FONT(13);
        _stateValueLabel.textColor = COLORFROM16(0x838383, 1);
    }
    return _stateValueLabel;
}
- (UIView *)secondLineView {
    if (!_secondLineView) {
        _secondLineView = [[UIView alloc] init];
        _secondLineView.backgroundColor = COLORFROM16(0xF6F6F6, 1);
    }
    return _secondLineView;
}
- (UILabel *)projectSkypeLabel {
    if (!_projectSkypeLabel) {
        _projectSkypeLabel = [[UILabel alloc] init];
        _projectSkypeLabel.font = FONT(13);
        _projectSkypeLabel.text = DBHGetStringWithKeyFromTable(@"Offical website", nil);
        _projectSkypeLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _projectSkypeLabel;
}
- (UILabel *)projectSkypeValueLabel {
    if (!_projectSkypeValueLabel) {
        _projectSkypeValueLabel = [[UILabel alloc] init];
        _projectSkypeValueLabel.font = FONT(13);
        _projectSkypeValueLabel.textColor = COLORFROM16(0x838383, 1);
    }
    return _projectSkypeValueLabel;
}
- (UIImageView *)firstMoreImageView {
    if (!_firstMoreImageView) {
        _firstMoreImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xiangmuchakan_fanhui"]];
    }
    return _firstMoreImageView;
}
- (UIButton *)projectSkypeButton {
    if (!_projectSkypeButton) {
        _projectSkypeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_projectSkypeButton addTarget:self action:@selector(respondsToProjectSkypeButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _projectSkypeButton;
}
- (UIView *)thirdLineView {
    if (!_thirdLineView) {
        _thirdLineView = [[UIView alloc] init];
        _thirdLineView.backgroundColor = COLORFROM16(0xF6F6F6, 1);
    }
    return _thirdLineView;
}
- (UILabel *)historicalInformationLabel {
    if (!_historicalInformationLabel) {
        _historicalInformationLabel = [[UILabel alloc] init];
        _historicalInformationLabel.font = FONT(13);
        _historicalInformationLabel.text = DBHGetStringWithKeyFromTable(@"History", nil);
        _historicalInformationLabel.textColor = COLORFROM16(0x34A21F, 1);
    }
    return _historicalInformationLabel;
}
- (UIImageView *)secondMoreImageView {
    if (!_secondMoreImageView) {
        _secondMoreImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xiangmuchakan_fanhui"]];
    }
    return _secondMoreImageView;
}
- (UIButton *)historicalInformationButton {
    if (!_historicalInformationButton) {
        _historicalInformationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_historicalInformationButton addTarget:self action:@selector(respondsToHistoricalInformationButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _historicalInformationButton;
}
- (UIView *)communityProjectBackView {
    if (!_communityProjectBackView) {
        _communityProjectBackView = [[UIView alloc] init];
        _communityProjectBackView.backgroundColor = COLORFROM16(0xFAFAFA, 1);
    }
    return _communityProjectBackView;
}
- (UILabel *)communityProjectLabel {
    if (!_communityProjectLabel) {
        _communityProjectLabel = [[UILabel alloc] init];
        _communityProjectLabel.font = FONT(13);
        _communityProjectLabel.text = DBHGetStringWithKeyFromTable(@"Community", nil);
        _communityProjectLabel.textColor = COLORFROM16(0x838383, 1);
    }
    return _communityProjectLabel;
}

- (NSArray *)menuArray {
    if (!_menuArray) {
        _menuArray = @[@"Trading", @"Active", @"Upcoming", @"Ended"];
    }
    return _menuArray;
}

@end
