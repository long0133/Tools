//
//  DBHRankTitleAndDataModel.h
//  FBG
//
//  Created by yy on 2018/3/29.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBHRankTitleAndDataModel : NSObject

@property (nonatomic, strong) NSMutableArray *titlesArr;
@property (nonatomic, strong) NSMutableArray *datasArr;
@property (nonatomic, assign) CGFloat minWidth;

@end
