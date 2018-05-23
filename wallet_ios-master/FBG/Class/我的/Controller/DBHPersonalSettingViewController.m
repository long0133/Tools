//
//  DBHPersonalSettingViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/23.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHPersonalSettingViewController.h"

#import <AliyunOSSiOS/OSSService.h>

#import "TZImagePickerController.h"

#import "DBHSetNicknameViewController.h"
#import "DBHChangePasswordViewController.h"
#import "ZFTabBarViewController.h"

#import "DBHPersonalSettingForHeadTableViewCell.h"
#import "DBHPersonalSettingForTitleTableViewCell.h"
#import "DBHPersonalSettingForSwitchTableViewCell.h"

static NSString *const kDBHPersonalSettingForHeadTableViewCellIdentifier = @"kDBHPersonalSettingForHeadTableViewCellIdentifier";
static NSString *const kDBHPersonalSettingForTitleTableViewCellIdentifier = @"kDBHPersonalSettingForTitleTableViewCellIdentifier";
static NSString *const kDBHPersonalSettingForSwitchTableViewCellIdentifier = @"kDBHPersonalSettingForSwitchTableViewCellIdentifier";

@interface DBHPersonalSettingViewController ()<UITableViewDataSource, UITableViewDelegate, TZImagePickerControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *quitLoginButton;

@property (nonatomic, copy) NSArray *titleArray;

@end

@implementation DBHPersonalSettingViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = DBHGetStringWithKeyFromTable(@"Personal Setting", nil);
    self.view.backgroundColor = LIGHT_WHITE_BGCOLOR;
    
    [self setUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.quitLoginButton];
    
    WEAKSELF
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.quitLoginButton.mas_top);
    }];
    [self.quitLoginButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view).offset(- AUTOLAYOUTSIZE(108));
        make.height.offset(AUTOLAYOUTSIZE(40.5));
        make.centerX.equalTo(weakSelf.view);
        make.bottom.offset(- AUTOLAYOUTSIZE(47.5));
    }];
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return !section ? 3 : 2 + ([UserSignData share].user.canUseUnlockType == DBHCanUseUnlockTypeNone ? - 1 : 0);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section && !indexPath.row) {
        DBHPersonalSettingForHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHPersonalSettingForHeadTableViewCellIdentifier forIndexPath:indexPath];
        [cell.headImageView sdsetImageWithURL:[UserSignData share].user.img placeholderImage:[UIImage imageNamed:@"touxiang"]];
        
        return cell;
    } else if (!indexPath.section || (indexPath.section && !indexPath.row)) {
        DBHPersonalSettingForTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHPersonalSettingForTitleTableViewCellIdentifier forIndexPath:indexPath];
        cell.title = DBHGetStringWithKeyFromTable(self.titleArray[indexPath.section][indexPath.row], nil);
        if (!indexPath.section) {
            cell.value = indexPath.row == 1 ? [UserSignData share].user.nickname : [UserSignData share].user.email;
        }
        
        return cell;
    } else {
        DBHPersonalSettingForSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHPersonalSettingForSwitchTableViewCellIdentifier forIndexPath:indexPath];
        cell.title = [UserSignData share].user.canUseUnlockType == DBHCanUseUnlockTypeTouchID ? @"Touch ID" : @"Face ID";
        cell.functionalUnitType = -1;
        cell.isStick = [UserSignData share].user.canUseUnlockType == DBHCanUseUnlockTypeTouchID ? [UserSignData share].user.isOpenTouchId : [UserSignData share].user.isOpenFaceId;
        
        [cell changeSwitchBlock:^(BOOL isOpen) {
            if ([UserSignData share].user.canUseUnlockType == DBHCanUseUnlockTypeTouchID) {
                [UserSignData share].user.isOpenTouchId = isOpen;
            } else {
                [UserSignData share].user.isOpenFaceId = isOpen;
            }
            [[UserSignData share] storageData:[UserSignData share].user];
        }];
        
        return cell;
    }
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        switch (indexPath.row) {
            case 0: {
                // 头像
                TZImagePickerController *imagePickerController = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
                [self presentViewController:imagePickerController animated:YES completion:nil];
                break;
            }
            case 1: {
                // 昵称
                DBHSetNicknameViewController *setNicknameViewController = [[DBHSetNicknameViewController alloc] init];
                [self.navigationController pushViewController:setNicknameViewController animated:YES];
                break;
            }
                
            default:
                break;
        }
    } else if (!indexPath.row) {
        // 修改密码
        DBHChangePasswordViewController *changePasswordViewController = [[DBHChangePasswordViewController alloc] init];
        [self.navigationController pushViewController:changePasswordViewController animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return !indexPath.section && !indexPath.row ? AUTOLAYOUTSIZE(103.5) : AUTOLAYOUTSIZE(51);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return AUTOLAYOUTSIZE(11.5);
}

#pragma mark ------ TZImagePickerControllerDelegate ------
/**
 选择照片回调
 */
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    //获取到图片
    NSString *endpoint = @"http://oss-cn-shanghai.aliyuncs.com";
    
    WEAKSELF
    id<OSSCredentialProvider> credential2 = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken *
                                             {
                                                 // 构造请求访问您的业务server
                                                 NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@sts",APP_APIEHEAD]];
                                                 NSURLRequest * request = [NSURLRequest requestWithURL:url];
                                                 NSMutableURLRequest *mutableRequest = [request mutableCopy];    //拷贝request
                                                 [mutableRequest addValue:[UserSignData share].user.token forHTTPHeaderField:@"Authorization"];
                                                 request = [mutableRequest copy];
                                                 OSSTaskCompletionSource * tcs = [OSSTaskCompletionSource taskCompletionSource];
                                                 NSURLSession * session = [NSURLSession sharedSession];
                                                 // 发送请求
                                                 NSURLSessionTask * sessionTask = [session dataTaskWithRequest:request
                                                                                             completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                                                                   {
                                                                                       if (error)
                                                                                       {
                                                                                           [tcs setError:error];
                                                                                           return;
                                                                                       }
                                                                                       [tcs setResult:data];
                                                                                   }];
                                                 [sessionTask resume];
                                                 // 需要阻塞等待请求返回
                                                 [tcs.task waitUntilFinished];
                                                 // 解析结果
                                                 if (tcs.task.error)
                                                 {
                                                     return nil;
                                                 } else
                                                 {
                                                     // 返回数据是json格式，需要解析得到token的各个字段
                                                     NSDictionary * object = [NSJSONSerialization JSONObjectWithData:tcs.task.result
                                                                                                             options:kNilOptions
                                                                                                               error:nil];
                                                     NSDictionary * dic = [[object objectForKey:@"data"] objectForKey:@"Credentials"];
                                                     OSSFederationToken * token = [OSSFederationToken new];
                                                     token.tAccessKey = [dic objectForKey:@"AccessKeyId"];
                                                     token.tSecretKey = [dic objectForKey:@"AccessKeySecret"];
                                                     token.tToken = [dic objectForKey:@"SecurityToken"];
                                                     token.expirationTimeInGMTFormat = [dic objectForKey:@"Expiration"];
                                                     NSLog(@"get token: %@", token);
                                                     return token;
                                                 }
                                             }];
    
    OSSClient *client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential2];
    
    // 上传后通知回调
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    OSSPutObjectRequest * request = [OSSPutObjectRequest new];
    request.bucketName = @"inwecrypto-china";
    request.objectKey = [NSString stringWithFormat:@"ios_header_%@.jpeg",timeString];
    request.uploadingData = UIImageJPEGRepresentation(photos.firstObject, 0.5); // 直接上传NSData
    
    request.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    OSSTask * task = [client putObject:request];
    [task continueWithBlock:^id(OSSTask *task) {
        if (task.error) {
            OSSLogError(@"%@", task.error);
        } else {
            OSSPutObjectResult * result = task.result;
            NSLog(@"Result - requestId: %@, headerFields: %@, servercallback: %@",
                  result.requestId,
                  result.httpResponseHeaderFields,
                  result.serverReturnJsonString);
            
            // sign public url
            NSString * publicURL = nil;
            OSSTask * task1 = [client presignPublicURLWithBucketName:request.bucketName
                                                       withObjectKey:[NSString stringWithFormat:@"ios_header_%@.jpeg",timeString]];
            
            if (!task1.error)
            {
                publicURL = task1.result;
                
                dispatch_queue_t mainQueue = dispatch_get_main_queue();
                //异步返回主线程，根据获取的数据，更新UI
                dispatch_async(mainQueue, ^
                               {
                                   [weakSelf uploadHeadImageWithHeadImageUrl:publicURL];
                               });
            }
            else
            {
                NSLog(@"sign url error: %@", task.error);
            }
        }
        return nil;
    }];
}

#pragma mark ------ Data ------
/**
 上传头像
 */
- (void)uploadHeadImageWithHeadImageUrl:(NSString *)headImageUrl {
    NSDictionary *paramters = @{@"img":headImageUrl,
                                NAME:[UserSignData share].user.nickname};
    WEAKSELF
    [PPNetworkHelper PUT:@"user" baseUrlType:3 parameters:paramters hudString:[NSString stringWithFormat:@"%@...", DBHGetStringWithKeyFromTable(@"Submit", nil)] success:^(id responseObject) {
        [UserSignData share].user.img = responseObject[@"img"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [LCProgressHUD showSuccess:DBHGetStringWithKeyFromTable(@"Change Success", nil)];
            [weakSelf.tableView reloadData];
        });
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    }];
}

#pragma mark ------ Event Responds ------
/**
 退出登录
 */
- (void)respondsToQuitLoginButton {
    EMError *error = [[EMClient sharedClient] logout:YES];
    if (!error) {
        [[UserSignData share] storageData:nil];
        
        UserModel *user = [UserSignData share].user;
        // 货币单位跟随语言
        user.walletUnitType = [[DBHLanguageTool sharedInstance].language isEqualToString:CNS] ? 1 : 2;
        [[UserSignData share] storageData:user];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:IS_LOGIN_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[EMClient sharedClient].options setIsAutoLogin:NO];
//        [[AppDelegate delegate] showLoginController];
        [LCProgressHUD showSuccess:DBHGetStringWithKeyFromTable(@"Exit Success", nil)];
//        [self.navigationController popViewControllerAnimated:YES];
        
        ZFTabBarViewController * tab = [[ZFTabBarViewController alloc] init];
        UIWindow *window = [AppDelegate delegate].window;
        window.rootViewController = tab;
        [window makeKeyAndVisible];
        
    } else {
        [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"Exit Failed", nil)];
    }
}

#pragma mark ------ Getters And Setters ------
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = LIGHT_WHITE_BGCOLOR;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHPersonalSettingForHeadTableViewCell class] forCellReuseIdentifier:kDBHPersonalSettingForHeadTableViewCellIdentifier];
        [_tableView registerClass:[DBHPersonalSettingForTitleTableViewCell class] forCellReuseIdentifier:kDBHPersonalSettingForTitleTableViewCellIdentifier];
        [_tableView registerClass:[DBHPersonalSettingForSwitchTableViewCell class] forCellReuseIdentifier:kDBHPersonalSettingForSwitchTableViewCellIdentifier];
    }
    return _tableView;
}
- (UIButton *)quitLoginButton {
    if (!_quitLoginButton) {
        _quitLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _quitLoginButton.backgroundColor = MAIN_ORANGE_COLOR;
        _quitLoginButton.titleLabel.font = FONT(14);
        [_quitLoginButton setTitle:DBHGetStringWithKeyFromTable(@"Exit", nil) forState:UIControlStateNormal];
        [_quitLoginButton addTarget:self action:@selector(respondsToQuitLoginButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _quitLoginButton;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@[@"", @"Name", @"Account"], @[@"Change Password"]];
    }
    return _titleArray;
}

@end
