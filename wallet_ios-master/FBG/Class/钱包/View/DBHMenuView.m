//
//  DBHMenuView.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/8.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHMenuView.h"

#import "DBHMenuViewTableViewCell.h"

static NSString *const kDBHMenuViewTableViewCellIdentifier = @"kDBHMenuViewTableViewCellIdentifier";

@interface DBHMenuView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIImageView *boxImageView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) SelectedBlock selectedBlock;

@end

@implementation DBHMenuView

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
    DBHMenuViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHMenuViewTableViewCellIdentifier forIndexPath:indexPath];
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
    __block CGFloat width = 0;
    if (_dataSource) {
        [_dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *str = DBHGetStringWithKeyFromTable(obj, nil);
            
            NSDictionary *attributes = @{NSFontAttributeName:FONT(13)};
            CGSize textSize = [str boundingRectWithSize:CGSizeMake(200, 0) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
          
            CGFloat value = textSize.width;
            if (value > width) {
                width = value;
            }
        }];
    }
    
    WEAKSELF
    [self layoutIfNeeded];
    [self.boxImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(width + 10 * 3 + 15));
        make.height.offset(AUTOLAYOUTSIZE(44) * weakSelf.dataSource.count + AUTOLAYOUTSIZE(5));
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
- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    
    [self.tableView reloadData];
}

- (UIImageView *)boxImageView {
    if (!_boxImageView) {
        _boxImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Group7"]];
    }
    return _boxImageView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.rowHeight = AUTOLAYOUTSIZE(44);
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHMenuViewTableViewCell class] forCellReuseIdentifier:kDBHMenuViewTableViewCellIdentifier];
    }
    return _tableView;
}

@end
