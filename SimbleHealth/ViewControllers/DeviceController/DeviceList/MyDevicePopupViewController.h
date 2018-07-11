//
//  MyDevicePopupViewController.h
//  ElectricityVersion2
//
//  Created by Aditi Tiwari on 17/12/15.
//  Copyright © 2015 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DeviceInfo;

@protocol MyDevicePopUpDelegate  <NSObject>

-(void)devicePopUpShouldDismissWithName:(NSString*)name andSubtype:(NSString*)subtype;

@end

@interface MyDevicePopupViewController : UIViewController

@property (assign, nonatomic) id <MyDevicePopUpDelegate> delegate;

@property (strong, nonatomic) DeviceInfo *deviceInfo;

@end
