//
//  NSObject+MultiPerformSEL.m
//  
//
//  Created by huweitao on 2019/4/8.
//  Copyright © 2019年 DMC. All rights reserved.
//

#import "NSObject+EX.h"

@implementation NSObject (EX)

+ (id)performMultiplyMethodsClass:(Class)clazz withSelector:(SEL)aSelector inputParams:(NSArray *)inputs
{
    
    if (nil == clazz || nil == aSelector) {
        NSLog(@"Perform selector method can not accept nil class or selector!");
        return nil;
    }
    
    NSMethodSignature *signature = [clazz methodSignatureForSelector:aSelector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    if (nil == signature || nil == invocation) {
        NSLog(@"Class %@ has no method %@",NSStringFromClass(clazz),NSStringFromSelector(aSelector));
        return nil;
    }
    [invocation setSelector:aSelector];
    // 签名中方法参数的个数：内部包含了self和_cmd，所以参数从第3个开始
    NSArray *objects = inputs;
    NSInteger signatureParamCount = signature.numberOfArguments - 2;
    NSInteger requireParamCount = objects.count;
    NSInteger resultParamCount = MIN(signatureParamCount, requireParamCount);
    invocation.target = clazz;
    invocation.selector = aSelector;
    for (NSInteger i = 0; i < resultParamCount; i++)
    {
        id obj = objects[i];
        [invocation setArgument:&obj atIndex:i+2];
    }
    [invocation invoke];
    [invocation retainArguments];
    
    // return instance
    // https://blog.csdn.net/ZBrightz/article/details/46514565
    const char * returnType = methodSignature.methodReturnType;
    NSString *returnTypeStr = [NSString stringWithUTF8String:returnType];
    if ([returnTypeStr containsString:@"\""]) {
        returnType = [returnTypeStr substringToIndex:1].UTF8String;
    }
    
    NSLog(@"Return type ==> %s",returnType);
    id returnValue = nil;
    if (strcmp(returnType,@encode(void)) == 0) {
        returnValue = nil;
    }
    else if (strcmp(returnType, @encode(id)) == 0) {
        [invocation getReturnValue:&returnValue];
    }
    else {
        //根据长度申请内存
        NSUInteger length = signature.methodReturnLength;
        void *buffer = (void *)malloc(length);
        // 为变量赋值
        [invocation getReturnValue:buffer];
        if(strcmp(returnType, @encode(BOOL)) == 0) {
            returnValue = [NSNumber numberWithBool:*((BOOL*)buffer)];
        }
        else if(strcmp(returnType, @encode(NSInteger)) == 0) {
            returnValue = [NSNumber numberWithInteger:*((NSInteger*)buffer)];
        }
        else {
            returnValue = [NSValue valueWithBytes:buffer objCType:returnType];
        }
        free(buffer);
    }
    return returnValue;
}

@end
