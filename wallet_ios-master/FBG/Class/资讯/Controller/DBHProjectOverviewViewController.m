//
//  DBHProjectOverviewViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/27.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHProjectOverviewViewController.h"

#import "KKWebView.h"

#import "DBHInputView.h"
#import "DBHProjectHomeMenuView.h"
#import "DBHGradePromptView.h"
#import "DBHProjectOverviewForProjectInfomtaionTableViewCell.h"
#import "DBHProjectOverviewForRelevantInformationTableViewCell.h"

#import "DBHProjectDetailInformationDataModels.h"

static NSString *const kDBHProjectOverviewForProjectInfomtaionTableViewCellIdentifier = @"kDBHProjectOverviewForProjectInfomtaionTableViewCellIdentifier";
static NSString *const kDBHProjectOverviewForRelevantInformationTableViewCellIdentifier = @"kDBHProjectOverviewForRelevantInformationTableViewCellIdentifier";

@interface DBHProjectOverviewViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DBHInputView *keyboardView;
@property (nonatomic, strong) DBHProjectHomeMenuView *browserMenuView;
@property (nonatomic, strong) DBHProjectHomeMenuView *walletMenuView;
@property (nonatomic, strong) DBHGradePromptView *gradePromptView;

@end

@implementation DBHProjectOverviewViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.projectDetailModel.unit;
    self.view.backgroundColor = COLORFROM16(0xF6F6F6, 1);
    
    [self setUI];
}

#pragma mark ------ UI ------
- (void)setUI {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:DBHGetStringWithKeyFromTable(@"Rating", nil) style:UIBarButtonItemStylePlain target:self action:@selector(respondsToGradeButton)];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.keyboardView];
    
    WEAKSELF
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view).offset(AUTOLAYOUTSIZE(1));
        make.bottom.equalTo(weakSelf.keyboardView.mas_top);
    }];
    [self.keyboardView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.height.offset(AUTOLAYOUTSIZE(47));
        make.centerX.bottom.equalTo(weakSelf.view);
    }];
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.row) {
        DBHProjectOverviewForProjectInfomtaionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHProjectOverviewForProjectInfomtaionTableViewCellIdentifier forIndexPath:indexPath];
        cell.projectDetailModel = self.projectDetailModel;
        
        return cell;
    } else {
        DBHProjectOverviewForRelevantInformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHProjectOverviewForRelevantInformationTableViewCellIdentifier forIndexPath:indexPath];
        cell.projectDetailModel = self.projectDetailModel;
        
        return cell;
    }
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return !indexPath.row ? AUTOLAYOUTSIZE(159) : AUTOLAYOUTSIZE(190);
}

#pragma mark ------ Data ------
/**
 项目评分

 @param grade 分数
 */
- (void)projectGradeWithGrade:(NSInteger)grade {
    NSDictionary *paramters = @{@"score":@(grade)};
    
    WEAKSELF
    [PPNetworkHelper PUT:[NSString stringWithFormat:@"category/%ld/score", (NSInteger)self.projectDetailModel.dataIdentifier] baseUrlType:3 parameters:paramters hudString:[NSString stringWithFormat:@"%@...", DBHGetStringWithKeyFromTable(@"Submit", nil)] success:^(id responseObject) {
        weakSelf.projectDetailModel.categoryUser.score = responseObject[@"score"];
        weakSelf.gradePromptView.canGrade = NO;
        weakSelf.gradePromptView.grade = weakSelf.projectDetailModel.categoryUser.score.integerValue;
        [LCProgressHUD showSuccess:DBHGetStringWithKeyFromTable(@"Submit Success", nil)];
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    }];
}

#pragma mark ------ Event Responds ------
/**
 评分
 */
- (void)respondsToGradeButton {
    if (![UserSignData share].user.isLogin) {
        [[AppDelegate delegate] goToLoginVC:self];
    } else {
        [[UIApplication sharedApplication].keyWindow addSubview:self.gradePromptView];
        
        WEAKSELF
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.gradePromptView animationShow];
        });
    }
}

#pragma mark ------ Getters And Setters ------
- (void)setProjectDetailModel:(DBHProjectDetailInformationModelData *)projectDetailModel {
    _projectDetailModel = projectDetailModel;
    
    self.gradePromptView.canGrade = _projectDetailModel.categoryUser.score.integerValue == 0;
    self.gradePromptView.grade = _projectDetailModel.categoryUser.score.integerValue;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = BACKGROUNDCOLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHProjectOverviewForProjectInfomtaionTableViewCell class] forCellReuseIdentifier:kDBHProjectOverviewForProjectInfomtaionTableViewCellIdentifier];
        [_tableView registerClass:[DBHProjectOverviewForRelevantInformationTableViewCell class] forCellReuseIdentifier:kDBHProjectOverviewForRelevantInformationTableViewCellIdentifier];
    }
    return _tableView;
}
- (DBHInputView *)keyboardView {
    if (!_keyboardView) {
        _keyboardView = [[DBHInputView alloc] init];
        _keyboardView.dataSource = @[@{VALUE:@"Explore", @"isMore":@"1"},
                                     @{VALUE:@"Wallet", @"isMore":@"1"},
                                     @{VALUE:@"Token Holder", @"isMore":@"0"}];
        
        WEAKSELF
        [_keyboardView clickButtonBlock:^(NSInteger buttonType) {
            switch (buttonType) {
                case 0: {
                    if (weakSelf.browserMenuView.superview) {
                        [weakSelf.browserMenuView animationHide];
                    }
                    if (weakSelf.walletMenuView.superview) {
                        [weakSelf.walletMenuView animationHide];
                    }
                    // 聊天室
                    if (!weakSelf.projectDetailModel.roomId) {
                        // 聊天室不存在
                        [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"The project has no chat room", nil)];
                        return ;
                    }
                    EaseMessageViewController *chatViewController = [[EaseMessageViewController alloc] initWithConversationChatter:[NSString stringWithFormat:@"%ld", (NSInteger)weakSelf.projectDetailModel.roomId] conversationType:EMConversationTypeChatRoom];
                    chatViewController.title = weakSelf.projectDetailModel.unit;
                    [weakSelf.navigationController pushViewController:chatViewController animated:YES];
                    break;
                }
                case 1: {
                    // 浏览器
                    if (weakSelf.walletMenuView.superview) {
                        [weakSelf.walletMenuView animationHide];
                    }
                    if (weakSelf.browserMenuView.superview) {
                        [weakSelf.browserMenuView animationHide];
                    } else {
                        NSMutableArray *browserArray = [NSMutableArray array];
                        for (DBHProjectDetailInformationModelCategoryExplorer *model in weakSelf.projectDetailModel.categoryExplorer) {
                            [browserArray addObject:model.name];
                        }
                        weakSelf.browserMenuView.dataSource = [browserArray copy];
                        [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.browserMenuView];
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [weakSelf.browserMenuView animationShow];
                        });
                    }
                    break;
                }
                case 2: {
                    // 钱包
                    if (weakSelf.browserMenuView.superview) {
                        [weakSelf.browserMenuView animationHide];
                    }
                    if (weakSelf.walletMenuView.superview) {
                        [weakSelf.walletMenuView animationHide];
                    } else {
                        NSMutableArray *walletArray = [NSMutableArray array];
                        for (DBHProjectDetailInformationModelCategoryWallet *model in weakSelf.projectDetailModel.categoryWallet) {
                            [walletArray addObject:model.name];
                        }
                        weakSelf.walletMenuView.dataSource = [walletArray copy];
                        [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.walletMenuView];
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [weakSelf.walletMenuView animationShow];
                        });
                    }
                    break;
                }
                case 3: {
                    // 令牌持有人
                    if (weakSelf.browserMenuView.superview) {
                        [weakSelf.browserMenuView animationHide];
                    }
                    if (weakSelf.walletMenuView.superview) {
                        [weakSelf.walletMenuView animationHide];
                    }
                    
                    KKWebView *webView = [[KKWebView alloc] initWithUrl:weakSelf.projectDetailModel.tokenHolder];
                    webView.title = DBHGetStringWithKeyFromTable(@"Token Holder", nil);
                    webView.imageStr = weakSelf.projectDetailModel.img;
                    [weakSelf.navigationController pushViewController:webView animated:YES];
                    break;
                }
                    
                default:
                    break;
            }
        }];
    }
    return _keyboardView;
}
- (DBHProjectHomeMenuView *)browserMenuView {
    if (!_browserMenuView) {
        _browserMenuView = [[DBHProjectHomeMenuView alloc] init];
        _browserMenuView.line = 1;
        _browserMenuView.maxLine = 3;
        
        WEAKSELF
        [_browserMenuView selectedBlock:^(NSInteger index) {
            DBHProjectDetailInformationModelCategoryExplorer *model = weakSelf.projectDetailModel.categoryExplorer[index];
            KKWebView *webView = [[KKWebView alloc] initWithUrl:model.url];
            webView.title = model.name;
            webView.imageStr = weakSelf.projectDetailModel.img;
            [weakSelf.navigationController pushViewController:webView animated:YES];
        }];
    }
    return _browserMenuView;
}
- (DBHProjectHomeMenuView *)walletMenuView {
    if (!_walletMenuView) {
        _walletMenuView = [[DBHProjectHomeMenuView alloc] init];
        _walletMenuView.line = 2;
        _walletMenuView.maxLine = 3;
        
        WEAKSELF
        [_walletMenuView selectedBlock:^(NSInteger index) {
            DBHProjectDetailInformationModelCategoryWallet *model = weakSelf.projectDetailModel.categoryWallet[index];
            KKWebView *webView = [[KKWebView alloc] initWithUrl:model.url];
            webView.title = model.name;
            webView.imageStr = weakSelf.projectDetailModel.img;
            [weakSelf.navigationController pushViewController:webView animated:YES];
        }];
    }
    return _walletMenuView;
}
- (DBHGradePromptView *)gradePromptView {
    if (!_gradePromptView) {
        _gradePromptView = [[DBHGradePromptView alloc] init];
        
        WEAKSELF
        [_gradePromptView gradeBlock:^(NSInteger grade) {
            [weakSelf projectGradeWithGrade:grade];
        }];
    }
    return _gradePromptView;
}

@end
