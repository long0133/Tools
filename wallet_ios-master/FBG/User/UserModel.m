//
//  UserModel.m
//  FBG
//
//  Created by mac on 2017/7/13.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

#pragma mark ------ Private Methods ------
- (void)saveData {
    [[UserSignData share] storageData:self];
}

#pragma mark ------ Getters And Setters ------
- (void)setWalletUnitType:(int)walletUnitType {
    _walletUnitType = walletUnitType;
    
//    [self saveData];
}
- (void)setIsOpenTouchId:(BOOL)isOpenTouchId {
    _isOpenTouchId = isOpenTouchId;
    
//    [self saveData];
}
- (void)setIsOpenFaceId:(BOOL)isOpenFaceId {
    _isOpenFaceId = isOpenFaceId;
    
//    [self saveData];
}
- (void)setCanUseUnlockType:(DBHCanUseUnlockType)canUseUnlockType {
    _canUseUnlockType = canUseUnlockType;
    
//    [self saveData];
}

- (void)setIsHideAsset:(BOOL)isHideAsset {
    _isHideAsset = isHideAsset;
}

- (void)setIsLogin:(BOOL)isLogin {
    _isLogin = isLogin;
}

- (void)setLanguage:(NSString *)language {
    _language = language;
    
//    self.walletUnitType = 2;
    if ([language isEqualToString:@"zh"]) {
        language = CNS;
//        self.walletUnitType = 1;
    }
    [[DBHLanguageTool sharedInstance] setNewLanguage:language];
}

- (NSArray *)sortedTokenFlags {
    if (!_sortedTokenFlags) {
        _sortedTokenFlags = [NSArray array];
    }
    return _sortedTokenFlags;
}

- (NSMutableArray *)functionalUnitArray {
    if (!_functionalUnitArray) {
        _functionalUnitArray = [NSMutableArray array];
        [_functionalUnitArray addObject:@"0"];
        [_functionalUnitArray addObject:@"0"];
        [_functionalUnitArray addObject:@"0"];
        [_functionalUnitArray addObject:@"0"];
        [_functionalUnitArray addObject:@"0"];
    }
    if (_functionalUnitArray.count > 5) {
        [_functionalUnitArray removeLastObject];
    }
    return _functionalUnitArray;
}
- (NSMutableArray *)realTimeDeliveryArray {
    if (!_realTimeDeliveryArray) {
        _realTimeDeliveryArray = [NSMutableArray array];
        [_realTimeDeliveryArray addObject:@"1"];
        [_realTimeDeliveryArray addObject:@"1"];
//        [_realTimeDeliveryArray addObject:@"1"];
        [_realTimeDeliveryArray addObject:@"1"];
        [_realTimeDeliveryArray addObject:@"1"];
        [_realTimeDeliveryArray addObject:@"1"];
    }
    return _realTimeDeliveryArray;
}

@end
