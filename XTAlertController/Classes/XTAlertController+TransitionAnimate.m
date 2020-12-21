//
//  XTAlertController+TransitionAnimate.m
//  XTAlertController
//
//  Created by zt.cheng on 12/18/2020.
//  Copyright (c) 2020 zt.cheng. All rights reserved.
//

#import "XTAlertController.h"
#import "XTAlertFadeAnimation.h"
#import "XTAlertScaleFadeAnimation.h"
#import "XTAlertDropDownAnimation.h"

@implementation XTAlertController (TransitionAnimate)

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    switch (self.transitionAnimation) {
        case XTAlertTransitionAnimationFade:
            return [XTAlertFadeAnimation alertAnimationIsPresenting:YES];
        case XTAlertTransitionAnimationScaleFade:
            return [XTAlertScaleFadeAnimation alertAnimationIsPresenting:YES];
        case XTAlertTransitionAnimationDropDown:
            return [XTAlertDropDownAnimation alertAnimationIsPresenting:YES];
        case XTAlertTransitionAnimationCustom:
            return [self.transitionAnimationClass alertAnimationIsPresenting:YES preferredStyle:self.preferredStyle];
        default:
            return nil;
    }
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    switch (self.transitionAnimation) {
        case XTAlertTransitionAnimationFade:
            return [XTAlertFadeAnimation alertAnimationIsPresenting:NO];
        case XTAlertTransitionAnimationScaleFade:
            return [XTAlertScaleFadeAnimation alertAnimationIsPresenting:NO];
        case XTAlertTransitionAnimationDropDown:
            return [XTAlertDropDownAnimation alertAnimationIsPresenting:NO];
        case XTAlertTransitionAnimationCustom:
            return [self.transitionAnimationClass alertAnimationIsPresenting:NO preferredStyle:self.preferredStyle];
        default:
            return nil;
    }
}

@end
