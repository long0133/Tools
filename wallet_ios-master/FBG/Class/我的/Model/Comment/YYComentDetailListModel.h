//
//  YYComentDetailListModel.h
//  FBG
//
//  Created by yy on 2018/4/8.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBHProjectCommentDetailModel.h"

@interface YYComentDetailListModel : NSObject

@property (nonatomic, copy) NSString *last_page_url;
@property (nonatomic, copy) NSString *prev_page_url;
@property (nonatomic, assign) NSInteger from;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, copy) NSString *path;

@property (nonatomic, copy) NSString *first_page_url;
@property (nonatomic, assign) NSInteger last_page;

@property (nonatomic, copy) NSString *next_page_url;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, assign) NSInteger current_page;
@property (nonatomic, assign) NSInteger per_page;
@property (nonatomic, assign) NSInteger to;



@end
