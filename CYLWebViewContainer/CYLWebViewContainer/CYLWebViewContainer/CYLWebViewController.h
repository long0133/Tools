//
//  CYLWebViewController.h
//  CYLWebViewContainer
//
//  Created by chinapex on 2018/4/12.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <UIKit/UIKit.h>

#warning 缓存html时 需要再AFNetwork 的AFHTTPResponseSerializer类里修改 self.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
@interface CYLWebViewController : UIViewController
@property (nonatomic, strong) NSURLRequest *request;

+(instancetype) sharedInstance;
@end
