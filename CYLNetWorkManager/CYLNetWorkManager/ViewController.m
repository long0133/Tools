//
//  ViewController.m
//  CYLNetWorkManager
//
//  Created by chinapex on 2018/3/29.
//  Copyright © 2018年 chinapex. All rights reserved.
//

#import "ViewController.h"
#import "CYLGetTypeApi.h"
#import "CYLTypeReformer.h"

@interface ViewController ()<CYLApiBaseManagerDelegate>
@property (nonatomic, strong) id<ReformerProtocol> reformer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _reformer = [CYLTypeReformer new];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CYLGetTypeApi *api =  [[CYLGetTypeApi alloc] init];
    api.delegate = self;
    [api callApi];
    
}

- (void)callApiDidSuccess:(CYLApiBaseManager *)apiManager{
    id t = [apiManager fetchDataWithReformer:_reformer];
    NSLog(@"%@",[apiManager class]);
}

- (void)callApiDidFailed:(NSError *)error{
    NSLog(@"call failed");
}


@end
