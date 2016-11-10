//
//  LetterKeyboardView.m
//  DashCustomKeyboard
//
//  Created by 耿大帅 on 2016/11/10.
//  Copyright © 2016年 耿大帅. All rights reserved.
//

#import "LetterKeyboardView.h"
#import "UIView+ViewExtension.h"
#import "CustomKeyboardHelper.h"

/**
 *  创建类的静态成员变量
 */
static LetterKeyboardView *sharedInstance = nil;

@interface LetterKeyboardView()

/**
 接收输入信息的字符串
 */
@property (nonatomic, strong) NSMutableString *innerString;

/**
 小写字母数组
 */
@property (nonatomic, strong) NSArray *lettersArray;

/**
 大写字母数组
 */
@property (nonatomic, strong) NSArray *uppersArray;

/**
 字母按钮数组
 */
@property (nonatomic, strong) NSMutableArray *charButtonArray;

/**
 当前字符数组
 */
@property (nonatomic, strong) NSMutableArray *currentCharArray;

/**
 键盘状态 0: 小写  1: 大写  2: 始终大写
 */
@property (nonatomic, strong) NSString *keyboardStatus;

/**
 完成按钮
 */
@property (nonatomic, strong) UIButton *finishButton;

/**
 切换大小写按钮
 */
@property (nonatomic, strong) UIButton *shiftButton;

/**
 删除按钮
 */
@property (nonatomic, strong) UIButton *deleteButton;

/**
 空格按钮
 */
@property (nonatomic, strong) UIButton *spaceButton;

/**
 数字键盘切换按钮
 */
@property (nonatomic, strong) UIButton *switchNumberButton;

/**
 符号键盘切换按钮
 */
@property (nonatomic, strong) UIButton *switchSymbolButton;

@end

@implementation LetterKeyboardView

#pragma mark - Singleton Methods

/**
 *  使用单例模式，创建类的实例化对象
 *
 *  @return 返回类的实例化对象
 */
+ (LetterKeyboardView *)sharedInstance {
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
 初始化小写字母数组
 
 @return 初始化后的小写字母数组
 */
- (NSArray *)lettersArray {
    if (!_lettersArray) {
        _lettersArray = @[@"q",@"w",@"e",@"r",@"t",@"y",@"u",@"i",@"o",@"p",@"a",@"s",@"d",@"f",@"g",@"h",@"j",@"k",@"l",@"z",@"x",@"c",@"v",@"b",@"n",@"m"];
    }
    return _lettersArray;
}

/**
 初始化大写字母数组
 
 @return 初始化后的大写字母数组
 */
- (NSArray *)uppersArray {
    if (!_uppersArray) {
        _uppersArray = @[@"Q",@"W",@"E",@"R",@"T",@"Y",@"U",@"I",@"O",@"P",@"A",@"S",@"D",@"F",@"G",@"H",@"J",@"K",@"L",@"Z",@"X",@"C",@"V",@"B",@"N",@"M"];
    }
    return _uppersArray;
}

/**
 初始化字符按钮数组
 
 @return 初始化后的字符按钮数组
 */
- (NSMutableArray *)charButtonArray {
    if (!_charButtonArray) {
        _charButtonArray = [NSMutableArray array];
    }
    return _charButtonArray;
}

/**
 初始化当前使用的字符数组
 
 @return 初始化后的当前使用的字符数组
 */
- (NSMutableArray *)currentCharArray {
    if (!_currentCharArray) {
        _currentCharArray = [NSMutableArray array];
    }
    return _currentCharArray;
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
        self.keyboardStatus = @"0";
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
        self.keyboardStatus = @"0";
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
    CGFloat buttonWidth = (self.width - 2 * leftMargin - 9 * columnMargin) / 10;
    // 按钮高度
    CGFloat buttonHeight = (self.height - topMargin - bottomMargin - 3 * rowMargin) / 4;
    // 布局字母按钮
    NSUInteger count = self.charButtonArray.count;
    for (NSUInteger i = 0; i < count; i++) {
        UIButton *button = (UIButton *)self.charButtonArray[i];
        CGFloat floatWidth = buttonWidth - 4;
        //        if (kIS_IPHONE_4_OR_LESS) {
        //            floatWidth = buttonW-1;
        //        }else if (kIS_IPHONE_5) {
        //            floatWidth = buttonW-2;
        //        }else{
        //            floatWidth = buttonW-4;
        //        }
        button.width = floatWidth;
        button.height = buttonHeight - 10;
        if (i < 10) { // 第一行
            button.x = (columnMargin + buttonWidth) * i + leftMargin + 2;
            button.y = topMargin+15;
        } else if (i < 19) { // 第二行
            button.x = (columnMargin + buttonWidth) * (i - 10) + leftMargin + buttonWidth / 2 + columnMargin;
            button.y = topMargin + rowMargin + buttonHeight + 15;
        } else if (i < count) {
            button.x = (columnMargin + buttonWidth) * (i - 19) + leftMargin + buttonWidth / 2 + columnMargin + buttonWidth;
            button.y = (topMargin + 2 * rowMargin + 2 * buttonHeight) + 15;
        }
    }
    
    // 切换大小写按钮的位置
    CGFloat shiftButtonWidth = buttonWidth / 2 + columnMargin + buttonWidth;
    CGFloat shiftButtonY = topMargin + 2 * rowMargin + 2 * buttonHeight;
    self.shiftButton.frame = CGRectMake(leftMargin + 2, shiftButtonY + 15, shiftButtonWidth - 10, buttonHeight - 10);
    // 删除按钮的位置
    CGFloat deleteButtonWidth = buttonWidth / 2 + buttonWidth;
    self.deleteButton.frame = CGRectMake(self.width - leftMargin - deleteButtonWidth - 2, shiftButtonY + 15, deleteButtonWidth, buttonHeight - 10);
    // 数字键盘按钮的位置
    CGFloat finishButtonWidth = 2 * buttonWidth + columnMargin;
    CGFloat finishButtonX = self.width - leftMargin - finishButtonWidth;
    CGFloat finishButtonY = self.height - bottomMargin - buttonHeight;
    CGFloat switchButtonWidth = (finishButtonX - 2 * columnMargin - leftMargin) / 2;
    self.switchNumberButton.frame = CGRectMake(leftMargin + 3, finishButtonY + 15, (switchButtonWidth / 2) + 15, buttonHeight - 10);
    // 空格键的位置
    CGFloat floatWidth;
    floatWidth = (finishButtonWidth * 2) + 37;
    //    if (kIS_IPHONE_4_OR_LESS) {
    //        floatWidth = (loginBtnW*2)+25;
    //    }else if (kIS_IPHONE_5) {
    //        floatWidth = (loginBtnW*2)+27;
    //    }else if(kIS_IPHONE_6){
    //        floatWidth = (loginBtnW*2)+37;
    //    }else{
    //        floatWidth = (loginBtnW*2)+46;
    //    }
    self.spaceButton.frame = CGRectMake(self.switchNumberButton.frame.size.width + 10, finishButtonY + 15, floatWidth, buttonHeight - 10);
    // 符号键盘按钮的位置
    self.switchSymbolButton.frame = CGRectMake(self.switchNumberButton.frame.size.width + self.spaceButton.frame.size.width + 15, finishButtonY + 15, finishButtonWidth + 16, buttonHeight - 10);
    // 完成按钮的位置
    self.finishButton.x = self.frame.size.width - 73;
    self.finishButton.y = 0;
    self.finishButton.width = 73;
    self.finishButton.height = 39.2;
}

#pragma mark - Setup Controls Methods

/**
 设置输入视图上的控件
 */
- (void)setupControls {
    // 添加26个字母按钮
    UIImage *normalImage = [UIImage imageNamed:@"LetterKeyboardButton"];
    UIImage *highlightedImage = [UIImage imageNamed:@"LetterKeyboardButtonSelected"];
    
    NSUInteger count = self.lettersArray.count;
    [self.charButtonArray removeAllObjects];
    for (NSUInteger i = 0 ; i < count; i++) {
        UIButton *button = [CustomKeyboardHelper createButtonWithTitle:@""
                                                             titleSize:22
                                                           normalColor:[UIColor whiteColor]
                                                      highlightedColor:[UIColor whiteColor]
                                                           normalImage:normalImage
                                                      highlightedImage:highlightedImage];
        
        [button addTarget:self action:@selector(charButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [self.charButtonArray addObject:button];
    }
    
    // 设置空格键按钮
    self.spaceButton = [CustomKeyboardHelper createButtonWithTitle:@"空格"
                                                         titleSize:18
                                                       normalColor:[UIColor whiteColor]
                                                  highlightedColor:[UIColor blackColor]
                                                       normalImage:[UIImage imageNamed:@"LetterKeyboardSpaceButton"]
                                                  highlightedImage:[UIImage imageNamed:@"LetterKeyboardSpaceButtonSelected"]];
    [self.spaceButton addTarget:self action:@selector(functionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.spaceButton];
    // 设置切换大小写键按钮
    self.shiftButton = [CustomKeyboardHelper createButtonWithTitle:@""
                                                         titleSize:20
                                                       normalColor:[UIColor whiteColor]
                                                  highlightedColor:[UIColor whiteColor]
                                                       normalImage:[UIImage imageNamed:@"LetterKeyboardShiftButton"]
                                                  highlightedImage:[UIImage imageNamed:@"LetterKeyboardShiftButtonSelected"]];
    [self.shiftButton addTarget:self action:@selector(changeKeyboardStatus:) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapShiftButton:)];
    [doubleTapGestureRecognizer setNumberOfTapsRequired:2];
    [self.shiftButton addGestureRecognizer:doubleTapGestureRecognizer];
    [self addSubview:self.shiftButton];
    // 设置删除键按钮
    self.deleteButton = [CustomKeyboardHelper createButtonWithTitle:@""
                                                          titleSize:20
                                                        normalColor:[UIColor whiteColor]
                                                   highlightedColor:[UIColor whiteColor]
                                                        normalImage:[UIImage imageNamed:@"LetterKeyboardDeleteButton"]
                                                   highlightedImage:[UIImage imageNamed:@"LetterKeyboardDeleteButtonSelected"]];
    [self.deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.deleteButton];
    // 设置数字键盘按钮
    self.switchNumberButton = [CustomKeyboardHelper createButtonWithTitle:@"123"
                                                                titleSize:20
                                                              normalColor:[UIColor whiteColor]
                                                         highlightedColor:[UIColor blackColor]
                                                              normalImage:[UIImage imageNamed:@"LetterKeyboardSwitchButton"]
                                                         highlightedImage:[UIImage imageNamed:@"LetterKeyboardSwitchButton"]];
    [self.switchNumberButton addTarget:self action:@selector(functionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.switchNumberButton];
    // 设置符号键盘按钮
    self.switchSymbolButton = [CustomKeyboardHelper createButtonWithTitle:@"#+="
                                                                titleSize:20
                                                              normalColor:[UIColor whiteColor]
                                                         highlightedColor:[UIColor blackColor]
                                                              normalImage:[UIImage imageNamed:@"LetterKeyboardSwitchButton"]
                                                         highlightedImage:[UIImage imageNamed:@"LetterKeyboardSwitchButton"]];
    [self.switchSymbolButton addTarget:self action:@selector(functionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.switchSymbolButton];
    // 设置输入视图信息控件
    [self setupInfoControls];
    // 设置键盘状态
    [self changeKeyboardStatus:nil];
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

/**
 点击字符按钮的处理
 
 @param button 字符按钮
 */
- (void)charButtonClick:(UIButton *)button {
    /**
     *  切换键盘  点击了大写 输入一个字符 就切换键盘
     */
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"KeyboardStatusIsUpper"]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KeyboardStatusIsUpper"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        self.keyboardStatus = @"0";
        [self.currentCharArray removeAllObjects];
        self.currentCharArray = [NSMutableArray arrayWithArray:self.uppersArray];
        
        NSUInteger count1 = self.charButtonArray.count;
        for (int i = 0; i < count1; i++) {
            UIButton *charBtn = (UIButton *)self.charButtonArray[i];
            NSString *upperTitle = self.currentCharArray[i];
            [charBtn setTitle:upperTitle forState:UIControlStateNormal];
        }
        
        [self.shiftButton setSelected:NO];
        [self.shiftButton setBackgroundImage:[UIImage imageNamed:@"LetterKeyboardShiftButton"] forState:UIControlStateNormal];
        [self.shiftButton setBackgroundImage:[UIImage imageNamed:@"LetterKeyboardShiftButtonSelected"] forState:UIControlStateSelected];
        
        [self.innerString appendString:button.currentTitle];
        if ([self.delegate respondsToSelector:@selector(letterKeyboardView:didClickButton:string:)]) {
            [self.delegate letterKeyboardView:self didClickButton:button string:self.innerString];
        }
        
        self.keyboardStatus = @"1";
        [self.currentCharArray removeAllObjects];
        self.currentCharArray = [NSMutableArray arrayWithArray:self.lettersArray];
        
        NSUInteger count = self.charButtonArray.count;
        for (int i = 0; i < count; i++) {
            UIButton *button = (UIButton *)self.charButtonArray[i];
            NSString *title = self.currentCharArray[i];
            [button setTitle:title forState:UIControlStateNormal];
        }
        
        [self.shiftButton setSelected:NO];
        [self.shiftButton setBackgroundImage:[UIImage imageNamed:@"LetterKeyboardShiftButton"] forState:UIControlStateNormal];
        [self.shiftButton setBackgroundImage:[UIImage imageNamed:@"LetterKeyboardShiftButtonSelected"] forState:UIControlStateSelected];
    } else {
        [self.innerString appendString:button.currentTitle];
        if ([self.delegate respondsToSelector:@selector(letterKeyboardView:didClickButton:string:)]) {
            [self.delegate letterKeyboardView:self didClickButton:button string:self.innerString];
        }
    }
}

/**
 设置切换大小写键按钮状态 0: 小写  1: 大写  2: 始终大写
 
 @param shiftButton 切换大小写键按钮
 */
- (void)changeKeyboardStatus:(UIButton *)shiftButton {
    [self.currentCharArray removeAllObjects];
    NSUInteger count = self.charButtonArray.count;
    // 设置当前使用的字符串数组
    if ([self.keyboardStatus isEqualToString:@"0"]) {
        [self.shiftButton setSelected:NO];
        self.keyboardStatus = @"1";
        self.currentCharArray = [NSMutableArray arrayWithArray:self.lettersArray];
    } else if([self.keyboardStatus isEqualToString:@"1"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"KeyboardStatusIsUpper" forKey:@"KeyboardStatusIsUpper"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.shiftButton setSelected:YES];
        self.keyboardStatus = @"0";
        self.currentCharArray = [NSMutableArray arrayWithArray:self.uppersArray];
    } else if ([self.keyboardStatus isEqualToString:@"2"]) {
        [self.shiftButton setSelected:NO];
        self.keyboardStatus = @"0";
        self.currentCharArray = [NSMutableArray arrayWithArray:self.lettersArray];
    }
    
    // 设置按钮上的字母
    for (int i = 0; i < count; i++) {
        UIButton *button = (UIButton *)self.charButtonArray[i];
        NSString *title = self.currentCharArray[i];
        [button setTitle:title forState:UIControlStateNormal];
    }
    
    // 设置切换大小写键的背景图像
    [self.shiftButton setBackgroundImage:[UIImage imageNamed:@"LetterKeyboardShiftButton"] forState:UIControlStateNormal];
    [self.shiftButton setBackgroundImage:[UIImage imageNamed:@"LetterKeyboardShiftButtonSelected"] forState:UIControlStateSelected];
}

/**
 *  双击切换大小写按钮的处理
 *
 *  @param gestureRecognizer 手势
 */
- (void)doubleTapShiftButton:(UIGestureRecognizer*)gestureRecognizer {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"KeyboardStatusIsUpper"]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KeyboardStatusIsUpper"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self.currentCharArray removeAllObjects];
    self.currentCharArray = [NSMutableArray arrayWithArray:self.uppersArray];
    [self.shiftButton setSelected:YES];
    self.keyboardStatus = @"0";
    NSUInteger count = self.charButtonArray.count;
    // 设置按钮上的字母
    for (int i = 0; i < count; i++) {
        UIButton *button = (UIButton *)self.charButtonArray[i];
        NSString *title = self.currentCharArray[i];
        [button setTitle:title forState:UIControlStateNormal];
    }
    // 设置切换大小写键的背景图像
    [self.shiftButton setBackgroundImage:[UIImage imageNamed:@"LetterKeyboardShiftButton"] forState:UIControlStateNormal];
    [self.shiftButton setBackgroundImage:[UIImage imageNamed:@"LetterKeyboardShiftButtonDoubleTap"] forState:UIControlStateSelected];
}

/**
 点击完成按钮的处理
 
 @param button 完成按钮
 */
- (void)finishButtonClick:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(letterKeyboardView:didClickButton:string:)]) {
        [self.delegate letterKeyboardView:self didClickButton:button string:self.innerString];
    }
}

/**
 点击功能按钮的处理
 
 @param button 按钮
 */
- (void)functionButtonClick:(UIButton *)button {
    [self.innerString appendString:button.currentTitle];
    if ([self.delegate respondsToSelector:@selector(letterKeyboardView:didClickButton:string:)]) {
        [self.delegate letterKeyboardView:self didClickButton:button string:self.innerString];
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
