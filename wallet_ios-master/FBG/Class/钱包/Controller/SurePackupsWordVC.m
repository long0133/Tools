//
//  SurePackupsWordsVC.m
//  FBG
//
//  Created by 贾仕海 on 2017/8/29.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "SurePackupsWordVC.h"
#import "CCTagCollectionLayout.h"
#import "CCTagSelectSectionHeaderView.h"
#import "SectionModel.h"
#import "CCTagModel.h"
#import "Masonry.h"

#import "WalletLeftListModel.h"
#import "DBHWalletDetailViewController.h"
#import "DBHWalletDetailWithETHViewController.h"
#import "DBHWalletManagerForNeoModelList.h"

NSString *const kLabelSelectionCellIdentifier = @"kLabelSelectionCellIdentifier";
NSString *const kLabelSelectionHeaderIdentifier = @"kLabelSelectionHeaderIdentifier";

@interface SurePackupsWordVC () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>

@property(nonatomic,strong) UIVisualEffectView *effectView;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,retain) NSMutableArray *dataArray;

@property(nonatomic, assign)BOOL isExist;

@end

@implementation SurePackupsWordVC

#pragma mark - Lifecycle(生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = DBHGetStringWithKeyFromTable(@"Backup Mnemonic", nil);
    [self.sureBtn setTitle:DBHGetStringWithKeyFromTable(@"Confirm", nil) forState:UIControlStateNormal];
    [self initializeComponent];
}

#pragma mark - Custom Accessors (控件响应方法)


#pragma mark - IBActions(xib响应方法)

- (IBAction)sureButtonCilick:(id)sender {
    //确定
    NSString * string = @"";
    for (SectionModel *s in _dataArray)  {
        if ([s.userInfo isEqual:[NSNumber numberWithInt:0]]) {
            //已选
            for (CCTagModel *tagModel in s.mutableCells) {
                string = [string stringByAppendingString:[NSString stringWithFormat:@"%@ ",tagModel.title]];
            }
        }
    }
    
    if ([string containsString:self.mnemonic])  {
        //选对了
        [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Backup successfully", nil)];
        //本地记录备份了
        if ([NSString isNulllWithObject:[UserSignData share].user.walletIdsArray])
        {
            [UserSignData share].user.walletIdsArray = [[NSMutableArray alloc] init];
        }
        if (![[UserSignData share].user.walletIdsArray containsObject:@(self.model.id)])
        {
            [[UserSignData share].user.walletIdsArray addObject:@(self.model.id)];
            [[UserSignData share] storageData:[UserSignData share].user];
        }
        
        if ([NSString isNulllWithObject:[UserSignData share].user.walletZhujiciIdsArray])
        {
            [UserSignData share].user.walletZhujiciIdsArray = [[NSMutableArray alloc] init];
        }
        
        if (![[UserSignData share].user.walletZhujiciIdsArray containsObject:@(self.model.id)])
        {
            [[UserSignData share].user.walletZhujiciIdsArray addObject:@(self.model.id)];
            [[UserSignData share] storageData:[UserSignData share].user];
        }
        
        UIViewController *vc = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3];
        if ([vc isKindOfClass:[DBHWalletDetailViewController class]]) {
            DBHWalletDetailViewController *detailVC = (DBHWalletDetailViewController *)vc;
            detailVC.neoWalletModel.isBackUpMnemonnic = YES;
            [self.navigationController popToViewController:vc animated:YES];
        } else if ([vc isKindOfClass:[DBHWalletDetailWithETHViewController class]]) {
            DBHWalletDetailWithETHViewController *detailVC = (DBHWalletDetailWithETHViewController *)vc;
            detailVC.ethWalletModel.isBackUpMnemonnic = YES;
            [self.navigationController popToViewController:vc animated:YES];
        }
        
        
        //发送消息
//        [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"SurePackupsWordNotfi" object:@(YES) userInfo:nil]];
    }
    else
    {
        //选择错误
        [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Backup failed", nil)];
    
//        if ([NSString isNulllWithObject:[UserSignData share].user.walletIdsArray])
//        {
//            [UserSignData share].user.walletIdsArray = [[NSMutableArray alloc] init];
//        }
//        if (![[UserSignData share].user.walletIdsArray containsObject:@(self.model.id)])
//        {
//            [[UserSignData share].user.walletIdsArray addObject:@(self.model.id)];
//            [[UserSignData share] storageData:[UserSignData share].user];
//        }
//        
//        if ([NSString isNulllWithObject:[UserSignData share].user.walletZhujiciIdsArray])
//        {
//            [UserSignData share].user.walletZhujiciIdsArray = [[NSMutableArray alloc] init];
//        }
//        
//        if (![[UserSignData share].user.walletZhujiciIdsArray containsObject:@(self.model.id)])
//        {
//            [[UserSignData share].user.walletZhujiciIdsArray addObject:@(self.model.id)];
//            [[UserSignData share] storageData:[UserSignData share].user];
//        }
//        
//        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
//        //发送消息
//        [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"SurePackupsWordNotfi" object:@(YES) userInfo:nil]];
    }
    
}

#pragma mark - Public (.h 公共调用方法)


#pragma mark - Private (.m 私有方法)

- (void)initializeComponent {
    self.view.backgroundColor = WHITE_COLOR;
    
    _dataArray = [NSMutableArray array];
    [self loaderData];
    
    CCTagCollectionLayout *layout = [[CCTagCollectionLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing = 8;//列
    layout.minimumLineSpacing = 10;

    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero  collectionViewLayout:layout];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kLabelSelectionCellIdentifier];
    [_collectionView registerClass:[CCTagSelectSectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kLabelSelectionHeaderIdentifier];
    [self.view addSubview:_collectionView];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(-75);
    }];
}


- (void)loaderData {
    //创建空的组模型;选中的标签
    SectionModel *section0 = [[SectionModel alloc] init];
    section0.userInfo = [NSNumber numberWithInteger:0];//选中的标签
    section0.title = DBHGetStringWithKeyFromTable(@"Prepare mnemonics for selecting records in order", nil);
    section0.mutableCells = [NSMutableArray array];
    
    //全部标签
    SectionModel *section1 = [[SectionModel alloc] init];
    section1.userInfo = [NSNumber numberWithInteger:1];//全部标签
    section1.title = @"";
    section1.mutableCells = [NSMutableArray array];
    
    [_dataArray addObject:section0];
    [_dataArray addObject:section1];
    
    //tennis bid bracket grape unlock acoustic abuse huge october witness battle foster first basic reason myth fiscal train favorite leaf theme version spirit despair
    
    NSArray *listItems = [self.mnemonic componentsSeparatedByString:@" "];
    
    // 对数组乱序
    listItems = [listItems sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
        int seed = arc4random_uniform(2);
        
        if (seed) {
            return [str1 compare:str2];
        } else {
            return [str2 compare:str1];
        }
    }];
    NSMutableArray * tags = [[NSMutableArray alloc] init];
    
    for (int i = 1; i <= listItems.count; i ++)
    {
        NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
        [parametersDic setObject:@(i) forKey:@"id"];
        [parametersDic setObject:listItems[i - 1] forKey:@"title"];
        [parametersDic setObject:@"0" forKey:@"isSelect"];
        
        [tags addObject:parametersDic];
    }
    
    for (NSDictionary * dic in tags)
    {
        CCTagModel *model = [[CCTagModel alloc] initWithDictionary:dic];
        if (model.isSelect)
        {
            [section0.mutableCells addObject:model];
        }
        else
        {
            [section1.mutableCells addObject:model];
        }
    }
    [self.collectionView reloadData];
    
}


#pragma mark - Deletate/DataSource (相关代理)

#pragma -mark collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    SectionModel *s = _dataArray[section];
    return s.mutableCells.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SectionModel *s = _dataArray[indexPath.section];
    NSMutableArray *array = s.mutableCells;
    CCTagModel *tagModel = array[indexPath.row];
    if(!tagModel.title) {
        return CGSizeMake(1, 1);
    }
    
    CGFloat width = [tagModel.title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}].width;
    if(width > CGRectGetWidth(collectionView.frame) / 2)  {
        width = CGRectGetWidth(collectionView.frame) / 2;
    }
    
    CGFloat wid = (SCREEN_WIDTH - 30 - 7 * 8) / 8;
    
    if (width < wid) {
        return CGSizeMake(wid, wid);
    }
    return CGSizeMake(width + 10, wid);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGSize size = CGSizeMake(SCREEN_WIDTH - 30, 120);
    return size;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CCTagSelectSectionHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kLabelSelectionHeaderIdentifier forIndexPath:indexPath];
    SectionModel *s = _dataArray[indexPath.section];
    
    UILabel *titleLabel = view.titleLabel;
    titleLabel.text = s.title;
    return view;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLabelSelectionCellIdentifier forIndexPath:indexPath];
    UIView *backgroundView = cell.backgroundView;
    if(!backgroundView) {
        UILabel *ltView = [[UILabel alloc] initWithFrame:cell.bounds];
        ltView.layer.masksToBounds = YES;
        
        backgroundView = ltView;
        cell.backgroundView = backgroundView;
    }
    SectionModel *s = _dataArray[indexPath.section];
    NSMutableArray *array = s.mutableCells;
    CCTagModel *tagModel = array[indexPath.row];
    
    UILabel *titleView = (UILabel*)backgroundView;
    titleView.frame = cell.bounds;
    titleView.font = [UIFont systemFontOfSize:13];
    titleView.text = tagModel.title;
    titleView.layer.cornerRadius = 3;
    titleView.textAlignment = NSTextAlignmentCenter;
    
    titleView.textColor = COLORFROM16(0x333333, 1);
    titleView.backgroundColor = WHITE_COLOR;
 
    [titleView.layer setBorderWidth:AUTOLAYOUTSIZE(1.0)]; // 边框宽度
    titleView.layer.borderColor = [UIColor colorWithHexString:@"008C55"].CGColor;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SectionModel *sectionModel = _dataArray[indexPath.section];
    NSMutableArray *array = sectionModel.mutableCells;
    CCTagModel *tagModel = array[indexPath.row];
    
    if([sectionModel.userInfo isEqual:[NSNumber numberWithInteger:0]]) {
        
        if(tagModel.id && tagModel.title) {
            SectionModel *s;
            NSIndexPath *targetIndexPath;
            
            s = _dataArray[1];
            targetIndexPath = [NSIndexPath indexPathForRow:s.mutableCells.count inSection:1];
            [s.mutableCells addObject:tagModel];
            [array removeObjectAtIndex:indexPath.row];
            [collectionView moveItemAtIndexPath:indexPath toIndexPath:targetIndexPath];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_collectionView reloadData];
            });
        }
    }
    else
    {
        SectionModel *s0 = _dataArray[0];
        [s0.mutableCells insertObject:tagModel atIndex:s0.mutableCells.count];
        [array removeObjectAtIndex:indexPath.row];
        NSIndexPath *targetIndexPath = [NSIndexPath indexPathForRow:s0.mutableCells.count-1 inSection:0];
        [collectionView moveItemAtIndexPath:indexPath toIndexPath:targetIndexPath];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_collectionView reloadData];
        });
    }
}


#pragma mark - Setter/Getter

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
