//
//  ChoseCell.h
//  FBG
//
//  Created by 贾仕海 on 2017/8/16.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletLeftListModel.h"

@interface ChoseCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;

@property (nonatomic, strong) WalletLeftListModel * model;

@end
