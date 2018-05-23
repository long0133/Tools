//
//  EBTAttributeLinkClickLabel.m
//  EBTCustomAttributeLabel
//
//  Created by MJ on 2017/3/13.
//  Copyright © 2017年 com.csst.www. All rights reserved.
//

#import "EBTAttributeLinkClickLabel.h"
#define kLinkBaseTag 100

@interface EBTAttributeLinkClickLabel ()<TTTAttributedLabelDelegate>
{
    EBTAttributeLinkClickLabelCompleteHandler mylinkCompleteHander;

}
@property(nonatomic,strong) NSMutableArray *array_underlineString;

@end
@implementation EBTAttributeLinkClickLabel

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        self.delegate = self;
    }
    return self;

}

- (void)awakeFromNib{

    [super awakeFromNib];
    self.delegate = self;
    

}

- (NSMutableArray *)array_underlineString{

    if (!_array_underlineString) {
        
        _array_underlineString = [NSMutableArray array];
    }
    return _array_underlineString;
    
}

- (void)attributeLinkLabelText:(NSString *)textString withLinksAttribute:(NSDictionary *)attributeDictionary withActiveLinkAttributes:(NSDictionary *)activeDictionary withLinkClickCompleteHandler:(EBTAttributeLinkClickLabelCompleteHandler)linkCompleteHandler withUnderLineTextString:(NSString *)underLineString, ...{

    mylinkCompleteHander = [linkCompleteHandler copy];
    
    self.linkAttributes = attributeDictionary ? attributeDictionary : @{
                                        NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),
                                        NSForegroundColorAttributeName:[UIColor colorWithHexString:@"333333"]
                                        };
    
    
    self.activeLinkAttributes = activeDictionary?:@{
                                                    (NSString *)kCTForegroundColorAttributeName:
                                                        (__bridge id)[[UIColor clearColor] CGColor]
                                                    };
    [self.array_underlineString removeAllObjects];
    
    va_list argument_String;
    va_start(argument_String, underLineString);
    for (NSString *keyString=underLineString; keyString!=nil; keyString=va_arg(argument_String, NSString *)) {
        
        [self.array_underlineString addObject:keyString];
    }
    va_end(argument_String);
    
    if (self.array_underlineString) {
        
        __weak typeof(self)weakSelf = self;
        
        [self setText:textString afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            
            __strong typeof(self)strongSelf = weakSelf;

            [strongSelf.array_underlineString enumerateObjectsUsingBlock:^(id   obj, NSUInteger idx, BOOL *  stop) {
                
                NSRange stringRange = [[mutableAttributedString string] rangeOfString:obj options:NSCaseInsensitiveSearch];
                
                [mutableAttributedString addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"%ld",idx+kLinkBaseTag] range:stringRange];
                

                
            }];
            
            return mutableAttributedString;
        }];

    }
    
    
    
    
    
    
    
}

#pragma mark -TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url{
    if (mylinkCompleteHander) {
        mylinkCompleteHander([url.absoluteString integerValue]?:0);
    }
}
@end
