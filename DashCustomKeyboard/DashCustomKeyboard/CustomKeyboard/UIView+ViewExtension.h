//
//  UIView+ViewExtension.h
//  DashCustomKeyboard
//
//  Created by 耿大帅 on 2016/11/10.
//  Copyright © 2016年 耿大帅. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ViewExtension)

/**
 X轴坐标
 */
@property (nonatomic, assign) CGFloat x;

/**
 Y轴坐标
 */
@property (nonatomic, assign) CGFloat y;

/**
 宽度
 */
@property (nonatomic, assign) CGFloat width;

/**
 高度
 */
@property (nonatomic, assign) CGFloat height;

/**
 中心点的X轴坐标
 */
@property (nonatomic, assign) CGFloat centerX;

/**
 中心点的Y轴坐标
 */
@property (nonatomic, assign) CGFloat centerY;

/**
 宽度和高度的大小
 */
@property (nonatomic, assign) CGSize size;

/**
 X轴和Y轴坐标
 */
@property (nonatomic, assign) CGPoint origin;

@end
