//
//  HistoryViewController.m
//  ElectricityVersion2
//
//  Created by Krishna Kant Kaira on 04/02/16.
//  Copyright © 2016 Mobiloitte Inc. All rights reserved.
//

#import "HistoryViewController.h"
#import "FSLineChart.h"
#import "UIColor+Extended.h"
#import "ServiceHelper.h"
#import "GWDateFormatter.h"
#import "PerformanceInfo.h"
#define kSecondInDay (24 * 60 * 60)

typedef NS_ENUM(NSInteger, SelectedDurationType) {
    
    Duration_Day,
    Duration_Week,
    Duration_Moth
};


@interface HistoryViewController()
<ServiceHelperDelegate>{
    
    __weak IBOutlet UILabel *label_X_axisUnit;
    __weak IBOutlet UILabel *label_Y_axisUnit;
    __weak IBOutlet UIButton *button_forward;
    __weak IBOutlet UILabel *lblSelectedDate;
    __weak IBOutlet UIView *viewContaint;
    __weak IBOutlet UISegmentedControl *segmentController_duration;
    IBOutlet UIImageView *imvLastTime;
    IBOutlet UILabel *lblLastTimeStatus;
    IBOutlet UILabel *lblTime;
    
    AppUser *loggedInUser;
    ServiceHelper *appWebEngine;
    FSLineChart *lineChart_performance;
    SelectedDurationType durationType;
    GWDateFormatter *customDataeFormatter;
    
    
    NSDate *selectedDate;
    NSString *performanceIndex;
    NSString *selectedDropDownValue;
    NSMutableArray *array_realLongEnergy;
    NSMutableArray *array_realCost;
    NSMutableArray *array_benchMarkCost;
    NSMutableArray *array_benchMarkLongEnergy;
    NSArray *array_weekDay;
}
@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDatas];
    [self loadUIs];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadUIs {
    
    
    [segmentController_duration setTintColor:[UIColor appGreenColor]];
    lblSelectedDate.textColor = [UIColor appGreenColor];
}

- (void)loadDatas {
    loggedInUser = [AppUser sharedUser];
    durationType = Duration_Day;
    array_realCost = [NSMutableArray array];
    array_benchMarkCost = [NSMutableArray array];
    array_realLongEnergy = [NSMutableArray array];
    array_benchMarkLongEnergy = [NSMutableArray array];
    array_weekDay = [NSArray arrayWithObjects:@"", @"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat", @"Sun", @"", nil];
    
    customDataeFormatter = [GWDateFormatter sharedManager];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = [[NSCalendar currentCalendar] ordinalityOfUnit:(NSCalendarUnitDay) inUnit:(NSCalendarUnitEra) forDate:[NSDate date]];
    
    selectedDate = [[[NSCalendar currentCalendar] dateFromComponents:components] dateByAddingTimeInterval:customDataeFormatter.secondsFromGMT];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setLastTimeStatusWith:loggedInUser.device];
}
- (void)setLastTimeStatusWith:(DeviceInfo *)currentDevice{
    if ([currentDevice.online boolValue] == YES) {
        
        if (currentDevice.previousSensorStatus != nil) {
            if (currentDevice.deviceSensorType == DeviceSensorType_MotionDetector) {
                [self setLastTimeStatusForMotionDetectorWith:currentDevice];
            } else if (loggedInUser.device.deviceSensorType == DeviceSensorType_SmokeDetector){
                [self setLastTimeStatusForSmokeDetectorWith:currentDevice];
            } else if (loggedInUser.device.deviceSensorType == DeviceSensorType_KeyFob) {
                [self setLastTimeStatusForKeyFobWith:currentDevice];
            } else if (loggedInUser.device.deviceSensorType == DeviceSensorType_WindowSensor) {
                [self setLastTimeStatusForWindowSensorWith:currentDevice];
            }
        } else {
            lblTime.text = @"";
            lblLastTimeStatus.text = @"No data";
            imvLastTime.image = nil;
        }
        
    }
    else {
        lblLastTimeStatus.text = @"Sensor was offline";
        imvLastTime.image = [UIImage imageNamed:@""];
        lblTime.text = @"";
    }
}
- (void)setLastTimeStatusForMotionDetectorWith:(DeviceInfo *)currentDevice{
    NSString *state = @"";
    NSString *imageName = @"MotionDetector_offline.png";
    lblTime.hidden = NO;
    if ([currentDevice.preSensorStatus boolValue] == YES){
        state = @"Last time: Motion Detected";
        imageName = @"MotionDetector_detected.png";
        
    } else {
        state = @"Last time: No Motion Detected";
        imageName = @"MotionDetector_notDetected.png";
    }
    lblTime.text = [NSString stringWithFormat:@"%@ %@", @"was", [DateCommon getTimePeriodFromNowToTimeStamp:currentDevice.preTime]];
    lblLastTimeStatus.text = state;
    imvLastTime.image = [UIImage imageNamed:imageName];
}

- (void)setLastTimeStatusForSmokeDetectorWith:(DeviceInfo *)currentDevice{
    NSString *state = @"";
    NSString *imageName = @"MotionDetector_offline.png";
    lblTime.hidden = NO;
    if ([currentDevice.preSensorStatus boolValue] == YES){
        state = @"Last time: found smoke";
        imageName = @"ic_flame_big";
    } else {
        state = @"Last time: Safe";
        imageName = @"ic_shield_big";
    }
    lblTime.text = [NSString stringWithFormat:@"%@ %@", @"was", [DateCommon getTimePeriodFromNowToTimeStamp:currentDevice.preTime]];
    lblLastTimeStatus.text = state;
    imvLastTime.image = [UIImage imageNamed:imageName];
}

- (void)setLastTimeStatusForKeyFobWith:(DeviceInfo *)currentDevice{
    NSString *state = @"";
    NSString *imageName = @"MotionDetector_offline.png";
    lblTime.hidden = NO;
    if ([currentDevice.preSensorStatus boolValue] == YES){
        state = @"Last time: Out of Range";
        imageName = @"ic_keyfob_out_of_range.png";
    } else {
        state = @"Last time: In range";
        imageName = @"ic_keyfob_in_range.png";
    }
    lblTime.text = [NSString stringWithFormat:@"%@ %@", @"was", [DateCommon getTimePeriodFromNowToTimeStamp:currentDevice.preTime]];
    lblLastTimeStatus.text = state;
    imvLastTime.image = [UIImage imageNamed:imageName];
}

- (void)setLastTimeStatusForWindowSensorWith:(DeviceInfo *)currentDevice{
    NSString *state = @"";
    NSString *imageName = @"MotionDetector_offline.png";
    lblTime.hidden = NO;
    if ([currentDevice.preSensorStatus boolValue] == YES){
        imageName = @"ic_door_open";
        state = @"Last time: open";
    } else {
        imageName = @"ic_door_close";
        state = @"Last time: closed";
    }
    lblTime.text = [NSString stringWithFormat:@"%@ %@", @"was", [DateCommon getTimePeriodFromNowToTimeStamp:currentDevice.preTime]];
    lblLastTimeStatus.text = state;
    imvLastTime.image = [UIImage imageNamed:imageName];
}

#pragma mark - button action

- (IBAction)touchSegmented:(UISegmentedControl *)sender {
    if (segmentController_duration.selectedSegmentIndex) {
        [self refreshDataForSelectionType:sender.selectedSegmentIndex];
    }
}

#pragma mark - Service Helper Methods
-(ServiceHelper *)getAppEngine {
    
    if (!appWebEngine) appWebEngine = [[ServiceHelper alloc] init];
    
    [appWebEngine setServiceHelperDelegate:self];
    
    return appWebEngine;
}

-(void)callApiForPerformanceFrom:(NSTimeInterval)fromTime to:(NSTimeInterval)toTime {
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setValue:((durationType == Duration_Day) ? @"hour" : @"day") forKey:@"granularity"];
    [paramDict setValue:[NSString stringWithFormat:@"%ld",(long)fromTime] forKey:@"fromTS"];
    [paramDict setValue:[NSString stringWithFormat:@"%ld",(long)toTime] forKey:@"toTS"];
    [paramDict setValue:performanceIndex forKey:@"performanceIndex"];
    [paramDict setValue:[[NSTimeZone localTimeZone] name] forKey:@"timezone"];
    [paramDict setValue:loggedInUser.token forKey:@"token"];
    [paramDict setValue:[NSNumber numberWithBool:((durationType == Duration_Moth) ? YES : NO)] forKey:@"month"];
    
    [[self getAppEngine] callGetMethodWithData:paramDict andMethodName:WebMethodType_performanceIndex forPath:[NSString stringWithFormat:@"%@/performance_index",loggedInUser.device.circuitID] andController:[APPDELEGATE navController] headerValue:loggedInUser.token authenticationValue:@"Bearer"];
}

-(void)refreshDataForSelectionType:(SelectedDurationType)type {
    
    durationType = type;
    double GMTsecs = customDataeFormatter.secondsFromGMT;
    GMTsecs = 0.0;
    
    lblSelectedDate.text = [[GWDateFormatter sharedManager] getDateString:selectedDate];
    NSTimeInterval fromTimeStamp;
    NSTimeInterval toTimeStamp = [[NSDate date] timeIntervalSince1970] + GMTsecs;
    button_forward.enabled = ([selectedDate timeIntervalSince1970] < (toTimeStamp - kSecondInDay));
    
    switch (durationType) {
            
        case Duration_Day: {
            
            NSDateComponents *components = [[NSDateComponents alloc] init];
            components.day = [[NSCalendar currentCalendar] ordinalityOfUnit:(NSCalendarUnitDay) inUnit:(NSCalendarUnitEra) forDate:selectedDate];
            NSDate *dayBegin = [[NSCalendar currentCalendar] dateFromComponents:components];
            fromTimeStamp = [dayBegin timeIntervalSince1970] + GMTsecs;
            
            NSTimeInterval maxTimestampForDay = fromTimeStamp + kSecondInDay - 1;
            toTimeStamp = MIN(toTimeStamp, maxTimestampForDay);
        }
            break;
            
        case Duration_Week: {
            
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:selectedDate];
            NSInteger dayofweek = [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:selectedDate] weekday];// this will give you current day of week
            [components setDay:([components day] - (dayofweek - 2))];// for beginning of the week.
            NSDate *beginningOfWeek = [[NSCalendar currentCalendar] dateFromComponents:components];
            fromTimeStamp = [beginningOfWeek timeIntervalSince1970] + GMTsecs;
            
            NSTimeInterval maxTimestampForWeek = fromTimeStamp + (kSecondInDay * 7) - 1;
            toTimeStamp = MIN(toTimeStamp, maxTimestampForWeek);
        }
            break;
            
        case Duration_Moth: {
            
            NSDateComponents *components = [[NSDateComponents alloc] init];
            components.month = [[NSCalendar currentCalendar] ordinalityOfUnit:(NSCalendarUnitMonth) inUnit:(NSCalendarUnitEra) forDate:selectedDate];
            NSDate *dayBegin = [[NSCalendar currentCalendar] dateFromComponents:components];
            fromTimeStamp = [dayBegin timeIntervalSince1970] + GMTsecs;
            
            NSInteger daysCount = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:selectedDate].length;
            NSTimeInterval maxTimestampForMonth = fromTimeStamp + (kSecondInDay * daysCount) - 1;
            toTimeStamp = MIN(toTimeStamp, maxTimestampForMonth);
        }
            break;
            
        default:
            break;
    }
    
    
    [self callApiForPerformanceFrom:fromTimeStamp to:toTimeStamp];
    
    BOOL isCost = ([selectedDropDownValue.lowercaseString rangeOfString:[@"($)" lowercaseString]].location != NSNotFound);
    label_Y_axisUnit.text = (isCost ? @"$" : @"kWh");
    label_X_axisUnit.text = ((durationType == Duration_Day) ? @"hour" : @"day");
}

#pragma mark - draw Grap
-(void)refreshPerformanceGraph {
    
    if (lineChart_performance) {
        for (UIView *subview in lineChart_performance.subviews) {
            [subview removeFromSuperview];
        }
        
        [lineChart_performance removeFromSuperview];
        lineChart_performance = nil;
    }
    
    if (!lineChart_performance) {
        
        lineChart_performance = [[FSLineChart alloc] initWithFrame:CGRectMake(10.0, 10.0, [[UIScreen mainScreen] bounds].size.width - 40.0, 240.0)];
        lineChart_performance.color = [UIColor clearColor];
        lineChart_performance.bezierSmoothing = YES;
        lineChart_performance.bezierSmoothingTension = 1.0;
        lineChart_performance.displayDataPoint = YES;
        lineChart_performance.dataPointColor = [UIColor appRedColor];
        lineChart_performance.dataPointBackgroundColor = [UIColor appRedColor];
        lineChart_performance.dataPointRadius = 2.0;
        lineChart_performance.animationDuration = 0.8;
        lineChart_performance.axisColor = [UIColor darkGrayColor];
        lineChart_performance.lineWidth = 0.50;
        lineChart_performance.minBound = 0.0;
        lineChart_performance.maxBound = 0.0;
        lineChart_performance.innerGridColor = [UIColor grayColor];
        lineChart_performance.valueLabelBackgroundColor = [UIColor clearColor];
        lineChart_performance.indexLabelBackgroundColor = [UIColor clearColor];
        
        [viewContaint addSubview:lineChart_performance];
        [viewContaint clipsToBounds];
    }
    
    [lineChart_performance clearChartData];
    
    BOOL isCost = ([selectedDropDownValue.lowercaseString rangeOfString:[@"($)" lowercaseString]].location != NSNotFound);
    
    NSMutableArray *real_data;
    NSMutableArray *benchmark_Data;
    
    if (isCost) {
        
        real_data = array_realCost;
        benchmark_Data = array_benchMarkCost;
    }
    else {
        
        real_data = array_realLongEnergy;
        benchmark_Data = array_benchMarkLongEnergy;
    }
    
    
    BOOL isDataAvailable = (real_data.count > 0);
    
    if (isDataAvailable == NO)
        real_data = [NSMutableArray arrayWithObjects:@"0.0", nil];
    if (benchmark_Data.count < 1)
        benchmark_Data = [NSMutableArray arrayWithObjects:@"0.0", nil];
    
    [real_data addObject:@"0"];
    [real_data insertObject:@"" atIndex:0];
    [benchmark_Data addObject:@"0"];
    [benchmark_Data insertObject:@"" atIndex:0];
    NSMutableArray *labelIndexTitle = [NSMutableArray array];
    for(int i = 0; i < [real_data count]; i++){
        if (segmentController_duration.selectedSegmentIndex == Duration_Day) {
            if (i == 0) {
                [labelIndexTitle addObject:@""];
            } else if (i == real_data.count - 1){
                [labelIndexTitle addObject:@""];
            } else {
                [labelIndexTitle addObject:[NSString stringWithFormat:@"%d",i]];
            }
        } else if (segmentController_duration.selectedSegmentIndex == Duration_Week) {
            if (i == 0) {
                [labelIndexTitle addObject:@""];
            } else if (i == real_data.count - 1){
                [labelIndexTitle addObject:@""];
            } else {
                [labelIndexTitle addObject:[array_weekDay objectAtIndex:i]];
            }
        } else {
            if (i == 0) {
                [labelIndexTitle addObject:@""];
            } else if (i == real_data.count - 1){
                [labelIndexTitle addObject:@""];
            } else {
                [labelIndexTitle addObject:[NSString stringWithFormat:@"%d",i]];
            }
        }
    }
    
    double maxVal_real = [[real_data valueForKeyPath:@"@max.doubleValue"] doubleValue];
    double maxVal_benchmark = [[benchmark_Data valueForKeyPath:@"@max.doubleValue"] doubleValue];
    lineChart_performance.verticalGridStep = MIN(((int)(MAX(maxVal_real, maxVal_benchmark) * 10) + 1), 5);
    lineChart_performance.horizontalGridStep = MAX((int)real_data.count, (int)benchmark_Data.count);
    
    lineChart_performance.labelForIndex = ^(NSUInteger item) {
        return labelIndexTitle[item];
    };
    
    lineChart_performance.labelForValue = ^(CGFloat value) {
        return [NSString stringWithFormat:@"%0.2f", value];
    };
    
    
    if (maxVal_real > maxVal_benchmark) {
        
        lineChart_performance.fillColorOne = [[UIColor appGraphColor] colorWithAlphaComponent:0.4];
        lineChart_performance.color = [[UIColor appGraphColor] colorWithAlphaComponent:0.5];
        [lineChart_performance setChartData:real_data shouldDisplayDatapoints:isDataAvailable];
        
        lineChart_performance.fillColorTwo = [[UIColor appGraphColor] colorWithAlphaComponent:0.15];
        lineChart_performance.color = [[UIColor appGraphColor] colorWithAlphaComponent:0.25];
        [lineChart_performance setChartData2:benchmark_Data shouldDisplayDatapoints:NO];
    }
    else {
        
        lineChart_performance.fillColorOne = [[UIColor appGraphColor] colorWithAlphaComponent:0.15];
        lineChart_performance.color = [[UIColor appGraphColor] colorWithAlphaComponent:0.25];
        [lineChart_performance setChartData:benchmark_Data shouldDisplayDatapoints:NO];
        
        lineChart_performance.fillColorTwo = [[UIColor appGraphColor] colorWithAlphaComponent:0.4];
        lineChart_performance.color = [[UIColor appGraphColor] colorWithAlphaComponent:0.5];
        [lineChart_performance setChartData2:real_data shouldDisplayDatapoints:isDataAvailable];
    }
}

#pragma mark - Service Helper Delegate methods
-(void)serviceResponse:(id)response andMethodName:(WebMethodType)methodName {
    
    switch (methodName) {
            
        case WebMethodType_performanceIndex: {
            
            //[array_performanceInfo removeAllObjects];
            [array_realCost removeAllObjects];
            [array_benchMarkCost removeAllObjects];
            [array_realLongEnergy removeAllObjects];
            [array_benchMarkLongEnergy removeAllObjects];
            
            NSArray *tempArray = (NSArray*)response;
            for (NSDictionary *performanceItem in tempArray) {
                
                PerformanceInfo *performance = [[PerformanceInfo alloc] initWithAttributes:performanceItem];
                //[array_performanceInfo addObject:performance];
                if ([performance.circuitID isEqualToString:performanceIndex]) {
                    
                    [array_benchMarkCost addObject:performance.cost];
                    [array_benchMarkLongEnergy addObject:performance.longEnergy];
                }
                else {
                    
                    [array_realCost addObject:performance.cost];
                    [array_realLongEnergy addObject:performance.longEnergy];
                }
            }
            
            [self refreshPerformanceGraph];
            //            [self refreshPerformanceChart];
            
            //log event
            //[[GAHelper instance] sendEventOfType:LogType_PerformanceScreen forUser:loggedInUser];
        }
            break;
            
        default: break;
    }
}

-(void)serviceError:(id)response andMethodName:(WebMethodType)methodName {
    
    //    [array_performanceInfo removeAllObjects];
    [array_realCost removeAllObjects];
    [array_benchMarkCost removeAllObjects];
    [array_realLongEnergy removeAllObjects];
    [array_benchMarkLongEnergy removeAllObjects];
    
    //[self refreshPerformanceGraph];
    
    NSString *message = [response objectForKey:@"errorMessage" expectedType:String];
    [[[UIAlertView alloc]initWithTitle:@"Sorry!" message:((message.length < 1) ? [response objectForKey:kLocalizedError] : message) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
}
@end
