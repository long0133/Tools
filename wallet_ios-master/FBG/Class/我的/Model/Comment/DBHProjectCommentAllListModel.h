//
//  DBHProjectCommentAllListModel.h
//  FBG
//
//  Created by yy on 2018/4/4.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBHProjectCommentAllListDetailModel.h"

@interface DBHProjectCommentAllListModel : NSObject

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, assign) NSInteger total;

@end
