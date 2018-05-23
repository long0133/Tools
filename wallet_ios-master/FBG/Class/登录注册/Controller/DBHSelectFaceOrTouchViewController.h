//
//  DBHSelectFaceOrTouchViewController.h
//  FBG
//
//  Created by 邓毕华 on 2018/2/8.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseViewController.h"

typedef enum : NSUInteger {
    DBHTouchViewControllerType,
    DBHFaceViewControllerType
} DBHSelectFaceOrTouchViewControllerType;

@interface DBHSelectFaceOrTouchViewController : DBHBaseViewController

@property (nonatomic, assign) DBHSelectFaceOrTouchViewControllerType faceOrTouchViewControllerType;
@property (nonatomic, strong) id target;

@end
