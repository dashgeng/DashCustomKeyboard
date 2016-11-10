//
//  CustomKeyboardView.m
//  DashCustomKeyboard
//
//  Created by 耿大帅 on 2016/11/10.
//  Copyright © 2016年 耿大帅. All rights reserved.
//

#import "CustomKeyboardView.h"
#import "LetterKeyboardView.h"
#import "SymbolKeyboardView.h"
#import "NumberKeyboardView.h"

@interface CustomKeyboardView () <CustomKeyboardDelegate>

@property (nonatomic, strong) LetterKeyboardView *letterKeyboardView;
@property (nonatomic, strong) SymbolKeyboardView *symbolKeyboardView;
@property (nonatomic, strong) NumberKeyboardView *numberKeyboardView;

@property (nonatomic, strong) NSMutableString *innerString;

@end

@implementation CustomKeyboardView

#pragma mark - Initialization Methods

- (LetterKeyboardView *)letterKeyboardView {
    if (!_letterKeyboardView) {
        _letterKeyboardView = [[LetterKeyboardView sharedInstance] initWithFrame:self.bounds string:self.innerString];
        _letterKeyboardView.delegate = self;
    }
    return _letterKeyboardView;
}

- (SymbolKeyboardView *)symbolKeyboardView {
    if (!_symbolKeyboardView) {
        _symbolKeyboardView = [[SymbolKeyboardView sharedInstance] initWithFrame:self.bounds string:self.innerString];
        _symbolKeyboardView.delegate = self;
    }
    return _symbolKeyboardView;
}

- (NumberKeyboardView *)numberKeyboardView {
    if (!_numberKeyboardView) {
        _numberKeyboardView = [[NumberKeyboardView sharedInstance] initWithFrame:self.bounds string:self.innerString];
        _numberKeyboardView.delegate = self;
    }
    return _numberKeyboardView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 186, [[UIScreen mainScreen] bounds].size.width, 246);
        self.innerString = [NSMutableString string];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"KeyboardStatusIsUpper"]) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KeyboardStatusIsUpper"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        [self addSubview:self.symbolKeyboardView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame type:(CustomKeyboardType)keyboardType string:(NSString *)string {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.innerString = [NSMutableString stringWithString:string];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"KeyboardStatusIsUpper"]) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KeyboardStatusIsUpper"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        switch (keyboardType) {
            case 1:
                [self addSubview:self.letterKeyboardView];
                break;
            case 2:
                [self addSubview:self.symbolKeyboardView];
                break;
            case 3:
                [self addSubview:self.numberKeyboardView];
                break;
            default:
                break;
        }
    }
    return self;
}

#pragma CustomKeyboardDelegate Methods

/**
 字母键盘上点击按钮的处理
 
 @param view 视图
 @param button 按钮
 @param string 字符串
 */
- (void)letterKeyboardView:(LetterKeyboardView *)view didClickButton:(UIButton *)button string:(NSString *)string {
    if ([button.currentTitle isEqualToString:@"#+="]) {
        [view removeFromSuperview];
        [self addSubview:self.symbolKeyboardView];
    } else if ([button.currentTitle isEqualToString:@"123"]) {
        [view removeFromSuperview];
        [self addSubview:self.numberKeyboardView];
    } else if ([button.currentTitle isEqualToString:@"完成"]) {
        [self.nextResponder resignFirstResponder];
    } else {
        [self appendString:button];
    }
}

/**
 符号键盘上点击按钮的处理
 
 @param view 视图
 @param button 按钮
 @param string 字符串
 */
- (void)symbolKeyboardView:(SymbolKeyboardView *)view didClickButton:(UIButton *)button string:(NSString *)string {
    if ([button.currentTitle isEqualToString:@"ABC"]) {
        [view removeFromSuperview];
        [self addSubview:self.letterKeyboardView];
    } else if ([button.currentTitle isEqualToString:@"123"]) {
        [view removeFromSuperview];
        [self addSubview:self.numberKeyboardView];
    } else if ([button.currentTitle isEqualToString:@"完成"]) {
        [self.nextResponder resignFirstResponder];
    } else {
        [self appendString:button];
    }
}

/**
 数字键盘上点击按钮的处理
 
 @param view 视图
 @param button 按钮
 @param string 字符串
 */
- (void)numberKeyboardView:(NumberKeyboardView *)view didClickButton:(UIButton *)button string:(NSString *)string {
    if ([button.currentTitle isEqualToString:@"#+="]) {
        [view removeFromSuperview];
        [self addSubview:self.symbolKeyboardView];
    } else if ([button.currentTitle isEqualToString:@"ABC"]) {
        [view removeFromSuperview];
        [self addSubview:self.letterKeyboardView];
    } else if ([button.currentTitle isEqualToString:@"完成"]) {
        [self.nextResponder resignFirstResponder];
    } else {
        [self appendString:button];
    }
}

/**
 点击删除按钮的处理
 
 @param button 按钮
 */
- (void)didClickDeleteButton:(UIButton *)button string:(NSString *)string {
    if (self.innerString.length > 0) {
        [self.innerString deleteCharactersInRange:NSMakeRange(self.innerString.length - 1, 1)];
        if ([self.delegate respondsToSelector:@selector(keyboardView:didClickDeleteButton:string:)]) {
            [self.delegate keyboardView:self didClickDeleteButton:button string:self.innerString];
        }
    }
}

#pragma Private Methods

/**
 追加字符串处理
 
 @param button 按钮
 */
- (void)appendString:(UIButton *)button {
    if ([button.currentTitle isEqualToString:@"空格"]) {
        [self.innerString appendString:@" "];
    } else {
        [self.innerString appendString:button.currentTitle];
    }
    if ([self.delegate respondsToSelector:@selector(keyboardView:didClickButton:string:)]) {
        [self.delegate keyboardView:self didClickButton:button string:self.innerString];
    }
}

@end
