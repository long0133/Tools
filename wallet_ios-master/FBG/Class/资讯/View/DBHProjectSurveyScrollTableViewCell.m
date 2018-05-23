//
//  DBHProjectSurveyScrollTableViewCell.m
//  FBG
//
//  Created by yy on 2018/4/5.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHProjectSurveyScrollTableViewCell.h"
#import "DBHICODistributionTableViewCell.h"

#import "DBHProjectOverviewForRelevantInformationTableViewCell.h"
#import "DBHProjectInformationTableViewCell.h"
#import "DBHProjectOtherSectionTableViewCell.h"
#import "DBHProjectDetailInformationModelCategoryExplorer.h"

#import "DBHProjectOverviewNoTradingForRelevantInformationTableViewCell.h"
#import "DBHProjectDetailInformationDataModels.h"
#import "DBHProjectOverviewNoTradingTableViewCell.h"
#import "DBHICODistributionTableViewCell.h"

#define TAG_START 300

static NSString *const kDBHICODistributionTableViewCell = @"kDBHICODistributionTableViewCell";

static NSString *const kDBHProjectInformationTableViewCell = @"kDBHProjectInformationTableViewCell";
static NSString *const kDBHProjectOtherSectionTableViewCell = @"kDBHProjectOtherSectionTableViewCell";
static NSString *const kDBHProjectOverviewNoTradingForRelevantInformationTableViewCell = @"kDBHProjectOverviewNoTradingForRelevantInformationTableViewCell";
static NSString *const kDBHProjectOverviewNoTradingTableViewCell = @"kDBHProjectOverviewNoTradingTableViewCell";


@interface DBHProjectSurveyScrollTableViewCell() <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIScrollView *contentScrollView;

@property (nonatomic, strong) UITableView *infoTableView;

@property (nonatomic, strong) NSMutableArray *browserDatasource;
@property (nonatomic, strong) NSMutableArray *walletDatasource;

@property (nonatomic, strong) UITableView *commentTableView;
@property (nonatomic, strong) WKWebView *webView;


@end

@implementation DBHProjectSurveyScrollTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.contentScrollView];
    WEAKSELF
    [self.contentScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.contentView);
        make.center.equalTo(weakSelf.contentView);
    }];
    
    // 添加第一个tableView
    [self.contentScrollView addSubview:self.infoTableView];
    [self.infoTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.contentScrollView);
        make.size.equalTo(weakSelf.contentScrollView);
    }];
    
    // 添加第二个tableView
    [self.contentScrollView addSubview:self.commentTableView];
    [self.commentTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.infoTableView);
        make.left.equalTo(weakSelf.infoTableView.mas_right);
        make.width.equalTo(weakSelf.infoTableView);
    }];
    
    // 添加第三个webview
    [self.contentScrollView addSubview:self.webView];
    [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.commentTableView);
        make.left.equalTo(weakSelf.commentTableView.mas_right);
        make.width.equalTo(weakSelf.infoTableView);
    }];
}

#pragma mark ----- UITableView ---------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([tableView isEqual:self.infoTableView]) {
        return 4;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = 0;
    if ([tableView isEqual:self.infoTableView]) {
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
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if ([tableView isEqual:self.infoTableView]) {
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
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([tableView isEqual:self.infoTableView]) {
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
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if ([tableView isEqual:self.infoTableView]) {
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([tableView isEqual:self.infoTableView]) {
        if (section == 0) {
            return 0;
        }
        
        return AUTOLAYOUTSIZE(25);
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.infoTableView]) {
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
    return 0;
}

#pragma mark ----- UIScrollViewDelegate ---------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
   
}

#pragma mark ----- Getters And Setters ---------
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
    
    NSString *htmlStr = projectDetailModel.categoryPresentation.content;
    if ([htmlStr containsString:@"<!doctype html>"]) {
        htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"<!doctype html>" withString:@"<!doctype html><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, maximum-scale=5.0, user-scalable=0\">"];
    }
    
    if (htmlStr != nil) {
        [self.webView loadHTMLString:htmlStr baseURL:nil];
    }
}

- (void)setCurrentSelectedIndex:(NSInteger)currentSelectedIndex {
    _currentSelectedIndex = currentSelectedIndex;
    
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] init];
        _webView.tag = TAG_START + 2;
    }
    return _webView;
}

- (UITableView *)infoTableView {
    if (!_infoTableView) {
        _infoTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _infoTableView.tag = TAG_START;
        _infoTableView.backgroundColor = COLORFROM16(0xF6F6F6, 1);
        _infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _infoTableView.rowHeight = AUTOLAYOUTSIZE(33);
        _infoTableView.contentInset = UIEdgeInsetsMake(-AUTOLAYOUTSIZE(36), 0, AUTOLAYOUTSIZE(100), 0);
        
        _infoTableView.dataSource = self;
        _infoTableView.delegate = self;
        
        _infoTableView.sectionHeaderHeight = 0;
        _infoTableView.sectionFooterHeight = 0;
        
        _infoTableView.tableHeaderView = nil;
        _infoTableView.tableFooterView = nil;
        
        [_infoTableView registerClass:[DBHICODistributionTableViewCell class] forCellReuseIdentifier:kDBHICODistributionTableViewCell];
        [_infoTableView registerClass:[DBHProjectOverviewNoTradingTableViewCell class] forCellReuseIdentifier:kDBHProjectOverviewNoTradingTableViewCell];
        [_infoTableView registerClass:[DBHProjectOverviewNoTradingForRelevantInformationTableViewCell class] forCellReuseIdentifier:kDBHProjectOverviewNoTradingForRelevantInformationTableViewCell];
        [_infoTableView registerClass:[DBHProjectOtherSectionTableViewCell class] forCellReuseIdentifier:kDBHProjectOtherSectionTableViewCell];
        [_infoTableView registerClass:[DBHProjectInformationTableViewCell class] forCellReuseIdentifier:kDBHProjectInformationTableViewCell];
    }
    return _infoTableView;
}

- (UITableView *)commentTableView {
    if (!_commentTableView) {
        _commentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _commentTableView.tag = TAG_START + 1;
        _commentTableView.backgroundColor = COLORFROM16(0xF6F6F6, 1);
        _commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _commentTableView.rowHeight = AUTOLAYOUTSIZE(33);
        
        _commentTableView.dataSource = self;
        _commentTableView.delegate = self;
        
        _commentTableView.sectionHeaderHeight = 0;
        _commentTableView.sectionFooterHeight = 0;
        
        _commentTableView.tableHeaderView = nil;
        _commentTableView.tableFooterView = nil;
    }
    return _commentTableView;
}

- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] init];
        _contentScrollView.contentSize = CGSizeMake(SCREENWIDTH * 3, 0);
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

- (NSMutableArray *)browserDatasource {
    if (!_browserDatasource) {
        _browserDatasource = [NSMutableArray array];
    }
    return _browserDatasource;
}

- (NSMutableArray *)walletDatasource {
    if (!_walletDatasource) {
        _walletDatasource = [NSMutableArray array];
    }
    return _walletDatasource;
}
@end
