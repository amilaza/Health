//
//  customTextField.h
//  TongueLineApp
//
//  Created by Abhishek Tyagi on 07/12/15.
//  Copyright © 2015 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTextField : UITextField <UITextFieldDelegate>

@property (strong,nonatomic) UITextField *textField;

- (CGRect)textRectForBounds:(CGRect)bounds;

- (CGRect)editingRectForBounds:(CGRect)bounds;

@end
