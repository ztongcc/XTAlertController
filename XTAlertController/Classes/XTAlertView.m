//
//  XTAlertView.m
//  XTAlertController
//
//  Created by zt.cheng on 12/18/2020.
//  Copyright (c) 2020 zt.cheng. All rights reserved.
//

#import "XTAlertView.h"
#import "UIView+XTAlertView.h"
#import "UIView+XTAutoLayout.h"


#define XTAlertView_AlertViewWidth   280
#define XTAlertView_ContentViewEdge  15
#define XTAlertView_ContentViewSpace 15

#define XTAlertView_TextLabelSpace   6

#define XTAlertView_ButtonTagOffset 1000
#define XTAlertView_ButtonSpace     6
#define XTAlertView_ButtonHeight    44

#define XTAlertView_TextFieldOffset 10000
#define XTAlertView_TextFieldHeight 30
#define XTAlertView_TextFieldEdge   8
#define XTAlertView_TextFieldBorderWidth 0.5



@interface XTAlertAction ()
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) XTAlertActionStyle style;
@property (nonatomic, copy) void (^handler)(XTAlertAction *);
@end

@implementation XTAlertAction

+ (instancetype)actionWithTitle:(NSString *)title style:(XTAlertActionStyle)style handler:(void (^)(XTAlertAction *))handler {
    return [[self alloc]initWithTitle:title style:style handler:handler];
}

- (instancetype)initWithTitle:(NSString *)title style:(XTAlertActionStyle)style handler:(void (^)(XTAlertAction *))handler {
    if (self = [super init]) {
        _title = title;
        _style = style;
        _handler = handler;
        _enabled = YES;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    XTAlertAction *action = [[self class]allocWithZone:zone];
    action.title = self.title;
    action.style = self.style;
    return action;
}

@end


@interface XTAlertView ()

// text content View
@property (nonatomic, weak) UIView *textContentView;
@property (nonatomic, weak) UILabel *titleLable;
@property (nonatomic, weak) UILabel *messageLabel;

@property (nonatomic, weak) UIView *textFieldContentView;
@property (nonatomic, weak) NSLayoutConstraint *textFieldTopConstraint;
@property (nonatomic, strong) NSMutableArray *textFields;
@property (nonatomic, strong) NSMutableArray *textFieldSeparateViews;

// button content View
@property (nonatomic, weak) UIView *buttonContentView;
@property (nonatomic, weak) NSLayoutConstraint *buttonTopConstraint;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) NSMutableArray *actions;

@end



@implementation XTAlertView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configureProperty];
        [self addContentViews];
        [self addTextLabels];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message {
    if (self = [self init]) {
        _titleLable.text = title;
        _messageLabel.text = message;
    }
    return self;
}

+ (instancetype)alertViewWithTitle:(NSString *)title message:(NSString *)message {
    return [[self alloc]initWithTitle:title message:message];
}

#pragma mark - configure

- (void)configureProperty {
    _clickedAutoHide = YES;
    self.backgroundColor = [UIColor whiteColor];
    _alertViewWidth = XTAlertView_AlertViewWidth;
    _contentViewSpace = XTAlertView_ContentViewSpace;
    
    _textLabelSpace = XTAlertView_TextLabelSpace;
    _textLabelContentViewEdge = XTAlertView_ContentViewEdge;
    
    _buttonHeight = XTAlertView_ButtonHeight;
    _buttonSpace = XTAlertView_ButtonSpace;
    _buttonContentViewEdge = XTAlertView_ContentViewEdge;
    _buttonContentViewTop = XTAlertView_ContentViewSpace;
    _buttonCornerRadius = 4.0;
    _buttonFont = [UIFont fontWithName:@"HelveticaNeue" size:18];
    _buttonDefaultBgColor = [UIColor colorWithRed:52/255.0 green:152/255.0 blue:219/255.0 alpha:1];
    _buttonCancelBgColor = [UIColor colorWithRed:127/255.0 green:140/255.0 blue:141/255.0 alpha:1];
    _buttonDestructiveBgColor = [UIColor colorWithRed:231/255.0 green:76/255.0 blue:60/255.0 alpha:1];
    
    _textFieldHeight = XTAlertView_TextFieldHeight;
    _textFieldEdge = XTAlertView_TextFieldEdge;
    _textFieldBorderWidth = XTAlertView_TextFieldBorderWidth;
    _textFieldContentViewEdge = XTAlertView_ContentViewEdge;
    
    _textFieldBorderColor = [UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:1];
    _textFieldBackgroudColor = [UIColor whiteColor];
    _textFieldFont = [UIFont systemFontOfSize:14];
    
    _buttons = [NSMutableArray array];
    _actions = [NSMutableArray array];
}

- (UIColor *)buttonBgColorWithStyle:(XTAlertActionStyle)style {
    switch (style) {
        case XTAlertActionStyleDefault:
            return _buttonDefaultBgColor;
        case XTAlertActionStyleCancel:
            return _buttonCancelBgColor;
        case XTAlertActionStyleDestructive:
            return _buttonDestructiveBgColor;
            
        default:
            return nil;
    }
}

#pragma mark - add contentview

- (void)addContentViews {
    UIView *textContentView = [[UIView alloc]init];
    [self addSubview:textContentView];
    _textContentView = textContentView;
    
    UIView *textFieldContentView = [[UIView alloc]init];
    [self addSubview:textFieldContentView];
    _textFieldContentView = textFieldContentView;
    
    UIView *buttonContentView = [[UIView alloc]init];
    buttonContentView.userInteractionEnabled = YES;
    [self addSubview:buttonContentView];
    _buttonContentView = buttonContentView;
}

- (void)addTextLabels {
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    [_textContentView addSubview:titleLabel];
    _titleLable = titleLabel;
    
    UILabel *messageLabel = [[UILabel alloc]init];
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    messageLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    [_textContentView addSubview:messageLabel];
    _messageLabel = messageLabel;
}

- (void)didMoveToSuperview {
    if (self.superview) {
        [self layoutContentViews];
        [self layoutTextLabels];
    }
}

- (void)addAction:(XTAlertAction *)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.clipsToBounds = YES;
    button.layer.cornerRadius = _buttonCornerRadius;
    [button setTitle:action.title forState:UIControlStateNormal];
    button.titleLabel.font = _buttonFont;
    button.backgroundColor = [self buttonBgColorWithStyle:action.style];
    button.enabled = action.enabled;
    button.tag = XTAlertView_ButtonTagOffset + _buttons.count;
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button addTarget:self action:@selector(actionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [_buttonContentView addSubview:button];
    [_buttons addObject:button];
    [_actions addObject:action];
    
    if (_buttons.count == 1) {
        [self layoutContentViews];
        [self layoutTextLabels];
    }
    
    [self layoutButtons];
}

- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler
{
    if (_textFields == nil) {
        _textFields = [NSMutableArray array];
    }
    
    UITextField *textField = [[UITextField alloc]init];
    textField.tag = XTAlertView_TextFieldOffset + _textFields.count;
    textField.font = _textFieldFont;
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    
    if (configurationHandler) {
        configurationHandler(textField);
    }
    
    [_textFieldContentView addSubview:textField];
    [_textFields addObject:textField];
    
    if (_textFields.count > 1) {
        if (_textFieldSeparateViews == nil) {
            _textFieldSeparateViews = [NSMutableArray array];
        }
        UIView *separateView = [[UIView alloc]init];
        separateView.backgroundColor = _textFieldBorderColor;
        separateView.translatesAutoresizingMaskIntoConstraints = NO;
        [_textFieldContentView addSubview:separateView];
        [_textFieldSeparateViews addObject:separateView];
    }
    
    [self layoutTextFields];
}

- (NSArray *)textFieldArray {
    return _textFields;
}

#pragma mark - layout contenview

- (void)layoutContentViews {
    if (!_textContentView.translatesAutoresizingMaskIntoConstraints) {
        // layout done
        return;
    }
    if (_alertViewWidth) {
        [self addConstraintWidth:_alertViewWidth height:0];
    }
    
    // textContentView
    _textContentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraintWithView:_textContentView topView:self leftView:self bottomView:nil rightView:self edgeInset:UIEdgeInsetsMake(_contentViewSpace, _textLabelContentViewEdge, 0, -_textLabelContentViewEdge)];
    
    // textFieldContentView
    _textFieldContentView.translatesAutoresizingMaskIntoConstraints = NO;
    _textFieldTopConstraint = [self addConstraintWithTopView:_textContentView toBottomView:_textFieldContentView constant:0];
    
    [self addConstraintWithView:_textFieldContentView topView:nil leftView:self bottomView:nil rightView:self edgeInset:UIEdgeInsetsMake(0, _textFieldContentViewEdge, 0, -_textFieldContentViewEdge)];
    
    // buttonContentView
    _buttonContentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    _buttonTopConstraint = [self addConstraintWithTopView:_textFieldContentView toBottomView:_buttonContentView constant:_buttonContentViewTop];
    
    [self addConstraintWithView:_buttonContentView topView:nil leftView:self bottomView:self rightView:self edgeInset:UIEdgeInsetsMake(0, _buttonContentViewEdge, -_contentViewSpace, -_buttonContentViewEdge)];
}

- (void)layoutTextLabels {
    if (!_titleLable.translatesAutoresizingMaskIntoConstraints && !_messageLabel.translatesAutoresizingMaskIntoConstraints) {
        // layout done
        return;
    }
    // title
    _titleLable.translatesAutoresizingMaskIntoConstraints = NO;
    [_textContentView addConstraintWithView:_titleLable topView:_textContentView leftView:_textContentView bottomView:nil rightView:_textContentView edgeInset:UIEdgeInsetsZero];
    
    // message
    _messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_textContentView addConstraintWithTopView:_titleLable toBottomView:_messageLabel constant:_textLabelSpace];
    [_textContentView addConstraintWithView:_messageLabel topView:nil leftView:_textContentView bottomView:_textContentView rightView:_textContentView edgeInset:UIEdgeInsetsZero];
}

- (void)layoutButtons {
    UIButton *button = _buttons.lastObject;
    if (_buttons.count == 1) {
        _buttonTopConstraint.constant = -_buttonContentViewTop;
        [_buttonContentView addConstraintToView:button edgeInset:UIEdgeInsetsZero];
        [button addConstraintWidth:0 height:_buttonHeight];
    }else if (_buttons.count == 2) {
        UIButton *firstButton = _buttons.firstObject;
        [_buttonContentView removeConstraintWithView:firstButton attribute:NSLayoutAttributeRight];
        [_buttonContentView addConstraintWithView:button topView:_buttonContentView leftView:nil bottomView:nil rightView:_buttonContentView edgeInset:UIEdgeInsetsZero];
        [_buttonContentView addConstraintWithLeftView:firstButton toRightView:button constant:_buttonSpace];
        [_buttonContentView addConstraintEqualWithView:button widthToView:firstButton heightToView:firstButton];
    }else {
        if (_buttons.count == 3) {
            UIButton *firstBtn = _buttons[0];
            UIButton *secondBtn = _buttons[1];
            [_buttonContentView removeConstraintWithView:firstBtn attribute:NSLayoutAttributeRight];
            [_buttonContentView removeConstraintWithView:firstBtn attribute:NSLayoutAttributeBottom];
            [_buttonContentView removeConstraintWithView:secondBtn attribute:NSLayoutAttributeTop];
            [_buttonContentView addConstraintWithView:firstBtn topView:nil leftView:nil bottomView:nil rightView:_buttonContentView edgeInset:UIEdgeInsetsZero];
            [_buttonContentView addConstraintWithTopView:firstBtn toBottomView:secondBtn constant:_buttonSpace];
        }
        
        UIButton *lastSecondBtn = _buttons[_buttons.count - 2];
        [_buttonContentView removeConstraintWithView:lastSecondBtn attribute:NSLayoutAttributeBottom];
        [_buttonContentView addConstraintWithTopView:lastSecondBtn toBottomView:button constant:_buttonSpace];
        [_buttonContentView addConstraintWithView:button topView:nil leftView:_buttonContentView bottomView:_buttonContentView rightView:_buttonContentView edgeInset:UIEdgeInsetsZero];
        [_buttonContentView addConstraintEqualWithView:button widthToView:nil heightToView:lastSecondBtn];
    }
}

- (void)layoutTextFields {
    UITextField *textField = _textFields.lastObject;
    
    if (_textFields.count == 1) {
        // setup textFieldContentView
        _textFieldContentView.backgroundColor = _textFieldBackgroudColor;
        _textFieldContentView.layer.masksToBounds = YES;
        _textFieldContentView.layer.cornerRadius = 4;
        _textFieldContentView.layer.borderWidth = _textFieldBorderWidth;
        _textFieldContentView.layer.borderColor = _textFieldBorderColor.CGColor;
        _textFieldTopConstraint.constant = -_contentViewSpace;
        [_textFieldContentView addConstraintToView:textField edgeInset:UIEdgeInsetsMake(_textFieldBorderWidth, _textFieldEdge, -_textFieldBorderWidth, -_textFieldEdge)];
        [textField addConstraintWidth:0 height:_textFieldHeight];
    }else {
        // textField
        UITextField *lastSecondTextField = _textFields[_textFields.count - 2];
        [_textFieldContentView removeConstraintWithView:lastSecondTextField attribute:NSLayoutAttributeBottom];
        [_textFieldContentView addConstraintWithTopView:lastSecondTextField toBottomView:textField constant:_textFieldBorderWidth];
        [_textFieldContentView addConstraintWithView:textField topView:nil leftView:_textFieldContentView bottomView:_textFieldContentView rightView:_textFieldContentView edgeInset:UIEdgeInsetsMake(0, _textFieldEdge, -_textFieldBorderWidth, -_textFieldEdge)];
        [_textFieldContentView addConstraintEqualWithView:textField widthToView:nil heightToView:lastSecondTextField];
        
        // separateview
        UIView *separateView = _textFieldSeparateViews[_textFields.count - 2];
        [_textFieldContentView addConstraintWithView:separateView topView:nil leftView:_textFieldContentView bottomView:nil rightView:_textFieldContentView edgeInset:UIEdgeInsetsZero];
        [_textFieldContentView addConstraintWithTopView:separateView toBottomView:textField constant:0];
        [separateView addConstraintWidth:0 height:_textFieldBorderWidth];
    }
}

#pragma mark - action

- (void)actionButtonClicked:(UIButton *)button {
    XTAlertAction *action = _actions[button.tag - XTAlertView_ButtonTagOffset];
    if (_clickedAutoHide) {
        [self hideView];
    }
    
    if (action.handler) {
        action.handler(action);
    }
}

//- (void)dealloc
//{
//    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
//}

@end
