#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "XTAlertController.h"
#import "XTAlertDropDownAnimation.h"
#import "XTAlertFadeAnimation.h"
#import "XTAlertScaleFadeAnimation.h"
#import "XTAlertView.h"
#import "TYBaseAnimation.h"
#import "TYShowAlertView.h"
#import "UIView+XTAlertView.h"
#import "UIView+TYAutoLayout.h"

FOUNDATION_EXPORT double XTAlertControllerVersionNumber;
FOUNDATION_EXPORT const unsigned char XTAlertControllerVersionString[];

