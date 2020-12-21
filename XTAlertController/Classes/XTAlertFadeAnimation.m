//
//  XTAlertDefaultAnimation.m
//  XTAlertController
//
//  Created by zt.cheng on 12/18/2020.
//  Copyright (c) 2020 zt.cheng. All rights reserved.
//

#import "XTAlertFadeAnimation.h"

@implementation XTAlertFadeAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (self.isPresenting) {
        return 0.45;
    }
    return 0.25;
}

- (void)presentAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    XTAlertController *alertController = (XTAlertController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if ([alertController isKindOfClass:[UINavigationController class]]) {
        alertController = [((UINavigationController *)alertController).viewControllers firstObject];
    }
    alertController.backgroundView.alpha = 0.0;
    
    switch (alertController.preferredStyle) {
        case XTAlertControllerStyleAlert:
            alertController.alertView.alpha = 0.0;
            alertController.alertView.transform = CGAffineTransformMakeScale(0.5, 0.5);
            break;
        case XTAlertControllerStyleActionSheet:
            alertController.alertView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(alertController.alertView.frame));
            break;
        case XTAlertControllerStyleDrawerFromLeft:
            alertController.alertView.transform = CGAffineTransformMakeTranslation(-CGRectGetWidth(alertController.alertView.frame), 0);
            break;
        case XTAlertControllerStyleDrawerFromRight:
            alertController.alertView.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(alertController.view.frame), 0);
            break;
        default:
            break;
    }
    
    UIView *containerView = [transitionContext containerView];
    if (alertController.navigationController) {
        [containerView addSubview:alertController.navigationController.view];
    }
    [containerView addSubview:alertController.view];

    CGFloat damping = alertController.preferredStyle == XTAlertControllerStyleAlert?0.65:0.95;
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:damping initialSpringVelocity:0.5 options:0 animations:^{
        alertController.backgroundView.alpha = 1.0;
        switch (alertController.preferredStyle) {
            case XTAlertControllerStyleAlert:
                alertController.alertView.alpha = 1.0;
                alertController.alertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                break;
            case XTAlertControllerStyleActionSheet:
            case XTAlertControllerStyleDrawerFromLeft:
            case XTAlertControllerStyleDrawerFromRight:
                alertController.alertView.transform = CGAffineTransformMakeTranslation(0, 0.0);
                break;
            default:
                break;
        }
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

- (void)dismissAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    XTAlertController *alertController = (XTAlertController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    if ([alertController isKindOfClass:[UINavigationController class]]) {
        alertController = [((UINavigationController *)alertController).viewControllers firstObject];
    }
    [UIView animateWithDuration:0.25 animations:^{
        alertController.backgroundView.alpha = 0.0;
        switch (alertController.preferredStyle) {
            case XTAlertControllerStyleAlert:
                alertController.alertView.alpha = 0.0;
                alertController.alertView.transform = CGAffineTransformMakeScale(0.85, 0.85);
                break;
            case XTAlertControllerStyleActionSheet:
                alertController.alertView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(alertController.alertView.frame));
                break;
            case XTAlertControllerStyleDrawerFromLeft:
                alertController.alertView.transform = CGAffineTransformMakeTranslation(-CGRectGetWidth(alertController.alertView.frame), 0);
                break;
            case XTAlertControllerStyleDrawerFromRight:
                alertController.alertView.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(alertController.view.frame), 0);
            default:
                break;
        }
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

@end
