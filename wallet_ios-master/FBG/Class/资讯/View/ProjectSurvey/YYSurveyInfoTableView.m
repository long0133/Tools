//
//  YYSurveyInfoTableView.m
//  CSJF
//
//  Created by cqdingwei@163.com on 2017/5/18.
//  Copyright © 2017年 dingwei. All rights reserved.
//

#import "YYSurveyInfoTableView.h"

#import "DBHProjectOverviewForProjectInfomtaionTableViewCell.h"
#import "DBHProjectOverviewForRelevantInformationTableViewCell.h"
#import "DBHProjectInformationTableViewCell.h"
#import "DBHProjectOtherSectionTableViewCell.h"
#import "DBHProjectDetailInformationModelCategoryExplorer.h"

#import "DBHProjectOverviewNoTradingForRelevantInformationTableViewCell.h"
#import "DBHProjectOverviewNoTradingTableViewCell.h"
#import "DBHICODistributionTableViewCell.h"
#import "DBHProjectSurveyHeaderView.h"
#import "DBHProjectDetailInformationDataModels.h"

static NSString *const kDBHICODistributionTableViewCell = @"kDBHICODistributionTableViewCell";

static NSString *const kDBHProjectInformationTableViewCell = @"kDBHProjectInformationTableViewCell";
static NSString *const kDBHProjectOtherSectionTableViewCell = @"kDBHProjectOtherSectionTableViewCell";
static NSString *const kDBHProjectOverviewNoTradingForRelevantInformationTableViewCell = @"kDBHProjectOverviewNoTradingForRelevantInformationTableViewCell";
static NSString *const kDBHProjectOverviewNoTradingTableViewCell = @"kDBHProjectOverviewNoTradingTableViewCell";

@interface YYSurveyInfoTableView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *browserDatasource;
@property (nonatomic, strong) NSMutableArray *walletDatasource;
@property (nonatomic, assign) CGFloat heightOfCell;

@end

@implementation YYSurveyInfoTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        [self initTableView];
        _heightOfCell = SURVEY_SECTION1_HEIGHT(SCREEN_HEIGHT, SURVEY_HEADER_HEIGHT, SURVEY_DEFAULT_Y);
    }
    return self;
}

- (void)dealloc {
    self.delegate = nil;
    self.dataSource = nil;
}

- (void)initTableView {
    self.dataSource = self;
    self.delegate = self;
    self.alwaysBounceVertical = YES;
    
    [self registerClass:[DBHICODistributionTableViewCell class] forCellReuseIdentifier:kDBHICODistributionTableViewCell];
    [self registerClass:[DBHProjectOverviewNoTradingTableViewCell class] forCellReuseIdentifier:kDBHProjectOverviewNoTradingTableViewCell];
    [self registerClass:[DBHProjectOverviewNoTradingForRelevantInformationTableViewCell class] forCellReuseIdentifier:kDBHProjectOverviewNoTradingForRelevantInformationTableViewCell];
    [self registerClass:[DBHProjectOtherSectionTableViewCell class] forCellReuseIdentifier:kDBHProjectOtherSectionTableViewCell];
    [self registerClass:[DBHProjectInformationTableViewCell class] forCellReuseIdentifier:kDBHProjectInformationTableViewCell];
}

#pragma mark *** UIScrollViewDelegate ***
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    OffsetType type = self.mainVC.offsetType;
    if (scrollView.contentOffset.y <= 0) {
        self.offsetType = OffsetTypeMin;
    } else {
        self.offsetType = OffsetTypeCenter;
    }
    
    if (type == OffsetTypeMin) {
        scrollView.contentOffset = CGPointZero;
    }
    if (type == OffsetTypeCenter) {
        scrollView.contentOffset = CGPointZero;
    }
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
                        NSString *rank = [NSString stringWithFormat:@"No.%ld", self.projectDetailModel.ico.rank.integerValue];
                        if ([[DBHLanguageTool sharedInstance].language isEqualToString:CNS]) {
                            rank = [NSString stringWithFormat:@"第%ld名", (NSInteger)self.projectDetailModel.ico.rank.integerValue];
                        }
                        
                        [cell setName:@"Rank" value:rank];
                        break;
                    }
                    case 1: {
                        NSString *cap = isZhUnit ? self.projectDetailModel.ico.marketCapCny : self.projectDetailModel.ico.marketCapUsd;
                        if (cap == nil || [cap isEqual:[NSNull null]]) {
                            cap = @"0";
                        }
                        
                        NSDecimalNumber *first = [NSDecimalNumber decimalNumberWithString:cap];
                        NSDecimalNumber *second = [NSDecimalNumber decimalNumberWithString:@"1000000"];
                        
                        NSDecimalNumber *resultCap = [first decimalNumberByDividingBy:second];

                        cap = [NSString stringWithFormat:@"%@ %@ million", isZhUnit ? @"￥" : @"$", resultCap.stringValue];
                        [cell setName:@"Market Cap" value:cap];
                        break;
                    }
                    case 2: {
                        NSString *availableSupply = self.projectDetailModel.ico.availableSupply;
                        if (availableSupply == nil || [availableSupply isEqual:[NSNull null]]) {
                            availableSupply = @"0";
                        }
                        
                        NSDecimalNumber *first = [NSDecimalNumber decimalNumberWithString:availableSupply];
                        NSDecimalNumber *second = [NSDecimalNumber decimalNumberWithString:@"1000000"];
                        
                        NSDecimalNumber *result = [first decimalNumberByDividingBy:second];
                        availableSupply = result.stringValue;
                        
//                        availableSupply = [NSString DecimalFuncWithOperatorType:3 first:availableSupply secend:@"1000000" value:10];
                        [cell setName:@"Circulating Supply" value:[NSString stringWithFormat:@"%@ million %@", availableSupply, self.projectDetailModel.name]];
                        break;
                    }
                    case 3: {
                        NSString *totalSupply = self.projectDetailModel.ico.totalSupply;
                        if (totalSupply == nil || [totalSupply isEqual:[NSNull null]]) {
                            totalSupply = @"0";
                        }
                        
                        NSDecimalNumber *first = [NSDecimalNumber decimalNumberWithString:totalSupply];
                        NSDecimalNumber *second = [NSDecimalNumber decimalNumberWithString:@"1000000"];
                        
                        NSDecimalNumber *result = [first decimalNumberByDividingBy:second];
                        totalSupply = result.stringValue;
                        
//                        totalSupply = [NSString DecimalFuncWithOperatorType:3 first:totalSupply secend:@"1000000" value:10];
                        [cell setName:@"Total Supply" value:[NSString stringWithFormat:@"%@ million %@", totalSupply, self.projectDetailModel.unit]];
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
            [[self parentController].navigationController pushViewController:webView animated:YES];
        }
    } else if (section == 2) {
        if (isTrading) {
            DBHProjectDetailInformationModelCategoryWallet *model = self.projectDetailModel.categoryWallet[row];
            KKWebView *webView = [[KKWebView alloc] initWithUrl:model.url];
            webView.title = model.name;
            webView.imageStr = self.projectDetailModel.img;
            [[self parentController].navigationController pushViewController:webView animated:YES];
        } else {
            DBHProjectDetailInformationModelCategoryExplorer *model = self.projectDetailModel.categoryExplorer[row];
            KKWebView *webView = [[KKWebView alloc] initWithUrl:model.url];
            webView.title = model.name;
            webView.imageStr = self.projectDetailModel.img;
            [[self parentController].navigationController pushViewController:webView animated:YES];
        }
    } else if (section == 3) {
        if (isTrading) {
            KKWebView *webView = [[KKWebView alloc] initWithUrl:self.projectDetailModel.tokenHolder];
            webView.title = DBHGetStringWithKeyFromTable(@"Token Holder", nil);
            webView.imageStr = self.projectDetailModel.img;
            [[self parentController].navigationController pushViewController:webView animated:YES];
        } else {
            DBHProjectDetailInformationModelCategoryWallet *model = self.projectDetailModel.categoryWallet[row];
            KKWebView *webView = [[KKWebView alloc] initWithUrl:model.url];
            webView.title = model.name;
            webView.imageStr = self.projectDetailModel.img;
            [[self parentController].navigationController pushViewController:webView animated:YES];
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
            }
            return AUTOLAYOUTSIZE(height);
            break;
        }
            
        default:
            return AUTOLAYOUTSIZE(44);
            break;
    }
}

- (void)setProjectDetailModel:(DBHProjectDetailInformationModelData *)projectDetailModel {
    _projectDetailModel = projectDetailModel;
    
    NSMutableArray *walletArray = [NSMutableArray array];
    for (DBHProjectDetailInformationModelCategoryExplorer *model in projectDetailModel.categoryWallet) {
        [walletArray addObject:model.name];
    }
    self.walletDatasource = walletArray;
    
    NSMutableArray *browserArray = [NSMutableArray array];
    for (DBHProjectDetailInformationModelCategoryExplorer *model in self.projectDetailModel.categoryExplorer) {
        [browserArray addObject:model.name];
    }
    self.browserDatasource = browserArray;
}

#pragma mark *** other ***
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
