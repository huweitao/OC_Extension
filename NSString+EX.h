//
//  NSString+LoginExtension.h
//  
//
//  Created by huweitao on 2019/4/2.
//  Copyright © 2019年 DMC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (EX)

- (NSString *)md5String;
- (NSDictionary *)jsonDictFromString;
- (NSString*)sha1String;
- (BOOL)compareInsensitive:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
