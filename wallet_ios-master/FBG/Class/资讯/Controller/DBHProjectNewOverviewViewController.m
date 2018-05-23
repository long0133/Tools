//
//  DBHProjectNewOverviewViewController.m
//  FBG
//
//  Created by yy on 2018/3/15.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHProjectNewOverviewViewController.h"
#import "KKWebView.h"
#import "DBHGradeView.h"

#import "DBHInputView.h"
#import "DBHProjectHomeMenuView.h"
#import "DBHGradePromptView.h"
#import "DBHProjectOverviewForProjectInfomtaionTableViewCell.h"
#import "DBHProjectOverviewForRelevantInformationTableViewCell.h"
#import "DBHProjectInformationTableViewCell.h"
#import "DBHProjectOtherSectionTableViewCell.h"
#import "DBHProjectDetailInformationModelCategoryExplorer.h"

#import "DBHProjectOverviewNoTradingForRelevantInformationTableViewCell.h"
#import "DBHProjectDetailInformationDataModels.h"
#import "DBHProjectOverviewNoTradingTableViewCell.h"
#import "DBHICODistributionTableViewCell.h"

static NSString *const kDBHICODistributionTableViewCell = @"kDBHICODistributionTableViewCell";

static NSString *const kDBHProjectInformationTableViewCell = @"kDBHProjectInformationTableViewCell";
static NSString *const kDBHProjectOtherSectionTableViewCell = @"kDBHProjectOtherSectionTableViewCell";
static NSString *const kDBHProjectOverviewNoTradingForRelevantInformationTableViewCell = @"kDBHProjectOverviewNoTradingForRelevantInformationTableViewCell";
static NSString *const kDBHProjectOverviewNoTradingTableViewCell = @"kDBHProjectOverviewNoTradingTableViewCell";


@interface DBHProjectNewOverviewViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, WKNavigationDelegate>

@property (nonatomic, strong) UIView *headerContentView;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *tagLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *changeLabel;
@property (nonatomic, strong) UILabel *volumeLabel;
@property (nonatomic, strong) UIView *grayLineView;
@property (nonatomic, strong) UILabel *rankLabel;
@property (nonatomic, strong) UILabel *hotAttentionLabel;
@property (nonatomic, strong) UIView *centerGrayLineView;
@property (nonatomic, strong) DBHGradeView *gradeView;
@property (nonatomic, strong) UILabel *gradeLabel;
@property (nonatomic, strong) UILabel *userGradeLabel;


@property (nonatomic, strong) UIScrollView *titleScrollView;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, weak) UILabel *currentSelectedTitleLabel; // 当前选中标题Label

@property (nonatomic, strong) NSArray *titleStrArray;
@property (nonatomic, strong) DBHGradePromptView *gradePromptView;

@property (nonatomic, strong) NSMutableArray *browserDatasource;
@property (nonatomic, strong) NSMutableArray *walletDatasource;
@end

@implementation DBHProjectNewOverviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.projectDetailModel.unit;
    self.view.backgroundColor = COLORFROM16(0xF6F6F6, 1);
    
    [self setUI];
    [self setData];
}

#pragma mark ------ UI ------
- (void)setUI {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:DBHGetStringWithKeyFromTable(@"Rating", nil) style:UIBarButtonItemStylePlain target:self action:@selector(respondsToGradeButton)];
    [self setHeaderUI];
    [self setScrollUI];
}

- (void)setHeaderUI {
    [self.view addSubview:self.headerContentView];
    [self.headerContentView addSubview:self.iconImageView];
    [self.headerContentView addSubview:self.nameLabel];
    [self.headerContentView addSubview:self.tagLabel];
    [self.headerContentView addSubview:self.priceLabel];
    [self.headerContentView addSubview:self.changeLabel];
    [self.headerContentView addSubview:self.volumeLabel];
    [self.headerContentView addSubview:self.grayLineView];
    [self.headerContentView addSubview:self.rankLabel];
    [self.headerContentView addSubview:self.hotAttentionLabel];
    [self.headerContentView addSubview:self.centerGrayLineView];
    [self.headerContentView addSubview:self.gradeView];
    [self.headerContentView addSubview:self.gradeLabel];
    [self.headerContentView addSubview:self.userGradeLabel];
    
    WEAKSELF
    [self.headerContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view).offset(AUTOLAYOUTSIZE(1));
        make.height.equalTo(@(AUTOLAYOUTSIZE(160)));
    }];
    
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(24));
        make.left.offset(AUTOLAYOUTSIZE(17));
        make.top.offset(AUTOLAYOUTSIZE(24));
    }];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(AUTOLAYOUTSIZE(8));
        make.top.offset(AUTOLAYOUTSIZE(18));
    }];
    [self.tagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLabel);
        make.top.equalTo(weakSelf.nameLabel.mas_bottom);
    }];
    [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.nameLabel);
        make.right.offset(- AUTOLAYOUTSIZE(21));
    }];
    [self.changeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.priceLabel.mas_bottom).offset(AUTOLAYOUTSIZE(1.5));
        make.right.equalTo(weakSelf.priceLabel);
    }];
    [self.volumeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.changeLabel.mas_bottom).offset(AUTOLAYOUTSIZE(4.5));
        make.right.equalTo(weakSelf.priceLabel);
    }];
    [self.grayLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.headerContentView).offset(- AUTOLAYOUTSIZE(44));
        make.height.offset(AUTOLAYOUTSIZE(1));
        make.centerX.equalTo(weakSelf.headerContentView);
        make.bottom.offset(- AUTOLAYOUTSIZE(59));
    }];
    [self.rankLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.grayLineView.mas_bottom).offset(AUTOLAYOUTSIZE(8));
        make.centerX.equalTo(weakSelf.hotAttentionLabel);
    }];
    [self.hotAttentionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.rankLabel.mas_bottom).offset(AUTOLAYOUTSIZE(2));
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.centerGrayLineView.mas_left);
    }];
    [self.centerGrayLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(1));
        make.centerX.equalTo(weakSelf.headerContentView);
        make.top.equalTo(weakSelf.grayLineView.mas_bottom).offset(AUTOLAYOUTSIZE(13));
        make.bottom.offset(- AUTOLAYOUTSIZE(13));
    }];
    [self.gradeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(56.5));
        make.height.equalTo(weakSelf.gradeLabel);
        make.right.offset(- AUTOLAYOUTSIZE(86));
        make.centerY.equalTo(weakSelf.rankLabel);
    }];
    [self.gradeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.rankLabel);
        make.left.equalTo(weakSelf.gradeView.mas_right).offset(AUTOLAYOUTSIZE(5));
    }];
    [self.userGradeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.hotAttentionLabel);
        make.left.equalTo(weakSelf.centerGrayLineView.mas_right);
        make.right.equalTo(weakSelf.headerContentView);
    }];
}

- (void)setScrollUI {
    [self.view addSubview:self.titleScrollView];
    [self.view addSubview:self.contentScrollView];
    [self.titleScrollView insertSubview:self.lineView atIndex:0];
    
    WEAKSELF
    [self.titleScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.height.offset(AUTOLAYOUTSIZE(37));
        make.top.equalTo(weakSelf.headerContentView.mas_bottom);
        make.centerX.equalTo(weakSelf.view);
    }];
    [self.contentScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.titleScrollView.mas_bottom);
        make.bottom.equalTo(weakSelf.view);
        make.centerX.equalTo(weakSelf.view);
    }];
    
    [self addTitleLabels];
    [self addTableViews];
}

#pragma mark ------ Data ------
- (void)setData {
    [self setHeaderData];
    [self switchShowData];
}

- (void)setHeaderData {
    [self.iconImageView sdsetImageWithURL:_projectDetailModel.img placeholderImage:nil];
    
    NSMutableAttributedString *nameAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@（%@）", _projectDetailModel.unit, _projectDetailModel.name]];
    [nameAttributedString addAttributes:@{NSFontAttributeName:BOLDFONT(16)} range:NSMakeRange(0, _projectDetailModel.unit.length)];
    self.nameLabel.attributedText = nameAttributedString;
    self.tagLabel.text = _projectDetailModel.industry;
    
    self.priceLabel.hidden = _projectDetailModel.type != 1;
    self.changeLabel.hidden = _projectDetailModel.type != 1;
    self.volumeLabel.hidden = _projectDetailModel.type != 1;
    if (_projectDetailModel.type == 1) {
        BOOL isZhUnit = [UserSignData share].user.walletUnitType == 1;
        NSString *price = isZhUnit ? _projectDetailModel.ico.priceCny : _projectDetailModel.ico.priceUsd;
        price = [NSString stringWithFormat:@"%@%.2lf", isZhUnit ? @"¥" : @"$", price.doubleValue];
        self.priceLabel.text =  price;
        
        self.volumeLabel.text = [NSString stringWithFormat:@"%@：%@", DBHGetStringWithKeyFromTable(@"Volume (24h)", nil), isZhUnit ? _projectDetailModel.ico.volumeCny24h : _projectDetailModel.ico.volumeUsd24h];
    
        self.changeLabel.text = [NSString stringWithFormat:@"(%@%.2lf%%)", _projectDetailModel.ico.percentChange24h.doubleValue >= 0 ? @"+" : @"", _projectDetailModel.ico.percentChange24h.doubleValue];
    } else {
        
    }
    if ([[DBHLanguageTool sharedInstance].language isEqualToString:CNS]) {
        self.rankLabel.text = [NSString stringWithFormat:@"第%ld名", (NSInteger)_projectDetailModel.categoryScore.sort];
    } else {
        self.rankLabel.text = [NSString stringWithFormat:@"No.%ld", (NSInteger)_projectDetailModel.categoryScore.sort];
    }
    self.gradeView.grade = _projectDetailModel.categoryScore.value;
    self.gradeLabel.text = [NSString stringWithFormat:@"%.1lf%@", _projectDetailModel.categoryScore.value, DBHGetStringWithKeyFromTable(@"", nil)];
    
    self.gradePromptView.canGrade = _projectDetailModel.categoryUser.score.integerValue == 0;
    self.gradePromptView.grade = _projectDetailModel.categoryUser.score.integerValue;
}

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

#pragma mark ------ respondsToSelectors -------
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

#pragma mark ------ Data ------
/**
 切换显示的数据
 */
- (void)switchShowData {
    NSInteger currentTag = self.currentSelectedTitleLabel.tag;
    NSInteger index = currentTag - 200;
    
    if (index == 0) { // 综合信息
        //        UITableView *tableView = [self.contentScrollView viewWithTag:300];
        //        [tableView reloadData];
    } else {  // 项目概况
        //        WKWebView *webView = [self.contentScrollView viewWithTag:301];
        //        [webView loadHTMLString:self.projectDetailModel.categoryPresentation.content baseURL:nil];
    }
}

#pragma mark - Event Responds
- (void)respondsToTitleLabel:(UITapGestureRecognizer *)tapGR {
    // 选中label
    [self selectedLabel:(UILabel *)tapGR.view];
    
    // 显示对应控制器的view
    [self showTableView:tapGR.view.tag - 200];
}
#pragma mark ------ UITableView ------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = 0;
    BOOL isTrading = self.projectDetailModel.type == 1;
    switch (section) {
        case 0:
            row = isTrading ? 5 : 1;
            break;
        case 1:
            row = isTrading ? ((self.browserDatasource.count > 0) ? self.browserDatasource.count : 1) : 1;
            break;
        case 2:
            row = isTrading ? ((self.walletDatasource.count > 0) ? self.walletDatasource.count : 1) : ((self.browserDatasource.count > 0) ? self.browserDatasource.count : 1);
            break;
        case 3:
            row = isTrading ? 1 : ((self.walletDatasource.count > 0) ? self.walletDatasource.count : 1);
            break;
        default:
            break;
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (self.projectDetailModel.type != 1) { // 非交易中
        switch (section) {
            case 0: {
                DBHProjectOverviewNoTradingForRelevantInformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHProjectOverviewNoTradingForRelevantInformationTableViewCell forIndexPath:indexPath];
                cell.projectDetailModel = self.projectDetailModel;
                
                return cell;
                break;
            }
            case 1: {
//                DBHProjectOverviewNoTradingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHProjectOverviewNoTradingTableViewCell forIndexPath:indexPath];
                DBHICODistributionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHICODistributionTableViewCell forIndexPath:indexPath];
                cell.projectDetailModel = self.projectDetailModel;
                
                return cell;
                break;
            }
            case 2: {
                DBHProjectOtherSectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHProjectOtherSectionTableViewCell forIndexPath:indexPath];
                if (row < self.browserDatasource.count) {
                    [cell setTitle:self.browserDatasource[row] isShowArrow:YES];
                    cell.userInteractionEnabled = YES;
                } else {
                    [cell setTitle:DBHGetStringWithKeyFromTable(@"No Data ", nil) isShowArrow:NO];
                    cell.userInteractionEnabled = NO;
                }
                return cell;
                break;
            }
            case 3: { // 钱包
                DBHProjectOtherSectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHProjectOtherSectionTableViewCell forIndexPath:indexPath];
                if (row < self.walletDatasource.count) {
                    [cell setTitle:self.walletDatasource[row] isShowArrow:YES];
                    cell.userInteractionEnabled = YES;
                } else {
                    [cell setTitle:DBHGetStringWithKeyFromTable(@"No Data ", nil) isShowArrow:NO];
                    cell.userInteractionEnabled = NO;
                }
                return cell;
            }
        }
    } else {
        switch (section) {
            case 0: { // 综合信息
                DBHProjectInformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHProjectInformationTableViewCell forIndexPath:indexPath];
                BOOL isZhUnit = [UserSignData share].user.walletUnitType == 1;
                switch (row) {
                    case 0: {
                        NSString *rank = [NSString stringWithFormat:@"%.02d", self.projectDetailModel.ico.rank.intValue];
                        [cell setName:@"Rank" value:rank];
                        break;
                    }
                    case 1: {
                        NSString *cap = isZhUnit ? self.projectDetailModel.ico.marketCapCny : self.projectDetailModel.ico.marketCapUsd;
                        if (cap == nil || [cap isEqual:[NSNull null]]) {
                            cap = @"0";
                        }
                        cap = [NSString DecimalFuncWithOperatorType:3 first:cap secend:@"1000000" value:10];
                        cap = [NSString stringWithFormat:@"%@ %@ million", isZhUnit ? @"￥" : @"$", @(cap.doubleValue)];
                        [cell setName:@"Market Cap" value:cap];
                        break;
                    }
                    case 2: {
                        NSString *availableSupply = self.projectDetailModel.ico.availableSupply;
                        if (availableSupply == nil || [availableSupply isEqual:[NSNull null]]) {
                            availableSupply = @"0";
                        }
                        availableSupply = [NSString DecimalFuncWithOperatorType:3 first:availableSupply secend:@"1000000" value:10];
                        [cell setName:@"Circulating Supply" value:[NSString stringWithFormat:@"%@ million %@", @(availableSupply.doubleValue), self.projectDetailModel.name]];
                        break;
                    }
                    case 3: {
                        NSString *totalSupply = self.projectDetailModel.ico.totalSupply;
                        if (totalSupply == nil || [totalSupply isEqual:[NSNull null]]) {
                            totalSupply = @"0";
                        }
                        totalSupply = [NSString DecimalFuncWithOperatorType:3 first:totalSupply secend:@"1000000" value:10];
                        [cell setName:@"Total Supply" value:[NSString stringWithFormat:@"%@ million %@", @(totalSupply.doubleValue), self.projectDetailModel.unit]];
                        break;
                    }
                    case 4: {
                        NSString *icoPrice = self.projectDetailModel.icoPrice;
                        if (![icoPrice containsString:@"-"]) {
                            icoPrice = [NSString stringWithFormat:@"%@", icoPrice];
                        }
                        [cell setName:@"ICO Price" value:icoPrice];
                    }
                        break;
                }
                return cell;
            }
                break;
                
            case 1: { // 浏览器
                DBHProjectOtherSectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHProjectOtherSectionTableViewCell forIndexPath:indexPath];
                if (row < self.browserDatasource.count) {
                    [cell setTitle:self.browserDatasource[row] isShowArrow:YES];
                    cell.userInteractionEnabled = YES;
                } else {
                    [cell setTitle:DBHGetStringWithKeyFromTable(@"No Data ", nil) isShowArrow:NO];
                    cell.userInteractionEnabled = NO;
                }
                return cell;
            }
                break;
                
            case 2: { // 钱包
                DBHProjectOtherSectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHProjectOtherSectionTableViewCell forIndexPath:indexPath];
                if (row < self.walletDatasource.count) {
                    [cell setTitle:self.walletDatasource[row] isShowArrow:YES];
                    cell.userInteractionEnabled = YES;
                } else {
                    [cell setTitle:DBHGetStringWithKeyFromTable(@"No Data ", nil) isShowArrow:NO];
                    cell.userInteractionEnabled = NO;
                }
                return cell;
            }
                break;
                
            case 3: { //代币分布图
                DBHProjectOtherSectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHProjectOtherSectionTableViewCell forIndexPath:indexPath];
                [cell setTitle:DBHGetStringWithKeyFromTable(@"Watch1", nil) isShowArrow:YES];
                cell.userInteractionEnabled = YES;
                return cell;
            }
                break;
        }
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    
    BOOL isTrading = self.projectDetailModel.type == 1;
    NSString *text = @"";
    switch (section) {
        case 1:
            text = isTrading ? @"Explore" : @"ICO Distribution";
            break;
        case 2:
            text = isTrading ? @"Wallet" : @"Explore";
            break;
        case 3:
            text = isTrading ? @"Token Holder" : @"Wallet";
            break;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, AUTOLAYOUTSIZE(25))];
    view.backgroundColor = [UIColor clearColor];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(AUTOLAYOUTSIZE(22), 0, AUTOLAYOUTSIZE(100), AUTOLAYOUTSIZE(25))];
    
    headerLabel.text = DBHGetStringWithKeyFromTable(text, nil);
    headerLabel.font = FONT(13);
    headerLabel.textColor = COLORFROM16(0xC5C5C5, 1);
    
    [view addSubview:headerLabel];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    BOOL isTrading = self.projectDetailModel.type == 1;
    if (section == 1) {
        if (isTrading) { // 浏览器
            DBHProjectDetailInformationModelCategoryExplorer *model = self.projectDetailModel.categoryExplorer[row];
            KKWebView *webView = [[KKWebView alloc] initWithUrl:model.url];
            webView.title = model.name;
            webView.imageStr = self.projectDetailModel.img;
            [self.navigationController pushViewController:webView animated:YES];
        }
    } else if (section == 2) {
        if (isTrading) {
            DBHProjectDetailInformationModelCategoryWallet *model = self.projectDetailModel.categoryWallet[row];
            KKWebView *webView = [[KKWebView alloc] initWithUrl:model.url];
            webView.title = model.name;
            webView.imageStr = self.projectDetailModel.img;
            [self.navigationController pushViewController:webView animated:YES];
        } else {
            DBHProjectDetailInformationModelCategoryExplorer *model = self.projectDetailModel.categoryExplorer[row];
            KKWebView *webView = [[KKWebView alloc] initWithUrl:model.url];
            webView.title = model.name;
            webView.imageStr = self.projectDetailModel.img;
            [self.navigationController pushViewController:webView animated:YES];
        }
    } else if (section == 3) {
        if (isTrading) {
            KKWebView *webView = [[KKWebView alloc] initWithUrl:self.projectDetailModel.tokenHolder];
            webView.title = DBHGetStringWithKeyFromTable(@"Token Holder", nil);
            webView.imageStr = self.projectDetailModel.img;
            [self.navigationController pushViewController:webView animated:YES];
        } else {
            DBHProjectDetailInformationModelCategoryWallet *model = self.projectDetailModel.categoryWallet[row];
            KKWebView *webView = [[KKWebView alloc] initWithUrl:model.url];
            webView.title = model.name;
            webView.imageStr = self.projectDetailModel.img;
            [self.navigationController pushViewController:webView animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    
    return AUTOLAYOUTSIZE(25);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isTrading = self.projectDetailModel.type == 1;
    
    if (isTrading) {
        return AUTOLAYOUTSIZE(44);
    }
    
    switch (indexPath.section) {
        case 0: {
            CGFloat height = AUTOLAYOUTSIZE(33);
            if (!isTrading) {
                NSAttributedString *htmlString = [[NSAttributedString alloc] initWithData:[self.projectDetailModel.categoryDesc.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                NSLog(@"height:%lf", [htmlString boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - AUTOLAYOUTSIZE(30), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height);
                height = [htmlString boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - AUTOLAYOUTSIZE(30), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height + AUTOLAYOUTSIZE(60);
            }
            return height;
        }
            break;
        case 1: {
            CGFloat height = 44;
            if (!isTrading) {
                NSInteger count = self.projectDetailModel.categoryStructure.count;
                height = ICO_DISTRIBUTION_HEIGHT * count + 20 + 150 + 30;
//                height = self.projectDetailModel.categoryStructure.count >= 4 ? AUTOLAYOUTSIZE(56) + AUTOLAYOUTSIZE(30) * self.projectDetailModel.categoryStructure.count + AUTOLAYOUTSIZE(230) : AUTOLAYOUTSIZE(180);
            }
            return AUTOLAYOUTSIZE(height);
            break;
        }
            
        default:
            return AUTOLAYOUTSIZE(44);
            break;
    }
}

#pragma mark ------ Private Methods ------
/**
 添加所有子控制器对应的标题
 */
- (void)addTitleLabels {
    self.contentScrollView.contentSize = CGSizeMake(SCREENWIDTH * self.titleStrArray.count, 1);
    for (NSInteger i = 0; i < self.titleStrArray.count; i ++) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.tag = 200 + i;  //200  201
        titleLabel.frame = CGRectMake(!i ? 0 : CGRectGetMaxX([self.titleScrollView.subviews lastObject].frame), 0, [NSString getWidthtWithString:self.titleStrArray[i] fontSize:AUTOLAYOUTSIZE(14)] + AUTOLAYOUTSIZE(38), AUTOLAYOUTSIZE(37));
        titleLabel.font = FONT(14);
        titleLabel.text = self.titleStrArray[i];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = COLORFROM16(0x626262, 1);
        titleLabel.highlightedTextColor = COLORFROM16(0xF46A00, 1);
        titleLabel.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTitleLabel:)];
        [titleLabel addGestureRecognizer:tapGR];
        
        [self.titleScrollView addSubview:titleLabel];
        
        if (!i) {
            titleLabel.highlighted = YES;
            self.currentSelectedTitleLabel = titleLabel;
            
            [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.offset(AUTOLAYOUTSIZE(10));
                make.height.offset(AUTOLAYOUTSIZE(1));
                make.centerX.equalTo(titleLabel);
                make.top.offset(AUTOLAYOUTSIZE(30.5));
            }];
        }
    }
    
    _titleScrollView.contentSize = CGSizeMake(CGRectGetMaxX([self.view viewWithTag:200 + self.titleStrArray.count].frame), 0);
}
/**
 添加所有子控制器
 */
- (void)addTableViews {
    [self.view layoutIfNeeded];
    
    CGFloat height = CGRectGetHeight(self.contentScrollView.frame) - AUTOLAYOUTSIZE(8);
    // 添加第一个tableview
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, height) style:UITableViewStyleGrouped];
    tableView.tag = 300;
    tableView.backgroundColor = COLORFROM16(0xF6F6F6, 1);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.rowHeight = AUTOLAYOUTSIZE(33);
    tableView.contentInset = UIEdgeInsetsMake(-AUTOLAYOUTSIZE(36), 0, AUTOLAYOUTSIZE(100), 0);
    //    tableView.contentInset = UIEdgeInsetsMake(0, 0, AUTOLAYOUTSIZE(100), 0);
    
    tableView.dataSource = self;
    tableView.delegate = self;
    
    tableView.sectionHeaderHeight = 0;
    tableView.sectionFooterHeight = 0;
    
    tableView.tableHeaderView = nil;
    tableView.tableFooterView = nil;
    
    [tableView registerClass:[DBHICODistributionTableViewCell class] forCellReuseIdentifier:kDBHICODistributionTableViewCell];
    [tableView registerClass:[DBHProjectOverviewNoTradingTableViewCell class] forCellReuseIdentifier:kDBHProjectOverviewNoTradingTableViewCell];
    [tableView registerClass:[DBHProjectOverviewNoTradingForRelevantInformationTableViewCell class] forCellReuseIdentifier:kDBHProjectOverviewNoTradingForRelevantInformationTableViewCell];
    [tableView registerClass:[DBHProjectOtherSectionTableViewCell class] forCellReuseIdentifier:kDBHProjectOtherSectionTableViewCell];
    [tableView registerClass:[DBHProjectInformationTableViewCell class] forCellReuseIdentifier:kDBHProjectInformationTableViewCell];
    [self.contentScrollView addSubview:tableView];
    
    // 添加第二个webview
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(SCREENWIDTH, 0, SCREENWIDTH, height)];
    webView.tag = 301;
    webView.navigationDelegate = self;
    
    NSString *htmlStr = self.projectDetailModel.categoryPresentation.content;
    if ([htmlStr containsString:@"<!doctype html>"]) {
        htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"<!doctype html>" withString:@"<!doctype html><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, maximum-scale=5.0, user-scalable=0\">"];
    }
    
    if (htmlStr != nil) {
        [webView loadHTMLString:htmlStr baseURL:nil];
    }
    
    //    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [self.contentScrollView addSubview:webView];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    //    [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '250%'" completionHandler:nil];
}

/**
 选中label
 */
- (void)selectedLabel:(UILabel *)label {
    WEAKSELF
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(10));
        make.height.offset(AUTOLAYOUTSIZE(1));
        make.centerX.equalTo(label);
        make.top.offset(AUTOLAYOUTSIZE(30.5));
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf.titleScrollView layoutIfNeeded];
    }];
    
    // 还原前一个选中label的属性
    self.currentSelectedTitleLabel.highlighted = NO;
    //    self.currentSelectedTitleLabel.transform = CGAffineTransformIdentity;
    self.currentSelectedTitleLabel.textColor = COLORFROM16(0x626262, 1);
    
    // 修改选中label的属性
    label.highlighted = YES;
    //    label.transform = CGAffineTransformMakeScale(scale, scale);
    
    // 更改选中的label
    self.currentSelectedTitleLabel = label;
    
    // 居中选中的label
    CGFloat offsetX = label.center.x - SCREENWIDTH * 0.5;
    CGFloat maxOffsetX = self.titleScrollView.contentSize.width - SCREENWIDTH;
    if (offsetX < 0) {
        offsetX = 0;
    } else if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    [self.titleScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
    [self switchShowData];
}
/**
 显示选中标题对面的控制器view
 
 @param index 选中标题的下标
 */
- (void)showTableView:(NSInteger)index {
    // 移动内容scrollView到指定位置
    self.contentScrollView.contentOffset = CGPointMake(SCREENWIDTH * index, 0);
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    UILabel *label = (UILabel *)[self.titleScrollView viewWithTag:200 + self.contentScrollView.contentOffset.x / SCREENWIDTH];
    // 选中label
    [self selectedLabel:label];
    
    // 显示对应tableview
    [self showTableView:self.contentScrollView.contentOffset.x / SCREENWIDTH];
}

#pragma mark ------ Getters And Setters -------
- (NSArray *)titleStrArray {
    if (!_titleStrArray) {
        _titleStrArray = @[DBHGetStringWithKeyFromTable(@"Information", nil),
                           DBHGetStringWithKeyFromTable(@"Overview", nil)];
    }
    return _titleStrArray;
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

- (UIView *)headerContentView {
    if (!_headerContentView) {
        _headerContentView = [[UIView alloc] init];
        _headerContentView.backgroundColor = WHITE_COLOR;
    }
    return _headerContentView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImageView;
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = FONT(14);
        _nameLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _nameLabel;
}
- (UILabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.font = FONT(11);
        _tagLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _tagLabel;
}
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = BOLDFONT(20);
        _priceLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _priceLabel;
}
- (UILabel *)changeLabel {
    if (!_changeLabel) {
        _changeLabel = [[UILabel alloc] init];
        _changeLabel.font = FONT(11);
        _changeLabel.textColor = COLORFROM16(0xFF680F, 1);
    }
    return _changeLabel;
}
- (UILabel *)volumeLabel {
    if (!_volumeLabel) {
        _volumeLabel = [[UILabel alloc] init];
        _volumeLabel.font = FONT(9);
        _volumeLabel.textColor = COLORFROM16(0xACACAC, 1);
    }
    return _volumeLabel;
}
- (UIView *)grayLineView {
    if (!_grayLineView) {
        _grayLineView = [[UIView alloc] init];
        _grayLineView.backgroundColor = COLORFROM16(0xF6F6F6, 1);
    }
    return _grayLineView;
}
- (UILabel *)rankLabel {
    if (!_rankLabel) {
        _rankLabel = [[UILabel alloc] init];
        _rankLabel.font = FONT(15);
        _rankLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _rankLabel;
}
- (UILabel *)hotAttentionLabel {
    if (!_hotAttentionLabel) {
        _hotAttentionLabel = [[UILabel alloc] init];
        _hotAttentionLabel.font = FONT(11);
        _hotAttentionLabel.text = DBHGetStringWithKeyFromTable(@"Attention", nil);
        _hotAttentionLabel.textColor = COLORFROM16(0xC5C5C5, 1);
        _hotAttentionLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _hotAttentionLabel;
}
- (UIView *)centerGrayLineView {
    if (!_centerGrayLineView) {
        _centerGrayLineView = [[UIView alloc] init];
        _centerGrayLineView.backgroundColor = COLORFROM16(0xF6F6F6, 1);
    }
    return _centerGrayLineView;
}
- (DBHGradeView *)gradeView {
    if (!_gradeView) {
        _gradeView = [[DBHGradeView alloc] init];
    }
    return _gradeView;
}
- (UILabel *)gradeLabel {
    if (!_gradeLabel) {
        _gradeLabel = [[UILabel alloc] init];
        _gradeLabel.font = FONT(15);
        _gradeLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _gradeLabel;
}
- (UILabel *)userGradeLabel {
    if (!_userGradeLabel) {
        _userGradeLabel = [[UILabel alloc] init];
        _userGradeLabel.font = FONT(11);
        _userGradeLabel.text = DBHGetStringWithKeyFromTable(@"Rating", nil);
        _userGradeLabel.textColor = COLORFROM16(0xC5C5C5, 1);
        _userGradeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _userGradeLabel;
}

- (UIScrollView *)titleScrollView {
    if (!_titleScrollView) {
        _titleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, 44)];
        _titleScrollView.backgroundColor = COLORFROM16(0xFAFAFA, 1);
        // 隐藏水平滚动条
        _titleScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _titleScrollView;
}

- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] init];
        _contentScrollView.contentSize = CGSizeMake(SCREENWIDTH * (self.titleStrArray.count), 0);
        // 开启分页
        _contentScrollView.pagingEnabled = YES;
        // 关闭回弹
        _contentScrollView.bounces = NO;
        // 隐藏水平滚动条
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        // 设置代理
        _contentScrollView.delegate = self;
    }
    return _contentScrollView;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = COLORFROM16(0xF46A00, 1);
    }
    return _lineView;
}

- (NSMutableArray *)browserDatasource {
    if (!_browserDatasource) {
        NSMutableArray *browserArray = [NSMutableArray array];
        for (DBHProjectDetailInformationModelCategoryExplorer *model in self.projectDetailModel.categoryExplorer) {
            [browserArray addObject:model.name];
        }
        _browserDatasource = browserArray;
    }
    return _browserDatasource;
}

- (NSMutableArray *)walletDatasource {
    if (!_walletDatasource) {
        NSMutableArray *walletArray = [NSMutableArray array];
        for (DBHProjectDetailInformationModelCategoryExplorer *model in self.projectDetailModel.categoryWallet) {
            [walletArray addObject:model.name];
        }
        _walletDatasource = walletArray;
    }
    return _walletDatasource;
}

@end

