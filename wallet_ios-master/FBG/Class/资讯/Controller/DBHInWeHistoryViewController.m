//
//  DBHInWeHistoryViewController.m
//  FBG
//
//  Created by yy on 2018/3/7.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHInWeHistoryViewController.h"

#import "DBHMyFavoriteTableViewCell.h"

#import "DBHHistoricalInformationForTagDataModels.h"
#import "DBHHistoricalInformationDataModels.h"

static NSString *const kDBHMyFavoriteTableViewCellIdentifier = @"kDBHMyFavoriteTableViewCellIdentifier";

@interface DBHInWeHistoryViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *titleScrollView;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, weak) UILabel *currentSelectedTitleLabel; // 当前选中标题Label

@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSArray *titleStrArray;


@end

@implementation DBHInWeHistoryViewController


#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = DBHGetStringWithKeyFromTable(@"History", nil);
    
    [self setUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        [self getTag];
    });
    
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.view addSubview:self.titleScrollView];
    [self.view addSubview:self.contentScrollView];
    [self.titleScrollView insertSubview:self.lineView atIndex:0];
    
    WEAKSELF
    [self.titleScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.height.offset(AUTOLAYOUTSIZE(37));
        make.centerX.top.equalTo(weakSelf.view);
    }];
    [self.contentScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.titleScrollView.mas_bottom);
        make.bottom.equalTo(weakSelf.view);
        make.centerX.equalTo(weakSelf.view);
    }];
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger index = tableView.tag - 300;
    if (index < self.dataSource.count) {
        NSMutableArray *array = self.dataSource[index];
        return array.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHMyFavoriteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHMyFavoriteTableViewCellIdentifier forIndexPath:indexPath];
    NSInteger index = tableView.tag - 300;
    cell.isNoImage = NO;
    if (index < self.dataSource.count) {
        NSMutableArray *arr = self.dataSource[index];
        NSInteger row = indexPath.row;
        if (row < arr.count) {
            DBHHistoricalInformationModelData *data = arr[row];
            cell.isNoImage = (data.type == 1 || data.type == 16);
            cell.model = data;
        }
    }
    
    return cell;
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHHistoricalInformationModelData *model = nil;
    NSInteger index = tableView.tag - 300;
    if (index < self.dataSource.count) {
        NSMutableArray *arr = self.dataSource[index];
        NSInteger row = indexPath.row;
        if (row < arr.count) {
            model = arr[row];
        }
    }
    KKWebView *webView = [[KKWebView alloc] initWithUrl:[NSString stringWithFormat:@"%@%ld", [APP_APIEHEAD isEqualToString:APIEHEAD1] ? APIEHEAD4 : TESTAPIEHEAD4, (NSInteger)model.dataIdentifier]];
    webView.title = model.title;
    webView.imageStr = model.img;
    webView.isHaveShare = YES;
    webView.infomationId = [NSString stringWithFormat:@"%ld", (NSInteger)model.dataIdentifier];
    [self.navigationController pushViewController:webView animated:YES];
}

#pragma mark - UIScrollViewDelegate

/**
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 获取当前页数
    CGFloat currentPage = scrollView.contentOffset.x / SCREENWIDTH;

    // 获取当前选中label
    UILabel *currentSelectedLabel = [self.titleScrollView viewWithTag:200 + currentPage];
    // 获取上一个选中label
    UILabel *lastSelectedLabel;
    if (currentPage + 1 < self.titleArray.count - 1) {
        lastSelectedLabel = [self.titleScrollView viewWithTag:201 + currentPage];
    }

    // 计算上一个选中label缩放比例
    CGFloat lastSelectedLabelScale = currentPage - (NSInteger)currentPage;
    // 计算当前选中label缩放比例
    CGFloat currentSelectedLabelScale = 1 - lastSelectedLabelScale;

    // 缩放
    currentSelectedLabel.transform = CGAffineTransformMakeScale(currentSelectedLabelScale * 0.3 + 1, currentSelectedLabelScale * 0.3 + 1);
    lastSelectedLabel.transform = CGAffineTransformMakeScale(lastSelectedLabelScale * 0.3 + 1, lastSelectedLabelScale * 0.3 + 1);

    // 颜色渐变
    currentSelectedLabel.textColor = COLORFROM16(0xF46A00, 1);
    lastSelectedLabel.textColor = COLORFROM16(0x626262, 1);
}
 */

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    UILabel *label = (UILabel *)[self.titleScrollView viewWithTag:200 + self.contentScrollView.contentOffset.x / SCREENWIDTH];
    // 选中label
    [self selectedLabel:label];
    
    // 显示对应tableview
    [self showTableView:self.contentScrollView.contentOffset.x / SCREENWIDTH];
}

#pragma mark ------ Data ------
/**
 获取资讯
 */
- (void)getInfomation {
    DBHHistoricalInformationForTagModelData *model;
    NSInteger currentTag = self.currentSelectedTitleLabel.tag;
    NSInteger index = currentTag - 200;
    if (index < self.titleArray.count) {
        model = self.titleArray[index];
    }
    
    NSString *param = @"type=[1,2,3,6,16]"; // 默认全部
    switch (index) {
        case 1:
            param = @"type=16";
            break;
        case 2:
            param = @"type=1";
            break;
        case 3:
            param = @"type=[2,3,6]";
            break;
            
        default:
            break;
    }
    
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        [PPNetworkHelper GET:[NSString stringWithFormat:@"article?is_not_category&%@&per_page=100", param] baseUrlType:3 parameters:nil hudString:nil responseCache:^(id responseCache) {
            NSMutableArray *array = weakSelf.dataSource[index];
            [array removeAllObjects];
            
            for (NSDictionary *dic in responseCache[@"data"]) {
                DBHHistoricalInformationModelData *model = [DBHHistoricalInformationModelData modelObjectWithDictionary:dic];
                
                [array addObject:model];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UITableView *tableView = [weakSelf.contentScrollView viewWithTag:currentTag + 100];
                [tableView reloadData];
            });
        } success:^(id responseObject) {
            NSMutableArray *array = weakSelf.dataSource[index];
            [array removeAllObjects];
            
            for (NSDictionary *dic in responseObject[@"data"]) {
                DBHHistoricalInformationModelData *model = [DBHHistoricalInformationModelData modelObjectWithDictionary:dic];
                
                [array addObject:model];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UITableView *tableView = [weakSelf.contentScrollView viewWithTag:currentTag + 100];
                [tableView reloadData];
            });
        } failure:^(NSString *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [LCProgressHUD showFailure:error];
            });
        } specialBlock:^{
            
        }];
    });
}
/**
 获取标签
 */
- (void)getTag {
    if (self.titleArray.count) {
        return;
    }
    
    for (int i = 0; i <= self.titleStrArray.count - 1; i ++) {
        DBHHistoricalInformationForTagModelData *model = [[DBHHistoricalInformationForTagModelData alloc] init];
        model.name = self.titleStrArray[i];
        [self.titleArray addObject:model];
        [self.dataSource addObject:[NSMutableArray array]];
    }
    
    [self.dataSource addObject:[NSMutableArray array]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self addTitleLabels];
        [self addTableViews];
        [self getInfomation];
    });
}

#pragma mark - Event Responds
- (void)respondsToTitleLabel:(UITapGestureRecognizer *)tapGR {
    // 选中label
    [self selectedLabel:(UILabel *)tapGR.view];
    
    // 显示对应控制器的view
    [self showTableView:tapGR.view.tag - 200];
}

#pragma mark ------ Private Methods ------
/**
 添加所有子控制器对应的标题
 */
- (void)addTitleLabels {
    self.contentScrollView.contentSize = CGSizeMake(SCREENWIDTH * (self.titleArray.count + 1), 0);
    for (NSInteger i = 0; i < self.titleArray.count + 1; i++) {
        DBHHistoricalInformationForTagModelData *model = !i ? nil : self.titleArray[i - 1];
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.tag = 200 + i;
        titleLabel.frame = CGRectMake(!i ? 0 : CGRectGetMaxX([self.view viewWithTag:199 + i].frame), 0, [NSString getWidthtWithString:!i ? DBHGetStringWithKeyFromTable(@"All", nil) : model.name fontSize:AUTOLAYOUTSIZE(14)] + AUTOLAYOUTSIZE(42), AUTOLAYOUTSIZE(37));
        titleLabel.font = FONT(14);
        titleLabel.text = !i ? DBHGetStringWithKeyFromTable(@"All", nil) : model.name;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = COLORFROM16(0x626262, 1);
        titleLabel.highlightedTextColor = COLORFROM16(0xF46A00, 1);
        titleLabel.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTitleLabel:)];
        [titleLabel addGestureRecognizer:tapGR];
        
        // 默认选中第1个titleLabel
        //        if (!i) {
        //            [self respondsToTitleLabel:tapGR];
        //        }
        
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
    
    _titleScrollView.contentSize = CGSizeMake(CGRectGetMaxX([self.view viewWithTag:200 + self.titleArray.count].frame), 0);
}
/**
 添加所有子控制器
 */
- (void)addTableViews {
    for (NSInteger i = 0; i < self.titleArray.count + 1; i++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(i * SCREENWIDTH, 0, SCREENWIDTH, SCREENHEIGHT - STATUS_HEIGHT - 44 - AUTOLAYOUTSIZE(62.5))];
        tableView.tag = 300 + i;
        tableView.backgroundColor = WHITE_COLOR;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        tableView.rowHeight = AUTOLAYOUTSIZE(75.5);
        
        tableView.dataSource = self;
        tableView.delegate = self;
        
        [tableView registerClass:[DBHMyFavoriteTableViewCell class] forCellReuseIdentifier:kDBHMyFavoriteTableViewCellIdentifier];
        [self.contentScrollView addSubview:tableView];
    }
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
    
    [self getInfomation];
}
/**
 显示选中标题对面的控制器view
 
 @param index 选中标题的下标
 */
- (void)showTableView:(NSInteger)index {
    // 移动内容scrollView到指定位置
    self.contentScrollView.contentOffset = CGPointMake(SCREENWIDTH * index, 0);
}

#pragma mark ------ Getters And Setters ------
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
        _contentScrollView.contentSize = CGSizeMake(SCREENWIDTH * (self.titleArray.count + 1), 0);
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

- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSArray *)titleStrArray {
    if (!_titleStrArray) {
        _titleStrArray = @[DBHGetStringWithKeyFromTable(@"Exchange", nil),
                           DBHGetStringWithKeyFromTable(@"24H News", nil),
                           DBHGetStringWithKeyFromTable(@"News ", nil)]; 
    }
    return _titleStrArray;
}

@end
