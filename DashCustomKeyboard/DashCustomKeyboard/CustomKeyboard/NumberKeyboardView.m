//
//  NumberKeyboardView.m
//  DashCustomKeyboard
//
//  Created by 耿大帅 on 2016/11/10.
//  Copyright © 2016年 耿大帅. All rights reserved.
//

#import "NumberKeyboardView.h"
#import "UIView+ViewExtension.h"
#import "CustomKeyboardHelper.h"

/**
 *  创建类的静态成员变量
 */
static NumberKeyboardView *sharedInstance = nil;

@interface NumberKeyboardView()

/**
 接收输入信息的字符串
 */
@property (nonatomic, strong) NSMutableString *innerString;

/**
 完成按钮
 */
@property (nonatomic, strong) UIButton *finishButton;

/**
 删除按钮
 */
@property (nonatomic, strong) UIButton *deleteButton;

/**
 字母键盘切换按钮
 */
@property (nonatomic, strong) UIButton *switchLetterButton;

@end

@implementation NumberKeyboardView

#pragma mark - Singleton Methods

/**
 *  使用单例模式，创建类的实例化对象
 *
 *  @return 返回类的实例化对象
 */
+ (NumberKeyboardView *)sharedInstance {
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
        return self;
    }
    return nil;
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
        return self;
    }
    return self;
}

/**
 绘制子视图
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    // 距离上面
    CGFloat topMargin = 39.2;
    // 距离下面
    CGFloat bottomMargin = 0;
    // 距离左面
    CGFloat leftMargin = 0;
    // 列边缘
    CGFloat columnMargin = 0;
    // 行边缘
    CGFloat rowMargin = 0;
    // 按钮宽度
    CGFloat buttonWidth = (self.width - 2 * leftMargin - 2 * columnMargin) / 3;
    // 按钮高度
    CGFloat buttonHeight = (self.height - topMargin - bottomMargin - 3 * rowMargin) / 4;
    
    NSUInteger count = self.subviews.count;
    // 布局数字按钮
    for (int i = 0; i < count; i++) {
        if (i == 0) {
            UIButton *button = self.subviews[i];
            button.height = buttonHeight;
            button.width = buttonWidth;
            button.centerX = self.centerX;
            button.centerY = self.height - bottomMargin - button.height * 0.5;
            // 删除按钮的位置
            self.deleteButton.x = CGRectGetMaxX(button.frame) + columnMargin;
            self.deleteButton.y = button.y;
            self.deleteButton.width = button.width;
            self.deleteButton.height = button.height;
            // 字母键盘按钮的位置
            self.switchLetterButton.x = leftMargin;
            self.switchLetterButton.y = button.y;
            self.switchLetterButton.width = button.width;
            self.switchLetterButton.height = button.height;
            // 完成按钮的位置
            self.finishButton.x = self.frame.size.width - 73;
            self.finishButton.y = 0;
            self.finishButton.width = 73;
            self.finishButton.height = 39.2;
        }
        
        // 0 ~ 9 按钮的位置
        if (i > 0 && i < 10) {
            UIButton *topButton = self.subviews[i];
            CGFloat row = (i - 1) / 3;
            CGFloat column = (i - 1) % 3;
            topButton.x = leftMargin + column * (buttonWidth + columnMargin);
            topButton.y = topMargin + row * (buttonHeight + rowMargin);
            topButton.width = buttonWidth;
            topButton.height = buttonHeight;
        }
    }
}

#pragma mark - Setup Controls Methods

/**
 在键盘上设置控件
 */
- (void)setupControls {
    // 设置数字按钮
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0 ; i < 10; i++) {
        NSNumber *number = [[NSNumber alloc] initWithInt:i];
        if ([array containsObject:number]) {
            i--;
            continue;
        }
        [array addObject:number];
    }
    
    for (int i = 0; i < 10; i++) {
        NSNumber *number = array[i];
        NSString *title = number.stringValue;
        UIButton *numberButton = [CustomKeyboardHelper createButtonWithTitle:title
                                                                   titleSize:30
                                                                 normalColor:[UIColor whiteColor]
                                                            highlightedColor:[UIColor whiteColor]
                                                                 normalImage:[UIImage imageNamed:@"NumberKeyboardButton"]
                                                            highlightedImage:[UIImage imageNamed:@"NumberKeyboardButtonSelected"]];
        [numberButton addTarget:self action:@selector(numberButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [numberButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self addSubview:numberButton];
    }
    // 设置字母键盘按钮
    self.switchLetterButton = [CustomKeyboardHelper createButtonWithTitle:@"ABC"
                                                                titleSize:20
                                                              normalColor:[UIColor whiteColor]
                                                         highlightedColor:[UIColor whiteColor]
                                                              normalImage:[UIImage imageNamed:@"NumberKeyboardSwitchButton"]
                                                         highlightedImage:[UIImage imageNamed:@"NumberKeyboardButtonSelected"]];
    [self.switchLetterButton addTarget:self action:@selector(switchLetterClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.switchLetterButton];
    // 设置删除按钮
    self.deleteButton = [CustomKeyboardHelper createButtonWithTitle:@""
                                                          titleSize:20
                                                        normalColor:[UIColor whiteColor]
                                                   highlightedColor:[UIColor whiteColor]
                                                        normalImage:[UIImage imageNamed:@"NumberKeyboardDeleteButton"]
                                                   highlightedImage:[UIImage imageNamed:@"NumberKeyboardDeleteButtonSelected"]];
    [self.deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.deleteButton];
    // 设置输入视图信息的控件
    [self setupInfoControls];
}

/**
 设置输入视图信息的控件
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
    [self.finishButton addTarget:self action:@selector(finishButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.finishButton];
    // 设置分割线
    UILabel *splitLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 39.2, [[UIScreen mainScreen] bounds].size.width, 0.3)];
    splitLine.backgroundColor = [UIColor blackColor];
    [self addSubview:splitLine];
}

#pragma mark - Touch Button Methods

/**
 点击数字按钮的处理
 
 @param button 数字按钮
 */
- (void)numberButtonClick:(UIButton *)button {
    [self.innerString appendString:button.currentTitle];
    if ([self.delegate respondsToSelector:@selector(numberKeyboardView:didClickButton:string:)]) {
        [self.delegate numberKeyboardView:self didClickButton:button string:self.innerString];
    }
}

/**
 点击完成按钮的处理
 
 @param button 完成按钮
 */
- (void)finishButtonClick:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(numberKeyboardView:didClickButton:string:)]) {
        [self.delegate numberKeyboardView:self didClickButton:button string:self.innerString];
    }
}

/**
 点击功能按钮的处理
 
 @param button 按钮
 */
- (void)switchLetterClick:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(numberKeyboardView:didClickButton:string:)]) {
        [self.delegate numberKeyboardView:self didClickButton:button string:self.innerString];
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

@end
