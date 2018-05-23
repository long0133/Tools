//
//  DBHCommentDetailViewController.m
//  FBG
//
//  Created by yy on 2018/4/4.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHCommentDetailViewController.h"
#import "DBHPlaceHolderTextView.h"
#import "DBHCommentHeaderView.h"
#import "DBHCommentListTableViewCell.h"
#import "DBHProjectCommentModel.h"
#import "DBHProjectCommentDetailModel.h"
#import "DBHProjectCommentAllListModel.h"
#import "DBHCommentDetailTableViewCell.h"

@interface DBHCommentDetailViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *commentsDatasource;
@property (weak, nonatomic) IBOutlet DBHPlaceHolderTextView *textView;
@property (nonatomic, assign) BOOL isRequested;

@end

@implementation DBHCommentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}

- (void)setUI {
    self.view.backgroundColor = COLORFROM16(0xF8F8F8, 1);
    self.title = DBHGetStringWithKeyFromTable(@" Detail ", nil);
    
    self.textView.placeholder = DBHGetStringWithKeyFromTable(@" Comment ", nil);
    self.textView.placeholderColor = COLORFROM16(0xB6B6B6, 1);
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DBHCommentListTableViewCell class]) bundle:nil] forCellReuseIdentifier:COMMENT_LIST_CELL_ID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DBHCommentDetailTableViewCell class]) bundle:nil] forCellReuseIdentifier:COMMENT_DETAIL_CELL_ID];
}

#pragma mark ---- data -----
- (void)getData:(NSString *)urlStr urlType:(int)urlType {
    self.isRequested = YES;
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        WEAKSELF
        [PPNetworkHelper GET:urlStr baseUrlType:3 parameters:nil hudString:DBHGetStringWithKeyFromTable(@"Loading...", nil) responseCache:^(id responseCache) {
            [weakSelf handleResponse:responseCache urlType:urlType];
        } success:^(id responseObject) {
            [weakSelf handleResponse:responseObject urlType:urlType];
        } failure:^(NSString *error) {
            [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"Load failed", nil)];
        } specialBlock:nil];
    });
}

- (void)handleResponse:(id)responseObj urlType:(int)urlType {
    if ([NSObject isNulllWithObject:responseObj]) {
        return;
    }
    
    if ([responseObj isKindOfClass:[NSDictionary class]]) {
        if (urlType == 5) { // 2.10.5
            DBHProjectCommentDetailModel *model = [DBHProjectCommentDetailModel mj_objectWithKeyValues:responseObj];
            self.detailModel = model;
        } else if (urlType == 6) { // 2.10.6
            DBHProjectCommentAllListModel *listModel = [DBHProjectCommentAllListModel mj_objectWithKeyValues:responseObj];
            NSArray *datas = listModel.data;
            if (datas.count > 0) {
                NSMutableArray *tempArr = [NSMutableArray array];
                for (DBHProjectCommentAllListDetailModel *detail in datas) {
                    [tempArr addObject:detail];
                }
                self.commentsDatasource = tempArr;
            }
        }
    }
}

- (void)sendComment:(NSString *)comment {
    if (comment.length == 0) {
        [LCProgressHUD showInfoMsg:DBHGetStringWithKeyFromTable(@"Content cannot be empty", nil)];
        return;
    }
    
    NSString *commentUrlStr = [NSString stringWithFormat:@"category/%ld/comment/%ld/reply", self.detailModel.category_id, self.detailModel.commentId];
    NSDictionary *params = @{@"content" : comment};
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        WEAKSELF
        [PPNetworkHelper POST:commentUrlStr baseUrlType:3 parameters:params hudString:DBHGetStringWithKeyFromTable(@"Sending...", nil) success:^(id responseObject) {
            weakSelf.textView.text = nil;
            [LCProgressHUD showSuccess:DBHGetStringWithKeyFromTable(@"Send successfully", nil)];
            [weakSelf getData:commentUrlStr urlType:6];
            
            NSString *urlStr = [NSString stringWithFormat:@"category/%ld/comment/%ld", self.detailModel.category_id, self.detailModel.commentId];
            [weakSelf getData:urlStr urlType:5];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:COMMENT_HAS_CHANGED object:nil];
        } failure:^(NSString *error) {
            [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"Send failed", nil)];
        }];
    });
}

#pragma mark ----- tableview ---------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.commentsDatasource.count > 0) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    
    return self.commentsDatasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (section == 0) {
        DBHCommentDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:COMMENT_DETAIL_CELL_ID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.from = CellFromDetail;
        cell.model = self.model;
        if (self.detailModel) {
            cell.detailModel = self.detailModel;
        }
        return cell;
    }
    
    NSInteger row = indexPath.row;
    DBHCommentListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:COMMENT_LIST_CELL_ID forIndexPath:indexPath];
    if (row < self.commentsDatasource.count) {
        DBHProjectCommentAllListDetailModel *model = self.commentsDatasource[row];
        cell.model = model;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    
    DBHCommentHeaderView *headerView = [[DBHCommentHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), AUTOLAYOUTSIZE(60))];
    headerView.count = self.commentsDatasource.count;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }
    return AUTOLAYOUTSIZE(60);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (section == 0) {
        return self.detailModel.height;
    }
    
    NSInteger row = indexPath.row;
    if (row < self.commentsDatasource.count) {
        DBHProjectCommentAllListDetailModel *model = self.commentsDatasource[row];
        return model.height;
    }
    return AUTOLAYOUTSIZE(100);
}

#pragma mark ---- UITextView Delegate ------
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [self.view endEditing:YES];
        [self sendComment:textView.text];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

#pragma mark ---- getters  and setter ------
- (void)setDetailModel:(DBHProjectCommentDetailModel *)detailModel {
    _detailModel = detailModel;
    
    if (!self.isRequested) {
        NSString *urlStr = [NSString stringWithFormat:@"category/%ld/comment/%ld", self.detailModel.category_id, self.detailModel.commentId];
        [self getData:urlStr urlType:5];
        
        NSString *commentUrlStr = [NSString stringWithFormat:@"category/%ld/comment/%ld/reply", self.detailModel.category_id, self.detailModel.commentId];
        [self getData:commentUrlStr urlType:6];
    } else {
        [self.tableView reloadData];
    }
}

- (void)setModel:(DBHProjectCommentModel *)model {
    _model = model;
    
    NSString *urlStr = [NSString stringWithFormat:@"category/%ld/comment/%ld", self.model.category_id, self.model.commentId];
    [self getData:urlStr urlType:5];
    
    NSString *commentUrlStr = [NSString stringWithFormat:@"category/%ld/comment/%ld/reply", self.model.category_id, self.model.commentId];
    [self getData:commentUrlStr urlType:6];
}

- (void)setCommentsDatasource:(NSMutableArray *)commentsDatasource {
    _commentsDatasource = commentsDatasource;
    
    [self.tableView reloadData];
}

@end
