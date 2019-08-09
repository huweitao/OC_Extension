//
//  UIViewController+EX.m
//  AccountAuthService
//
//  Created by huweitao on 2019/4/17.
//  Copyright © 2019年 DMC. All rights reserved.
//

#import "UIViewController+EX.h"
#import "MODebugMacro.h"

static inline void SafeAsyncMain(dispatch_block_t block)
{
    if (!block) {
        return;
    }
    dispatch_block_t blockCP = [block copy];
    dispatch_block_t excuteHandler = ^(){
        @autoreleasepool {
            blockCP();
        }
    };
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
        excuteHandler();
    } else {
        dispatch_async(dispatch_get_main_queue(), excuteHandler);
    }
}

@implementation UIViewController (EX)

+ (UIViewController *)currentTopViewController
{
    UIViewController *vc = UIApplication.sharedApplication.keyWindow.rootViewController;
    while (  [vc isKindOfClass:[UINavigationController class]] || [vc isKindOfClass:[UITabBarController class]] ) {
        if ( [vc isKindOfClass:[UINavigationController class]] ) vc = [(UINavigationController *)vc topViewController];
        if ( [vc isKindOfClass:[UITabBarController class]] ) vc = [(UITabBarController *)vc selectedViewController];
        if ( vc.presentedViewController ) vc = vc.presentedViewController;
    }
    return vc;
}

+ (void)simpleSystemAlertTitle:(NSString *)title message:(NSString *)msg lastTime:(CGFloat)time
{
    if (time < 0.0) {
        time = 0.0;
    }
    SafeAsyncMain(^{
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:title
                                    message:msg
                                    preferredStyle:UIAlertControllerStyleAlert];
        
        [[UIViewController currentTopViewController] presentViewController:alert animated:YES completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:nil];
        });
    });
}

+ (void)simpleSystemAlertTitle:(NSString *)title message:(NSString *)msg okTitle:(NSString *)okTitle cancel:(NSString *)cancelTitle okHandler:(void (^)(void))okHandler cancelHandler:(void (^)(void))cancelHandler
{
    [[NSArray new] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
    }];
    
    SafeAsyncMain(^{
        UIAlertController *alertController = [UIAlertController
                                    alertControllerWithTitle:title
                                    message:msg
                                    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = nil;
        
        if (okHandler) {
            okAction = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                okHandler();
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertController addAction:okAction];
        }
        
        UIAlertAction *cancelAction = nil;
        
        if (cancelHandler) {
            [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                cancelHandler();
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertController addAction:cancelAction];
        }
        
        [[UIViewController currentTopViewController] presentViewController:alertController animated:YES completion:nil];
    });
    
}

+ (void)pushToViewController:(UIViewController *)vc
{
    if (!vc) {
        return;
    }
    SafeAsyncMain(^{
        [[UIViewController currentTopViewController].navigationController pushViewController:vc animated:YES];
    });
}

+ (void)presentViewControllerOnTop:(UIViewController *)vc
{
    if (!vc) {
        return;
    }
    SafeAsyncMain(^{
        [[UIViewController currentTopViewController] presentViewController:vc animated:YES completion:nil];
    });
}

@end
