//
//  UINavigationBar+EX.m
//
//  Created by huweitao on 2019/5/22.
//  Copyright © 2019年 DMC. All rights reserved.
//

#import "UINavigationBar+EX.h"
#import <objc/runtime.h>

@interface UINavigationBar ()

@property (nonatomic, strong) CALayer *maskBarLayer;

@end

@implementation UINavigationBar (EX)

- (void)setupBarBackgroundViewColor:(UIColor *)color
{
    if (!color) {
        return;
    }
    
    if (!self.maskBarLayer) {
        self.maskBarLayer = [CALayer layer];
    }
    
    CGRect rect = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)+CGRectGetHeight(self.frame));
    self.maskBarLayer.backgroundColor = color.CGColor;
    [self resetMaskLayerFrame:rect];
    
    if (@available(iOS 10.0, *)) {
        [self setupMaskLayerAfteriOS10];
    }
    else {
        [self setupMaskLayerBeforeiOS10];
    }
}

- (void)resetBarBackgroundViewColor
{
    if (self.maskBarLayer) {
        [self.maskBarLayer removeFromSuperlayer];
        self.maskBarLayer = nil;
    }
    [self resetoreNavigationBarHiddenViews];
}

- (BOOL)isMaskBarLayerAppear
{
    if (self.maskBarLayer) {
        return YES;
    }
    return NO;
}

#pragma mark - Private

- (void)setupMaskLayerAfteriOS10
{
    for (UIView *view in self.subviews) {
        // >= ios 10
        if ([view isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
            [self resetMaskLayerFrame:view.frame];
            [view.layer addSublayer:self.maskBarLayer];
            for (UIView *subview in [view subviews]) {
                [self setupNavigationBottomLine:subview toHide:YES];
                if ([subview isKindOfClass:NSClassFromString(@"UIVisualEffectView")]){
                    subview.hidden = YES;
                    break;
                }
            }
            break;
        }
    }
}

- (void)setupMaskLayerBeforeiOS10
{
    if (@available(iOS 10.0, *)) {
        for (UIView *view in self.subviews) {
            // < ios 10
            if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
                [self resetMaskLayerFrame:view.frame];
                [view.layer addSublayer:self.maskBarLayer];
                break;
            }
        }
    }
}

- (void)resetoreNavigationBarHiddenViews
{
    for (UIView *view in self.subviews) {
        // >= ios 10
        if (@available(iOS 10.0, *)) {
            if ([view isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
                for (UIView *subview in [view subviews]) {
                    [self setupNavigationBottomLine:subview toHide:NO];
                    if ([subview isKindOfClass:NSClassFromString(@"UIVisualEffectView")]){
                        subview.hidden = NO;
                    }
                }
                break;
            }
        }
        else {
            if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
                [self setupNavigationBottomLine:view toHide:NO];
                break;
            }
        }
    }
}

- (void)setupNavigationBottomLine:(UIView *)view toHide:(BOOL)toHide
{
    if (!view) {
        return;
    }
    if ([view isKindOfClass:[UIImageView class]] && CGRectGetHeight(view.frame) < 2.0){
        view.hidden = YES;
    }
}

- (void)resetMaskLayerFrame:(CGRect)frame
{
    if (self.maskBarLayer) {
        CGRect rect = frame;
        rect.origin = CGPointMake(0, 0);
        self.maskBarLayer.frame = rect;
    }
}

#pragma mark - property

- (CALayer *)maskBarLayer
{
    return objc_getAssociatedObject(self, @selector(maskBarLayer));
}

- (void)setMaskBarLayer:(CALayer *)maskBarLayer
{
    objc_setAssociatedObject(self, @selector(maskBarLayer), maskBarLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
