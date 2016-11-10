//
//  CustomKeyboardHelper.h
//  DashCustomKeyboard
//
//  Created by 耿大帅 on 2016/11/10.
//  Copyright © 2016年 耿大帅. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CustomKeyboardHelper : NSObject

+ (UIButton *)createButtonWithTitle:(NSString *)title
                          titleSize:(CGFloat)size
                        normalColor:(UIColor *)normalColor
                   highlightedColor:(UIColor *)highlightedColor
                        normalImage:(UIImage *)normalImage
                   highlightedImage:(UIImage *)highlightedImage;
@end
