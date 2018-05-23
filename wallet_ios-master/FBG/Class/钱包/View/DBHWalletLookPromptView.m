//
//  DBHWalletLookPromptView.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/9.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHWalletLookPromptView.h"

#import "DBHWalletLookPromptViewTableViewCell.h"

#import "DBHWalletManagerForNeoModelList.h"

static NSString *const kDBHWalletLookPromptViewTableViewCellIdentifier = @"kDBHWalletLookPromptViewTableViewCellIdentifier";

@interface DBHWalletLookPromptView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UIButton *quitButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *avaliableLabel;

/**
 没有钱包时显示的View
 */
@property (nonatomic, strong) UIView *noDataView;

/**
 暂时还没有钱包
 */
@property (nonatomic, strong) UILabel *tipNoWalletLabel;

/**
 添加/导入钱包
 */
@property (nonatomic, strong) UIButton *addWalletBtn;

@property (nonatomic, copy) SelectedWalletBlock selectedBlock;

@property (nonatomic, copy) AddOrImportWalletBlock addWalletBlock;

@end

@implementation DBHWalletLookPromptView

#pragma mark ------ Lifecycle ------
- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = COLORFROM16(0x000000, 0.4);
        self.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
        
        [self setUI];
    }
    return self;
}

- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    
    self.noDataView.hidden = (_dataSource.count != 0);
    [self sortData];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    if (![touch.view isEqual:self.boxView]) {
        [self respondsToQuitButton];
    }
}

#pragma mark ------ UI ------
- (void)setUI {
    [self addSubview:self.boxView];
    [self.boxView addSubview:self.quitButton];
    [self.boxView addSubview:self.titleLabel];
    [self.boxView addSubview:self.numberLabel];
    [self.boxView addSubview:self.tableView];
    [self.boxView addSubview:self.avaliableLabel];
    
    [self.boxView addSubview:self.noDataView];
    [self.noDataView addSubview:self.addWalletBtn];
    [self.noDataView addSubview:self.tipNoWalletLabel];
    
    WEAKSELF
    [self.boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf);
        make.height.offset(AUTOLAYOUTSIZE(373.5));
        make.centerX.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf).offset(AUTOLAYOUTSIZE(373.5));
    }];
    [self.quitButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(40));
        make.height.offset(AUTOLAYOUTSIZE(44));
        make.top.right.equalTo(weakSelf.boxView);
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.boxView).offset(AUTOLAYOUTSIZE(15));
    }];
    [self.numberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(- AUTOLAYOUTSIZE(25));
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(AUTOLAYOUTSIZE(11.5));
    }];
    
    [self.avaliableLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(AUTOLAYOUTSIZE(23));
        make.top.equalTo(weakSelf.numberLabel);
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.boxView);
        make.centerX.equalTo(weakSelf.boxView);
        make.top.equalTo(weakSelf.numberLabel.mas_bottom);
        make.bottom.equalTo(weakSelf.boxView);
    }];
    
    [self.noDataView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.top.centerX.bottom.equalTo(weakSelf.tableView);
    }];
    
    [self.addWalletBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.noDataView);
        make.height.offset(AUTOLAYOUTSIZE(47));
        make.centerY.equalTo(weakSelf.noDataView).offset(- AUTOLAYOUTSIZE(30));
        make.width.equalTo(weakSelf.noDataView).offset(- AUTOLAYOUTSIZE(120));
    }];
    
    [self.tipNoWalletLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.addWalletBtn.mas_top).offset(- AUTOLAYOUTSIZE(16));
        make.centerX.equalTo(weakSelf.noDataView);
    }];
    
    self.noDataView.hidden = YES;
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHWalletLookPromptViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHWalletLookPromptViewTableViewCellIdentifier forIndexPath:indexPath];
    cell.tokenName = self.tokenName;
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self respondsToQuitButton];
    self.selectedBlock(self.dataSource[indexPath.row]);
}

#pragma mark ------ Event Responds ------
/**
 退出
 */
- (void)respondsToQuitButton {
    WEAKSELF
    [self.boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf);
        make.height.offset(AUTOLAYOUTSIZE(373.5));
        make.centerX.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf).offset(AUTOLAYOUTSIZE(373.5));
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

/**
 添加/导入钱包
 */
- (void)respondsAddWalletBtn {
    [self respondsToQuitButton];
    self.addWalletBlock();
}

- (void)addOrImportWalletBlock:(AddOrImportWalletBlock)block {
    self.addWalletBlock = block;
}

#pragma mark ------ Public Methods ------
/**
 动画显示
 */
- (void)animationShow {
    WEAKSELF
    [self.boxView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf);
        make.height.offset(AUTOLAYOUTSIZE(373.5));
        make.centerX.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf).offset(0);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf layoutIfNeeded];
    }];
}
- (void)selectedBlock:(SelectedWalletBlock)selectedBlock {
    self.selectedBlock = selectedBlock;
}


#pragma mark ------ Private Methods ------
/**
 排序
 */
- (void)sortData {
    for (NSInteger i = 0; i < self.dataSource.count; i++) {
        DBHWalletManagerForNeoModelList *model = self.dataSource[i];
        if (model.tokenStatistics[self.tokenName] == nil && ![self.tokenName isEqualToString:@"NEO"] && ![self.tokenName isEqualToString:@"NEO"] && ![self.tokenName isEqualToString:@"ETH"]) {
            [self.dataSource removeObjectAtIndex:i];
            i--;
        }
    }
    
    if (self.dataSource.count < 2) {
        [self.tableView reloadData];
        
        return;
    }
    
    for (NSInteger i = 0; i < self.dataSource.count - 1; i++) {
        for (NSInteger j = 0; j < self.dataSource.count - i - 1; j++) {
            DBHWalletManagerForNeoModelList *currentModel = self.dataSource[j];
            DBHWalletManagerForNeoModelList *nextModel = self.dataSource[j + 1];
            NSString *currentBalance = currentModel.tokenStatistics[self.tokenName];
            NSString *nextBalance = nextModel.tokenStatistics[self.tokenName];
            if (currentBalance.doubleValue < nextBalance.doubleValue) {
                [self.dataSource exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
            }
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark ------ Getters And Setters ------
- (UIView *)boxView {
    if (!_boxView) {
        _boxView = [[UIView alloc] init];
        _boxView.backgroundColor = WHITE_COLOR;
    }
    return _boxView;
}
- (UIButton *)quitButton {
    if (!_quitButton) {
        _quitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_quitButton setImage:[UIImage imageNamed:@"login_close"] forState:UIControlStateNormal];
        [_quitButton addTarget:self action:@selector(respondsToQuitButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _quitButton;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = BOLDFONT(18);
        _titleLabel.text = DBHGetStringWithKeyFromTable(@"Wallet List ", nil);
        _titleLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _titleLabel;
}
- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.font = BOLDFONT(10);
        _numberLabel.text = DBHGetStringWithKeyFromTable(@"Amount Available", nil);
        _numberLabel.textColor = COLORFROM16(0xC1BEBE, 1);
    }
    return _numberLabel;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = WHITE_COLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.rowHeight = AUTOLAYOUTSIZE(60);
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHWalletLookPromptViewTableViewCell class] forCellReuseIdentifier:kDBHWalletLookPromptViewTableViewCellIdentifier];
    }
    return _tableView;
}

- (UIView *)noDataView {
    if (!_noDataView) {
        _noDataView = [[UIView alloc] init];
        _noDataView.backgroundColor = WHITE_COLOR;
    }
    return _noDataView;
}

- (UIButton *)addWalletBtn {
    if (!_addWalletBtn) {
        _addWalletBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addWalletBtn.layer.cornerRadius = AUTOLAYOUTSIZE(5);
        [_addWalletBtn setBackgroundColor:MAIN_ORANGE_COLOR];
        [_addWalletBtn setTitle:DBHGetStringWithKeyFromTable(@"Add / Import wallet", nil) forState:UIControlStateNormal];
        [_addWalletBtn addTarget:self action:@selector(respondsAddWalletBtn) forControlEvents:UIControlEventTouchUpInside];
        [_addWalletBtn setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
        _addWalletBtn.titleLabel.font = FONT(14);
    }
    return _addWalletBtn;
}

- (UILabel *)tipNoWalletLabel {
    if (!_tipNoWalletLabel) {
        _tipNoWalletLabel = [[UILabel alloc] init];
        _tipNoWalletLabel.numberOfLines = 0;
        _tipNoWalletLabel.text = DBHGetStringWithKeyFromTable(@"You don't have a wallet yet.", nil);
        _tipNoWalletLabel.textColor = COLORFROM16(0xC1BEBE, 1);
        _tipNoWalletLabel.font = FONT(12);
    }
    return _tipNoWalletLabel;
}

- (UILabel *)avaliableLabel {
    if (!_avaliableLabel) {
        _avaliableLabel = [[UILabel alloc] init];
        _avaliableLabel.text = DBHGetStringWithKeyFromTable(@"Wallet List", nil);
        _avaliableLabel.textColor = COLORFROM16(0xC1BEBE, 1);
        _avaliableLabel.font = BOLDFONT(10);
    }
    return _avaliableLabel;
}
@end
