//
//  ViewController.m
//  DashCustomKeyboard
//
//  Created by 耿大帅 on 2016/11/10.
//  Copyright © 2016年 耿大帅. All rights reserved.
//

#import "ViewController.h"
#import "CustomKeyboardView.h"
#import "CustomKeyboardDelegate.h"

@interface ViewController () <KeyboardDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CustomKeyboardView *letterKeyboardView = [[CustomKeyboardView alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 186, [[UIScreen mainScreen] bounds].size.width, 246) type:KeyboardLetter string:@""];
    letterKeyboardView.delegate = self;
    letterKeyboardView.tag = 101;
    self.letterTextField.inputView = letterKeyboardView;
    
    CustomKeyboardView *symbolKeyboardView = [[CustomKeyboardView alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 186, [[UIScreen mainScreen] bounds].size.width, 246) type:KeyboardSymbol string:@""];
    symbolKeyboardView.delegate = self;
    symbolKeyboardView.tag = 102;
    self.symbolTextField.inputView = symbolKeyboardView;
    
    CustomKeyboardView *numberKeyboardView = [[CustomKeyboardView alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 186, [[UIScreen mainScreen] bounds].size.width, 246) type:KeyboardNumber string:@""];
    numberKeyboardView.delegate = self;
    numberKeyboardView.tag = 103;
    self.numberTextField.inputView = numberKeyboardView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)keyboardView:(CustomKeyboardView *)keyboardView didClickButton:(UIButton *)button string:(NSMutableString *)string {
    if (keyboardView.tag == 101) {
        self.letterTextField.text = string;
    } else if (keyboardView.tag == 102) {
        self.symbolTextField.text = string;
    } else  if (keyboardView.tag == 103) {
        self.numberTextField.text = string;
    }
}

- (void)keyboardView:(CustomKeyboardView *)keyboardView didClickDeleteButton:(UIButton *)button string:(NSMutableString *)string {
    if (keyboardView.tag == 101) {
        self.letterTextField.text = string;
    } else if (keyboardView.tag == 102) {
        self.symbolTextField.text = string;
    } else  if (keyboardView.tag == 103) {
        self.numberTextField.text = string;
    }
}

@end
