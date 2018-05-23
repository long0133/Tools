//
//  UserLogin.h
//  FBG
//
//  Created by yy on 2018/3/3.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserLogin : NSObject

@property (nonatomic, assign) BOOL login;

+ (void)userLogin:(NSString *)email password:(NSString *)password target:(UIViewController *)target;


@end
