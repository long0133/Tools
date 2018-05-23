//
//  YYRedPacketChoosePayStyleView.m
//  FBG
//
//  Created by yy on 2018/4/24.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketChoosePayStyleView.h"
#import "YYChoosePayStyleTableViewCell.h"

@interface YYRedPacketChoosePayStyleView() <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *boxView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end

@implementation YYRedPacketChoosePayStyleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
        [self initUI];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
        [self initUI];
    }
    return self;
}

- (void)initUI {
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YYChoosePayStyleTableViewCell class]) bundle:nil] forCellReuseIdentifier:CHOOSE_PAY_STYLE_CELL_ID];

    self.titleLabel.text = DBHGetStringWithKeyFromTable(@"Choose Pay Style", nil);
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 58;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    if (![touch.view isEqual:self.boxView]) {
        [self respondsToExitBtn:nil];
    }
}

#pragma mark ----- Setters And Getters ---------
/**
 动画显示
 */
- (void)animationShow {
    WEAKSELF
    self.bottomConstraint.constant = 0;
    
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf layoutIfNeeded];
    }];
}

#pragma mark ----- UITableView ---------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YYChoosePayStyleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CHOOSE_PAY_STYLE_CELL_ID forIndexPath:indexPath];
    if (indexPath.row < self.dataSource.count) {
        [cell setModel:self.dataSource[indexPath.row] currentWalletID:self.currentWalletId tokenName:self.tokenName];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (row < self.dataSource.count) {
        DBHWalletManagerForNeoModelList *model = self.dataSource[row];
        if (model.listIdentifier != self.currentWalletId) {
            self.currentWalletId = model.listIdentifier;
            [tableView reloadData];
        }
        
        [self respondsToExitBtn:nil];
        if (self.block) {
            self.block(model);
        }
    }
}

#pragma mark ----- RespondsToSelector ---------
- (IBAction)respondsToExitBtn:(id)sender {
    WEAKSELF
    self.bottomConstraint.constant = -375;
    
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark ----- Setters And Getters ---------
- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    [self.tableView reloadData];
}

@end
