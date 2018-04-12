//
//  CYLWebView.m
//  CYLWebViewContainer
//
//  Created by chinapex on 2018/4/12.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "CYLWebView.h"

@implementation CYLWebView
- (instancetype)init{
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}

#pragma mark - public
- (WKNavigation*)loadHtml:(NSURLRequest*)request{
    return [self loadRequest:request];
}

#pragma mark - private
- (void)initUI{
    
}

@end
