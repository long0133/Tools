//
//  DBHProjectCommentCategoryModel.h
//  FBG
//
//  Created by yy on 2018/4/4.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBHProjectCommentCategoryModel : NSObject

@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *long_name;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *cover_img;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *website;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, copy) NSString *ico_price;
@property (nonatomic, copy) NSString *token_holder;
@property (nonatomic, copy) NSString *room_id;
@property (nonatomic, assign) BOOL is_hot;
@property (nonatomic, assign) BOOL is_top;
@property (nonatomic, assign) BOOL is_scroll;
@property (nonatomic, assign) NSInteger search_rate;
@property (nonatomic, assign) NSInteger click_rate;
@property (nonatomic, copy) NSString *type_name;
@property (nonatomic, copy) NSString *industry;

@end
