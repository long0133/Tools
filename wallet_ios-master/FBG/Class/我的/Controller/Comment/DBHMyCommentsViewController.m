//
//  DBHMyCommentsViewController.m
//  FBG
//
//  Created by yy on 2018/4/3.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHMyCommentsViewController.h"
#import "DBHMyCommentsTableViewCell.h"
#import "DBHCommentSendSuccessViewController.h"
#import "DBHBaseNavigationController.h"
#import "DBHProjectCommentModel.h"

@interface DBHMyCommentsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation DBHMyCommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    [self getData];
}

- (void)setUI {
    self.title = DBHGetStringWithKeyFromTable(@"Commented Project", nil);
    self.view.backgroundColor = COLORFROM16(0xF8F8F8, 1);
}

- (void)getData {
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        WEAKSELF
        [PPNetworkHelper GET:@"user/category/comment" baseUrlType:3 parameters:nil hudString:DBHGetStringWithKeyFromTable(@"Loading...", nil) responseCache:^(id responseCache) {
            [weakSelf handleResponse:responseCache];
        } success:^(id responseObject) {
            [weakSelf handleResponse:responseObject];
        } failure:^(NSString *error) {
            [LCProgressHUD showFailure:error];
        } specialBlock:nil];
    });
}

- (void)handleResponse:(id)responseObj {
    if ([NSObject isNulllWithObject:responseObj]) {
        return;
    }
    
    if ([responseObj isKindOfClass:[NSArray class]]) {
        NSMutableArray *tempArr = [NSMutableArray array];
        for (NSDictionary *dict in responseObj) {
            @autoreleasepool {
                DBHProjectCommentModel *model = [DBHProjectCommentModel mj_objectWithKeyValues:dict];
                [tempArr addObject:model];
            }
        }
        
        self.dataSource = tempArr;
    }
}

#pragma mark ---- tableview -------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    DBHMyCommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MYCOMMENTS_CELL_ID forIndexPath:indexPath];
    if (row < self.dataSource.count) {
        cell.model = self.dataSource[row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSInteger row = indexPath.row;
    DBHProjectCommentModel *model = nil;
    if (row < self.dataSource.count) {
        model = self.dataSource[row];
    }
    [self performSelectorOnMainThread:@selector(pushToSendSuccessVC:) withObject:model waitUntilDone:NO];
}

- (void)pushToSendSuccessVC:(DBHProjectCommentModel *)model {
    DBHCommentSendSuccessViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:COMMENTSENDSUCCESS_STORYBOARD_ID];
    DBHBaseNavigationController *nav = [[DBHBaseNavigationController alloc] initWithRootViewController:vc];
    vc.title = DBHGetStringWithKeyFromTable(@"My Comment", nil);
    vc.model = model;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    
    [self.tableView reloadData];
}
@end
