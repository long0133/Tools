//
//  CYLRefreshFooter.h
//  CYLReferesh
//
//  Created by chinapex on 2018/4/9.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "CYLRefereshBaseView.h"

static CGFloat CYLRefreshFooterViewHeight = 60;

@interface CYLRefreshFooter : CYLRefereshBaseView
@property (nonatomic, copy) dispatch_block_t footerAction;
@end
