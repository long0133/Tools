//
//  DBHHotInfoDataCategoryModel.h
//  FBG
//
//  Created by yy on 2018/4/3.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBHHotInfoDataCategoryModel : NSObject

@property (nonatomic, copy) NSString *img;
@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, copy) NSString *industry;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *type_name;

@end
