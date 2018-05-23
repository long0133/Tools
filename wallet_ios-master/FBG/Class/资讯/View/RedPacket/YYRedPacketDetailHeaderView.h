//
//  YYRedPacketDetailHeaderView.h
//  FBG
//
//  Created by yy on 2018/4/27.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DETAIL_HEADERVIEW_HEIGHT 37

@interface YYRedPacketDetailHeaderView : UIView

@property (nonatomic, copy) NSString *headerTitle;
@property (nonatomic, strong) YYRedPacketDetailModel *model;
@property (nonatomic, assign) BOOL showTotal; // 是否显示合计

@end
