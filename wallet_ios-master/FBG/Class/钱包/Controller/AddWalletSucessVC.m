//
//  AddWalletSucessVC.m
//  FBG
//
//  Created by mac on 2017/7/26.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "AddWalletSucessVC.h"

#import "DBHWalletDetailViewController.h"
#import "DBHWalletDetailWithETHViewController.h"

#import "DBHWalletManagerForNeoModelList.h"
#import "PackupsWordsVC.h"
#import "WalletLeftListModel.h"

@interface AddWalletSucessVC ()

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *sucessLB;
@property (weak, nonatomic) IBOutlet UILabel *infoLB;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UIButton *enterWalletBtn;

@end

@implementation AddWalletSucessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = DBHGetStringWithKeyFromTable(@"Add Wallet", nil);
    
//    if ([self.model.category_name isEqualToString:@"ETH"])
//    {
//        //ETH
//        self.headImage.image = [UIImage imageNamed:@"ETH_pic_sucess"];
//    }
//    else if ([self.model.category_name isEqualToString:@"BTC"])
//    {
//        //BTC
//        self.headImage.image = [UIImage imageNamed:@"BTC_pic_sucess"];
//    }
    self.sucessLB.text = DBHGetStringWithKeyFromTable(@"Add Success", nil);
    self.infoLB.text = DBHGetStringWithKeyFromTable(@"Please enter the wallet and back up your security code and Key Store to protect your wallet. Once the security code is backed up, it will disappear on the app. You need to keep it in mind. Otherwise, the wallet cannot be retrieved.", nil);
    [self.sureButton setTitle:DBHGetStringWithKeyFromTable(@"Start Backup Mnemonics", nil) forState:UIControlStateNormal];
    
   UIImageView *tipImageView = (UIImageView *)[self.view viewWithTag:998];
    tipImageView.image =  [UIImage imageNamed:(self.neoWalletModel.categoryId == 1) ? @"add_wallet_success_eth" : @"add_wallet_success_neo"];
    
    UILabel *tipLabel1 = [self.view viewWithTag:999];
    tipLabel1.text = DBHGetStringWithKeyFromTable(@"Add Success", nil);
    
    [self.enterWalletBtn setTitle:DBHGetStringWithKeyFromTable(@"Don't Back up, Enter wallet", nil) forState:UIControlStateNormal];
}

- (IBAction)enterWalletBtnClicked:(UIButton *)sender {
    NSInteger count = self.navigationController.viewControllers.count;
    if (self.neoWalletModel.categoryId == 1) {
        DBHWalletDetailWithETHViewController *walletDetailWithETHViewController = [[DBHWalletDetailWithETHViewController alloc] init];
        walletDetailWithETHViewController.ethWalletModel = self.neoWalletModel;
        walletDetailWithETHViewController.backIndex = (count == 4) ? 2 : 1;
        [self.navigationController pushViewController:walletDetailWithETHViewController animated:YES];
    } else {
        DBHWalletDetailViewController *walletDetailViewController = [[DBHWalletDetailViewController alloc] init];
        walletDetailViewController.neoWalletModel = self.neoWalletModel;
        walletDetailViewController.backIndex = (count == 4) ? 2 : 1;
        [self.navigationController pushViewController:walletDetailViewController animated:YES];
    }
}


- (IBAction)sureButtonCilick:(id)sender
{
    
    //我记好了，下一步
    PackupsWordsVC * vc = [[PackupsWordsVC alloc] init];
    vc.mnemonic = self.mnemonic;
    
    WalletLeftListModel *model = [[WalletLeftListModel alloc] init];
    model.id = self.neoWalletModel.listIdentifier;
    model.category_id = self.neoWalletModel.categoryId;
    model.name = self.neoWalletModel.name;
    model.address = self.neoWalletModel.address;
    model.created_at = self.neoWalletModel.createdAt;
    vc.model = model;
    
    [self.navigationController pushViewController:vc animated:YES];
//    //完成创建跳转回钱包详情
//    [self.navigationController popToRootViewControllerAnimated:NO];
//    //发送消息
//    [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"AddWalletSucessPushWalletInfoNotification" object:self.model userInfo:nil]];
}


@end
