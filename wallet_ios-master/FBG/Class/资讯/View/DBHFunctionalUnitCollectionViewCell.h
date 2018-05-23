//
//  DBHFunctionalUnitCollectionViewCell.h
//  FBG
//
//  Created by 邓毕华 on 2018/2/10.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBHFunctionalUnitCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) NSInteger noReadMsgCount; // 未读消息数
/**
 标题
 */
@property (nonatomic, copy) NSString *title;

@end
