//
//  DBHAddressBookViewController.m
//  Trinity
//
//  Created by 邓毕华 on 2017/12/28.
//  Copyright © 2017年 邓毕华. All rights reserved.
//

#import "DBHAddressBookViewController.h"

#import "DBHAddOrEditAddressViewController.h"

#import "DBHAddressBookHeaderView.h"
#import "DBHAddressBookMenuView.h"
#import "DBHAddressBookTableViewCell.h"

#import "DBHAddressBookDataModels.h"

static NSString *const kDBHAddressBookTableViewCellIdentifier = @"kDBHAddressBookTableViewCellIdentifier";

@interface DBHAddressBookViewController ()<UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, strong) DBHAddressBookHeaderView *addressBookHeaderView;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UITableView *ethTableView;
@property (nonatomic, strong) UITableView *neoTableView;
@property (nonatomic, strong) UITableView *btcTableView;
@property (nonatomic, strong) DBHAddressBookMenuView *addressBookMenuView;

@property (nonatomic, copy) SelectedAddressBlock selectedAddressBlock;
@property (nonatomic, strong) NSMutableArray *ethDataSource;
@property (nonatomic, strong) NSMutableArray *neoDataSource;
@property (nonatomic, strong) NSMutableArray *btcDataSource;

@end

@implementation DBHAddressBookViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = DBHGetStringWithKeyFromTable(@"Contacts", nil);
    
    _currentSelectedItem = 0;
    [self setUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    WEAKSELF
    switch (_currentSelectedItem) {
        case 0: {
            [self loadDataWithIcoId:@"1" completion:^{
                [weakSelf.addressBookHeaderView selectedType:weakSelf.currentSelectedItem];
                [weakSelf.contentScrollView setContentOffset:CGPointMake(SCREENWIDTH * _currentSelectedItem, 0) animated:YES];
            }];
        }
            break;
        case 1: {
            [self loadDataWithIcoId:@"2" completion:^{
                [weakSelf.addressBookHeaderView selectedType:weakSelf.currentSelectedItem];
                [weakSelf.contentScrollView setContentOffset:CGPointMake(SCREENWIDTH * _currentSelectedItem, 0) animated:YES];
            }];
        }
            break;
            
        default: {
            [self loadDataWithIcoId:@"1" completion:nil];
        }
            break;
    }
}

#pragma mark ------ UI ------
- (void)setUI {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"wode_tianjia"] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToAddAddressBarButtonItem)];
    
    [self.view addSubview:self.addressBookHeaderView];
    [self.view addSubview:self.contentScrollView];
    [self.contentScrollView addSubview:self.ethTableView];
    [self.contentScrollView addSubview:self.neoTableView];
    [self.contentScrollView addSubview:self.btcTableView];
    
    WEAKSELF
    [self.addressBookHeaderView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.height.offset(AUTOLAYOUTSIZE(62.5));
        make.centerX.top.equalTo(weakSelf.view);
    }];
    [self.contentScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.addressBookHeaderView.mas_bottom);
        make.bottom.equalTo(weakSelf.view);
        make.centerX.equalTo(weakSelf.view);
    }];
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (tableView.tag - 300) {
        case 0:
            return self.ethDataSource.count;
            break;
        case 1:
            return self.neoDataSource.count;
            break;
            
        default:
            return self.btcDataSource.count;
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHAddressBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHAddressBookTableViewCellIdentifier forIndexPath:indexPath];
    switch (tableView.tag - 300) {
        case 0:
            cell.model = self.ethDataSource[indexPath.row];
            break;
        case 1:
            cell.model = self.neoDataSource[indexPath.row];
            break;
            
        default:
            cell.model = self.btcDataSource[indexPath.row];
            break;
    }
    
    return cell;
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isSelected) {
        DBHAddressBookModelList *model;
        switch (tableView.tag - 300) {
            case 0:
                model = self.ethDataSource[indexPath.row];
                break;
            case 1:
                model = self.neoDataSource[indexPath.row];
                break;
                
            default:
                model = self.btcDataSource[indexPath.row];
                break;
        }
        
        self.selectedAddressBlock(model.address);
        [self.navigationController popViewControllerAnimated:YES];
        
        return;
    }
    DBHAddOrEditAddressViewController *editAddressViewController = [[DBHAddOrEditAddressViewController alloc] init];
    editAddressViewController.addressViewControllerType = DBHAddressViewControllerEditType;
    editAddressViewController.icoId = tableView.tag == 300 ? @"1" : @"2";
    switch (tableView.tag - 300) {
        case 0:
            editAddressViewController.model = self.ethDataSource[indexPath.row];
            break;
        case 1:
            editAddressViewController.model = self.neoDataSource[indexPath.row];
            break;
            
        default:
            editAddressViewController.model = self.btcDataSource[indexPath.row];
            break;
    }
    [self.navigationController pushViewController:editAddressViewController animated:YES];
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return @"A";
//}
//- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    return @[@"A"];
//}

#pragma mark ------ UIScrollViewDelegate ------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.contentScrollView]) {
        _currentSelectedItem = scrollView.contentOffset.x / SCREENWIDTH;
        [self.addressBookHeaderView selectedType:scrollView.contentOffset.x / SCREENWIDTH];
    }
}

#pragma mark ------ Data ------
- (void)loadDataWithIcoId:(NSString *)icoId completion:(void(^)(void))completion {
    WEAKSELF
    [PPNetworkHelper GET:[NSString stringWithFormat:@"contact?%@=%@", @"category_id", icoId] baseUrlType:1 parameters:nil hudString:nil responseCache:^(id responseCache) {
        NSInteger type = icoId.integerValue - 1;
        switch (type) {
            case 0:
                [weakSelf.ethDataSource removeAllObjects];
                break;
            case 1:
                [weakSelf.neoDataSource removeAllObjects];
                break;
                
            default:
                [weakSelf.btcDataSource removeAllObjects];
                break;
        }
        
        for (NSDictionary *dic in responseCache[LIST]) {
            DBHAddressBookModelList *model = [DBHAddressBookModelList modelObjectWithDictionary:dic];
            
            switch (type) {
                case 0:
                    [weakSelf.ethDataSource addObject:model];
                    break;
                case 1:
                    [weakSelf.neoDataSource addObject:model];
                    break;
                    
                default:
                    [weakSelf.btcDataSource addObject:model];
                    break;
            }
        }
        
        switch (type) {
            case 0:
                [weakSelf.ethTableView reloadData];
                break;
            case 1:
                [weakSelf.neoTableView reloadData];
                break;
                
            default:
                [weakSelf.btcTableView reloadData];
                break;
        }
        if (completion) {
            completion();
        }
    } success:^(id responseObject) {
        NSInteger type = icoId.integerValue - 1;
        switch (type) {
            case 0:
                [weakSelf.ethDataSource removeAllObjects];
                break;
            case 1:
                [weakSelf.neoDataSource removeAllObjects];
                break;
                
            default:
                [weakSelf.btcDataSource removeAllObjects];
                break;
        }
        
        for (NSDictionary *dic in responseObject[LIST]) {
            DBHAddressBookModelList *model = [DBHAddressBookModelList modelObjectWithDictionary:dic];
            
            switch (type) {
                case 0:
                    [weakSelf.ethDataSource addObject:model];
                    break;
                case 1:
                    [weakSelf.neoDataSource addObject:model];
                    break;
                    
                default:
                    [weakSelf.btcDataSource addObject:model];
                    break;
            }
        }
        
        switch (type) {
            case 0:
                [weakSelf.ethTableView reloadData];
                break;
            case 1:
                [weakSelf.neoTableView reloadData];
                break;
                
            default:
                [weakSelf.btcTableView reloadData];
                break;
        }
        if (completion) {
            completion();
        }
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    } specialBlock:nil];
}

#pragma mark ------ Event Responds ------
/**
 添加联系人
 */
- (void)respondsToAddAddressBarButtonItem {
    [[UIApplication sharedApplication].keyWindow addSubview:self.addressBookMenuView];
    
    WEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.addressBookMenuView animationShow];
    });
}

#pragma mark ------ Public Methods ------
- (void)selectedAddressBlock:(SelectedAddressBlock)selectedAddressBlock {
    self.selectedAddressBlock = selectedAddressBlock;
}

#pragma mark ------ Getters And Setters ------
- (DBHAddressBookHeaderView *)addressBookHeaderView {
    if (!_addressBookHeaderView) {
        _addressBookHeaderView = [[DBHAddressBookHeaderView alloc] init];
        
        WEAKSELF
        [_addressBookHeaderView selectedTypeBlock:^(NSInteger type) {
//            _currentSelectedItem = type;
            // 选择代币类型
            [weakSelf.contentScrollView setContentOffset:CGPointMake(SCREENWIDTH * type, 0) animated:YES];
            
            if (type == 2) {
                [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Coming Soon", nil)];
                return;
            }
            
            // ETH:6 NEO:7
            [weakSelf loadDataWithIcoId:!type ? @"1" : @"2" completion:nil];
        }];
    }
    return _addressBookHeaderView;
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
- (UITableView *)ethTableView {
    if (!_ethTableView) {
        _ethTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - STATUS_HEIGHT - 44 - AUTOLAYOUTSIZE(62.5))];
        _ethTableView.tag = 300;
        _ethTableView.backgroundColor = WHITE_COLOR;
        _ethTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _ethTableView.sectionIndexColor = COLORFROM16(0x333333, 1);
        
        _ethTableView.rowHeight = AUTOLAYOUTSIZE(54);
        
        _ethTableView.dataSource = self;
        _ethTableView.delegate = self;
        
        [_ethTableView registerClass:[DBHAddressBookTableViewCell class] forCellReuseIdentifier:kDBHAddressBookTableViewCellIdentifier];
    }
    return _ethTableView;
}
- (UITableView *)neoTableView {
    if (!_neoTableView) {
        _neoTableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREENWIDTH, 0, SCREENWIDTH, SCREENHEIGHT - STATUS_HEIGHT - 44 - AUTOLAYOUTSIZE(62.5))];
        _neoTableView.tag = 301;
        _neoTableView.backgroundColor = WHITE_COLOR;
        _neoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _neoTableView.sectionIndexColor = COLORFROM16(0x333333, 1);
        
        _neoTableView.rowHeight = AUTOLAYOUTSIZE(54);
        
        _neoTableView.dataSource = self;
        _neoTableView.delegate = self;
        
        [_neoTableView registerClass:[DBHAddressBookTableViewCell class] forCellReuseIdentifier:kDBHAddressBookTableViewCellIdentifier];
    }
    return _neoTableView;
}
- (UITableView *)btcTableView {
    if (!_btcTableView) {
        _btcTableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREENWIDTH * 2, 0, SCREENWIDTH, SCREENHEIGHT - STATUS_HEIGHT - 44 - AUTOLAYOUTSIZE(62.5))];
        _btcTableView.tag = 302;
        _btcTableView.backgroundColor = WHITE_COLOR;
        _btcTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _btcTableView.sectionIndexColor = COLORFROM16(0x333333, 1);
        
        _btcTableView.rowHeight = AUTOLAYOUTSIZE(54);
        
        _btcTableView.dataSource = self;
        _btcTableView.delegate = self;
        
        [_btcTableView registerClass:[DBHAddressBookTableViewCell class] forCellReuseIdentifier:kDBHAddressBookTableViewCellIdentifier];
    }
    return _btcTableView;
}
- (DBHAddressBookMenuView *)addressBookMenuView {
    if (!_addressBookMenuView) {
        _addressBookMenuView = [[DBHAddressBookMenuView alloc] init];
        _addressBookMenuView.dataSource = @[@"ETH", @"NEO", @"BTC"];
        
        WEAKSELF
        [_addressBookMenuView selectedBlock:^(NSInteger index) {
            if (index == 2) {
                [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Coming Soon", nil)];
                return ;
            }
            weakSelf.currentSelectedItem = index;
            // 添加联系人
            DBHAddOrEditAddressViewController *addAddressViewController = [[DBHAddOrEditAddressViewController alloc] init];
            addAddressViewController.addressViewControllerType = DBHAddressViewControllerAddType;
            addAddressViewController.icoId = !index ? @"1" : @"2";
            [weakSelf.navigationController pushViewController:addAddressViewController animated:YES];
        }];
    }
    return _addressBookMenuView;
}

- (NSMutableArray *)ethDataSource {
    if (!_ethDataSource) {
        _ethDataSource = [NSMutableArray array];
    }
    return _ethDataSource;
}
- (NSMutableArray *)neoDataSource {
    if (!_neoDataSource) {
        _neoDataSource = [NSMutableArray array];
    }
    return _neoDataSource;
}
- (NSMutableArray *)btcDataSource {
    if (!_btcDataSource) {
        _btcDataSource = [NSMutableArray array];
    }
    return _btcDataSource;
}

@end
