//
//  MotionDetectorViewController.m
//  ElectricityVersion2
//
//  Created by Krishna Kant Kaira on 04/02/16.
//  Copyright © 2016 Mobiloitte Inc. All rights reserved.
//

#import "MotionDetectorViewController.h"
#import "ServiceHelper.h"
#import "FlickerImageView.h"
#import "DateCommon.h"

@interface MotionDetectorViewController () <ServiceHelperDelegate> {
    
    ServiceHelper *appWebEngine;
    NSTimer *timer_refreshData;
    AppUser *loggedInUser;
}

@property (strong, nonatomic) IBOutlet UIImageView *imageView_motionState;
@property (strong, nonatomic) IBOutlet UILabel *label_motionState;
@property (strong, nonatomic) IBOutlet UILabel *label_progressUnit;
@property (strong, nonatomic) IBOutlet UIProgressView *progress_energy;
@property (strong, nonatomic) IBOutlet UILabel *label_minValue;
@property (strong, nonatomic) IBOutlet UILabel *label_maxValue;
@property (strong, nonatomic) IBOutlet UILabel *label_progressValue;
@property (strong, nonatomic) IBOutlet UIView *view_indicator;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_indicatorLeading;
@property (strong, nonatomic) IBOutlet UIView *viewTemperature;
@property (strong, nonatomic) IBOutlet UILabel *lblLastStatus;
@property (strong, nonatomic) IBOutlet UIView *viewBattery;
@property (strong, nonatomic) IBOutlet FlickerImageView *imvBattery;
@property (strong, nonatomic) IBOutlet UILabel *lblBattery;


@end

@implementation MotionDetectorViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    loggedInUser = [AppUser sharedUser];
    [self setupLoad];
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if ([timer_refreshData isValid]) [timer_refreshData invalidate];
    timer_refreshData = nil;
    [self callApiForLiveEnergyData];
    timer_refreshData =  [NSTimer scheduledTimerWithTimeInterval:kRefreshTimeInterval/2 target:self selector:@selector(callApiForLiveEnergyData) userInfo:nil repeats:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    if ([timer_refreshData isValid]) [timer_refreshData invalidate];
    
    timer_refreshData = nil;
    [[self getAppEngine] cancelRequestwithName:WebMethodType_LiveEnergy];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {
    
    //invalidate timer
    if ([timer_refreshData isValid]) [timer_refreshData invalidate];
    timer_refreshData = nil;

    //cancel request if is in progress
    [appWebEngine cancelRequestwithName:WebMethodType_EnergyDevicesOfBuilding];

    //remove the delegate on deallocation of the controller
    [appWebEngine setServiceHelperDelegate:nil];
    appWebEngine = nil;
}

#pragma mark - Other Helper Method
-(void)setupLoad {
    
    UIColor *baseColor = [UIColor appOrangeColor];
    self.view_indicator.backgroundColor = baseColor;
    self.label_progressValue.textColor = baseColor;
    self.progress_energy.progressTintColor = baseColor;
    self.progress_energy.trackTintColor = [UIColor lightGrayColor];
   // [self refreshDeviceStatus];
    
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 3.0f);
    self.progress_energy.transform = transform;
    
//    [self callApiForLiveEnergyData];
}

- (void)refreshDataForMotionDetectorWith:(DeviceInfo *)currentDevice{
    NSString *state = @"";
    NSString *imageName = @"MotionDetector_offline.png";
    if ([currentDevice.sensorStatus boolValue] == YES) {
        state = @"Motion Detected";
        imageName = @"MotionDetector_detected.png";
    }
    else {
        state = @"No Motion Detected";
        imageName = @"MotionDetector_notDetected.png";
    }
    
    if (currentDevice.previousSensorStatus != nil) {
        _lblLastStatus.hidden = NO;
        NSString *status = @"";
        if ([currentDevice.preSensorStatus boolValue] == YES){
            status = @"Detected";
        } else {
            status = @"Undetected";
        }
        _lblLastStatus.text = [NSString stringWithFormat:@"Motion %@ %@", status, [DateCommon getTimePeriodFromNowToTimeStamp:currentDevice.preTime]];
    } else {
        _lblLastStatus.text = @"-";
    }
    self.label_motionState.text = state;
    self.imageView_motionState.image = [UIImage imageNamed:imageName];
}

- (void)refreshDataForSmokeDetectorWith:(DeviceInfo *)currentDevice{
    NSString *state = @"";
    NSString *imageName = @"MotionDetector_offline.png";
    if ([currentDevice.sensorStatus boolValue] == YES) {
        state = @"Fire";
        imageName = @"ic_flame_big";
    }
    else {
        state = @"Safe";
        imageName = @"ic_shield_big";
    }
    
    if (currentDevice.previousSensorStatus != nil) {
        _lblLastStatus.hidden = NO;
        NSString *status = @"";
        if ([currentDevice.preSensorStatus boolValue] == YES){
            status = @"found smoke";
        } else {
            status = @"safe";
        }
        _lblLastStatus.text = [NSString stringWithFormat:@"Smoker %@ %@", status, [DateCommon getTimePeriodFromNowToTimeStamp:currentDevice.preTime]];
    } else {
        _lblLastStatus.text = @"-";
    }
    self.label_motionState.text = state;
    self.imageView_motionState.image = [UIImage imageNamed:imageName];
}

- (void)refreshDataForKeyFobWith:(DeviceInfo *)currentDevice{
    NSString *state = @"";
    NSString *imageName = @"MotionDetector_offline.png";
    if ([currentDevice.sensorStatus boolValue] == YES) {
        
        state = @"In range";
        imageName = @"ic_keyfob_in_range.png";
    }
    else {
        state = @"Out of Range";
        imageName = @"ic_keyfob_out_of_range.png";
    }
    
    if (currentDevice.previousSensorStatus != nil) {
        _lblLastStatus.hidden = NO;
        NSString *status = @"";
        if ([currentDevice.preSensorStatus boolValue] == YES){
            status = @"out of range";
        } else {
            status = @"in range";
        }
        _lblLastStatus.text = [NSString stringWithFormat:@"Keyfob %@ %@", status, [DateCommon getTimePeriodFromNowToTimeStamp:currentDevice.preTime]];
    } else {
        _lblLastStatus.text = @"-";
    }
    self.label_motionState.text = state;
    self.imageView_motionState.image = [UIImage imageNamed:imageName];
}

- (void)refreshDataForWindowSensorWith:(DeviceInfo *)currentDevice{
    NSString *state = @"";
    NSString *imageName = @"MotionDetector_offline.png";
    if ([currentDevice.sensorStatus boolValue] == YES) {
        imageName = @"ic_door_open";
        state = @"Window open";
        
    } else {
        imageName = @"ic_door_close";
        state = @"Window closed";
    }
    
    if (currentDevice.previousSensorStatus != nil) {
        _lblLastStatus.hidden = NO;
        NSString *status = @"";
        if ([currentDevice.preSensorStatus boolValue] == YES){
            status = @"opened";
        } else {
            status = @"closed";
        }
        _lblLastStatus.text = [NSString stringWithFormat:@"Window %@ %@", status, [DateCommon getTimePeriodFromNowToTimeStamp:currentDevice.preTime]];
    } else {
        _lblLastStatus.text = @"-";
    }
    self.label_motionState.text = state;
    self.imageView_motionState.image = [UIImage imageNamed:imageName];
}

- (void)setBatteryStatusWith:(DeviceInfo *)currentDevice{
    if ([currentDevice.battery boolValue] == NO) {
        _imvBattery.image = [UIImage imageNamed:@"ic_battery_good"];
        _lblBattery.textColor = BATTERY_GOOD_COLOR;
        _lblBattery.text = @"battery: good";
    } else {
        _imvBattery.image = [UIImage imageNamed:@"ic_low_battery"];
        _lblBattery.textColor = BATTERY_LOW_COLOR;
        _lblBattery.text = @"battery: low";
    }
}
-(void)refreshDeviceStatus {
    
    DeviceInfo *currentDevice = loggedInUser.device;
    BOOL shouldHide = NO;
    double energyValue = 0;
    if (loggedInUser.device.deviceSensorType == DeviceSensorType_KeyFob) {
        _viewTemperature.hidden = YES;
    }
    
    if ([currentDevice.online boolValue] == NO){
        _label_motionState.text = @"";
        _imageView_motionState.image = [UIImage imageNamed:@"MotionDetector_offline.png"];
        _lblBattery.textColor = [UIColor lightGrayColor];
        _lblBattery.text = @"-";
        _imvBattery.image = nil;
        _lblLastStatus.text = @"-";
        //hide indicator
        shouldHide = YES;
    } else {
        [self setBatteryStatusWith:currentDevice];
        
        energyValue = [currentDevice.value doubleValue];
        if (currentDevice.deviceSensorType == DeviceSensorType_MotionDetector) {
            [self refreshDataForMotionDetectorWith:currentDevice];
        } else if (loggedInUser.device.deviceSensorType == DeviceSensorType_SmokeDetector){
            [self refreshDataForSmokeDetectorWith:currentDevice];
        } else if (loggedInUser.device.deviceSensorType == DeviceSensorType_KeyFob) {
            [self refreshDataForKeyFobWith:currentDevice];
        } else if (loggedInUser.device.deviceSensorType == DeviceSensorType_WindowSensor) {
            [self refreshDataForWindowSensorWith:currentDevice];
        } else {
            _label_motionState.text = @"Unexpected device 'sensorType'.";
            _imageView_motionState.image = [UIImage imageNamed:@""];
        }
    }
    
    if (shouldHide) {
        self.label_progressValue.hidden = YES;
        self.progress_energy.progress = 0.0;
        self.view_indicator.hidden = YES;
    }
    else {
        
        self.label_progressValue.hidden = NO;
        self.view_indicator.hidden = NO;
    }
    self.label_progressUnit.text = [NSString stringWithFormat:@"Temperature (%@)",currentDevice.unit];
    self.label_minValue.text = @"0º";
    
    double maxValue = MAX(40, (energyValue + fmod(energyValue, 10.0)));
    
    self.label_maxValue.text = [NSString stringWithFormat:@"%.0fº",maxValue];
    self.label_progressValue.text = [NSString stringWithFormat:@"%.1fº",energyValue];
    self.progress_energy.progress = ((shouldHide || (maxValue==0)) ? 0 : (energyValue / maxValue));
    
    double constant = ((self.progress_energy.progress != 0) ? ((self.progress_energy.bounds.size.width * energyValue) / maxValue) : 0.0);
    self.constraint_indicatorLeading.constant = constant * (1);
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Service Helper Methods
-(ServiceHelper *)getAppEngine {
    
    if (!appWebEngine) appWebEngine = [[ServiceHelper alloc] init];
    
    [appWebEngine setServiceHelperDelegate:self];
    
    return appWebEngine;
}

-(void)callApiForLiveEnergyData {
    
    [[self getAppEngine] callGetMethodWithData:[NSMutableDictionary dictionary] andMethodName:WebMethodType_LiveEnergy forPath:[NSString stringWithFormat:@"%@/tree",loggedInUser.building.buildingID] andController:[APPDELEGATE navController] headerValue:loggedInUser.token authenticationValue:@"Bearer"];
}

#pragma mark - Service Helper Delegate methods

-(void)serviceResponse:(id)response andMethodName:(WebMethodType)methodName {
    
    switch (methodName) {
            
        case WebMethodType_LiveEnergy: {
            
            NSArray *tempData = (NSArray*)response;
            
            for(NSDictionary *deviceItem in tempData) {
                
                if([loggedInUser.device.circuitID isEqualToString:[deviceItem objectForKey:@"circuitID" expectedType:String]]) {
                    [loggedInUser.device updateForLiveEnergyAttribute:deviceItem];
                    break;
                }
            }
            
            //log event
            //[[GAHelper instance] sendEventOfType:LogType_MotionDetectorScreen forUser:loggedInUser];
            
            [self refreshDeviceStatus];
        }
            break;
            
        default:
            break;
    }
}

-(void)serviceError:(id)response andMethodName:(WebMethodType)methodName{
    
    NSString *message = [response objectForKey:@"errorMessage" expectedType:String];
    [[[UIAlertView alloc]initWithTitle:@"Sorry!" message:((message.length < 1) ? [response objectForKey:kLocalizedError] : message) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
}

@end
