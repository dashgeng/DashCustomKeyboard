//
//  CustomKeyboardHelper.m
//  DashCustomKeyboard
//
//  Created by 耿大帅 on 2016/11/10.
//  Copyright © 2016年 耿大帅. All rights reserved.
//

#import "CustomKeyboardHelper.h"

@implementation CustomKeyboardHelper

/**
 创建按钮

 @param title 按钮显示的标题
 @param size 字体大小
 @param normalColor 正常字体颜色
 @param highlightedColor 高亮字体颜色
 @param normalImage 正常背景图像
 @param highlightedImage 高亮背景图像
 @return 返回创建的按钮
 */
+ (UIButton *)createButtonWithTitle:(NSString *)title
                          titleSize:(CGFloat)size
                        normalColor:(UIColor *)normalColor
                   highlightedColor:(UIColor *)highlightedColor
                        normalImage:(UIImage *)normalImage
                   highlightedImage:(UIImage *)highlightedImage {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:size];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:normalColor forState:UIControlStateNormal];
    [button setTitleColor:highlightedColor forState:UIControlStateHighlighted];
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    return button;
}

@end
