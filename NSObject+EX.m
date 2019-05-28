//
//  NSObject+MultiPerformSEL.m
//  AccountAuthService
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
    
    //返回值处理
    id callBackObject = nil;
    if(signature.methodReturnLength)
    {
        [invocation getReturnValue:&callBackObject];
    }
    return callBackObject;
}

@end
