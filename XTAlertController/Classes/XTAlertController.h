//
//  XTAlertController.h
//  XTAlertController
//
//  Created by zt.cheng on 12/18/2020.
//  Copyright (c) 2020 zt.cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTAlertView.h"

typedef NS_ENUM(NSInteger, XTAlertControllerStyle) {
    XTAlertControllerStyleAlert = 0,
    XTAlertControllerStyleActionSheet,    // 从底部弹出
    XTAlertControllerStyleDrawerFromLeft, // 左侧拉门，暂未实现
    XTAlertControllerStyleDrawerFromRight // 右侧拉门，暂未实现
};

typedef NS_ENUM(NSInteger, XTAlertTransitionAnimation) {
    XTAlertTransitionAnimationFade = 0,
    XTAlertTransitionAnimationScaleFade,
    XTAlertTransitionAnimationDropDown,
    XTAlertTransitionAnimationCustom
};

typedef NS_ENUM(NSInteger, XTAlertLevelPriority) {
    XTAlertLevelPriorityLow = 0,
    XTAlertLevelPriorityNormal = 500,
    XTAlertLevelPriorityHigh = 1000,
};


@interface XTAlertController : UIViewController

@property (nonatomic, strong, readonly) UIView *alertView;

@property (nonatomic, strong) UIColor *backgroundColor; // set backgroundColor
@property (nonatomic, strong) UIView  *backgroundView; // you set coustom view to it

@property (nonatomic, assign, readonly) XTAlertControllerStyle preferredStyle;

@property (nonatomic, assign, readonly) XTAlertTransitionAnimation transitionAnimation;

@property (nonatomic, assign, readonly) Class transitionAnimationClass;

// 默认  XTAlertControllerStyleAlert 为 NO, 其余为 YES
@property (nonatomic, assign) BOOL backgoundTapDismissEnable;  // default NO

@property (nonatomic, assign) CGFloat alertViewOriginY;  // default center Y

@property (nonatomic, assign) CGFloat alertStyleEdging; //  when width frame equal to 0,or no width constraint ,this proprty will use, default to 15 edge
@property (nonatomic, assign) CGFloat actionSheetStyleEdging; // default 0


// 默认为 NO
@property (nonatomic, assign) BOOL embedInNavigationController; // 嵌入 navigationController

@property (copy, nonatomic) void (^navigationControllerSetupHandler)(UINavigationController * navigationController);

// alertView lifecycle block
@property (copy, nonatomic) void (^viewWillShowHandler)(UIView *alertView);
@property (copy, nonatomic) void (^viewDidShowHandler)(UIView *alertView);
@property (copy, nonatomic) void (^viewWillHideHandler)(UIView *alertView);
@property (copy, nonatomic) void (^viewDidHideHandler)(UIView *alertView);

// dismiss controller completed block
@property (nonatomic, copy) void (^dismissComplete)(void);

+ (instancetype)alertControllerWithAlertView:(UIView *)alertView;

+ (instancetype)alertControllerWithAlertView:(UIView *)alertView preferredStyle:(XTAlertControllerStyle)preferredStyle;

+ (instancetype)alertControllerWithAlertView:(UIView *)alertView preferredStyle:(XTAlertControllerStyle)preferredStyle transitionAnimation:(XTAlertTransitionAnimation)transitionAnimation;

+ (instancetype)alertControllerWithAlertView:(UIView *)alertView preferredStyle:(XTAlertControllerStyle)preferredStyle transitionAnimationClass:(Class)transitionAnimationClass;

+ (instancetype)alertControllerWithAlertView:(UIView *)alertView preferredStyle:(XTAlertControllerStyle)preferredStyle transitionAnimation:(XTAlertTransitionAnimation)transitionAnimation navigationClass:(Class)navigationClass;

+ (instancetype)alertControllerWithAlertView:(UIView *)alertView preferredStyle:(XTAlertControllerStyle)preferredStyle
    navigationClass:(Class)navigationClass;

+ (instancetype)alertControllerWithAlertView:(UIView *)alertView preferredStyle:(XTAlertControllerStyle)preferredStyle transitionAnimationClass:(Class)transitionAnimationClass navigationClass:(Class)navigationClass;

- (void)showFromController:(UIViewController *)fromViewController animated:(BOOL)flag completion:(void (^)(void))completion;

- (void)dismissViewControllerAnimated:(BOOL)animated;

@end

// Transition Animate
@interface XTAlertController (TransitionAnimate)<UIViewControllerTransitioningDelegate>

@end
