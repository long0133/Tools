//
//  DBHWalletLookPromptView.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/9.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBHWalletManagerForNeoModelList;

typedef void(^SelectedWalletBlock)(DBHWalletManagerForNeoModelList *model);
typedef void(^AddOrImportWalletBlock)(void);

@interface DBHWalletLookPromptView : UIView

/**
 查看的代币名称
 */
@property (nonatomic, copy) NSString *tokenName;

/**
 钱包列表
 */
@property (nonatomic, strong) NSMutableArray *dataSource;

/**
 动画显示
 */
- (void)animationShow;

/**
 选择回调
 */
- (void)selectedBlock:(SelectedWalletBlock)selectedBlock;

/**
 点击了添加/导入钱包

 @param block <#block description#>
 */
- (void)addOrImportWalletBlock:(AddOrImportWalletBlock)block;

@end
