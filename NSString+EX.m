//
//  NSString+LoginExtension.m
//  
//
//  Created by huweitao on 2019/4/2.
//  Copyright © 2019年 DMC. All rights reserved.
//

#import "NSString+EX.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (EX)


- (NSString *)md5String
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result);
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSDictionary *)jsonDictFromString
{
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *info = nil;
    NSError *err;
    @try {
        info = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    }
    @catch (NSException *exception) {
        
        NSLog(@"%s[%d], JSON read exception: %@", __func__, __LINE__, exception);
        NSLog(@"%s[%d], JSON read error: %@", __func__, __LINE__, err);
    }
    @finally {
        return info?info[@"ipayUserId"]:nil;
    }
}

- (NSString*)sha1String
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    // 对应的CC_SHA1,CC_SHA256,CC_SHA384,CC_SHA512的长度分别是20,32,48,64
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    // 对应的CC_SHA256,CC_SHA384,CC_SHA512
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

- (BOOL)compareInsensitive:(NSString *)str
{
    if (nil == str) {
        return NO;
    }
    return ([self compare:str options:NSCaseInsensitiveSearch] == NSOrderedSame);
}

@end
