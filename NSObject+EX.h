//
//  NSObject+MultiPerformSEL.h
//  
//
//  Created by huweitao on 2019/4/8.
//  Copyright © 2019年 DMC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (EX)

+ (id)performMultiplyMethodsClass:(Class)clazz withSelector:(SEL)aSelector inputParams:(NSArray *)inputs;

@end

NS_ASSUME_NONNULL_END
