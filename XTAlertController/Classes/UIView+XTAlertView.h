//
//  UIView+XTAlertView.h
//  XTAlertController
//
//  Created by zt.cheng on 12/18/2020.
//  Copyright (c) 2020 zt.cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTAlertController.h"
#import "XTShowAlertView.h"

@interface UIView (XTAlertView)

+ (instancetype)createViewFromNib;

+ (instancetype)createViewFromNibName:(NSString *)nibName;

- (UIViewController*)viewController;

#pragma mark - show in controller

- (void)showInController:(UIViewController *)viewController;

- (void)showInController:(UIViewController *)viewController preferredStyle:(XTAlertControllerStyle)preferredStyle;

// backgoundTapDismissEnable default NO
- (void)showInController:(UIViewController *)viewController preferredStyle:(XTAlertControllerStyle)preferredStyle backgoundTapDismissEnable:(BOOL)backgoundTapDismissEnable;

- (void)showInController:(UIViewController *)viewController preferredStyle:(XTAlertControllerStyle)preferredStyle transitionAnimation:(XTAlertTransitionAnimation)transitionAnimation;

- (void)showInController:(UIViewController *)viewController preferredStyle:(XTAlertControllerStyle)preferredStyle transitionAnimation:(XTAlertTransitionAnimation)transitionAnimation backgoundTapDismissEnable:(BOOL)backgoundTapDismissEnable;

#pragma mark - show in window

- (void)showInWindow;


#pragma mark - hide

// this will judge and call right method
- (void)hideView;

- (void)hideInController;

- (void)hideInWindow;

@end
