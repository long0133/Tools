//
//  PackupsWordsVC.m
//  FBG
//
//  Created by 贾仕海 on 2017/8/29.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "PackupsWordsVC.h"
#import "SurePackupsWordVC.h"

#import "WalletLeftListModel.h"
#define START_TAG 9990

@interface PackupsWordsVC ()

@property (weak, nonatomic) IBOutlet UITextView *mnemonicTextView;
@property (weak, nonatomic) IBOutlet UIButton *btnSure;

@end

@implementation PackupsWordsVC

#pragma mark - Lifecycle(生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = DBHGetStringWithKeyFromTable(@"Backup Mnemonic", nil);
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 16;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:self.mnemonicTextView.font,
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    self.mnemonicTextView.typingAttributes = attributes;
    
    NSString *showMnemonic = [self.mnemonic stringByReplacingOccurrencesOfString:@" " withString:@"  "];
    
    self.mnemonicTextView.text = showMnemonic;
    self.mnemonicTextView.editable = NO;
    
    [_btnSure setTitle:DBHGetStringWithKeyFromTable(@"Start Backup Mnemonics", nil) forState:UIControlStateNormal];
    [self setUI];
}

- (void)setUI {
    UILabel *label1 = [self.view viewWithTag:START_TAG];
    label1.text = DBHGetStringWithKeyFromTable(@"Need Backup", nil);
    
    UILabel *label2 = [self.view viewWithTag:START_TAG + 1];
    label2.text = DBHGetStringWithKeyFromTable(@"1. Back-up mnemonic words can help you recover quickly when you lose your wallet.", nil);
    
    UILabel *label3 = [self.view viewWithTag:START_TAG + 2];
    label3.text = DBHGetStringWithKeyFromTable(@"2. Be sure to transcribe the following mnemonic words and keep them in a safe place.", nil);
    
    UILabel *label4 = [self.view viewWithTag:START_TAG + 3];
    label4.text = DBHGetStringWithKeyFromTable(@"3. Once the backup is successful, this backup step will not appear again.", nil);

    UILabel *zjcLabel = [self.view viewWithTag:998];
    zjcLabel.text = DBHGetStringWithKeyFromTable(@"Mnemonic", nil);
}

#pragma mark - Custom Accessors (控件响应方法)


#pragma mark - IBActions(xib响应方法)

- (IBAction)sureButtonCilick:(id)sender
{
    //我记好了，下一步
    SurePackupsWordVC * vc = [[SurePackupsWordVC alloc] init];
    vc.mnemonic = self.mnemonic;
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Public (.h 公共调用方法)


#pragma mark - Private (.m 私有方法)


#pragma mark - Deletate/DataSource (相关代理)


#pragma mark - Setter/Getter





@end
