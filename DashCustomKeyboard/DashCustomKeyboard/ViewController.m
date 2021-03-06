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

@interface ViewController () <KeyboardDelegate, UITextFieldDelegate>

@property (nonatomic, strong)CustomKeyboardView *letterKeyboardView;
@property (nonatomic, strong)CustomKeyboardView *symbolKeyboardView;
@property (nonatomic, strong)CustomKeyboardView *numberKeyboardView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.letterTextField.delegate = self;
    self.letterTextField.tag = 201;
    
    self.symbolTextField.delegate = self;
    self.symbolTextField.tag = 202;
    
    self.numberTextField.delegate = self;
    self.numberTextField.tag = 203;
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

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.tag == 201) {
        self.letterKeyboardView = [[CustomKeyboardView alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 186, [[UIScreen mainScreen] bounds].size.width, 246) type:KeyboardLetter string:@""];
        self.letterKeyboardView.delegate = self;
        self.letterKeyboardView.tag = 101;
        self.letterTextField.inputView = self.letterKeyboardView;
    } else if (textField.tag == 202) {
        self.symbolKeyboardView = [[CustomKeyboardView alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 186, [[UIScreen mainScreen] bounds].size.width, 246) type:KeyboardSymbol string:@""];
        self.symbolKeyboardView.delegate = self;
        self.symbolKeyboardView.tag = 102;
        self.symbolTextField.inputView = self.symbolKeyboardView;
    } else if (textField.tag == 203) {
        self.numberKeyboardView = [[CustomKeyboardView alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 186, [[UIScreen mainScreen] bounds].size.width, 246) type:KeyboardNumber string:@""];
        self.numberKeyboardView.delegate = self;
        self.numberKeyboardView.tag = 103;
        self.numberTextField.inputView = self.numberKeyboardView;
    }
}
@end
