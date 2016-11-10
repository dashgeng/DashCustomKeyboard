//
//  SymbolKeyboardView.m
//  DashCustomKeyboard
//
//  Created by 耿大帅 on 2016/11/10.
//  Copyright © 2016年 耿大帅. All rights reserved.
//

#import "SymbolKeyboardView.h"
#import "UIView+ViewExtension.h"
#import "CustomKeyboardHelper.h"

/**
 *  创建类的静态成员变量
 */
static SymbolKeyboardView *sharedInstance = nil;

@interface SymbolKeyboardView()

/**
 接收输入信息的字符串
 */
@property (nonatomic, strong) NSMutableString *innerString;

/**
 符号数组
 */
@property (nonatomic, strong) NSArray *symbolArray;

/**
 符号按钮数组
 */
@property (nonatomic, strong) NSMutableArray *symbolButtonArray;

/**
 完成按钮
 */
@property (nonatomic, strong) UIButton *finishButton;

/**
 删除按钮
 */
@property (nonatomic, strong) UIButton *deleteButton;

/**
 数字键盘切换按钮
 */
@property (nonatomic, strong) UIButton *switchNumberButton;

/**
 字母键盘切换按钮
 */
@property (nonatomic, strong) UIButton *switchLetterButton;

@end

@implementation SymbolKeyboardView

#pragma mark - Singleton Methods

/**
 *  使用单例模式，创建类的实例化对象
 *
 *  @return 返回类的实例化对象
 */
+ (SymbolKeyboardView *)sharedInstance {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [[self alloc] init];
        }
    }
    return sharedInstance;
}

/**
 *  重写 NSObject 的 allocWithZone: 方法，创建类的实例化对象
 *
 *  @param zone 区域
 *
 *  @return 返回类的实例化对象
 */
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;
        }
    }
    return nil;
}

#pragma mark - Initialization Methods

/**
 初始化符号数组
 
 @return 初始化后的符号数组
 */
- (NSArray *)symbolArray {
    if (!_symbolArray) {
        _symbolArray = @[@"~",@"`",@"!",@"@",@"#",@"$",@"%",@"^",@"&",@"*",@"(",@")",@"_",@"-",@"+",@"=",@"{",@"}",@"[",@"]",@"|",@"\\",@":",@";",@"\"",@"'",@"<",@",",@">",@".",@"?",@"/"];
    }
    return _symbolArray;
}

/**
 初始化符号按钮数组
 
 @return 初始化后的符号按钮数组
 */
- (NSMutableArray *)symbolButtonArray {
    if (!_symbolButtonArray) {
        _symbolButtonArray = [NSMutableArray array];
    }
    return _symbolButtonArray;
}

/**
 初始化视图框架
 
 @param frame 框架
 @return 初始化的视图框架
 */
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.innerString = [NSMutableString string];
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"KeyboardBackground"]];
        [self setupControls];
    }
    return self;
}

/**
 初始化视图框架
 
 @param frame 框架
 @param string 输入内容
 @return 初始化的视图框架
 */
- (instancetype)initWithFrame:(CGRect)frame string:(NSString *)string {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.innerString = [NSMutableString stringWithString:string];
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"KeyboardBackground"]];
        [self setupControls];
    }
    return self;
}

/**
 绘制子视图
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    // 距离上面
    CGFloat topMargin = 37;
    // 距离下面
    CGFloat bottomMargin = 16;
    // 距离左面
    CGFloat leftMargin = 3;
    // 列边缘
    CGFloat columnMargin = 3;
    // 行边缘
    CGFloat rowMargin = 3;
    // 按钮宽度
    CGFloat buttonWidth = (self.width - 9 * columnMargin - leftMargin * 2) / 10;
    // 按钮宽度
    CGFloat buttonHeight = (self.height - (topMargin + bottomMargin + 3 * rowMargin)) / 4;
    
    NSUInteger count = self.symbolButtonArray.count;
    for (NSUInteger i = 0; i < count; i++) {
        UIButton *button = (UIButton *)self.symbolButtonArray[i];
        CGFloat floatWidth;
        floatWidth = buttonWidth - 4;
        //        if (kIS_IPHONE_4_OR_LESS) {
        //            floatWidth = buttonW-1;
        //        }else if (kIS_IPHONE_5) {
        //            floatWidth = buttonW-2;
        //        }else{
        //            floatWidth = buttonW-4;
        //        }
        button.width = floatWidth;
        button.height = buttonHeight - 10;
        
        CGFloat floatX = 0.0;
        
        if (i < 10) { // 第一行
            button.x = (columnMargin + buttonWidth) * i + leftMargin + 2;
            button.y = topMargin + 15;
        } else if (i < 20) { // 第二行
            button.x = ((columnMargin + buttonWidth) * i + leftMargin + 4) - [[UIScreen mainScreen] bounds].size.width;
            button.y = topMargin + rowMargin + buttonHeight + 15;
        } else if (i < 28) { // 第三行
            floatX = 20;
            //            if (kIS_IPHONE_4_OR_LESS || kIS_IPHONE_5) {
            //                floatX = 20;
            //            }else{ //if (kIS_IPHONE_6 || kIS_IPHONE_6P) {
            //                floatX = 20;
            //            }
            
            button.x = ((columnMargin + buttonWidth) * i + leftMargin + 4) - ([[UIScreen mainScreen] bounds].size.width * 2) + 37 - floatX;
            button.y = (topMargin + 2 * rowMargin + 2 * buttonHeight) + 15;
        } else if (i < count) {
            floatX = 6;
            //            if (kIS_IPHONE_4_OR_LESS || kIS_IPHONE_5) {
            //                floatX = 16;
            //            }else if (kIS_IPHONE_6) {
            //                floatX = 6;
            //            }else{
            //                floatX = 2;
            //            }
            
            button.x = ((columnMargin + buttonWidth) * (i - 28) + leftMargin + buttonWidth / 2 + columnMargin + buttonWidth + columnMargin) + 62 - floatX;
            button.y = (topMargin + 3 * rowMargin + 3 * buttonHeight) + 15;
        }
    }
    
    // 布局其他功能按钮  切换大小写、删除回退、确定（登录）、 数字、符号
    CGFloat shiftButtonY = topMargin + 2 * rowMargin + 2 * buttonHeight;
    CGFloat deleteButtonWidth = buttonWidth / 2 + buttonWidth;
    
    CGFloat finishButtonWidth = 2 * buttonWidth + columnMargin;
    CGFloat finishButtonY = self.height - bottomMargin - buttonHeight;
    CGFloat finishButtonX = self.width - leftMargin - finishButtonWidth;
    
    CGFloat switchButtonWidth = (finishButtonX - 2 * columnMargin - leftMargin) / 2;
    
    //    CGFloat floatWidth;
    //    if (kIS_IPHONE_4_OR_LESS) {
    //        floatWidth = (finishButtonW*2)+25;
    //    }else if (kIS_IPHONE_5) {
    //        floatWidth = (finishButtonW*2)+27;
    //    }else if(kIS_IPHONE_6){
    //        floatWidth = (finishButtonW*2)+37;
    //    }else{
    //        floatWidth = (finishButtonW*2)+46;
    //    }
    // 设置完成按钮位置
    self.finishButton.x = self.frame.size.width - 73;
    self.finishButton.y = 0;
    self.finishButton.width = 73;
    self.finishButton.height = 39.2;
    
    CGFloat letterButtonWidth = 2 * buttonWidth + columnMargin;
    CGFloat letterButtonY = self.height - bottomMargin - buttonHeight;
    
    // 设置删除按钮位置
    self.deleteButton.frame = CGRectMake(self.width - leftMargin - deleteButtonWidth - 2, shiftButtonY + 15, deleteButtonWidth, buttonHeight - 10);
    // 设置数字按钮位置
    self.switchNumberButton.frame = CGRectMake(leftMargin + 3, finishButtonY + 15, (switchButtonWidth / 2) + 25, buttonHeight - 10);
    // 设置字符按钮位置
    self.switchLetterButton.frame = CGRectMake(self.width - leftMargin - letterButtonWidth - 32, letterButtonY + 15, (switchButtonWidth / 2) + 30, buttonHeight - 10);
}

#pragma mark - Setup Controls Methods

/**
 设置输入视图上的控件
 */
- (void)setupControls {
    // 设置字母按钮
    NSUInteger count = self.symbolArray.count;
    [self.symbolButtonArray removeAllObjects];
    for (NSUInteger i = 0; i < count; i++) {
        NSString *title = self.symbolArray[i];
        UIButton *button = [CustomKeyboardHelper createButtonWithTitle:title
                                                              titleSize:20
                                                            normalColor:[UIColor whiteColor]
                                                       highlightedColor:[UIColor whiteColor]
                                                            normalImage:[UIImage imageNamed:@"SymbolKeyboardButton"]
                                                       highlightedImage:[UIImage imageNamed:@"SymbolKeyboardButtonSelected"]];
        [self addSubview:button];
        [button addTarget:self action:@selector(symbolButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.symbolButtonArray addObject:button];
    }
    // 设置删除键按钮
    self.deleteButton = [CustomKeyboardHelper createButtonWithTitle:@""
                                                          titleSize:20
                                                        normalColor:[UIColor whiteColor]
                                                   highlightedColor:[UIColor whiteColor]
                                                        normalImage:[UIImage imageNamed:@"SymbolKeyboardDeleteButton"]
                                                   highlightedImage:[UIImage imageNamed:@"SymbolKeyboardDeleteButtonSelected"]];
    [self.deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.deleteButton];
    // 设置数字键盘按钮
    self.switchNumberButton = [CustomKeyboardHelper createButtonWithTitle:@"123"
                                                                titleSize:20
                                                              normalColor:[UIColor whiteColor]
                                                         highlightedColor:[UIColor blackColor]
                                                              normalImage:[UIImage imageNamed:@"SymbolKeyboardSwitchButton"]
                                                         highlightedImage:[UIImage imageNamed:@"SymbolKeyboardSwitchButton"]];
    [self.switchNumberButton addTarget:self action:@selector(functionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.switchNumberButton];
    // 设置字母键盘按钮
    self.switchLetterButton = [CustomKeyboardHelper createButtonWithTitle:@"ABC"
                                                                titleSize:20
                                                              normalColor:[UIColor whiteColor]
                                                         highlightedColor:[UIColor blackColor]
                                                              normalImage:[UIImage imageNamed:@"SymbolKeyboardSwitchButton"]
                                                         highlightedImage:[UIImage imageNamed:@"SymbolKeyboardSwitchButton"]];
    [self.switchLetterButton addTarget:self action:@selector(functionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.switchLetterButton];
    // 设置输入视图信息控件
    [self setupInfoControls];
}

/**
 设置输入视图信息控件
 */
- (void)setupInfoControls {
    // 设置标题
    UILabel *labelText = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, [[UIScreen mainScreen] bounds].size.width - 80, 39.2)];
    labelText.text = @"安全输入";
    labelText.textColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
    labelText.textAlignment = NSTextAlignmentCenter;
    labelText.font = [UIFont systemFontOfSize:16];
    [self addSubview:labelText];
    // 设置Logo
    CGFloat floatX = 125;
    //    if (kIS_IPHONE_4_OR_LESS) {
    //        floatX = 95;
    //    }else if (kIS_IPHONE_5){
    //        floatX = 97;
    //    }else if (kIS_IPHONE_6){
    //        floatX = 125;
    //    }else{
    //        floatX = 145;
    //    }
    UIImageView *logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(floatX - 10, 10, 20, 20)];
    logoImage.image = [UIImage imageNamed:@"KeyboardLogo"];
    [self addSubview:logoImage];
    // 设置完成按钮
    self.finishButton = [CustomKeyboardHelper createButtonWithTitle:@"完成"
                                                          titleSize:18
                                                        normalColor:[UIColor whiteColor]
                                                   highlightedColor:[UIColor whiteColor]
                                                        normalImage:[UIImage imageNamed:@"KeyboardBackground"]
                                                   highlightedImage:[UIImage imageNamed:@"KeyboardFinishButtonSelected"]];
    [self.finishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.finishButton addTarget:self action:@selector(finishButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.finishButton];
    // 设置分割线
    UILabel *splitLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 39.2, [[UIScreen mainScreen] bounds].size.width, 0.3)];
    splitLine.backgroundColor = [UIColor blackColor];
    [self addSubview:splitLine];
}

#pragma mark - Touch Button Methods

// 符号按钮
- (void)symbolButtonClick:(UIButton *)button {
    [self.innerString appendString:button.currentTitle];
    if ([self.delegate respondsToSelector:@selector(symbolKeyboardView:didClickButton:string:)]) {
        [self.delegate symbolKeyboardView:self didClickButton:button string:self.innerString];
    }
}

/**
 点击删除按钮的处理
 
 @param button 删除按钮
 */
- (void)deleteButtonClick:(UIButton *)button {
    if (self.innerString.length > 0) {
        [self.innerString deleteCharactersInRange:NSMakeRange(self.innerString.length - 1, 1)];
        if ([self.delegate respondsToSelector:@selector(didClickDeleteButton:string:)]) {
            [self.delegate didClickDeleteButton:button string:self.innerString];
        }
    }
}

/**
 点击功能按钮的处理
 
 @param button 按钮
 */
- (void)functionButtonClick:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(symbolKeyboardView:didClickButton:string:)]) {
        [self.delegate symbolKeyboardView:self didClickButton:button string:self.innerString];
    }
}

/**
 点击完成按钮的处理
 
 @param button 完成按钮
 */
- (void)finishButtonClick:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(symbolKeyboardView:didClickButton:string:)]) {
        [self.delegate symbolKeyboardView:self didClickButton:button string:self.innerString];
    }
}

@end
