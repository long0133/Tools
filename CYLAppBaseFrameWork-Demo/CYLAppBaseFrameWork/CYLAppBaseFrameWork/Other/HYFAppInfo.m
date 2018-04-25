//
//  HYFAppInfo.m
//  ZJbirdWorker
//
//  Created by 黄驿峰 on 2017/7/12.
//  Copyright © 2017年 黄驿峰. All rights reserved.
//

#import "HYFAppInfo.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <sys/utsname.h>
#import <sys/stat.h>
#import <mach-o/dyld.h>
#import <mach-o/dyld_images.h>

@implementation HYFAppInfo



//appBundle信息
+ (NSString *)appBundle{
    return [[NSBundle mainBundle] bundleIdentifier];
}

//app 显示名称
+ (NSString *)appName{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];

}

//app版本
+ (NSString *)appVersion{
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (!appVersion || [appVersion length] == 0) {
        appVersion = @"0.0.0";
    }
    return appVersion;
}

//appBuild版本
+ (NSString *)appBuild{
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    if (!appVersion || [appVersion length] == 0) {
        appVersion = @"0.0";
    }
    return appVersion;
}

//app渠道信息
+ (NSString *)appChannelID{
    NSString *configPlistPath = [[NSBundle mainBundle]pathForResource:@"channel" ofType:@"plist"];
    NSDictionary *config = [[NSDictionary alloc]initWithContentsOfFile:configPlistPath];
    NSString *channelId = config[@"channelId"];
    if (!channelId) {
        channelId = @"未设置";
    }
    return channelId;
}

+ (BOOL)fileExistInMainBundle:(NSString *)name {
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *path = [NSString stringWithFormat:@"%@/%@", bundlePath, name];
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

/// Whether this app is pirated (not install from appstore).
+ (BOOL)isPirated{
    if ([self isSimulator]) return YES; // Simulator is not from appstore
    
    if (getgid() <= 10) return YES; // process ID shouldn't be root
    
    if ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"SignerIdentity"]) {
        return YES;
    }
    
    if (![self fileExistInMainBundle:@"_CodeSignature"]) {
        return YES;
    }
    
    if (![self fileExistInMainBundle:@"SC_Info"]) {
        return YES;
    }
    
    //if someone really want to crack your app, this method is useless..
    //you may change this method's name, encrypt the code and do more check..
    return NO;
}


+ (BOOL)isDebug{
#ifdef DEBUG
    return YES;
#else
    return NO;
#endif
}
/// Whether the device is a simulator.

# pragma mark - Device Info

+ (NSString *)uuid{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return (__bridge_transfer NSString *)string;
}

//ip地址
+ (NSString *)localIPAddress{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

//基站IP
+ (NSString *)cellIPAddress{
    NSString *address = nil;
    struct ifaddrs *addrs = NULL;
    if (getifaddrs(&addrs) == 0) {
        struct ifaddrs *addr = addrs;
        while (addr != NULL) {
            if (addr->ifa_addr->sa_family == AF_INET) {
                if ([[NSString stringWithUTF8String:addr->ifa_name] isEqualToString:@"pdp_ip0"]) {
                    address = [NSString stringWithUTF8String:
                               inet_ntoa(((struct sockaddr_in *)addr->ifa_addr)->sin_addr)];
                    break;
                }
            }
            addr = addr->ifa_next;
        }
    }
    freeifaddrs(addrs);
    return address;
}

+ (NSString *)iosVersion {
    UIDevice *device = [UIDevice currentDevice];
    return [device systemVersion];
}

+ (NSString *)iosModel {
    UIDevice *device = [UIDevice currentDevice];
    return [device model];
}

+ (UIDeviceBatteryState)batteryState {
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    
    return [[UIDevice currentDevice] batteryState];
}
//设备大小
+ (NSString *)totalDiskspace {
    uint64_t totalSpace = 0;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        totalSpace = [fileSystemSizeInBytes unsignedLongLongValue];
    }
    
    return [NSString stringWithFormat:@"%llu", ((totalSpace/1024ll)/1024ll)];
}

//剩余空间
+ (NSString *)freeDiskspace {
    uint64_t totalFreeSpace = 0;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary) {
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalFreeSpace = [freeFileSystemSizeInBytes unsignedLongLongValue];
    }
    
    return [NSString stringWithFormat:@"%llu", ((totalFreeSpace/1024ll)/1024ll)];
}
//具体设备
+ (NSString *)machineType;
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *machineType = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return machineType;
}




///是不是模拟器
+ (BOOL)isSimulator{
#if TARGET_OS_SIMULATOR
    return YES;
#else
    return NO;
#endif
}

/// Whether the device is jailbroken.
+ (BOOL)isJailbroken {
    if ([self isSimulator]) return NO; // Dont't check simulator
    
    // iOS9 URL Scheme query changed ...
    // NSURL *cydiaURL = [NSURL URLWithString:@"cydia://package"];
    // if ([[UIApplication sharedApplication] canOpenURL:cydiaURL]) return YES;
    
    NSArray *paths = @[@"/Applications/Cydia.app",
                       @"/private/var/lib/apt/",
                       @"/private/var/lib/cydia",
                       @"/private/var/stash"];
    for (NSString *path in paths) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) return YES;
    }
    
    FILE *bash = fopen("/bin/bash", "r");
    if (bash != NULL) {
        fclose(bash);
        return YES;
    }
    
    NSString *path = [NSString stringWithFormat:@"/private/%@", [self uuid]];
    if ([@"test" writeToFile : path atomically : YES encoding : NSUTF8StringEncoding error : NULL]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        return YES;
    }
    
    for (int i = 0; i < _dyld_image_count(); i ++) {
        if (strstr(_dyld_get_image_name(i), "MobileSubstrate") != nil) {
            return YES;
        }
    }
    
    return NO;
}





/// The device's machine model name. e.g. "iPhone 5s" "iPad mini 2"
/// @see http://theiphonewiki.com/wiki/Models
+ (NSString *)machineModelName {
    static dispatch_once_t one;
    static NSString *name;
    dispatch_once(&one, ^{
        NSString *model = [self machineType];
        if (!model) return;
        NSDictionary *dic = @{
                              @"Watch1,1" : @"Apple Watch",
                              @"Watch1,2" : @"Apple Watch",
                              
                              @"iPod1,1" : @"iPod touch 1",
                              @"iPod2,1" : @"iPod touch 2",
                              @"iPod3,1" : @"iPod touch 3",
                              @"iPod4,1" : @"iPod touch 4",
                              @"iPod5,1" : @"iPod touch 5",
                              @"iPod7,1" : @"iPod touch 6",
                              
                              @"iPhone1,1"   : @"iPhone 1G",
                              @"iPhone1,2"   : @"iPhone 3G",
                              @"iPhone2,1"   : @"iPhone 3GS",
                              @"iPhone3,1"   : @"iPhone 4 (GSM)",
                              @"iPhone3,2"   : @"iPhone 4",
                              @"iPhone3,3"   : @"iPhone 4 (CDMA)",
                              @"iPhone4,1"   : @"iPhone 4S",
                              @"iPhone5,1"   : @"iPhone 5",
                              @"iPhone5,2"   : @"iPhone 5",
                              @"iPhone5,3"   : @"iPhone 5c",
                              @"iPhone5,4"   : @"iPhone 5c",
                              @"iPhone6,1"   : @"iPhone 5s",
                              @"iPhone6,2"   : @"iPhone 5s",
                              @"iPhone7,1"   : @"iPhone 6 Plus",
                              @"iPhone7,2"   : @"iPhone 6",
                              @"iPhone8,1"   : @"iPhone 6s",
                              @"iPhone8,2"   : @"iPhone 6s Plus",
                              @"iPhone8,4"   : @"iPhone SE",
                              @"iPhone9,1"   : @"iPhone 7",
                              @"iPhone9,2"   : @"iPhone 7 Plus",
                              @"iPhone9,3"   : @"iPhone 7",
                              @"iPhone9,4"   : @"iPhone 7 Plus",
                              @"iPhone10,1"  : @"iPhone 8",
                              @"iPhone10,2"  : @"iPhone 8 Plus",
                              @"iPhone10,3"  : @"iPhone X",
                              @"iPhone10,4"  : @"iPhone 8",
                              @"iPhone10,5"  : @"iPhone 8 Plus",
                              @"iPhone10,6"  : @"iPhone X",
                              
                              @"iPad1,1"   : @"iPad 1",
                              @"iPad2,1"   : @"iPad 2 (WiFi)",
                              @"iPad2,2"   : @"iPad 2 (GSM)",
                              @"iPad2,3"   : @"iPad 2 (CDMA)",
                              @"iPad2,4"   : @"iPad 2",
                              @"iPad2,5"   : @"iPad mini 1",
                              @"iPad2,6"   : @"iPad mini 1",
                              @"iPad2,7"   : @"iPad mini 1",
                              @"iPad3,1"   : @"iPad 3 (WiFi)",
                              @"iPad3,2"   : @"iPad 3 (4G)",
                              @"iPad3,3"   : @"iPad 3 (4G)",
                              @"iPad3,4"   : @"iPad 4",
                              @"iPad3,5"   : @"iPad 4",
                              @"iPad3,6"   : @"iPad 4",
                              @"iPad4,1"   : @"iPad Air",
                              @"iPad4,2"   : @"iPad Air",
                              @"iPad4,3"   : @"iPad Air",
                              @"iPad4,4"   : @"iPad mini 2",
                              @"iPad4,5"   : @"iPad mini 2",
                              @"iPad4,6"   : @"iPad mini 2",
                              @"iPad4,7"   : @"iPad mini 3",
                              @"iPad4,8"   : @"iPad mini 3",
                              @"iPad4,9"   : @"iPad mini 3",
                              @"iPad5,1"   : @"iPad mini 4",
                              @"iPad5,2"   : @"iPad mini 4",
                              @"iPad5,3"   : @"iPad Air 2",
                              @"iPad5,4"   : @"iPad Air 2",
                              @"iPad6,3"   : @"iPad Pro(9.7)",
                              @"iPad6,4"   : @"iPad Pro(9.7)",
                              @"iPad6,7"   : @"iPad Pro(12.9)",
                              @"iPad6,8"   : @"iPad Pro(12,9)",
                              @"iPad6,11"  : @"iPad (9.7)",
                              @"iPad6,12"  : @"iPad (9.7)",
                              @"iPad7,1"   : @"iPad Pro 2(12.9)",
                              @"iPad7,2"   : @"iPad Pro 2(12.9)",
                              @"iPad7,3"   : @"iPad Pro 2(10.5)",
                              @"iPad7,4"   : @"iPad Pro 2(10.5)",
                              
                              @"i386"   : @"Simulator x86",
                              @"x86_64" : @"Simulator x64",
                              };
        name = dic[model];
        if (!name) name = model;
    });
    return name;
}


@end
