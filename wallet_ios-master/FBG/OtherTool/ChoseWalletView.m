//
//  ChoseWalletView.m
//  FBG
//
//  Created by 贾仕海 on 2017/8/14.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "ChoseWalletView.h"
#import "WalletLeftListModel.h"
#import "ChoseCell.h"

@interface ChoseWalletView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * coustromTableView;
@property (nonatomic, strong) NSMutableArray * dataSource;

@property (weak, nonatomic) IBOutlet UIView *masView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation ChoseWalletView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self = [ChoseWalletView loadViewFromXIB];
        self.frame = frame;
        UITapGestureRecognizer * singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskViewSingleTap)];
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        [self.masView addGestureRecognizer:singleRecognizer];
        self.contentView.layer.cornerRadius = 5;
        self.contentView.layer.masksToBounds = YES;
        
        self.dataSource = [[NSMutableArray alloc] init];
        [self.contentView addSubview:self.coustromTableView];
    }
    return self;
}

- (void)loadData
{
    //加载左抽屉数据
    [PPNetworkHelper GET:@"wallet" baseUrlType:1 parameters:nil hudString:DBHGetStringWithKeyFromTable(@"Loading...", nil)  responseCache:^(id responseCache)
     {
         if (![NSString isNulllWithObject:[responseCache objectForKey:LIST]])
         {
             [self.dataSource removeAllObjects];
             for (NSDictionary * leftDic in [responseCache objectForKey:LIST])
             {
                 WalletLeftListModel * model = [[WalletLeftListModel alloc] initWithDictionary:leftDic];
                 model.category_name = [[leftDic objectForKey:@"category"] objectForKey:NAME];
                 
                 if ([NSString isNulllWithObject:[PDKeyChain load:KEYCHAIN_KEY(model.address)]])
                 {
                     //观察钱包
                     model.isLookWallet = YES;
                 }
                 
                 [self.dataSource addObject:model];
             }
             [self.coustromTableView reloadData];
         }
     } success:^(id responseObject)
     {
         if (![NSString isNulllWithObject:[responseObject objectForKey:LIST]])
         {
             [self.dataSource removeAllObjects];
             for (NSDictionary * leftDic in [responseObject objectForKey:LIST])
             {
                 WalletLeftListModel * model = [[WalletLeftListModel alloc] initWithDictionary:leftDic];
                 model.category_name = [[leftDic objectForKey:@"category"] objectForKey:NAME];
                 if ([NSString isNulllWithObject:[PDKeyChain load:KEYCHAIN_KEY(model.address)]])
                 {
                     //观察钱包
                     model.isLookWallet = YES;
                 }
                 [self.dataSource addObject:model];
             }
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.coustromTableView reloadData];
             });
         }
     } failure:^(NSString *error)
     {
     } specialBlock:nil];
}

- (void)showWithView:(UIView *)view
{
    [self loadData];
    if (view)
    {
        [view addSubview:self];
    }
    else
    {
        [self addToWindow];
    }
    
    [self.contentView springingAnimation];
}

- (void)canel
{
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
        self.contentView.alpha = 0;
    } completion:^(BOOL finished){
        [self removeFromSuperview];
        self.maskView.alpha = 0.4;
        self.contentView.alpha = 1;
    }];
}

- (void)maskViewSingleTap
{
    [self canel];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChoseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChoseCellident"];
    if (!cell) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"ChoseCell" owner:nil options:nil];
        cell = array[0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self  canel];
    WalletLeftListModel * model = self.dataSource[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(sureButtonCilickWithData:)])
    {
        [self.delegate sureButtonCilickWithData:@(indexPath.row)];
//        [self.delegate sureButtonCilickWithData:model];
    }
}

- (UITableView *)coustromTableView
{
    if (!_coustromTableView) {
        _coustromTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, self.contentView.bounds.size.width, self.contentView.bounds.size.height - 45) style:UITableViewStylePlain];
        _coustromTableView.delegate = self;
        _coustromTableView.dataSource = self;
        _coustromTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _coustromTableView.showsVerticalScrollIndicator = NO;
        _coustromTableView.showsHorizontalScrollIndicator = NO;
        _coustromTableView.rowHeight = 60;
    }
    return _coustromTableView;
}


@end
