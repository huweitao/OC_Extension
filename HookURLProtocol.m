//
//  HookURLProtocol.m
//  AccountAuthService
//
//  Created by huweitao on 2019/4/9.
//  Copyright © 2019年 Alipay. All rights reserved.
//

#import "HookURLProtocol.h"

@implementation HookURLProtocol

static NSString * const URLProtocolHandledKey = @"URLProtocolHandledKey";

#pragma mark - Override

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    //只处理http和https请求
    NSString *scheme = [[request URL] scheme];
    if ( ([scheme caseInsensitiveCompare:@"http"] == NSOrderedSame ||
          [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame))
    {
        NSString *url = [request.URL absoluteString];
        NSLog(@"%@",url);
        //看看是否已经处理过了，防止无限循环
        if ([NSURLProtocol propertyForKey:URLProtocolHandledKey inRequest:request]) {
            return NO;
        }

        return YES;
    }
    return NO;
}

+ (NSURLRequest *) canonicalRequestForRequest:(NSURLRequest *)request {
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    mutableReqeust = [self redirectHostInRequset:mutableReqeust];
    return mutableReqeust;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b
{
    return [super requestIsCacheEquivalent:a toRequest:b];
}

- (void)startLoading
{
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    
    NSLog(@"Hook URL ==> %@",[[self request].URL absoluteString]);
    NSLog(@"Hook URL headers ==> %@",[[self request] allHTTPHeaderFields]);
    NSLog(@"Hook URL method ==> %@",[[self request] HTTPMethod]);
    //打标签，防止无限循环
    [NSURLProtocol setProperty:@YES forKey:URLProtocolHandledKey inRequest:mutableReqeust];
}

- (void)stopLoading
{
    
}

#pragma mark - Private

+ (NSMutableURLRequest*)redirectHostInRequset:(NSMutableURLRequest *)request
{
    if ([request.URL host].length == 0) {
        return request;
    }
    return request;
    
    NSString *originUrlString = [request.URL absoluteString];
    NSString *originHostString = [request.URL host];
    NSRange hostRange = [originUrlString rangeOfString:originHostString];
    if (hostRange.location == NSNotFound) {
        return request;
    }
    //定向到bing搜索主页
    NSString *ip = @"cn.bing.com";
    
    // 替换域名
    NSString *urlString = [originUrlString stringByReplacingCharactersInRange:hostRange withString:ip];
    NSURL *url = [NSURL URLWithString:urlString];
    request.URL = url;
    
    return request;
}

@end
