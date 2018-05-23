//
//  DBHInfoScrollTableViewCell.m
//  FBG
//
//  Created by yy on 2018/3/20.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHInfoScrollTableViewCell.h"
#import "SDCycleScrollView.h"
#import "DBHProjectHomeNewsModelData.h"

@interface DBHInfoScrollTableViewCell()<SDCycleScrollViewDelegate>

//@property (nonatomic, strong) UIButton *pullDownBtn;

@property (nonatomic, strong) UIImageView *redPointImgView;
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIView *scrollTitleContentView; // 包含 小红点 titlescrollview 下拉按钮
@property (nonatomic, strong) SDCycleScrollView *titleScrollView;
@property (nonatomic, strong) SDCycleScrollView *imageScrollView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *titles;

@end

@implementation DBHInfoScrollTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
        [self titleLabelIsShow:YES];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    WEAKSELF
    [self.contentView addSubview:self.imageScrollView];
    [self.imageScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.contentView);
        make.height.equalTo(@(AUTOLAYOUTSIZE(SCROLL_LOOP_HEIGHT)));
    }];
    
    [self.contentView addSubview:self.topLineView];
    [self.topLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.imageScrollView.mas_bottom);
        make.height.offset(AUTOLAYOUTSIZE(1));
    }];
    
    [self.contentView addSubview:self.scrollTitleContentView];
    [self.scrollTitleContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.topLineView.mas_bottom);
        make.bottom.equalTo(weakSelf.contentView);
    }];
    
    [self.scrollTitleContentView addSubview:self.redPointImgView];
    [self.redPointImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(weakSelf.scrollTitleContentView);
        make.width.equalTo(@(AUTOLAYOUTSIZE(16)));
        make.centerY.equalTo(weakSelf.scrollTitleContentView);
        make.left.offset(AUTOLAYOUTSIZE(16));
    }];
    
    [self.scrollTitleContentView addSubview:self.titleScrollView];
    [self.titleScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.redPointImgView.mas_right).offset(AUTOLAYOUTSIZE(3));
        make.centerY.height.equalTo(weakSelf.scrollTitleContentView);
        make.right.equalTo(weakSelf.scrollTitleContentView).offset(-AUTOLAYOUTSIZE(8));
    }];
    
    [self.scrollTitleContentView addSubview: self.titleLabel];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.scrollTitleContentView);
        make.left.offset(AUTOLAYOUTSIZE(16));
        make.height.equalTo(weakSelf.scrollTitleContentView);
    }];
    
//    [self.scrollTitleContentView addSubview:self.pullDownBtn];
//    [self.pullDownBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(weakSelf.scrollTitleContentView);
//        make.size.equalTo(weakSelf.scrollTitleContentView);
//    }];
}

#pragma mark - scrollview delegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    // 跳转到网页
    if (self.dataSource.count > 0 && index < self.dataSource.count) {
        DBHProjectHomeNewsModelData *model = self.dataSource[index];
        
        KKWebView *webView = [[KKWebView alloc] initWithUrl:[NSString stringWithFormat:@"%@%ld", [APP_APIEHEAD isEqualToString:APIEHEAD1] ? APIEHEAD4 : TESTAPIEHEAD4, (NSInteger)model.dataIdentifier]];
        webView.title = model.title;
        webView.imageStr = model.img;
        webView.isHaveShare = YES;
        webView.infomationId = [NSString stringWithFormat:@"%ld", (NSInteger)model.dataIdentifier];
        
        [[self parentController].navigationController pushViewController:webView animated:YES];
    }
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    NSLog(@"didScrollToIndex %ld", (long)index);
    if ([cycleScrollView isEqual:self.imageScrollView]) { // 让titleScrollView跟随改变item
        if (index < self.titles.count) {
            self.titleLabel.text = self.titles[index];
        }
//        [self.titleScrollView manualScrollToIndex:(int)index];
    }
}

#pragma mark - fill data
- (void)setTitles:(NSArray *)titles images:(NSArray *)images models:(NSMutableArray *)models {
    self.dataSource = models;
    self.titles = [NSMutableArray arrayWithArray:titles];
  
    if (![self.titleScrollView.titlesGroup isEqualToArray:titles]) {
        self.titleScrollView.titlesGroup = titles;
        self.titleLabel.text = titles[0];
    }
    
    if (![self.imageScrollView.imageURLStringsGroup isEqualToArray:images]) {
        self.imageScrollView.imageURLStringsGroup = images;
    }
}

#pragma mark - respondsToSelector
- (void)respodsToPullDownBtn:(UIButton *)btn {
    if (self.block) {
        self.block();
    }
}

- (void)scrollToZero {
    [self.titleScrollView manualScrollToIndex:0];
    [self.imageScrollView manualScrollToIndex:0];
}

#pragma mark - getter and setter
//- (void)setIsShowScroll:(BOOL)isShowScroll {
//    _isShowScroll = isShowScroll;
//
//    if (isShowScroll) { // 显示 则titlelabel显示  titlescrollview隐藏
//        _titleLabel.hidden = NO;
//        _titleScrollView.hidden = YES;
//        _redPointImgView.hidden = YES;
//    } else {
//        _titleLabel.hidden = YES;
//        _titleScrollView.hidden = NO;
//        _redPointImgView.hidden = NO;
//    }
//}

- (void)titleLabelIsShow:(BOOL)isShow {
    if (isShow) { // 显示 则titlelabel显示  titlescrollview隐藏
        _titleLabel.hidden = NO;
        _titleScrollView.hidden = YES;
        _redPointImgView.hidden = YES;
    } else {
        _titleLabel.hidden = YES;
        _titleScrollView.hidden = NO;
        _redPointImgView.hidden = NO;
    }
}

- (void)invalidateTimers {
    [self.titleScrollView invalidateTimer];
    [self.imageScrollView invalidateTimer];
}

- (void)dealloc {
    [self invalidateTimers];
    _imageScrollView.delegate = nil;
    _titleScrollView.delegate = nil;
}

- (SDCycleScrollView *)titleScrollView {
    if (!_titleScrollView) {
        _titleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:nil];
        _titleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _titleScrollView.onlyDisplayText = YES;
        _titleScrollView.backgroundColor = WHITE_COLOR;
        _titleScrollView.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        [_titleScrollView disableScrollGesture];
        
    }
    return _titleScrollView;
}

- (SDCycleScrollView *)imageScrollView {
    if (!_imageScrollView) {
        _imageScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:nil];
        
        _imageScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _imageScrollView.currentPageDotImage = [UIImage imageNamed:@"page_control_selected"]; // 自定义分页控件小圆标
        _imageScrollView.pageDotImage = [UIImage imageNamed:@"page_control_normal"];
        
        CGFloat value = 8;
        _imageScrollView.pageControlDotSize = CGSizeMake(value, value);
    }
    return _imageScrollView;
}

- (UIView *)topLineView {
    if (!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = COLORFROM16(0xF6F6F6, 1);
    }
    return _topLineView;
}

- (UIView *)scrollTitleContentView {
    if (!_scrollTitleContentView) {
        _scrollTitleContentView = [[UIView alloc] init];
        _scrollTitleContentView.backgroundColor = WHITE_COLOR;
    }
    return _scrollTitleContentView;
}

- (UIImageView *)redPointImgView {
    if (!_redPointImgView) {
        _redPointImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loop_tip"]];
        _redPointImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _redPointImgView;
}

//- (UIButton *)pullDownBtn {
//    if (!_pullDownBtn) {
//        _pullDownBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_pullDownBtn addTarget:self action:@selector(respodsToPullDownBtn:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _pullDownBtn;
//}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)titles {
    if (!_titles) {
        _titles = [NSMutableArray array];
    }
    return _titles;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = COLORFROM16(0x333333, 1);
        _titleLabel.font = BOLDFONT(14);
        _titleLabel.backgroundColor = WHITE_COLOR;
    }
    return _titleLabel;
}
@end
