//
//  UIViewController+EX.m
//  AccountAuthService
//
//  Created by huweitao on 2019/4/17.
//  Copyright © 2019年 DMC. All rights reserved.
//

#import "UIViewController+EX.h"

@implementation UIViewController (EX)

- (UIViewController *)topViewController
{
    UIViewController *vc = UIApplication.sharedApplication.keyWindow.rootViewController;
    while (  [vc isKindOfClass:[UINavigationController class]] || [vc isKindOfClass:[UITabBarController class]] ) {
        if ( [vc isKindOfClass:[UINavigationController class]] ) vc = [(UINavigationController *)vc topViewController];
        if ( [vc isKindOfClass:[UITabBarController class]] ) vc = [(UITabBarController *)vc selectedViewController];
        if ( vc.presentedViewController ) vc = vc.presentedViewController;
    }
    return vc;
}

@end
