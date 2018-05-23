//
//  DBHSearchTypeView.h
//  FBG
//
//  Created by 邓毕华 on 2018/2/11.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedTypeBlock)(NSInteger type);

@interface DBHSearchTypeView : UIView

- (void)selectedTypeBlock:(SelectedTypeBlock)selectedTypeBlock;

@end
