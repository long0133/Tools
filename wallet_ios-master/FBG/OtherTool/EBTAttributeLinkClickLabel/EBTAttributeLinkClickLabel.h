//
//  EBTAttributeLinkClickLabel.h
//  EBTCustomAttributeLabel
//
//  Created by MJ on 2017/3/13.
//  Copyright © 2017年 com.csst.www. All rights reserved.
//

#import "TTTAttributedLabel/TTTAttributedLabel.h"


typedef void(^EBTAttributeLinkClickLabelCompleteHandler)(NSInteger linkedURLTag);

@interface EBTAttributeLinkClickLabel : TTTAttributedLabel
/**
 *  字符串设置下划线并实现添加点击事件
 * @param textString  字符串
 * @param attributeDictionary  字符串下划线富文本字体样式
 * @param activeDictionary  点击下划线字体后的样式
 * @param linkCompleteHandler  block回调
 * @param underLineString  要设置下划线关键字符串
 */

- (void)attributeLinkLabelText:(NSString *)textString
            withLinksAttribute:(NSDictionary *)attributeDictionary withActiveLinkAttributes:(NSDictionary *)activeDictionary withLinkClickCompleteHandler:(EBTAttributeLinkClickLabelCompleteHandler)linkCompleteHandler withUnderLineTextString:(NSString *)underLineString,...;


@end
