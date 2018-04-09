//
//  CYLRefershHeader.h
//  CYLReferesh
//
//  Created by chinapex on 2018/4/8.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "CYLRefereshBaseView.h"

static CGFloat CYLRefreshHeaderViewHeight = 60;

@interface CYLRefershHeader : CYLRefereshBaseView
@property (nonatomic, copy) dispatch_block_t headerAction;
@end
