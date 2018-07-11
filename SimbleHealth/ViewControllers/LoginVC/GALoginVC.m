//
//  GALoginVC.m
//  Electricity
//
//  Created by Abhishek on 07/12/15.
//  Copyright © 2015 Mobiloitte Inc. All rights reserved.
//

#import "Header.h"

@interface GALoginVC () <UITextFieldDelegate, ServiceHelperDelegate> {
    
    ServiceHelper *appWebEngine;
    NSString *emailID, *password;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView_login;
@property (weak, nonatomic) IBOutlet UILabel *label_title;
@property (weak, nonatomic) IBOutlet UITextField *textField_email;
@property (weak, nonatomic) IBOutlet UITextField *textField_password;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingConstraint_email;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingConstraint_password;
@property (weak, nonatomic) IBOutlet UIButton *button_login;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint_login;
@property (weak, nonatomic) IBOutlet UIButton *button_rememberMe;

@end

@implementation GALoginVC

#pragma mark - Life Cycle Method

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //set up controller
    [self setUpInitialValue];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    if ([[NSUSERDEFAULT objectForKey:_KEMAIL] length] || [[NSUSERDEFAULT objectForKey:_KPassword] length]) {
        
        emailID = [NSUSERDEFAULT valueForKey:_KEMAIL];
        password = [NSUSERDEFAULT valueForKey:_KPassword];
        self.button_rememberMe.selected = YES;
    }
    else {
        
         emailID = @"";
         password = @"";
         self.button_rememberMe.selected = NO;
    }
    
//#warning - Remove before releases
//    emailID =  @"NP24@acresta.com";
//    password = @"1111";
    
    [self.button_login setTitle:@"LOGIN" forState:UIControlStateNormal];
    self.textField_email.text = emailID;
    self.textField_password.text = password;
    
    [self resetLogInButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {
    
    [appWebEngine setServiceHelperDelegate:nil];
    appWebEngine = nil;
}

#pragma mark - Helper Method

-(void)resetLogInButton {
    
    [self.view layoutIfNeeded];
    [self.button_login setTitle:@"LOGIN" forState:UIControlStateNormal];
    self.heightConstraint_login.constant = 31;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) { }];
}

-(void)setUpInitialValue {
    
    self.scrollView_login.contentSize = CGSizeMake(_scrollView_login.frame.size.width, 1000);
    self.label_title.attributedText = [self getAttributedStringWithcustomFontAndColor:@"GRIDANALYTICS™" :@"ANALYTICS" :@"™" withFont1:[UIFont fontWithName:@"Roboto-Bold" size:22] withFont2:[UIFont fontWithName:@"Roboto-Regular" size:22] withColor1:[UIColor whiteColor] withColor2:[UIColor whiteColor]];
    [self.scrollView_login setScrollEnabled:(WIN_HEIGHT == 480)];
}

#pragma mark - To dismiss the keyboard on background
- (IBAction)clickedBackground {
    
    [self.view endEditing:YES];
}

#pragma mark - UITextField Delegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [self.view layoutIfNeeded];

    if (textField == _textField_email) {
        self.leadingConstraint_email.constant = 25;
    }
    else if (textField == _textField_password) {
        self.leadingConstraint_password.constant = 25;
    }
    
    [UIView animateWithDuration:0.3 animations:^{ [self.view layoutIfNeeded]; }];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    [self.view layoutIfNeeded];

    if (textField == _textField_email) {
        
        emailID =TRIM_SPACE(textField.text);
        self.leadingConstraint_email.constant = 30;
    } else if (textField == _textField_password) {
        
        password =  TRIM_SPACE(textField.text);
        self.leadingConstraint_password.constant = 30;
    }
    
    [UIView animateWithDuration:0.3 animations:^{ [self.view layoutIfNeeded]; }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:self.textField_email]) {
        [self.textField_password becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
    }
   
    return YES;
}

// use to get attributted string
- (NSAttributedString*)getAttributedStringWithcustomFontAndColor:(NSString*)text :(NSString *)str1 :(NSString *)str2  withFont1 :(UIFont *)font1 withFont2 :(UIFont *)font2 withColor1 :(UIColor *)color1 withColor2:(UIColor *)color2{
    
    
    NSString *effectedStr1 = [NSString stringWithFormat:@"(%@)",str1];
    NSString *effectedStr2 = [NSString stringWithFormat:@"(%@)",str2 ];
    
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
    
    BOOL isVerified = NO;
    
    if (![emailID length]) {
        
        showAlert1(@"", @"Please enter your Email ID");
    }
    else if ([ValidationFields validateEmailAddress:emailID])
    {
        showAlert1(@"", @"Incorrect email or password.");
    }
    else if (![password length])
    {
        showAlert1(@"", @"Please enter your Password");
    }
    else if ([emailID length] < 4)
    {
        showAlert1(@"", @"Incorrect email or password.");
    }else
    {
        isVerified = YES;
    }
    return isVerified;
}

#pragma mark - Buttons Action Methods

- (IBAction)buttonAction_rememberMe:(UIButton*)sender {
    
    sender.selected = !sender.selected;
}

- (IBAction)buttonAction_forgotPassword:(id)sender {
    
    [self.view endEditing:YES];
    
    GAForgotPasswordVC *obj = [[GAForgotPasswordVC alloc]initWithNibName:@"GAForgotPasswordVC" bundle:nil];
    [self.navigationController pushViewController:obj animated:YES];
}

- (IBAction)buttonAction_login:(id)sender {
    
    [self.view endEditing:YES];
    
   if ([self isallFieldsVerified]) {
    
        [self.view layoutIfNeeded];
        [self.button_login setTitle:@"LOGGING IN" forState:UIControlStateNormal];
        self.heightConstraint_login.constant = 40;
       
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self callApiForLogin];
        }];
   }
}

#pragma mark - Service Helper Methods
-(ServiceHelper *)getAppEngine {
    
    if (!appWebEngine) appWebEngine = [[ServiceHelper alloc] init];
    [appWebEngine setServiceHelperDelegate:self];
    return appWebEngine;
}

-(void)callApiForLogin {
    
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc]init];
    [paramDict setObject:emailID forKey:_KEMAIL];
    [paramDict setObject:password forKey:_KPassword];
    [paramDict setObject:@"0" forKey:@"salt"];
    
    [[self getAppEngine] callPOSTMethodWithData:paramDict andMethodName:WebMethodType_Authentication andController:self.navigationController headerValue:nil];
}

#pragma mark - Service Helper Delegate methods

-(void)serviceResponse:(id)response andMethodName:(WebMethodType)methodName {
    
    switch (methodName) {
            
        case WebMethodType_Authentication: {
            
            //log event
            //[[GAHelper instance] sendEventOfType:LogType_Login forUser:[AppUser sharedUser]];
            
            //update email/password if rememberme button is selected
            if (self.button_rememberMe.selected) {
                
                [NSUSERDEFAULT setValue:emailID forKey:_KEMAIL];
                [NSUSERDEFAULT setValue:password forKey:_KPassword];
            }
            else {
                
                [NSUSERDEFAULT setValue:@"" forKey:_KEMAIL];
                [NSUSERDEFAULT setValue:@"" forKey:_KPassword];
            }
            
            [NSUSERDEFAULT synchronize];
            
            //parse and save the app user
            [[AppUser sharedUser] setupAttributesWith:response];
            
            //navigate to dashboard
            GAMyDevicesVC *obj = [[GAMyDevicesVC alloc]initWithNibName:@"GAMyDevicesVC" bundle:nil];
            [self.navigationController pushViewController:obj animated:YES];
        }
            break;
            
        default:
            break;
    }
    
    [self resetLogInButton];
}

-(void)serviceError:(id)response andMethodName:(WebMethodType)methodName {
    
    NSString *message = [response objectForKey:@"errorMessage" expectedType:String];
    [[[UIAlertView alloc]initWithTitle:@"Sorry!" message:((message.length < 1) ? [response objectForKey:kLocalizedError] : @"Invalid email or password") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    
    [self resetLogInButton];
}

@end
