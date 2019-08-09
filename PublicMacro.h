//
//  PublicMacro.h
//  AlipayMoDebugBox
//
//  Created by huweitao on 2019/8/9.
//  Copyright © 2019 Alipay. All rights reserved.
//

#ifndef PublicMacro_h
#define PublicMacro_h

// safe async to main thread
#ifndef PU_ASYNC_MAIN
#define PU_ASYNC_MAIN(block)\
if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}
#endif

#define KILL_APP_AFTER(timeInterval)\
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{\
exit(0);\
});

// define inline methods

static inline id _Nonnull PerformeSelector_MutiplyParams_ReturnInstance(id _Nullable obj, NSString * _Nonnull methodName, NSArray * _Nullable params)
{
    SEL methodSEL = NSSelectorFromString(methodName);
    if (!params || [params count] == 0) {
        if ([obj respondsToSelector:methodSEL]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            return [obj performSelector:methodSEL];
#pragma clang diagnostic pop
        }
        else {
            return nil;
        }
    }
    //
    NSMethodSignature *methodSignature = [[obj class] instanceMethodSignatureForSelector:methodSEL];
    if(methodSignature == nil) {
        @throw [NSException exceptionWithName:@"Error!" reason:[NSString stringWithFormat:@"Instance from %@ has no method %@",NSStringFromClass([obj class]),methodName] userInfo:nil];
        return nil;
    }
    else {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        [invocation setTarget:obj];
        [invocation setSelector:methodSEL];
        // Signature params: self, _cmd, other params
        NSInteger  signatureParamCount = methodSignature.numberOfArguments - 2;
        NSInteger requireParamCount = params.count;
        NSInteger resultParamCount = MIN(signatureParamCount, requireParamCount);
        for (NSInteger i = 0; i < resultParamCount; i++) {
            id  obj = params[i];
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
            NSUInteger length = methodSignature.methodReturnLength;
            void *buffer = (void *)malloc(length);
            //为变量赋值
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
}

static inline id _Nonnull ObjectPerformeSelector_ReturnInstance(id _Nullable obj, NSString * _Nonnull methodName, id _Nullable object)
{
    SEL methodSEL = NSSelectorFromString(methodName);
    if ([obj respondsToSelector:methodSEL]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return [obj performSelector:methodSEL withObject:object];
#pragma clang diagnostic pop
    }
    return nil;
}

static inline id _Nonnull ClassPerformeSelector_ReturnInstance(NSString * _Nonnull clazz, NSString * _Nonnull methodName, id _Nullable object)
{
    Class classInstance = NSClassFromString(clazz);
    SEL methodSEL = NSSelectorFromString(methodName);
    if (classInstance && [classInstance respondsToSelector:methodSEL]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return [classInstance performSelector:methodSEL withObject:object];
#pragma clang diagnostic pop
    }
    return nil;
}

static inline void ClassPerformeSelector_NoReturn(NSString * _Nonnull clazz, NSString * _Nonnull methodName, id _Nullable object)
{
    Class classInstance = NSClassFromString(clazz);
    SEL methodSEL = NSSelectorFromString(methodName);
    if (classInstance && [classInstance respondsToSelector:methodSEL]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [classInstance performSelector:methodSEL withObject:object];
#pragma clang diagnostic pop
    }
}

// swizzle
#import <objc/runtime.h>
static inline bool Inline_SwizzleMethod(Class _Nonnull origClass, SEL _Nonnull origSel, Class _Nonnull newClass, SEL _Nonnull newSel)
{
    Method origMethod = class_getInstanceMethod(origClass, origSel);
    if (!origMethod) {
        NSLog(@"Original method %@ not found for class %@", NSStringFromSelector(origSel), [origClass class]);
        return false;
    }
    
    Method newMethod = class_getInstanceMethod(newClass, newSel);
    if (!newMethod) {
        NSLog( @"New method %@ not found for class %@", NSStringFromSelector(newSel), [newClass class]);
        return false;
    }
    
    if (class_addMethod(origClass,origSel,class_getMethodImplementation(origClass, origSel),method_getTypeEncoding(origMethod))) {
        NSLog(@"Original method %@ is is not owned by class %@",NSStringFromSelector(origSel), [origClass class]);
        return false;
    }
    
    // 添加新方法以及实现到需要被swizzle的class里
    if (!class_addMethod(origClass,newSel,class_getMethodImplementation(newClass, newSel),method_getTypeEncoding(newMethod))) {
        NSLog(@"New method %@ can not be added in class %@",NSStringFromSelector(newSel), [newClass class]);
        return false;
    }
    
    method_exchangeImplementations(class_getInstanceMethod(origClass, origSel), class_getInstanceMethod(origClass, newSel));
    return true;
}


#endif /* PublicMacro_h */
