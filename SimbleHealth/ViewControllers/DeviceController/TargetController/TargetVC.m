//
//  TargetVC.m
//  ElectricityVersion2
//
//  Created by Nguyen Ba Linh on 6/1/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "TargetVC.h"
#import "ServiceHelper.h"
#import "GWDateFormatter.h"
#import "BudgetData.h"
#import "DateCommon.h"

@interface TargetVC ()
<ServiceHelperDelegate>{

    __weak IBOutlet UIImageView *imvTarget;
    __weak IBOutlet UILabel *lblTarget;
    __weak IBOutlet UIView *viewTracking;
    __weak IBOutlet UIView *viewSoFar;
    __weak IBOutlet UILabel *lblTracking;
    __weak IBOutlet UILabel *lblSoFar;
    __weak IBOutlet UIImageView *imvSolar;
    __weak IBOutlet NSLayoutConstraint *viewTrackingConstraint;
    __weak IBOutlet NSLayoutConstraint *imvTargetConstraint;
    __weak IBOutlet UILabel *lblSolarPercent;
    __weak IBOutlet UILabel *lblTrackingPercent;
    __weak IBOutlet NSLayoutConstraint *soFarConstraint;
    AppUser *loggedInUser;
    ServiceHelper *appWebEngine;
    
    NSDate *selectedDate;
    
    NSDateComponents *dateComponents;
    GWDateFormatter *customDataeFormatter;
    NSArray *baseColorArray;
    CGFloat sliderMaxWidth;
    NSTimer *timer_refreshData;
    BudgetData *budgetObject;
    NSMutableArray *energies;
    float solarSize;
    float average;
    
}
@end

@implementation TargetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDatas];
    [self loadUIs];
}

- (void)loadDatas {
    average = 2.3;
    solarSize = 5.0;
    budgetObject = [BudgetData new];
    energies = [NSMutableArray new];
    loggedInUser = [AppUser sharedUser];
}

- (void)loadUIs {

}

- (void)viewWillAppear:(BOOL)animated {
    [self callApiForBudget];
}
- (void)getSolarTarget {
    float target = 0.0;
    target = solarSize * average * [DateCommon numberOfDaysOnMonthFromDate:[NSDate date]];
    lblTarget.text = [NSString stringWithFormat:@"TARGET\n%0.1f kWh", target];
    float trackingMaxValue = MAX([budgetObject.consumptionTrend doubleValue], [budgetObject.consumptionThreshold doubleValue]);
    if (trackingMaxValue > target) {
        float percent = 100 * (trackingMaxValue - target)/target;
        lblSolarPercent.text = [NSString stringWithFormat:@"%.1f%%", percent];
        lblTrackingPercent.text = [NSString stringWithFormat:@"Your solar system is tracking %.1f%% over target this month it has been especially sunny",percent];
    } else {
        float percent = 100 * (target - trackingMaxValue)/target;
        lblSolarPercent.text = [NSString stringWithFormat:@"%.1f%%", percent];
        lblTrackingPercent.text = [NSString stringWithFormat:@"Your solar system is tracking %.1f%% under target this month it has been especially sunny",percent];
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshUI {
    [self getSolarTarget];
    double consumptionThreshold = [budgetObject.consumptionThreshold doubleValue];
    double consumptionTrend = [budgetObject.consumptionTrend doubleValue];
    
    double trackingMaxValue = 0.0;
    double trackingValue = 0.0;
    double toDateTotalValue = 0.0;
    BOOL isUnderBudget = NO;
    toDateTotalValue = [[energies valueForKeyPath:@"@sum.self.usage.doubleValue"] doubleValue];
    lblSoFar.text = [NSString stringWithFormat:@"SO FAR: %.0f kWh", toDateTotalValue];
    lblTracking.text = [NSString stringWithFormat:@"TRACKING : %.@ kWh",budgetObject.consumptionThreshold];
    
    double toatalPowerPercentage = 0;
    if (consumptionThreshold == 0) {
        toatalPowerPercentage = 0.0;
    } else {
        toatalPowerPercentage = ((consumptionTrend * 100) / consumptionThreshold);
    }
    
    if (toatalPowerPercentage < 100) {
        isUnderBudget = YES;
    }
    
    trackingValue = [budgetObject.consumptionThreshold doubleValue];
    trackingMaxValue = MAX(consumptionThreshold, consumptionTrend);
    viewTrackingConstraint.constant = 0.7 * (WINDOW_WIDTH - 62) * trackingValue/trackingMaxValue;
    soFarConstraint.constant = 0.7 * (WINDOW_WIDTH - 62) * toDateTotalValue/trackingMaxValue;

    if (soFarConstraint.constant < WINDOW_WIDTH - 62 - 65) {
        float contraint = MAX(viewTrackingConstraint.constant, soFarConstraint.constant);
        imvTargetConstraint.constant = viewSoFar.frame.origin.x + contraint;
    } else {
        imvTargetConstraint.constant = WINDOW_WIDTH - 62 - 65;
    }
}

#pragma mark - call API
-(ServiceHelper *)getAppEngine {
    
    if (!appWebEngine) appWebEngine = [[ServiceHelper alloc] init];
    
    [appWebEngine setServiceHelperDelegate:self];
    
    return appWebEngine;
}

-(void)callApiForBudget {
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc]init];
    [paramDict setObject:[NSString stringWithFormat:@"%ld",(long)([selectedDate timeIntervalSince1970] - customDataeFormatter.secondsFromGMT)] forKey:@"fromTS"];
    [paramDict setValue:[[NSTimeZone localTimeZone] name] forKey:@"timezone"];
    [[self getAppEngine] callGetMethodWithData:paramDict andMethodName:WebMethodType_consumption forPath:[NSString stringWithFormat:@"%@/budget/consumption",loggedInUser.device.circuitID] andController:[APPDELEGATE navController] headerValue:loggedInUser.token authenticationValue:@"Bearer"];
}


#pragma mark - Service Helper Delegate methods
-(void)serviceResponse:(id)response andMethodName:(WebMethodType)methodName {
    
    switch (methodName) {
            
        case WebMethodType_consumption: {
            
            budgetObject = [[BudgetData alloc] initWithAttributes:[response objectForKey:@"budget" expectedType:Dictionary]];
            [energies removeAllObjects];
            
            NSArray *arrya_temp = [response objectForKey:@"energy" expectedType:Array];
            for (NSDictionary *item in arrya_temp){
                [energies addObject:[[EnergyItem alloc] initWithAttributes:item]];
            }
            
            
            [self refreshUI];
            
            //log event
            //[[GAHelper instance] sendEventOfType:LogType_BudgetScreen forUser:loggedInUser];
        }
            break;
            
        default: break;
    }
}

-(void)serviceError:(id)response andMethodName:(WebMethodType)methodName {
    
    budgetObject = nil;
    [energies removeAllObjects];
    [self refreshUI];
    
    NSString *message = [response objectForKey:@"errorMessage" expectedType:String];
    [[[UIAlertView alloc]initWithTitle:@"Sorry!" message:((message.length < 1) ? [response objectForKey:kLocalizedError] : message) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
}



@end
