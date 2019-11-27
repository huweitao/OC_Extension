//
//  UIViewController+EX.h
//
//  Created by huweitao on 2019/4/17.
//  Copyright © 2019年 DMC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (EX)

+ (void)simpleSystemAlertTitle:(NSString *)title message:(NSString *)msg lastTime:(CGFloat)time;
+ (void)simpleSystemAlertTitle:(NSString *)title message:(NSString *)msg okTitle:(NSString *)okTitle cancel:(NSString *)cancelTitle okHandler:(void (^)(void))okHandler cancelHandler:(void (^)(void))cancelHandler;
+ (void)simpleTextFieldTitle:(NSString *)title message:(NSString *)msg okHandler:(void (^ __nullable)(NSString *))okHandler;
+ (UIViewController *)currentTopViewController;
+ (void)pushToViewController:(UIViewController *)vc;
+ (void)presentViewControllerOnTop:(UIViewController *)vc;
+ (void)presentViewControllerOnTop:(UIViewController *)vc;
+ (void)presentViewControllerOnTop:(UIViewController *)vc completion:(void (^ __nullable)(void))completion;
+ (void)printTopViewControllerSubViews;

@end

NS_ASSUME_NONNULL_END
