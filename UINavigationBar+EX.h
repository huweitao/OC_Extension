//
//  UINavigationBar+EX.h
//
//  Created by huweitao on 2019/5/22.
//  Copyright © 2019年 DMC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationBar (EX)

- (void)setupBarBackgroundViewColor:(UIColor *)color;
- (void)resetBarBackgroundViewColor;
- (BOOL)isMaskBarLayerAppear;

@end

NS_ASSUME_NONNULL_END
