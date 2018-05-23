//
//  DBHWebViewController.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/31.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseViewController.h"

@interface DBHWebViewController : DBHBaseViewController

/**
 是否隐藏你的观点
 */
@property (nonatomic, assign) BOOL isHiddenYourOpinion;

/**
 html字符串
 */
@property (nonatomic, copy) NSString *htmlString;

@property (nonatomic, copy) NSString *url;

@end
