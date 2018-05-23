//
//  DBHAddressBookMenuView.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/23.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHAddressBookMenuView.h"

#import "DBHAddressBookMenuTableViewCell.h"

#define CELL_HEIGHT 44.0f

static NSString *const kDBHAddressBookMenuTableViewCellIdentifier = @"kDBHAddressBookMenuTableViewCellIdentifier";

@interface DBHAddressBookMenuView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIImageView *boxImageView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) SelectedBlock selectedBlock;

@end

@implementation DBHAddressBookMenuView

#pragma mark ------ Lifecycle ------
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = COLORFROM16(0x000000, 0.4);
        self.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
        
        [self setUI];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    if (![touch.view isEqual:self.tableView]) {
        [self respondsToQuitButton];
    }
}

#pragma mark ------ UI ------
- (void)setUI {
    [self addSubview:self.boxImageView];
    [self addSubview:self.tableView];
    
    WEAKSELF
    [self.boxImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(0);
        make.height.offset(0);
        make.top.offset(STATUS_HEIGHT + 44);
        make.right.offset(- AUTOLAYOUTSIZE(15.5));
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.boxImageView);
        make.height.equalTo(weakSelf.boxImageView).offset(- AUTOLAYOUTSIZE(5));
        make.centerX.bottom.equalTo(weakSelf.boxImageView);
    }];
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHAddressBookMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHAddressBookMenuTableViewCellIdentifier forIndexPath:indexPath];
    cell.title = self.dataSource[indexPath.row];
    
    return cell;
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self respondsToQuitButton];
    self.selectedBlock(indexPath.row);
}

#pragma mark ------ Event Responds ------
/**
 退出
 */
- (void)respondsToQuitButton {
    WEAKSELF
    [self.boxImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(0);
        make.height.offset(0);
        make.top.offset(STATUS_HEIGHT + 44);
        make.right.offset(- AUTOLAYOUTSIZE(15.5));
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark ------ Public Methods ------
/**
 动画显示
 */
- (void)animationShow {
    WEAKSELF
    [self.boxImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(95));
        make.height.offset(AUTOLAYOUTSIZE(CELL_HEIGHT) * weakSelf.dataSource.count + AUTOLAYOUTSIZE(5));
        make.top.offset(STATUS_HEIGHT + 44);
        make.right.offset(- AUTOLAYOUTSIZE(15.5));
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf layoutIfNeeded];
    }];
}
- (void)selectedBlock:(SelectedBlock)selectedBlock {
    self.selectedBlock = selectedBlock;
}

#pragma mark ------ Getters And Setters ------

- (UIImageView *)boxImageView {
    if (!_boxImageView) {
        UIImage *image = [UIImage imageNamed:@"Group7"];
        _boxImageView = [[UIImageView alloc] initWithImage:image];
    }
    return _boxImageView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.rowHeight = AUTOLAYOUTSIZE(CELL_HEIGHT);
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHAddressBookMenuTableViewCell class] forCellReuseIdentifier:kDBHAddressBookMenuTableViewCellIdentifier];
    }
    return _tableView;
}

@end
