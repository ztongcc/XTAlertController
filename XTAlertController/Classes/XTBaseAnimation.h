//
//  XTBaseAnimation.h
//  XTAlertController
//
//  Created by zt.cheng on 12/18/2020.
//  Copyright (c) 2020 zt.cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTAlertController.h"

@interface XTBaseAnimation : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign, readonly) BOOL isPresenting; // present . dismiss

+ (instancetype)alertAnimationIsPresenting:(BOOL)isPresenting;

// if you only want alert or actionsheet style ,you can judge that you don't need and return nil
//  code : only support alert style
//  if (preferredStyle == XTAlertControllerStyleAlert) {
//      return [super alertAnimationIsPresenting:isPresenting];
//  }
//  return nil;
+ (instancetype)alertAnimationIsPresenting:(BOOL)isPresenting preferredStyle:(XTAlertControllerStyle) preferredStyle;


// override transiton time
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext;

// override present
- (void)presentAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext;

// override dismiss
- (void)dismissAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext;

@end
