//
//  GAHelper.m
//  ElectricityVersion2
//
//  Created by Krishna Kant Kaira on 06/02/16.
//  Copyright © 2016 Mobiloitte Inc. All rights reserved.
//

#import <Google/Analytics.h>
#import "GAHelper.h"

//#warning - Update Tracking ID for Release

//#define kClientGAToken @"UA-38300342-11"
//#define kClientGATokenDemo @"UA-73376551-2"


// https://www.google.com/analytics/web/
// Dispatch interval for automatic dispatching of hits to Google Analytics.
// Values 0.0 or less will disable periodic dispatching. The default dispatch interval is 120 secs.
static NSTimeInterval const kGADispatchInterval = 30.0;

/*
 https://developers.google.com/analytics/devguides/collection/ios/v3/sdk-download
 https://developers.google.com/analytics/devguides/collection/ios/v3/mobile-implementation-guide
 https://developers.google.com/analytics/devguides/collection/ios/v3/advanced
 
 ** http://www.lunametrics.com/blog/2013/09/10/access-custom-dimensions-google-analytics/
 */

@interface GAHelper () {
    
    id <GAITracker> gaTracker;
    BOOL isLogginEnabled;
    
    NSString *screenHeight;
    NSString *screenWidth;
    NSString *OSVersion;
    NSString *appVersion;
    NSString *location;
}

@property(nonatomic, copy) void (^dispatchHandler)(GAIDispatchResult result);

@end

@implementation GAHelper

+(GAHelper*)instance {
    
    static GAHelper *sharedInstance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance defaultSetup];
    });
    
    return sharedInstance;
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private methods
-(void)defaultSetup {
    
    isLogginEnabled = NO;
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    screenHeight = [NSString stringWithFormat:@"%0.f",screenSize.height];
    screenWidth = [NSString stringWithFormat:@"%0.f",screenSize.width];
    OSVersion = [[UIDevice currentDevice] systemVersion];
    location = @"-";
    appVersion = @"";
    
    [self setupAnalytics];
    
    //register for notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

-(void)setupAnalytics {
    
    // Configure tracker from GoogleService-Info.plist.
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    // Optional: configure GAI options.
    GAI *gai = [GAI sharedInstance];

    // Set the dispatch interval for automatic dispatching.
    gai.dispatchInterval = kGADispatchInterval;
    
    // Automatically send uncaught exceptions to Google Analytics.
    gai.trackUncaughtExceptions = YES;
    
    // Set the appropriate log level for the default logger.
    gai.logger.logLevel = kGAILogLevelVerbose;
    
    //enableing 'DryRun' prevents data being sent to GA.
    [gai setDryRun:YES];
    
    //You can enable an app-level opt out flag that will disable Google Analytics across the entire app. Note that this flag must be set each time the app starts up and will default to NO
    [gai setOptOut:NO];
    
    //get a local instance of tracker
    gaTracker = gai.defaultTracker;
}

-(void)didEnterBackground:(id)sender {
    [self sendHitsInBackground];
}

-(void)willEnterForeground:(id)sender {
    // Restore the dispatch interval since dispatchWithCompletionHandler:
    // disables automatic dispatching.
    [GAI sharedInstance].dispatchInterval = kGADispatchInterval;
}

// This method sends any queued hits when the app enters the background.
- (void)sendHitsInBackground {
    
    __block BOOL taskExpired = NO;
    
    __block UIBackgroundTaskIdentifier taskId =
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        taskExpired = YES;
    }];
    
    if (taskId == UIBackgroundTaskInvalid) {
        return;
    }
    
    __weak GAHelper *weakSelf = self;
    self.dispatchHandler = ^(GAIDispatchResult result) {
        // Dispatch hits until we have none left, we run into a dispatch error,
        // or the background task expires.
        if (result == kGAIDispatchGood && !taskExpired) {
            [[GAI sharedInstance] dispatchWithCompletionHandler:weakSelf.dispatchHandler];
        } else {
            [[UIApplication sharedApplication] endBackgroundTask:taskId];
        }
    };
    
    [[GAI sharedInstance] dispatchWithCompletionHandler:self.dispatchHandler];
}

/*
 * construct logging info
 */
-(void)constructLoggingInfoFor:(LogType)type user:(AppUser*)user {
    
    NSString *screenTitle;
    NSString *eventID;
    NSString *eventDescription;
    NSString *senserType;
    NSString *senserUtility;
    NSString *timeStamp = [[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] stringValue];
    
    switch (type) {
            
        case LogType_Login: {
            
            screenTitle = @"Login Screen";
            eventID = @"100100";
            eventDescription = @"login";
        }
            break;
            
        case LogType_Reminder: {
            
            screenTitle = @"Forgot Password Screen";
            eventID = @"100200";
            eventDescription = @"Forgotten Password";
        }
            break;
            
        case LogType_DeviceListScreen: {
            
            screenTitle = @"Device List Screen";
            eventID = @"100300";
            eventDescription = @"My Devices";
        }
            break;
            
        case LogType_DeviceListScreen_DevicePowerOn: {
            
            screenTitle = @"Device List Screen";
            eventID = @"100301";
            eventDescription = @"Power on";
            senserType = user.device.sensorType;
            senserUtility = [NSString stringWithFormat:@"%@:%@",user.device.sensorType,user.device.sensorUtility];
        }
            break;
            
        case LogType_DeviceListScreen_DevicePowerOff: {
            
            screenTitle = @"Device List Screen";
            eventID = @"100301";
            eventDescription = @"Power off";
            senserType = user.device.sensorType;
            senserUtility = [NSString stringWithFormat:@"%@:%@",user.device.sensorType,user.device.sensorUtility];
        }
            break;
            
        case LogType_RightNowScreen: {
            
            screenTitle = @"Right Now Screen";
            eventID = @"100400";
            eventDescription = @"Right Now";
            senserType = user.device.sensorType;
            senserUtility = [NSString stringWithFormat:@"%@:%@",user.device.sensorType,user.device.sensorUtility];
        }
            break;
            
        case LogType_RightNowScreen_DevicePowerOn: {
            
            screenTitle = @"Right Now Screen";
            eventID = @"100401";
            eventDescription = @"Power on";
            senserType = user.device.sensorType;
            senserUtility = [NSString stringWithFormat:@"%@:%@",user.device.sensorType,user.device.sensorUtility];
        }
            break;
            
        case LogType_RightNowScreen_DevicePowerOff: {
            
            screenTitle = @"Right Now Screen";
            eventID = @"100401";
            eventDescription = @"Power off";
            senserType = user.device.sensorType;
            senserUtility = [NSString stringWithFormat:@"%@:%@",user.device.sensorType,user.device.sensorUtility];
        }
            break;
            
        case LogType_MotionDetectorScreen: {
            
            screenTitle = @"Motion Detector Screen";
            eventID = @"100500";
            eventDescription = @"Right Now";
            senserType = user.device.sensorType;
            senserUtility = [NSString stringWithFormat:@"%@:%@",user.device.sensorType,user.device.sensorUtility];
        }
            break;
            
        case LogType_PerformanceScreen: {
            
            screenTitle = @"Performance Screen";
            eventID = @"100600";
            eventDescription = @"Performance Page";
            senserType = user.device.sensorType;
            senserUtility = [NSString stringWithFormat:@"%@:%@",user.device.sensorType,user.device.sensorUtility];
        }
            break;
            
        case LogType_AlertScreen: {
            
            screenTitle = @"Alert Screen";
            eventID = @"100700";
            eventDescription = @"Alert Page";
        }
            break;
            
        case LogType_BudgetScreen: {
            
            screenTitle = @"Budget Screen";
            eventID = @"100800";
            eventDescription = @"Budget";
            senserType = user.device.sensorType;
            senserUtility = [NSString stringWithFormat:@"%@:%@",user.device.sensorType,user.device.sensorUtility];
        }
            break;
            
        case LogType_PreferenceScreen: {
            
            screenTitle = @"Preferences Screen";
            eventID = @"100900";
            eventDescription = @"Preferences";
        }
            break;
            
        case LogType_Logout: {
            
            screenTitle = @"Logout Screen";
            eventID = @"101000";
            eventDescription = @"Logout";
        }
            break;
            
        default: break;
    }
    
    [gaTracker set:kGAIScreenName value:screenTitle];
    
    [gaTracker set:[GAIFields customDimensionForIndex:1] value:user.token]; //Token
    [gaTracker set:[GAIFields customDimensionForIndex:2] value:eventID]; //EventID
    [gaTracker set:[GAIFields customDimensionForIndex:3] value:eventDescription]; //Description
    [gaTracker set:[GAIFields customDimensionForIndex:4] value:user.email]; //Email
    [gaTracker set:[GAIFields customDimensionForIndex:5] value:timeStamp]; //Time-stamp
    [gaTracker set:[GAIFields customDimensionForIndex:6] value:senserType]; //Sensor Type
    [gaTracker set:[GAIFields customDimensionForIndex:7] value:senserUtility]; //Sensor Utility
    
//    [gaTracker set:[GAIFields customDimensionForIndex:5] value:location]; //Location
//    [gaTracker set:[GAIFields customDimensionForIndex:6] value:screenWidth]; //Width
//    [gaTracker set:[GAIFields customDimensionForIndex:7] value:screenHeight]; //Height
//    [gaTracker set:[GAIFields customDimensionForIndex:8] value:OSVersion]; //OS Version
//    [gaTracker set:[GAIFields customDimensionForIndex:9] value:appVersion]; //device App Version
//    [gaTracker set:[GAIFields customDimensionForIndex:10] value:senserType]; //Sensor Type
//    [gaTracker set:[GAIFields customDimensionForIndex:11] value:senserUtility]; //Sensor Utility
}

#pragma mark - Public methods
//enable / disable logging to GA
-(void)enableLog:(BOOL)enable {
    
    if (enable) {
        //enable logging
        isLogginEnabled = YES;
//        [GAI sharedInstance].logger.logLevel = kGAILogLevelVerbose;
        [GAI sharedInstance].logger.logLevel = kGAILogLevelNone;
    }
    else {
        //disable logging
        isLogginEnabled = NO;
        [GAI sharedInstance].logger.logLevel = kGAILogLevelNone;
    }
    
    /*
     The SDK provides a dryRun flag that when set, prevents any data from being sent to Google Analytics. The dryRun flag should be set whenever you are testing or debugging an implementation and do not want test data to appear in your Google Analytics reports.
     
     To set the dry run flag:
     */
    [[GAI sharedInstance] setDryRun:!isLogginEnabled];
    
    //You can enable an app-level opt out flag that will disable Google Analytics across the entire app. Note that this flag must be set each time the app starts up and will default to NO
    //    [[GAI sharedInstance] setOptOut:!isLogginEnabled];
}

//log event to GA
-(void)sendEventOfType:(LogType)type
               forUser:(AppUser*)user {
    
    // if logging disabled, return imidiately
    if (!isLogginEnabled) return;
    
    [self constructLoggingInfoFor:type user:user];
    [gaTracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

@end
