//
//  DBHProjectSurveyHeaderView.h
//  FBG
//
//  Created by yy on 2018/4/5.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBHProjectDetailInformationModelData;

@interface DBHProjectSurveyHeaderView : UIView

@property (nonatomic, copy) NSMutableArray *titleStrArray;
@property (nonatomic, strong) DBHProjectDetailInformationModelData *projectDetailModel;

@end
