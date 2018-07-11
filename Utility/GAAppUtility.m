//
//  CTAppUtil.m
//  ConnectedTVApp
//
//  Created by Amit Majumdar on 8/10/15.
//  Copyright (c) 2015 Mobiloitte Technologies Pvt. Ltd. All rights reserved.
//

#import "GAAppUtility.h"
#import "Header.h"

@implementation GAAppUtility


+(id)sharedInstance{
    
    static dispatch_once_t sharedPredicate;
    static GAAppUtility *appUtil = nil;
    dispatch_once(&sharedPredicate, ^{
        appUtil = [[GAAppUtility alloc]init];
    });
    return appUtil;
}


-(void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message withCompletionHandler:(alertCompletionHandler)completionHandler{
    
    self.alertHandler = completionHandler;
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil]show];
    });
}

-(DeviceType)getCurrentDeviceType{
    
    double height = [UIScreen mainScreen].bounds.size.height;
    
    if (height == 480.0)
        return DeviceType_iPhone4;
    else if (height == 568.0)
        return DeviceType_iPhone5;
    else if (height == 667.0)
        return DeviceType_iPhone6;
    else if(height == 736.0)
        return DeviceType_iPhone6Plus;
    else
        return DeviceType_iPad; //1024
}


//Method for Setting Back Bar Button on Controllers with White Back Icon
UIBarButtonItem* backButtonForControllerWithWhiteBackIcon(id controller){
    
    UIImage *buttonImage = [UIImage imageNamed:@"back.png"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width-7,   buttonImage.size.height-5);
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -5.0, 0.0, 0.0)];
    [backButton setImage:buttonImage forState:UIControlStateNormal];
    [backButton addTarget:controller action: @selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    return backBarButtonItem;
}
//Method for Setting LeftBar Button for Music Feed Screen
UIBarButtonItem *menuButtonForController(id controller){
    
    UIImage *buttonImage = [UIImage imageNamed:@"menu.png"];
    UIButton *menu_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    menu_btn.frame = CGRectMake(0.0, 10.0, buttonImage.size.width-7,buttonImage.size.height-7);
    menu_btn.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    [menu_btn setImage:buttonImage forState:UIControlStateNormal];
    [menu_btn addTarget:controller action: @selector(menuBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *menuBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menu_btn];
    return menuBarButtonItem;
    
}

//Adding Bar Button with Dynamic Image
UIBarButtonItem *addingRightBarButton(id controller, NSString *imageName){
    
    UIImage *buttonImage = [UIImage imageNamed:imageName];
    UIButton *menu_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    menu_btn.frame = CGRectMake(0.0, 10.0, buttonImage.size.width-7,buttonImage.size.height-7);
    menu_btn.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    [menu_btn setImage:buttonImage forState:UIControlStateNormal];
    [menu_btn addTarget:controller action: @selector(rightBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *menuBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menu_btn];
    return menuBarButtonItem;
}
//Method for Setting rightbar button for navigationbar
UIBarButtonItem* rightBarButtonForController(id controller, NSString *imgStr) {
    UIImage * buttonImage = [UIImage imageNamed:imgStr];
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setExclusiveTouch:YES];
    backButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width -7,buttonImage.size.height-7);
    [backButton setImage:buttonImage forState:UIControlStateNormal];
    [backButton addTarget:controller action: @selector(editButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    return backBarButtonItem;
}

//Method for Setting rightbar button for navigationbar
UIBarButtonItem* rightBarButtonWithStringForController(id controller, NSString *str) {
    
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0, 0.0,50,50);
    [backButton setTitle:@"Save" forState:UIControlStateNormal];
    //   [backButton.titleLabel setFont:kAppFontOpenSansRegular14];
    [backButton addTarget:controller action: @selector(saveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    return backBarButtonItem;
}
-(void)menuBtnAction:(id)sender{}
-(void)backButtonAction:(id)sender{}
-(void)rightBarButtonAction:(id)sender{}
-(void)editButtonAction:(id)sender{}
-(void)saveButtonAction:(id)sender{}



#pragma mark- AlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    self.alertHandler(&buttonIndex);
}

//method for Camera check
+ (BOOL) isDeviceHasCamera {
    // does the device have a camera?
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return YES;
    }
    return NO;
}

#pragma mark - indexPath  Methods
void setHintFor (id elemnt, NSIndexPath *index) {
    [elemnt setAccessibilityLabel:[NSString stringWithFormat:@"%ld,%ld",(long)index.row,(long)index.section]];
}

NSIndexPath * getIndexPathFor (id elemnt) {
    
    NSArray *accessibilityArray = [[elemnt accessibilityLabel] componentsSeparatedByString:@","];
    return (([accessibilityArray count] == 2 ) ? [NSIndexPath indexPathForRow:[[accessibilityArray firstObject] integerValue] inSection:[[accessibilityArray lastObject] integerValue]] : [NSIndexPath indexPathForRow:-1 inSection:-1]);
}


/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Getting color <<<<<<<<<<<<<<<<<<<<<<<<*/

UIColor *getColor (float r,float g,float b,float a) {
    
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a];
    
}


+(NSString *)getFormattedStringfromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd/MM/yy"];
    return [dateFormatter stringFromDate:date];
    
}

void showAlert1 (NSString *errorTitle, NSString *message){
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:errorTitle message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
    
}

+(NSString *) currentTimeStamp {
    return [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000];
}


+(NSString *)getTimeFromDate:(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setLocale:[GAAppUtility enUSPosixlocal]];
    [dateFormatter setDateFormat:@"HH:mm a"];
    return [dateFormatter stringFromDate:date];
    
}



+(NSString *)getTimeFromTimeStamp:(NSTimeInterval )timeStamp {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp] ;
    [dateFormatter setDateFormat:@"hh:mm a"] ;
    return [dateFormatter stringFromDate:date];
    
}

+(NSString *)getDateFromTimeStamp:(NSTimeInterval )timeStamp {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp] ;
    [dateFormatter setDateFormat:@"yyyy-MM-dd"] ;
    return [dateFormatter stringFromDate:date];
    
}

+(NSString *)getStringTimeFromDate:(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setLocale:[GAAppUtility enUSPosixlocal]];
    [dateFormatter setDateFormat:@"hh:mma"];
    return [dateFormatter stringFromDate:date];
    
}
+(NSString *)getStringDateFromDate:(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.dateStyle = NSDateIntervalFormatterLongStyle;
    return [dateFormatter stringFromDate:date];
    
}

+(NSDate *)getDateFromString:(NSString *)dateStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[GAAppUtility enUSPosixlocal]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssz"];
    return [dateFormatter dateFromString: dateStr];
    
}

+(NSDate *)getTimestampFromStringDate:(NSString *)dateandTime {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd hh:mma"];
    return [format dateFromString:dateandTime];
}

+(NSLocale *)enUSPosixlocal {
    return  [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
}

#pragma mark - Method to get Height of label based on TextSize
+(float)getHeighOfComponentWithText:(NSString*)strText withWidth:(CGFloat) width withFont:(UIFont *) fontName {
    CGRect stringSize = [strText
                         boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                         options:NSStringDrawingUsesLineFragmentOrigin
                         attributes:@{NSFontAttributeName:fontName}
                         context:nil];
    
    return stringSize.size.height;
}

/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Setting rounded button <<<<<<<<<<<<<<<<<<<<<<<<*/

UIButton *getRoundedButtonWithClearBorder (UIButton *btn) {
    btn.layer.cornerRadius =  btn.frame.size.height /2;
    btn.layer.borderColor = [UIColor clearColor].CGColor;
    btn.layer.borderWidth = 1.0f;
    btn.clipsToBounds = YES;
    
    return btn;
}

/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Showing Alert with delegate <<<<<<<<<<<<<<<<<<<<<<<<*/

void showAlert (NSString *message, NSString *title ,NSString *cancelTitle, id delegate, NSString * buttonTitle) {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelTitle otherButtonTitles:buttonTitle, nil];
    [alertView show];
    alertView = nil;
    
}

/*>>>>>>>>>>>Setting border width and color of UILabel*/
UILabel* setLabelBorder (UILabel *label)
{
    label.layer.borderWidth = 1.0f;
    label.layer.borderColor =  getColor(84, 84, 84, 1).CGColor;
    return label;
}


/*>>>>>>>>>>>Setting border width and color of UIButton*/
UIButton *setButtonBorder (UIButton *button)
{
    button.layer.borderWidth = 1.0f;
    button.layer.borderColor =  getColor(84, 84, 84, 1).CGColor;
    return button;
}


/*>>>>>>>>>>>Setting border width and color of UIButton*/
UITextField *setTextFieldBorder (UITextField *textField)
{
    textField.layer.borderWidth = 1.0f;
    textField.layer.borderColor =  getColor(84, 84, 84, 1).CGColor;
    return textField;
}

/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Adding tool bar on text field fornext/done button <<<<<<<<<<<<<<<<<<<<<<<<*/

UIToolbar* toolBarForNumberPad(id controller, NSString *titleDoneOrNext){
    //NSString *doneOrNext;
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 50)];
    
    numberToolbar.barStyle = UIBarStyleBlackOpaque;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:titleDoneOrNext style:UIBarButtonItemStyleDone target:controller action:@selector(doneWithNumberPad)],
                           
                           nil];
    [numberToolbar sizeToFit];
    return numberToolbar;
}

- (void)doneWithNumberPad {
    
}

@end
