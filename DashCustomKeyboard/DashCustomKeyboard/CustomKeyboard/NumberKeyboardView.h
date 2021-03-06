//
//  NumberKeyboardView.h
//  DashCustomKeyboard
//
//  Created by 耿大帅 on 2016/11/10.
//  Copyright © 2016年 耿大帅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomKeyboardDelegate.h"

@interface NumberKeyboardView : UIView

@property (nonatomic, assign) id<CustomKeyboardDelegate> delegate;

+ (NumberKeyboardView *)sharedInstance;
- (instancetype)initWithFrame:(CGRect)frame string:(NSString *)string;

@end
