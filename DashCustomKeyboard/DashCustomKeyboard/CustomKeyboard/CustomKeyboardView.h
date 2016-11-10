//
//  CustomKeyboardView.h
//  DashCustomKeyboard
//
//  Created by 耿大帅 on 2016/11/10.
//  Copyright © 2016年 耿大帅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomKeyboardDelegate.h"

@class CustomKeyboardView;
@protocol KeyboardDelegate <NSObject>

@optional
/**
 *  点击了文字或字符数字按钮
 */
- (void)keyboardView:(CustomKeyboardView *)keyboardView didClickButton:(UIButton *)button string:(NSMutableString *)string;
/**
 *  点击了删除按钮
 */
- (void)keyboardView:(CustomKeyboardView *)keyboardView didClickDeleteButton:(UIButton *)button string:(NSMutableString *)string;

@end

@interface CustomKeyboardView : UIView

@property (nonatomic, assign) id<KeyboardDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame type:(CustomKeyboardType)keyboardType string:(NSString *)string;

@end
