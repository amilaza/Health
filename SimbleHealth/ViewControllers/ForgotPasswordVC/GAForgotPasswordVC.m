//
//  GAForgotPasswordVC.m
//  Electricity
//
//  Created by Abhishek on 07/12/15.
//  Copyright © 2015 Mobiloitte Inc. All rights reserved.
//

#import "GAForgotPasswordVC.h"
#import "Header.h"

@interface GAForgotPasswordVC () <UITextFieldDelegate, ServiceHelperDelegate> {
    ServiceHelper *appWebEngine;
    NSString *emailStr;
}

@property (strong, nonatomic) IBOutlet UILabel *label_title;
@property (strong, nonatomic) IBOutlet UITextField *textField_email;
@property (strong, nonatomic) IBOutlet UIButton *button_checkEmail;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leadingConstraint_email;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint_checkEmail;

- (IBAction)buttonAction_checkEmail:(id)sender;

@end

@implementation GAForgotPasswordVC

#pragma mark - Life Cycle Method

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setUpInitialValue];
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

-(void)dealloc {

    [appWebEngine setServiceHelperDelegate:nil];
    appWebEngine = nil;
}

#pragma mark - Helper Method

-(void)setUpInitialValue {
    
    self.label_title.attributedText = [self getAttributedStringWithcustomFontAndColor:@"GRIDANALYTICS™" :@"ANALYTICS" :@"™" withFont1:[UIFont fontWithName:@"HelveticaNeue-Bold" size:22] withFont2:[UIFont fontWithName:@"Helvetica Neue" size:22] withColor1:[UIColor whiteColor] withColor2:[UIColor whiteColor]];
}

#pragma mark - To dismiss the keyboard on background

- (IBAction) clickedBackground {
    
    [self.view endEditing:YES];
}

#pragma mark - UITextField Delegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField == _textField_email) {
        
        _textField_email.text = @"";
        [self.view layoutIfNeeded];
        self.leadingConstraint_email.constant = 25;
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == _textField_email) {
        
        [self.view layoutIfNeeded];
        self.leadingConstraint_email.constant = 30;
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

// use to get attributted string
- (NSAttributedString*)getAttributedStringWithcustomFontAndColor:(NSString*)text :(NSString *)str1 :(NSString *)str2  withFont1 :(UIFont *)font1 withFont2 :(UIFont *)font2 withColor1 :(UIColor *)color1 withColor2:(UIColor *)color2{
    
    
    NSString *effectedStr1 = [NSString stringWithFormat:@"(%@)",str1];
    NSString *effectedStr2 = [NSString stringWithFormat:@"(%@)",str2 ];
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    //replacing "AND" to "and" and coloring white
    //NSString *text = [initialStr stringByReplacingOccurrencesOfString:@"AND" withString:@"and"];
    
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:effectedStr1 options:kNilOptions error:nil];
    NSRange range = NSMakeRange(0,text.length);
    [regex enumerateMatchesInString:text options:kNilOptions range:range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSRange subStringRange = [result rangeAtIndex:1];
        [mutableAttributedString addAttribute:NSFontAttributeName value:font1 range:subStringRange];
        [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:color1 range:subStringRange];
    }];
    
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    //coloring all commas to white
    
    NSRegularExpression *regex1 = [NSRegularExpression regularExpressionWithPattern:effectedStr2 options:kNilOptions error:nil];
    NSRange range1 = NSMakeRange(0,text.length);
    [regex1 enumerateMatchesInString:text options:kNilOptions range:range1 usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        
        NSRange subStringRange = [result rangeAtIndex:1];
        [mutableAttributedString addAttribute:NSFontAttributeName value:font2 range:subStringRange];
        [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:color2 range:subStringRange];
    }];
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    return mutableAttributedString;
}

#pragma mark- Validation Helper Methods

-(BOOL)isallFieldsVerified {
    
    BOOL  isVerified = NO;
    
    emailStr = TRIM_SPACE([_textField_email text]);
    if (![emailStr length]) {
        
        showAlert1(@"", @"Please enter your Email ID");
    }
    else if ([ValidationFields validateEmailAddress:emailStr])
    {
        showAlert1(@"", @"Please enter valid Email ID");
    }
    else
    {
        isVerified = YES;
    }
    return isVerified;
}


#pragma mark - Buttons Action Methods
- (IBAction)buttonAction_checkEmail:(id)sender {
    
    [self.view endEditing:YES];
    if ([self isallFieldsVerified]) {
        
        [self.view layoutIfNeeded];
        self.heightConstraint_checkEmail.constant = 40;
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];
        
        [self callApiForForgotPassword];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [self.view endEditing:YES];
    
    if (buttonIndex == 0)  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)closeBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Service Helper Methods
-(ServiceHelper *)getAppEngine {
    
    if (!appWebEngine) appWebEngine = [[ServiceHelper alloc] init];
    
    [appWebEngine setServiceHelperDelegate:self];
    return appWebEngine;
}

-(void)callApiForForgotPassword {
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setValue:emailStr forKey:@"email"];
    [[self getAppEngine] callPOSTMethodWithData:paramDict andMethodName:WebMethodType_Reminder andController:self.navigationController headerValue:nil];
}

#pragma mark - Service Helper Delegate methods

-(void)serviceResponse:(id)response andMethodName:(WebMethodType)methodName {
    
    switch (methodName) {
            
        case WebMethodType_Reminder: {
            
            //log event
            AppUser *user = [[AppUser alloc] init];
            user.email = emailStr;
            user.token = @"";
            //[[GAHelper instance] sendEventOfType:LogType_Reminder forUser:user];
            
            showAlert(@"Your password has been send to your email ID.", nil, @"OK", self, nil);
            
            [self.view layoutIfNeeded];
            self.heightConstraint_checkEmail.constant = 31;
            
            [UIView animateWithDuration:0.3 animations:^{
                [self.view layoutIfNeeded];
            }];
        }
            break;
            
        default:
            break;
    }
}

-(void)serviceError:(id)response andMethodName:(WebMethodType)methodName{
    
    NSString *message = [response objectForKey:@"errorMessage" expectedType:String];
    [[[UIAlertView alloc]initWithTitle:@"Sorry!" message:((message.length < 1) ? [response objectForKey:kLocalizedError] : message) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    
    [self.view layoutIfNeeded];
    self.heightConstraint_checkEmail.constant = 31;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

@end
