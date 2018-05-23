//
//  PassWordView.h
//  FBG
//
//  Created by mac on 2017/7/30.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PassWordViewDelegate <NSObject>

- (void)canel;
- (void)sureWithPassWord:(NSString *)passWord;

@end

@interface PassWordView : UIView

@property (nonatomic, strong) id <PassWordViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *titleLN;
@property (weak, nonatomic) IBOutlet UILabel *infoLB;

- (void)begainFirstResponder;
- (void)clean;

@end
