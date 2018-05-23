//
//  DBHInputMenuButton.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/26.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBHInputMenuButton : UIButton

/**
 标题值
 */
@property (nonatomic, copy) NSString *value;

/**
 是否有更多
 */
@property (nonatomic, assign) BOOL isMore;

@end
