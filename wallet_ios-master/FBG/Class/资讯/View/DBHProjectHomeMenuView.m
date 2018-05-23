
//
//  DBHProjectHomeMenuView.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/26.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHProjectHomeMenuView.h"

#import "DBHProjectHomeMenuTableViewCell.h"

#define MENU_WIDTH(size) ((SCREENWIDTH /*- AUTOLAYOUTSIZE(43.5)*/ - AUTOLAYOUTSIZE(0.5) * size) / size)

static NSString *const kDBHProjectHomeMenuTableViewCellIdentifier = @"kDBHProjectHomeMenuTableViewCellIdentifier";

@interface DBHProjectHomeMenuView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIImageView *boxImageView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) SelectedBlock selectedBlock;

@end

@implementation DBHProjectHomeMenuView

#pragma mark ------ Lifecycle ------
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.clipsToBounds = YES;
        self.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - AUTOLAYOUTSIZE(47));
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
    [self.boxImageView addSubview:self.tableView];
    
    WEAKSELF
    [self.boxImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset((SCREENWIDTH /*- AUTOLAYOUTSIZE(43.5)*/ - AUTOLAYOUTSIZE(0.5) * 3) / self.maxLine);
        make.height.offset(AUTOLAYOUTSIZE(35) * weakSelf.dataSource.count + AUTOLAYOUTSIZE(5));
        make.left.offset(/*AUTOLAYOUTSIZE(43.5) + */AUTOLAYOUTSIZE(0.5) * self.line + (self.maxLine == 3 ? MENU_WIDTH(3) * (self.line - 1) : MENU_WIDTH(2) * (self.line - 1) + MENU_WIDTH(2) - MENU_WIDTH(3)));
        make.bottom.offset(AUTOLAYOUTSIZE(35) * weakSelf.dataSource.count + AUTOLAYOUTSIZE(5));
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.boxImageView);
        make.height.equalTo(weakSelf.boxImageView).offset(- AUTOLAYOUTSIZE(5));
        make.centerX.top.equalTo(weakSelf.boxImageView);
    }];
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHProjectHomeMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHProjectHomeMenuTableViewCellIdentifier forIndexPath:indexPath];
    cell.title = self.dataSource[indexPath.row];
    
    return cell;
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedBlock(indexPath.row);
    [self respondsToQuitButton];
}

#pragma mark ------ Event Responds ------
/**
 退出
 */
- (void)respondsToQuitButton {
    WEAKSELF
    [self.boxImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset((SCREENWIDTH/* - AUTOLAYOUTSIZE(43.5)*/ - AUTOLAYOUTSIZE(0.5) * 3) / self.maxLine);
        make.height.offset(AUTOLAYOUTSIZE(35) * weakSelf.dataSource.count + AUTOLAYOUTSIZE(5));
        make.left.offset(/*AUTOLAYOUTSIZE(43.5) + */AUTOLAYOUTSIZE(0.5) * self.line + (self.maxLine == 3 ? MENU_WIDTH(3) * (self.line - 1) : MENU_WIDTH(2) * (self.line - 1)));
        make.bottom.offset(AUTOLAYOUTSIZE(35) * weakSelf.dataSource.count + AUTOLAYOUTSIZE(5));
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf layoutIfNeeded];
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

#pragma mark ------ Public Methods ------
/**
 动画显示
 */
- (void)animationShow {
    WEAKSELF
    [self.boxImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(MENU_WIDTH(weakSelf.maxLine));
        make.height.offset(AUTOLAYOUTSIZE(35) * weakSelf.dataSource.count + AUTOLAYOUTSIZE(5));
        make.left.offset(/*AUTOLAYOUTSIZE(43.5) + */AUTOLAYOUTSIZE(0.5) * self.line + (self.maxLine == 3 ? MENU_WIDTH(3) * (self.line - 1) : MENU_WIDTH(2) * (self.line - 1)));
        make.bottom.offset(0);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf layoutIfNeeded];
    }];
}
/**
 动画隐藏
 */
- (void)animationHide {
    [self respondsToQuitButton];
}
- (void)selectedBlock:(SelectedBlock)selectedBlock {
    self.selectedBlock = selectedBlock;
}

#pragma mark ------ Getters And Setters ------
- (void)setMaxLine:(NSInteger)maxLine {
    _maxLine = maxLine;
    
    [self setUI];
}

- (UIImageView *)boxImageView {
    if (!_boxImageView) {
        _boxImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xiangmugaikuang_xialakuang"]];
        _boxImageView.clipsToBounds = YES;
        _boxImageView.userInteractionEnabled = YES;
    }
    return _boxImageView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = COLORFROM16(0xF9F9F9, 1);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.rowHeight = AUTOLAYOUTSIZE(35);
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHProjectHomeMenuTableViewCell class] forCellReuseIdentifier:kDBHProjectHomeMenuTableViewCellIdentifier];
    }
    return _tableView;
}

@end
