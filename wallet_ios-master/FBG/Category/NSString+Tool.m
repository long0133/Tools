//
//  NSString+Tool.m
//  Tool
//
//  Created by mac on 17/3/24.
//  Copyright © 2017年 lykj. All rights reserved.
//

#import "NSString+Tool.h"
#import <CommonCrypto/CommonDigest.h>
#import <CoreText/CoreText.h>
#import "NSDecimalNumber+Addtion.h"
#import <sys/utsname.h>
#import "NSDateFormatter+Category.h"
#import "JKBigDecimal.h"

@implementation NSString (Tool)

/**
 处理URL中含有空格和中文的情况

 @return 处理后的str
 */
- (NSString *)URLEncodedString {
    NSCharacterSet *encodeUrlSet = [NSCharacterSet URLQueryAllowedCharacterSet];
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    NSString *encodedString = (__bridge NSString *)
//    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
//                                            (CFStringRef)self,
//                                            (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
//                                            NULL,
//                                            kCFStringEncodingUTF8);
//    return encodedString;
//    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
//                                                                                                    (CFStringRef)self,
//                                                                                                    NULL,
//                                                                                                    (CFStringRef)@"!*'();:@&=+$,/?%#[]",
//                                                                                                    kCFStringEncodingUTF8));
//    NSString *encodedString = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    return encodedString;
}


//当前时间
+ (NSString *)nowDate
{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}

//明天
+ (NSString *)nextDate
{
    NSDate * date = [NSDate date];//当前时间
    // NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:date];//前一天
    NSDate *nextDay = [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];//后一天
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:nextDay];
    return dateString;
}


//时间格式转换
/*
 G:         公元时代，例如AD公元
 yy:     年的后2位
 yyyy:     完整年
 MM:     月，显示为1-12,带前置0
 MMM:     月，显示为英文月份简写,如 Jan
 MMMM:     月，显示为英文月份全称，如 Janualy
 dd:     日，2位数表示，如02
 d:         日，1-2位显示，如2，无前置0
 EEE:     简写星期几，如Sun
 EEEE:     全写星期几，如Sunday
 aa:     上下午，AM/PM
 H:         时，24小时制，0-23
 HH:     时，24小时制，带前置0
 h:         时，12小时制，无前置0
 hh:     时，12小时制，带前置0
 m:         分，1-2位
 mm:     分，2位，带前置0
 s:         秒，1-2位
 ss:     秒，2位，带前置0
 S:         毫秒
 Z：        GMT（时区）
 
yy-MM-dd HH:mm:ss
 */
+ (NSString *)timeExchangeWithType:(NSString *)type timestamp:(long long)timestamp
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString * dateNow = [formatter stringFromDate:[NSDate date]];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:[[dateNow substringWithRange:NSMakeRange(8,2)] intValue]];
    [components setMonth:[[dateNow substringWithRange:NSMakeRange(5,2)] intValue]];
    [components setYear:[[dateNow substringWithRange:NSMakeRange(0,4)] intValue]];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateFormatter *dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *messageDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)timestamp];
    return [dateFormatter stringFromDate:messageDate];
//    return ret;
//    //实例化一个NSDateFormatter对象
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    //设定时间格式,这里可以设置成自己需要的格式
//    [dateFormatter setDateFormat:type];
//    //用[NSDate date]可以获取系统当前时间
//    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)timestamp]];
//    return currentDateStr;
}


/**
 将UTC日期字符串转为本地时间字符串

 @param utcDate UTC日期字符串
 @return 本地时间字符串
 */
+ (NSString *)getLocalDateFormateUTCDate:(NSString *)utcDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:[utcDate containsString:@"."] ? @"yyyy-MM-dd HH:mm:ss.SSS" : @"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTimeZone];
    NSDate *dateFormatted = [dateFormatter dateFromString:utcDate];
    //输出格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
    return dateString;
}

//md5加密
- (NSString *)md5WithString
{
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (int)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return [NSString stringWithString:outputString];
}

//手机号码验证
+ (BOOL)isMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^1[3|4|5|7|8][0-9]\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat: @"SELF MATCHES %@",phoneRegex];
    BOOL isMatch = [phoneTest evaluateWithObject:mobile];
    return isMatch;
}

//邮箱
+ (BOOL)isEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", emailRegex];
    BOOL isMatch = [emailTest evaluateWithObject:email];
    return isMatch;
}

//验证码
+ (BOOL)isEmployeeNumber:(NSString *)number
{
    NSString *pattern = @"^[0-9]{6}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:number];
    return isMatch;
    
}

//金额
+ (BOOL)isMoneyNumber:(NSString *)number
{
    NSString *pattern = @"^[0-9]+(.[0-9]{4})?$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:number];
    return isMatch;
    
}

//正则匹配用户密码6-20位数字和字母组合
+ (BOOL)isPassword:(NSString *)password
{
    // 同时包含 数字 大、小写字母 特殊字符
//    NSString *pattern =@"^(?:(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[^A-Za-z0-9])).{10,20}$";
    //简单数字加字符判断
//    NSString *pattern =@"^[a-zA-Z0-9]{6,18}+$";
    NSString *pattern =@"^(?:(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])).{8,20}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
    
}

+ (BOOL)isAdress:(NSString *)adress
{
    if ([NSString isNulllWithObject:adress])
    {
        return NO;
    }
    if (![[adress substringToIndex:2] isEqualToString:@"0x"])
    {
        return NO;
    }
    NSString *regex = @"^[a-zA-Z0-9]{42}+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [predicate evaluateWithObject:adress];
    return isMatch;
}

+ (BOOL)isNEOAdress:(NSString *)adress
{
    if ([NSString isNulllWithObject:adress])
    {
        return NO;
    }
    NSString *regex = @"^[a-zA-Z0-9]{34}+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [predicate evaluateWithObject:adress];
    return isMatch;
}

//正则匹配用户昵称2-12位
+ (BOOL)isNickName:(NSString *)nickName
{
    NSString *pattern =@"^[\\u4e00-\\u9fa5_a-zA-Z0-9-]{2,12}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:nickName];
    return isMatch;
    
}

// 16进制 转10进制
+ (NSString *)numberHexString:(NSString *)aHexString
{
    JKBigInteger *int1 = [[JKBigInteger alloc] initWithString:aHexString andRadix:16];
    return [int1 stringValue];
}


// 10 进制转换16进制
+ (NSString *)getHexByDecimal:(NSInteger)decimal
{
    JKBigInteger *int1 = [[JKBigInteger alloc] initWithString:[NSString stringWithFormat:@"%ld",(long)decimal]];
    return [int1 stringValueWithRadix:16];
    
   /*
    NSString *hex =@"";
    NSString *letter;
    long long number;
    for (int i = 0; i < 9; i++) {
        number = decimal % 16;
        decimal = decimal / 16;
        switch (number) {
                
            case 10:
                letter =@"A"; break;
            case 11:
                letter =@"B"; break;
            case 12:
                letter =@"C"; break;
            case 13:
                letter =@"D"; break;
            case 14:
                letter =@"E"; break;
            case 15:
                letter =@"F"; break;
            default:
                letter = [NSString stringWithFormat:@"%lld", number];
        }
        hex = [letter stringByAppendingString:hex];
        if (decimal == 0) {
            
            break;
        }
    }
    return hex;
    */
}

+ (NSString *)stringFromHexStr:(NSString *)hexStr {
    if ([NSObject isNulllWithObject:hexStr]) {
        return @"0";
    }
    
    JKBigDecimal *resultDecimal = [[JKBigDecimal alloc] init];
    NSString *upperHex = hexStr.uppercaseString;
    
    if ([upperHex containsString:@" "]) {
        upperHex = [upperHex stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
 
    if (upperHex.length > 2) {
        if ([upperHex hasPrefix:@"0X"]) {
            upperHex = [upperHex substringFromIndex:2];
        }
    }
    
    int strLen = (int)upperHex.length;
    for (int i = 0; i < strLen; ++ i) {
        @autoreleasepool {
            unichar ch = [upperHex characterAtIndex:strLen - 1 - i];
            @try {
                NSString *cStr = [NSString stringWithFormat:@"%c", ch];
                JKBigInteger *bigInteger = [[JKBigInteger alloc] initWithString:cStr andRadix:16];
                JKBigDecimal *tempDecimal = [[JKBigDecimal alloc] initWithBigInteger:bigInteger figure:0];
                
                double value = pow(16, i);
                NSString *valueStr = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@", @(value)]].stringValue;
                
                JKBigInteger *sixteen = [[JKBigInteger alloc] initWithString:valueStr];
                JKBigDecimal *sixteenDecimal = [[JKBigDecimal alloc] initWithBigInteger:sixteen figure:0];
                
                resultDecimal = [resultDecimal add:[tempDecimal multiply:sixteenDecimal]];
                //            NSLog(@"result = %@---temp %@ * six %@ + before %@  = %@", resultDecimal.stringValue, tempDecimal.stringValue, sixteenDecimal.stringValue, @(beforeValue), @(tempDecimal.stringValue.doubleValue * sixteenDecimal.stringValue.doubleValue + beforeValue));
                //            NSLog(@"");
            } @catch (NSException *e) {
                //            NSLog(@"e = %@", e.description);
            }
        }
    }
    return resultDecimal.stringValue;
}

-(NSString *)ToHex:(long long int)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    long long int ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:nLetterValue=[[NSString alloc]initWithFormat:@"%i",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
        
    }
    return str;
} 

// data 转 json字符串
+ (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}

//data 转16
+ (NSString *)hexStringFromData:(NSData *)myD{
    
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    NSLog(@"hex = %@",hexStr);
    
    return hexStr;
}

/**
 保留小数点后几位

 @param price stirng
 @param position 位数
 @return 取小的数
 */
+ (NSString *)notRounding:(NSString *)price afterPoint:(int)position {
    NSDecimalNumberHandler * roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithString:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

- (NSArray *)componentsSeparatedFromString:(NSString *)fromString toString:(NSString *)toString {
    if (IsEmptyStr(fromString) || IsEmptyStr(toString)) {
        return nil;
    }
    NSMutableArray *subStringsArray = [[NSMutableArray alloc] init];
    NSString *tempString = self;
    NSRange range = [tempString rangeOfString:fromString];
    while (range.location != NSNotFound) {
        tempString = [tempString substringFromIndex:(range.location + range.length)];
        range = [tempString rangeOfString:toString];
        if (range.location != NSNotFound) {
            [subStringsArray addObject:[tempString substringToIndex:range.location]];
            range = [tempString rangeOfString:fromString];
        }
        else
        {
            break;
        }
    }
    return subStringsArray;
}

+ (NSString *)DecimalFuncWithOperatorType:(NSInteger)operatorType first:(id)first secend:(id)secend value:(int)value
{
    /*
    JKBigDecimal *firstValue = [[JKBigDecimal alloc] initWithString:[NSString stringWithFormat:@"%@",first]];
    JKBigDecimal *secendValue = [[JKBigDecimal alloc] initWithString:[NSString stringWithFormat:@"%@",secend]];
    
    JKBigDecimal *resultNumber = [[JKBigDecimal alloc] initWithString:@"0.0000"];
    switch (operatorType)
    {
        case 0:
            resultNumber = [firstValue add:secendValue];
            break;
        case 1:
            resultNumber = [firstValue subtract:secendValue];
            break;
        case 2:
            resultNumber = [firstValue multiply:secendValue];
            break;
        case 3:
            resultNumber = [firstValue divide:secendValue];
            break;
    }
    
    switch (value) {
        case 2:
        {
            return [NSString stringWithFormat:@"%.2f",[[resultNumber stringValue] floatValue]];
            break;
        }
        case 4:
        {
            return [NSString stringWithFormat:@"%.4f",[[resultNumber stringValue] floatValue]];
            break;
        }
        default:
            return [NSString stringWithFormat:@"%f",[[resultNumber stringValue] floatValue]];
            break;
    }
     */
    
    NSDecimalNumber *resultNumber = [[NSDecimalNumber alloc] initWithString:@"0"];
    
    if ([NSObject isNulllWithObject:first]) {
        first = @"0";
    }
    
    if ([first isKindOfClass:[NSNumber class]]) {
        first = [NSString stringWithFormat:@"%@", first];
    }
    
    
    @try {
        NSDecimalNumber *firstNumber = [[NSDecimalNumber alloc] initWithString:first];
        
        if ([NSObject isNulllWithObject:secend]) {
            secend = @"0";
        }
        
        if ([secend isKindOfClass:[NSNumber class]]) {
            secend = [NSString stringWithFormat:@"%@", secend];
        }
        
        NSDecimalNumber *secondNumber = [[NSDecimalNumber alloc] initWithString:secend];
        
        switch (operatorType)
        {
            case 0:
                //            resultNumber = SNAdd_handler(first, secend, NSRoundPlain, value);
                resultNumber = [firstNumber decimalNumberByAdding:secondNumber];
                
                break;
            case 1:
                //            resultNumber = SNSub_handler(first, secend, NSRoundPlain, value);
                resultNumber = [firstNumber decimalNumberBySubtracting:secondNumber];
                break;
            case 2:
                //            resultNumber = SNMul_handler(first, secend, NSRoundPlain, value);
                resultNumber = [firstNumber decimalNumberByMultiplyingBy:secondNumber];
                break;
            case 3: {
                //            resultNumber = SNDiv_handler(first, secend, NSRoundPlain, value);
                if (secondNumber.intValue == 0) {
                    return @"0";
                }
                resultNumber = [firstNumber decimalNumberByDividingBy:secondNumber];
                break;
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"e = %@", exception);
        resultNumber = @"0";
    }
     
    return resultNumber.stringValue;

}

+ (NSComparisonResult)DecimalFuncComparefirst:(NSString *)first secend:(NSString *)secend
{
    NSDecimalNumber * discount1 = [NSDecimalNumber decimalNumberWithString:first];
    NSDecimalNumber * discount2 = [NSDecimalNumber decimalNumberWithString:secend];
    NSComparisonResult result = [discount1 compare:discount2];
    return result;
}

//转换显示单位
+ (NSString *)getDealNumwithstring:(NSString *)string
{
    NSString *numberString = [NSString stringWithFormat:@"%@", string];
    NSDecimalNumber *numberA = [NSDecimalNumber decimalNumberWithString:numberString];
    NSDecimalNumber *numberB ;
    BOOL isEn = ![[DBHLanguageTool sharedInstance].language isEqualToString:CNS];
    if ([string intValue] < 10000) {
        numberB =  [NSDecimalNumber decimalNumberWithString:@"1"];
    } else if ([string intValue] >= 10000 && [string intValue] < 100000000) {
        if (isEn) {
            numberB =  [NSDecimalNumber decimalNumberWithString:@"1000000"];
        } else {
            numberB =  [NSDecimalNumber decimalNumberWithString:@"10000"];
        }
        
    } else {
        if (isEn) {
            numberB =  [NSDecimalNumber decimalNumberWithString:@"1000000000"]; // 10亿
        } else {
            numberB =  [NSDecimalNumber decimalNumberWithString:@"100000000"];
        }
    }
    //NSDecimalNumberBehaviors对象的创建  参数 1.RoundingMode 一个取舍枚举值 2.scale 处理范围 3.raiseOnExactness  精确出现异常是否抛出原因 4.raiseOnOverflow  上溢出是否抛出原因  4.raiseOnUnderflow  下溢出是否抛出原因  5.raiseOnDivideByZero  除以0是否抛出原因。
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    
    /// 这里不仅包含Multiply还有加 减 乘。
    NSDecimalNumber *numResult = [numberA decimalNumberByDividingBy:numberB withBehavior:roundingBehavior];
    NSString *strResult = [numResult stringValue];
    
    if ([string intValue] < 10000) {
        return strResult;
    } else if ([string intValue] >= 10000 && [string intValue] < 100000000) {
        if (isEn) {
            return [NSString stringWithFormat:@"%@Million", strResult];
        } else {
            return [NSString stringWithFormat:@"%@万", strResult];
        }
    } else {
        if (isEn) {
            return [NSString stringWithFormat:@"%@Billion", strResult];
        } else {
            return [NSString stringWithFormat:@"%@亿", strResult];
        }
    }
    
}

/**
 字典转NSString
 */
+ (NSString *)dataTOjsonString:(id)object {
    if (!object) {
        return @"";
    }
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

/**
 手机型号
 */
+ (NSString *)deviceType {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone9,1"] || [deviceString isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"] || [deviceString isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"] || [deviceString isEqualToString:@"iPhone10,4"])    return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"] || [deviceString isEqualToString:@"iPhone10,5"])    return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"] || [deviceString isEqualToString:@"iPhone10,6"])    return @"iPhone X";
    
    return deviceString;
}

//去掉html标签
+ (NSString *)flattenHTML:(NSString *)html {
    if (html.length <= 0) {
        return nil;
    }
    
    NSRegularExpression *regularExpretion = [NSRegularExpression regularExpressionWithPattern:@"<[^>]*>|" options:0 error:nil];
    NSString *str = [regularExpretion stringByReplacingMatchesInString:html options:NSMatchingReportProgress range:NSMakeRange(0, html.length) withTemplate:@""];//替换所有html和换行匹配元素为"-"
    
//    regularExpretion = [NSRegularExpression regularExpressionWithPattern:@"-{1,}" options:0 error:nil] ;
//    str = [regularExpretion stringByReplacingMatchesInString:str options:NSMatchingReportProgress range:NSMakeRange(0, str.length) withTemplate:@"-"];//把多个"-"匹配为一个"-"
    
    return str;
}

+ (NSString *)formatTimeDelayEight:(NSString *)timeStr {
    if ([NSObject isNulllWithObject:timeStr]) {
        return @"";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:timeStr];
    
    NSDate *newDate = [NSDate dateWithTimeInterval:8 * 60 * 60 sinceDate:date];
    
    return [dateFormatter stringFromDate:newDate];

}
@end
