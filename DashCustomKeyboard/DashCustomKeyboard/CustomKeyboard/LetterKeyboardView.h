//
//  LetterKeyboardView.h
//  DashCustomKeyboard
//
//  Created by 耿大帅 on 2016/11/10.
//  Copyright © 2016年 耿大帅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomKeyboardDelegate.h"

@interface LetterKeyboardView : UIView

@property (nonatomic, assign) id<CustomKeyboardDelegate> delegate;

+ (LetterKeyboardView *)sharedInstance;
- (instancetype)initWithFrame:(CGRect)frame string:(NSString *)string;

@end
