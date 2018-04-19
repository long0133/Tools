//
//  ZJNWebHandle.h
//  ZhujianniaoUser2.0
//
//  Created by 迟钰林 on 2017/8/1.
//  Copyright © 2017年 迟钰林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

typedef void(^handle)(WKUserContentController *userContentController, WKScriptMessage *message);

@interface CYLWebHandle : NSObject
@property (nonatomic, copy) handle msgHandle;

+ (instancetype)creatHandlerWithHandle:(handle)handler;
@end
