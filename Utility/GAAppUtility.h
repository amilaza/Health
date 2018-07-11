//
//  GAAppUtility.h
//  ElectricityVersion2
//
//  Created by Mohit Kumar on 12/7/15.
//  Copyright © 2015 Mobiloitte Inc. All rights reserved.
//

#import "Header.h"

typedef void(^alertCompletionHandler)(NSInteger *buttonIndex);

typedef NS_ENUM(NSUInteger, DeviceType) {
    
    DeviceType_iPhone4,
    DeviceType_iPhone5,
    DeviceType_iPhone6,
    DeviceType_iPhone6Plus,
    DeviceType_iPad
};

@interface GAAppUtility : NSObject

@property (nonatomic, assign) alertCompletionHandler alertHandler;
@property (nonatomic, assign) DeviceType deviceType;
@property (nonatomic, strong) NSString *strMemberID;
@property (nonatomic, strong) NSString *strUserName;
@property (nonatomic, strong) NSString *strPassword;

@property (strong, nonatomic) NSMutableArray *arraySavedLanguages;

+(id)sharedInstance;

-(void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message withCompletionHandler:(alertCompletionHandler)completionHandler;
//-(void)openActivityViewControllerinController:(id)controller
-(DeviceType)getCurrentDeviceType;

//Setting Alert
/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Showing Alert with delegate <<<<<<<<<<<<<<<<<<<<<<<<*/

void showAlert (NSString *message, NSString *title ,NSString *cancelTitle, id delegate, NSString * buttonTitle);
UIBarButtonItem* backButtonForControllerWithWhiteBackIcon(id controller);
UIBarButtonItem *menuButtonForController(id controller);
UIBarButtonItem* rightBarButtonWithStringForController(id controller, NSString *str);
UIBarButtonItem *addingRightBarButton(id controller, NSString *imageName);
UIBarButtonItem* rightBarButtonForController(id controller, NSString *imgStr);
UIColor *getColor (float r,float g,float b,float a);
+ (BOOL) isDeviceHasCamera;
+(NSString *)getFormattedStringfromDate:(NSDate *)date;
//Methods to set and get indexpath of element of table view cell
void setHintFor (id elemnt, NSIndexPath *index);
NSIndexPath * getIndexPathFor (id elemnt);

+(float)getHeighOfComponentWithText:(NSString*)strText withWidth:(CGFloat) width withFont:(UIFont *) fontName;
+ (NSString *) currentTimeStamp;
+(NSString *)getTimeFromDate:(NSDate *)date;
//+(NSString *)getDateFromDate:(NSDate *)date;
+(NSDate *)getDateFromString:(NSString *)dateStr;

+(NSString *)getStringTimeFromDate:(NSDate *)date;
//+(NSDate *)getCorrectFormatDateFromString:(NSString *)dateStr;

+(NSDate *)getTimestampFromStringDate:(NSString *)dateandTime;
+(NSString *)getTimeFromTimeStamp:(NSTimeInterval )timeStamp;
+(NSString *)getDateFromTimeStamp:(NSTimeInterval )timeStamp;
+(NSString *)getStringDateFromDate:(NSDate *)date;
void showAlert1 (NSString *errorTitle, NSString *message);
UIButton *getRoundedButtonWithClearBorder (UIButton *btn);

UILabel* setLabelBorder (UILabel *label);
UIButton *setButtonBorder (UIButton *button);
UITextField *setTextFieldBorder (UITextField *textField);
UIToolbar* toolBarForNumberPad(id controller, NSString *titleDoneOrNext);

@end
