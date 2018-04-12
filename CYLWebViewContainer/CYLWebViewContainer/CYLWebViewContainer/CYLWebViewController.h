//
//  CYLWebViewController.h
//  CYLWebViewContainer
//
//  Created by chinapex on 2018/4/12.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYLWebViewController : UIViewController
@property (nonatomic, strong) NSURLRequest *request;

+(instancetype) sharedInstance;
@end
