//
//  YsLabel.m
//  UnicomCM
//
//  Created by yanghandsome on 2016/10/20.
//  Copyright © 2016年 zjmk. All rights reserved.
//

#import "YsLabel.h"

@interface YsLabel()

@property (nonatomic,strong) UIPasteboard *pasteBoard;
@property(nonatomic,assign)NSRange movieStringRange;//当前选中的字符索引
@property(nonatomic,strong)NSMutableArray *ranges;//所有链接文本的位置数组

@end

@implementation YsLabel

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    NSLog(@"%s", __func__);
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.numberOfLines = 0;
        self.pasteBoard = [UIPasteboard generalPasteboard];
        [self attachTapHandle];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.numberOfLines = 0;
        self.pasteBoard = [UIPasteboard generalPasteboard];
        [self attachTapHandle];
    }
    return self;
}

- (void)attachTapHandle{
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *tap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tap];
}

- (void)handleTap:(UILongPressGestureRecognizer *)tap{
    [self becomeFirstResponder]; //UILabel默认是不能响应事件的，所以要让它成为第一响应者
    
    //系统自带
    //    UIMenuController *menuVC = [UIMenuController sharedMenuController];
    //    [menuVC setTargetRect:self.frame inView:self.superview]; //定位Menu
    //    [menuVC setMenuVisible:YES animated:YES]; //展示Menu
    
    //自定义
    UIMenuItem *copyMenuItem = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(copyAction:)];
    UIMenuItem *pasteMenueItem = [[UIMenuItem alloc]initWithTitle:@"粘贴" action:@selector(pasteAction:)];
    //    UIMenuItem *cutMenuItem = [[UIMenuItem alloc]initWithTitle:@"剪切" action:@selector(cutAction:)];
    UIMenuItem *selectAllItem = [[UIMenuItem alloc]initWithTitle:@"全选" action:@selector(selectAllAction:)];
    
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    [menuController setMenuItems:[NSArray arrayWithObjects:copyMenuItem, pasteMenueItem,selectAllItem, nil,nil]];
    [menuController setTargetRect:self.frame inView:self.superview];
    [menuController setMenuVisible:YES animated: YES];
}

- (BOOL)canBecomeFirstResponder { //指定UICopyLabel可以成为第一响应者
    return YES;
}

/*
 - (BOOL)canPerformAction:(SEL)action withSender:(id)sender { //指定该UICopyLabel可以响应的方法
 if (action == @selector(copy:)) {
 return YES;
 }
 if (action == @selector(paste:)) {
 return YES;
 }
 if (action == @selector(delete:)) {
 return YES;
 }
 if (action == @selector(selectAll:)) {
 return YES;
 }
 if (action == @selector(cut:)) {
 return YES;
 }
 return NO;
 }
 */

//自定义菜单
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(copyAction:)) {
        return YES;
    }
    if (action == @selector(pasteAction:)) {
        return YES;
    }
    if (action == @selector(selectAllAction:)) {
        return YES;
    }
    //    if (action == @selector(cutAction:)) {
    //        return YES;
    //    }
    return NO; //隐藏系统默认的菜单项
}

- (void)paste:(id)sender {
    self.text = self.pasteBoard.string;
    NSLog(@"粘贴的内容%@", self.pasteBoard.string);
    self.backgroundColor = self.pasteBoard.color;
    
}

- (void)copy:(id)sender {
    self.pasteBoard.string = self.text;
    NSLog(@"复制");
    self.pasteBoard.color = self.backgroundColor;
}

- (void)cut:(id)sender {
    self.pasteBoard.string = self.text;
    self.text = @"";
    NSLog(@"剪切");
}

- (void)delete:(id)sender {
    self.text = nil;
    self.pasteBoard = nil;
}

- (void)selectAll:(id)sender {
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    pasteBoard.string = self.text;
    self.textColor = [UIColor blueColor];
    NSLog(@"全选的数据%@", pasteBoard.string);
}

#pragma mark Method UIMenuController
//复制
- (void)copyAction:(id)sender {
    self.pasteBoard.string = self.text;
    NSLog(@"粘贴的内容为%@", self.pasteBoard.string);
}
//粘贴
- (void)pasteAction:(id)sender {
    self.text = self.pasteBoard.string;
}
//剪切
- (void)cutAction:(id)sender {
    self.pasteBoard.string = self.text;
    self.text = nil;
}
//全选
- (void)selectAllAction:(id)sender{
    self.pasteBoard.string = self.text;
    NSLog(@"全选的数据%@", self.pasteBoard.string);
}

@end
