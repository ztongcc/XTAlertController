//
//  XTShowAlertView.m
//  XTAlertControllerDemo
//
//  Created by zt.cheng on 12/18/2020.
//  Copyright (c) 2020 zt.cheng. All rights reserved.
//

#import "XTShowAlertView.h"
#import "UIView+XTAutoLayout.h"

@interface XTContainerController : UIViewController

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, strong) NSMutableArray * alertItems;

+ (void)showAlert:(UIView *)alertView fromController:(UIViewController *)controller;

@end



@interface XTShowAlertView ()

@property (nonatomic, weak) UIView * alertView;
@property (nonatomic, weak) UITapGestureRecognizer * singleTap;

- (void)commitPushAnimation;

@end

//current window
#define kCurrentWindow [[UIApplication sharedApplication].windows firstObject]

@implementation XTShowAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        _priority = XTAlertLevelPriorityNormal;
        _backgoundTapDismissEnable = NO;
        _alertViewEdging = 15;
        
        [self addBackgroundView];
        
        [self addSingleGesture];
    }
    return self;
}

- (instancetype)initWithAlertView:(UIView *)tipView {
    if (self = [self initWithFrame:CGRectZero]) {
        [self addSubview:tipView];
        _alertView = tipView;
    }
    return self;
}

+ (instancetype)alertViewWithView:(UIView *)tipView {
    return [[self alloc]initWithAlertView:tipView];
}

- (void)addBackgroundView {
    if (_backgroundView == nil) {
        UIView *backgroundView = [[UIView alloc]initWithFrame:self.bounds];
        backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        _backgroundView = backgroundView;
    }
    [self insertSubview:_backgroundView atIndex:0];
    _backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraintToView:_backgroundView edgeInset:UIEdgeInsetsZero];
}

- (void)setBackgroundView:(UIView *)backgroundView {
    if (_backgroundView != backgroundView) {
        [_backgroundView removeFromSuperview];
        _backgroundView = backgroundView;
        [self addBackgroundView];
        [self addSingleGesture];
    }
}
- (void)setBackgoundTapDismissEnable:(BOOL)backgoundTapDismissEnable {
    _backgoundTapDismissEnable = backgoundTapDismissEnable;
    _singleTap.enabled = backgoundTapDismissEnable;
}

- (void)didMoveToSuperview {
    if (self.superview) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self.superview addConstraintToView:self edgeInset:UIEdgeInsetsZero];
        [self layoutAlertView];
    }
}

- (void)layoutAlertView {
    _alertView.translatesAutoresizingMaskIntoConstraints = NO;
    // center X
    [self addConstraintCenterXToView:_alertView centerYToView:nil];
    
    // width, height
    if (!CGSizeEqualToSize(_alertView.frame.size,CGSizeZero)) {
        [_alertView addConstraintWidth:CGRectGetWidth(_alertView.frame) height:CGRectGetHeight(_alertView.frame)];
        
    }else {
        BOOL findAlertViewWidthConstraint = NO;
        for (NSLayoutConstraint *constraint in _alertView.constraints) {
            if (constraint.firstAttribute == NSLayoutAttributeWidth) {
                findAlertViewWidthConstraint = YES;
                break;
            }
        }
        
        if (!findAlertViewWidthConstraint) {
            [_alertView addConstraintWidth:CGRectGetWidth(self.superview.frame)-2*_alertViewEdging height:0];
        }
    }
    
    // topY
    NSLayoutConstraint *alertViewCenterYConstraint = [self addConstraintCenterYToView:_alertView constant:0];
    
    if (_alertViewOriginY > 0) {
        [_alertView layoutIfNeeded];
        alertViewCenterYConstraint.constant = _alertViewOriginY - (CGRectGetHeight(self.superview.frame) - CGRectGetHeight(_alertView.frame))/2;
    }
}

#pragma mark - add Gesture
- (void)addSingleGesture {
    self.userInteractionEnabled = YES;
    //单指单击
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTap.enabled = _backgoundTapDismissEnable;
    //增加事件者响应者，
    [_backgroundView addGestureRecognizer:singleTap];
    _singleTap = singleTap;
}

#pragma mark 手指点击事件
- (void)singleTap:(UITapGestureRecognizer *)sender {
    [self hide];
}

- (void)commitPushAnimation {
    if (self.customPushAnimationHandler) {
        self.customPushAnimationHandler(self.backgroundView, self.alertView);
    }else {
        self.backgroundView.alpha = 0;
        self.alertView.transform = CGAffineTransformScale(_alertView.transform,0.5,0.5);
        [UIView animateWithDuration:0.3 animations:^{
            self.alertView.transform = CGAffineTransformIdentity;
            self.backgroundView.alpha = 1;
        }];
    }
}

- (void)commitPopAnimation:(void (^)(BOOL finished))completion {
    if (self.customPopAnimationHandler) {
        self.customPopAnimationHandler(self.backgroundView, self.alertView, completion);
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            self.alertView.transform = CGAffineTransformScale(self.alertView.transform,0.5,0.5);
            self.backgroundView.alpha = 0;
        } completion:^(BOOL finished) {
            if (completion) {
                completion(finished);
            }
        }];
    }
}

//- (void)show {
//    if (self.superview == nil) {
//        [kCurrentWindow addSubview:self];
//    }
//    self.alpha = 0;
//    self.alertView.transform = CGAffineTransformScale(_alertView.transform,0.5,0.5);
//    [UIView animateWithDuration:0.3 animations:^{
//        self.alertView.transform = CGAffineTransformIdentity;
//        self.alpha = 1;
//    }];
//}

- (void)showInController:(UIViewController *)controller {
    if (self.superview == nil) {
        [controller.view addSubview:self];
    }
    [self commitPushAnimation];
}

- (void)showFromController:(UIViewController *)controller {
    [XTContainerController showAlert:self fromController:controller];
}

- (void)hide {
    if (self.superview) {
        [self commitPopAnimation:^(BOOL finished) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"notification.XTShowAlertView.hide" object:nil];
            [self removeFromSuperview];
        }];
    }
}

- (void)dealloc {
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

@end





@implementation XTContainerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
    self.modalPresentationStyle = UIModalPresentationCustom;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAlertViewHide:) name:@"notification.XTShowAlertView.hide" object:nil];
}

- (void)onAlertViewHide:(NSNotification *)notification {
    if (self.view.subviews.count <= 1) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (void)setupAlert:(XTShowAlertView *)contentView {
    __block NSInteger insertIdx = 0;
    if (self.view.subviews.count != 0) {
        [self.view.subviews enumerateObjectsUsingBlock:^(__kindof XTShowAlertView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[XTShowAlertView class]]) {
                if (obj.priority <= contentView.priority) {
                    insertIdx = idx+1;
                }
            }
        }];
    }
    [self.view insertSubview:contentView atIndex:insertIdx];
}

+ (void)showAlert:(XTShowAlertView *)alertView fromController:(UIViewController *)controller {
    XTContainerController * containerVC = (XTContainerController *)controller;
    while (containerVC.presentedViewController) {
        containerVC = (XTContainerController *)containerVC.presentedViewController;
    }
    
    if ([containerVC isMemberOfClass:[XTContainerController class]]) {
        [containerVC setupAlert:alertView];
        [alertView commitPushAnimation];
    }else {
        XTContainerController * vc = [[XTContainerController alloc] init];
        [vc setupAlert:alertView];
        [containerVC presentViewController:vc animated:NO completion:^{
            [alertView commitPushAnimation];
        }];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

