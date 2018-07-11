//
//  Header.h
//  ElectricityVersion2
//
//  Created by Mohit Kumar on 12/7/15.
//  Copyright © 2015 Mobiloitte Inc. All rights reserved.
//

#pragma mark---------> Imported Frameworks
/******************************************************************************************/

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define kLocalizedError @"LocalizedErrorDescription"



//staging URL
#define SERVICE_BASE_URL @"https://simblesense.com/"

#define PARAM_RESPONSE_CODE @"responseCode"
#define SELECTED_BUILDING_ID  @"SELECTED_BUILDING_ID"
#define DEFAULT_MESSAGE @"Sorry, maybe our server have some problem. Please, contact to us and try it later!"

/******************************************************************************************/
#pragma mark------------> Important Macro Definitions
/*********************************************************************************/
#define APPDELEGATE (AppDelegate *)[[UIApplication sharedApplication] delegate]



#define kAppLightFont(X)        [UIFont fontWithName:@"HelveticaNeue-Light" size:X]
#define kAppMediumFont(X)       [UIFont fontWithName:@"HelveticaNeue-Medium" size:X]
#define kAppMyProFontRegular(X) [UIFont fontWithName:@"MyriadPro-Regular" size:X]

#define RJTextField(tag)        (UITextField*)[self.view viewWithTag:tag]
#define TRIM_SPACE(str)            [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
#define isIphone4S   ([[UIScreen mainScreen] bounds].size.height == 480)?TRUE:FALSE
#define isIphone5   ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE
#define isIphoneSixPlus   ([[UIScreen mainScreen] bounds].size.height == 736)?TRUE:FALSE
#define isIphoneSix   ([[UIScreen mainScreen] bounds].size.height == 667)?TRUE:FALSE
#define WIN_ORIGIN               [[UIScreen mainScreen]bounds].origin.x
#define WIN_WIDTH               [[UIScreen mainScreen]bounds].size.width
#define WIN_HEIGHT              [[UIScreen mainScreen]bounds].size.height
#define APPDELEGATE              (AppDelegate *)[[UIApplication sharedApplication] delegate]
#define NSUSERDEFAULT        [NSUserDefaults standardUserDefaults]
#define SHARED_PLAYER  [[CTMediaPlayer sharedMediaPlayer]mediaPlayer]
#define WINDOW_HEIGHT           [UIScreen mainScreen].bounds.size.height
#define WINDOW_WIDTH             [UIScreen mainScreen].bounds.size.width
#define SCREENBOUNDS           [UIScreen mainScreen].bounds
#define _KEMAIL                                                @"email"
#define _KPassword                                             @"pin"


#define kMyRedColor   [UIColor colorWithRed:255.0/255 green:59.0/255 blue:48.0/255 alpha:1]
#define kMyGreenColor [UIColor colorWithRed:76.0/255 green:180.0/255 blue:73.0/255 alpha:1]
#define kMyBlueColor  [UIColor colorWithRed:76.0/255 green:217.0/255 blue:100.0/255 alpha:1]
#define KMyLabelColor  [UIColor colorWithRed:243/255.0 green:158.0/255.0 blue:5.0/255.0 alpha:1.0]
#define KMyLabel1Color  [UIColor colorWithRed:196/255.0 green:65.0/255.0 blue:14.0/255.0 alpha:1.0]
#define KMyLabel2Color  [UIColor colorWithRed:54/255.0 green:137.0/255.0 blue:153.0/255.0 alpha:1.0]
#define KMyLabel3Color  [UIColor colorWithRed:115/255.0 green:77.0/255.0 blue:140.0/255.0 alpha:1.0]
#define KMyLabel4Color  [UIColor colorWithRed:46/255.0 green:105.0/255.0 blue:154.0/255.0 alpha:1.0]
#define kAppLightGrayColor    [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]
#define kAppSeparatorColor    [UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1.0]
#define UIControl_Font_family(X) [UIFont fontWithName:@"MyriadPro-Regular" size:X]
#define kAppBackGroundColor    [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0]
#define kAppButtonBackgroundColor    [UIColor colorWithRed:174.0/255.0 green:228/255.0 blue:54.0/255.0 alpha:1.0]
#define KAppTextFieldBackgroundColor [UIColor colorWithRed:252.0/255.0 green:252.0/255.0 blue:252.0/255.0 alpha:1.0]

#define BLUE_TEXT_ONLINE [UIColor colorWithRed:30.0/255.0 green:149.0/255.0 blue:162.0/255.0 alpha:1.0]
#define DARK_LIGHT_TEXT_OFFLINE [UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0]
#define BLUE_SIMBLE_LOGO [UIColor colorWithRed:54.0/255.0 green:105.0/255.0 blue:201.0/255.0 alpha:1.0]

#define BATTERY_LOW_COLOR [UIColor colorWithRed:214.0/255.0 green:10.0/255.0 blue:168.0/255.0 alpha:1.0]
#define BATTERY_GOOD_COLOR [UIColor colorWithRed:89.0/255.0 green:219.0/255.0 blue:168.0/255.0 alpha:1.0]

#define k_sum_duration 3

#define SOLAR_SIZE -5

static NSString *isRemembered = @"isRemembered";


/**********************************************************************************/

#pragma mark---------> Imported AppDelegate
/******************************************************************************************/
#import "AppDelegate.h"
#import "OptionsPickerSheetView.h"
#import "MJPopupBackgroundView.h"
#import "UIViewController+MJPopupViewController.h"
#import "NIDropDown.h"

/******************************************************************************************/


#pragma mark---------> Imported Categories
/******************************************************************************************/

#import "UIViewController+CT.h"
#import "UIColor+CT.h"
#import "UIFont+CT.h"
#import "NSString+CT.h"
#import "UIImage+CT.h"
#import "OptionPickerSheet.h"

/******************************************************************************************/


/******************************************************************************************/

#pragma mark-----------> Imported Service Helper Class
/*******************************************************************************************/


/*******************************************************************************************/

#pragma mark---------> Imported Subclasses
/******************************************************************************************/

#import "GAAppUtility.h"


/******************************************************************************************/



#pragma mark---------> Imported ModalClass
#import "MyDeviceInfo.h"
#import "AppUser.h"

/******************************************************************************************/



/******************************************************************************************/


#pragma mark---------> Imported CustomClasses
/******************************************************************************************/
#import "SSBouncyButton.h"
#import "CustomTextField.h"
#import "ValidationFields.h"
#import "LMGaugeView.h"
#import  "FSLineChart.h"

/******************************************************************************************/

#pragma mark---------> Imported Utilities
/******************************************************************************************/
#import "MZFormSheetController.h"

/******************************************************************************************/


#pragma mark---------> Imported CustomCells

/******************************************************************************************/

#import "GAMenuCell.h"
#import "GAAlertsCell.h"

/******************************************************************************************/


#pragma mark---------> Imported ViewControllers
/******************************************************************************************/

#import "GAMyDevicesVC.h"
#import "GAMenuVC.h"
#import "GALoginVC.h"
#import "GAForgotPasswordVC.h"
#import "GAAlertsVC.h"
#import "GAContactUs.h"


#pragma mark-----------> Macro Definitions
/*******************************************************************************************/


#pragma mark---------> Imported CustomClasses
/******************************************************************************************/
#import "CustomTextField.h"
#import "ValidationFields.h"
#import "CustomLabel.h"


#pragma mark <-----------> Imported Web Service Helper Classes
/******************************************************************************************/

#import "ServiceHelper.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "UIButton+AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "MIBadgeButton.h"
#import "UIColor+Extended.h"
#import "NSDictionary+Extended.h"
#import "GAHelper.h"
#import "CustomPickerController.h"
#import "DateCommon.h"

//#warning - reset time interval
#define kRefreshTimeInterval (2*60)
