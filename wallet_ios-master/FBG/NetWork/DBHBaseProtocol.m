//
//  DBHBaseProtocol.m
//  FBG
//
//  Created by yy on 2018/3/10.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#define IP_ADDRESS_FROM_HOSTNAME @"ip_address_from_%@"
#define DEFAULT_REPLACE_IP @""

#include <sys/socket.h>
#include <netdb.h>
#include <sys/socket.h>
#include <arpa/inet.h>

#import "DBHBaseProtocol.h"
#import "AFNetworking.h"
#import "DBHLanguageTool.h"

@implementation DBHBaseProtocol

/**
 将dic转成json字符串

 @param dic dic
 @return jsonstr
 */
- (NSString *)JSONString:(NSDictionary *)dic {
    NSError *parseError = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:kNilOptions error:&parseError];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

/**
 根据hostName获取主机IP

 @param hostName hostname
 @return ip
 */
+ (NSString *)getIPWithHostName:(const NSString *)hostName {
    const char* szname = [hostName UTF8String];
    struct hostent* phot;
    @try {
        phot = gethostbyname(szname);
        if (phot == NULL) {
            return nil;
        }
    } @catch (NSException * e) {
        return nil;
    }
    
    struct in_addr ip_addr;
    memcpy(&ip_addr,phot->h_addr_list[0],4);///h_addr_list[0]里4个字节,每个字节8位，此处为一个数组，一个域名对应多个ip地址或者本地时一个机器有多个网卡
    
    char ip[20] = {0};
    inet_ntop(AF_INET, &ip_addr, ip, sizeof(ip));
    
    NSString* strIPAddress = [NSString stringWithUTF8String:ip];
    return strIPAddress;
}


/**
 替换url为主机IP

 @param target url
 @return 替换后的
 
 备注： 如果要用，需先设置 DEFAULT_REPLACE_IP 的值
 */
- (NSString *)getReplacedUrlByUrl:(NSString *)target {
    @autoreleasepool {
        if ([NSObject isNulllWithObject:target]) {
            return nil;
        }
        
        NSString *hostName = [NSURL URLWithString:target].host;
        NSString *key = [NSString stringWithFormat:IP_ADDRESS_FROM_HOSTNAME, hostName];
        NSString *ip = [[NSUserDefaults standardUserDefaults] stringForKey:key];
        //如果本地取出的IP为空
        if ([NSObject isNulllWithObject:ip]) {
            ip = [DBHBaseProtocol getIPWithHostName:hostName];
            
            if ([NSObject isNulllWithObject:ip]) {
                ip = DEFAULT_REPLACE_IP;
            } else {
                [[NSUserDefaults standardUserDefaults] setObject:ip ? ip : @"" forKey:key];
            }
        }
        if (![NSObject isNulllWithObject:hostName] && ![NSObject isNulllWithObject:ip]){
            NSString *addr = [target stringByReplacingOccurrencesOfString:hostName withString:ip];
            return addr;
        }
        
        return @"";
    }
}

/**
 创建并设置sessionManager

 @param baseUrlType baseUrlType
 @return manager
 */
+ (AFHTTPSessionManager *)sessionManagerWithBaseUrlType:(NSInteger)baseUrlType {
    NSString *baseUrl;
    switch (baseUrlType) {
        case 1:
            baseUrl = [APP_APIEHEAD isEqualToString:APIEHEAD1] ? APIEHEAD1 : TESTAPIEHEAD1;
            break;
        case 2:
            baseUrl = [APP_APIEHEAD isEqualToString:APIEHEAD1] ? APIEHEAD2 : TESTAPIEHEAD2;
            break;
        default:
            baseUrl = [APP_APIEHEAD isEqualToString:APIEHEAD1] ? APIEHEAD3 : TESTAPIEHEAD3;
            break;
    }
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 60.f; //设置请求的超时时间

    //设置服务器返回结果的类型:JSON
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"application/json",
                                                         @"application/x-www-form-urlencoded",
                                                         @"text/json",
                                                         @"text/javascript",
                                                         @"text/html",
                                                         @"text/plain",
                                                         nil];
    [manager.requestSerializer setValue:[[DBHLanguageTool sharedInstance].language isEqualToString:CNS] ? @"zh" : @"en" forHTTPHeaderField:@"lang"];
    if ([UserSignData share].user.token.length > 0) {
        [manager.requestSerializer setValue:[UserSignData share].user.token forHTTPHeaderField:@"Authorization"];
        [manager.requestSerializer setValue:@"0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b" forHTTPHeaderField:@"neo-asset-id"];
        [manager.requestSerializer setValue:@"0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7" forHTTPHeaderField:@"neo-gas-asset-id"];
    }
    return manager;
}


+ (void)sendGetData {
//    AFHTTPSessionManager *manager =  TODO
}
@end
