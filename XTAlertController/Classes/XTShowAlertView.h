//
//  XTShowAlertView.h
//  XTAlertControllerDemo
//
//  Created by zt.cheng on 12/18/2020.
//  Copyright (c) 2020 zt.cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTAlertController.h"


@interface XTShowAlertView : UIView

@property (nonatomic, weak, readonly) UIView *alertView;
@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, assign) XTAlertLevelPriority priority; // 优先级高的在最上面， 低的在最下面， 默认为 Normal

@property (nonatomic, assign) BOOL backgoundTapDismissEnable;  // default NO
@property (nonatomic, assign) CGFloat alertViewOriginY;  // default center Y
@property (nonatomic, assign) CGFloat alertViewEdging;   // default 15

@property (nonatomic, copy) void (^customPushAnimationHandler)(UIView * backgroundView, UIView * contentView);   // default nil
@property (nonatomic, copy) void (^customPopAnimationHandler)(UIView * backgroundView, UIView * contentView, void (^completion)(BOOL finished));   // default nil, completion 在动画执行完成之后必须执行


+ (instancetype)alertViewWithView:(UIView *)alertView;

- (void)showFromController:(UIViewController *)controller;

//- (void)show;

- (void)hide;

@end
