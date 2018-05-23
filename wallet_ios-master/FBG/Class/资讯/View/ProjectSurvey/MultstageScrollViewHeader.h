//
//  MultstageScrollViewHeader.h
//  YBMultistageScrollView
//
//  Created by cqdingwei@163.com on 2017/5/27.
//  Copyright © 2017年 yangbo. All rights reserved.
//

#ifndef MultstageScrollViewHeader_h
#define MultstageScrollViewHeader_h

#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS
#import <Masonry/Masonry.h>

#define SURVEY_SECTION0_HEIGHT  160
#define SURVEY_DEFAULT_Y 1
#define SURVEY_HEADER_HEIGHT 46
#define SURVEY_SECTION1_HEIGHT(total, header, y) (total - header - y)

#define WEAK_SELF __weak __typeof(self) weakSelf = self;

//tableview偏移类型
typedef NS_ENUM(NSInteger, OffsetType) {
    OffsetTypeMin,
    OffsetTypeCenter,
    OffsetTypeMax,
};

#endif /* MultstageScrollViewHeader_h */
