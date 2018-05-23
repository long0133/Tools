//
//  DBHPersonalSettingForSwitchTableViewCell.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/23.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"

typedef void(^ChangeSwitchBlock)(BOOL isOpen);

@interface DBHPersonalSettingForSwitchTableViewCell : DBHBaseTableViewCell

/**
 功能组件类型
 */
@property (nonatomic, assign) NSInteger functionalUnitType;

/**
 标题
 */
@property (nonatomic, copy) NSString *title;

/**
 是否置顶
 */
@property (nonatomic, assign) BOOL isStick;

/**
 开关改变回调
 */
- (void)changeSwitchBlock:(ChangeSwitchBlock)changeSwitchBlock;

@end
