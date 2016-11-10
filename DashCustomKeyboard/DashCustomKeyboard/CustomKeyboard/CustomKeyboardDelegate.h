//
//  CustomKeyboardDelegate.h
//  DashCustomKeyboard
//
//  Created by 耿大帅 on 2016/11/10.
//  Copyright © 2016年 耿大帅. All rights reserved.
//

/**
 *  自定义键盘类型
 */
typedef NS_ENUM(NSInteger, CustomKeyboardType) {
    /**
     *  字母键盘(可切换至符号或数字键盘)
     */
    KeyboardLetter = 1,
    /**
     *  符号键盘(可切换至字母或数字键盘)
     */
    KeyboardSymbol = 2,
    /**
     *  数字键盘(可切换至字母键盘)
     */
    KeyboardNumber = 3,
    /**
     *  数字键盘(不能切换至其它键盘)
     */
    KeyboardOnlyNumber = 4,
    /**
     *  带小数点的数字键盘(不能切换至其它键盘)
     */
    KeyboardDecimal = 5,
    /**
     *  带字母X的数字键盘(用于身份证号码输入，不能切换其它键盘)
     */
    KeyboardIDNumber = 6,
    /**
     *  带*#+字符的电话键盘(不能切换至其它键盘)
     */
    KeyboardPhone = 7,
};

@class LetterKeyboardView, SymbolKeyboardView, NumberKeyboardView;
@protocol CustomKeyboardDelegate <NSObject>

@optional

- (void)letterKeyboardView:(LetterKeyboardView *)view didClickButton:(UIButton *)button string:(NSString *)string;
- (void)symbolKeyboardView:(SymbolKeyboardView *)view didClickButton:(UIButton *)button string:(NSString *)string;
- (void)numberKeyboardView:(NumberKeyboardView *)view didClickButton:(UIButton *)button string:(NSString *)string;
- (void)didClickDeleteButton:(UIButton *)button string:(NSMutableString *)string;

@end

@interface DashKeyboardTool : NSObject

@end
