//
//  PerformanceViewController.m
//  ElectricityVersion2
//
//  Created by Krishna Kant Kaira on 04/02/16.
//  Copyright © 2016 Mobiloitte Inc. All rights reserved.
//

#import "PerformanceViewController.h"
#import "ServiceHelper.h"
#import "GWDateFormatter.h"
#import "PerformanceInfo.h"
#import "FSLineChart.h"
@import Charts;

#define kSecondInDay (24 * 60 * 60)

typedef NS_ENUM(NSInteger, SelectedDurationType) {
    
    Duration_Day,
    Duration_Week,
    Duration_Moth
};

@interface PerformanceViewController () <ServiceHelperDelegate, ChartViewDelegate> {
    
    AppUser *loggedInUser;
    ServiceHelper *appWebEngine;
    SelectedDurationType durationType;
    NSDate *selectedDate;
    NSString *selectedDropDownValue;
    FSLineChart *lineChart_performance;
    LineChartView *chartView_performance;

    GWDateFormatter *customDataeFormatter;
    NSString *performanceIndex;
    NSArray *array_options;
    NSArray *array_weekDay;
}

@property (strong, nonatomic) IBOutlet UIView *view_container;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentController_duration;
@property (strong, nonatomic) IBOutlet UILabel *label_selectedDate;
@property (strong, nonatomic) IBOutlet UIButton *button_dropDown;
@property (strong, nonatomic) IBOutlet UITableView *tableView_preferenceOption;
@property (strong, nonatomic) IBOutlet UIButton *button_forward;
@property (strong, nonatomic) IBOutlet UILabel *label_Y_axisUnit;
@property (strong, nonatomic) IBOutlet UILabel *label_X_axisUnit;

@property (strong, nonatomic) NSMutableArray *array_performanceInfo;
@property (strong, nonatomic) NSMutableArray *array_realLongEnergy;
@property (strong, nonatomic) NSMutableArray *array_realCost;

@property (strong, nonatomic) NSMutableArray *array_benchMarkLongEnergy;
@property (strong, nonatomic) NSMutableArray *array_benchMarkCost;

- (IBAction)segmentActionValueChanged:(UISegmentedControl *)sender;
- (IBAction)buttonActionCommon:(UIButton *)sender;

@end

@implementation PerformanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.tableView_preferenceOption setContentOffset:CGPointZero];
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self refreshDataForSelectionType:durationType];
}

-(void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    [[self getAppEngine] cancelRequestwithName:WebMethodType_performanceIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {
    
    //remove the delegate on deallocation of the controller
    [appWebEngine setServiceHelperDelegate:nil];
    appWebEngine = nil;
}

#pragma mark - Other helper methods
-(void)setupLoad {
    
    loggedInUser = [AppUser sharedUser];
    durationType = Duration_Day;
    self.array_performanceInfo = [NSMutableArray array];
    self.array_realCost = [NSMutableArray array];
    self.array_benchMarkCost = [NSMutableArray array];
    self.array_realLongEnergy = [NSMutableArray array];
    self.array_benchMarkLongEnergy = [NSMutableArray array];
    
    self.label_Y_axisUnit.textColor = [UIColor appRedColor];
    self.label_X_axisUnit.textColor = [UIColor appRedColor];

    array_options = [NSArray arrayWithObjects:@"Average household (kWh)", @"Average household ($)", @"Efficient household (kWh)", @"Efficient household ($)", @"Neighbourhood (kWh)", @"Neighbourhood ($)", nil];
    array_weekDay = [NSArray arrayWithObjects:@"", @"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat", @"Sun", @"", nil];
    selectedDropDownValue = [array_options firstObject];
    
    customDataeFormatter = [GWDateFormatter sharedManager];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = [[NSCalendar currentCalendar] ordinalityOfUnit:(NSCalendarUnitDay) inUnit:(NSCalendarUnitEra) forDate:[NSDate date]];
    selectedDate = [[[NSCalendar currentCalendar] dateFromComponents:components] dateByAddingTimeInterval:customDataeFormatter.secondsFromGMT];
    
    [self.segmentController_duration setTintColor:[UIColor appGreenColor]];
    self.label_selectedDate.textColor = [UIColor appGreenColor];

    self.button_dropDown.layer.borderWidth = 1.0;
    self.button_dropDown.layer.borderColor = [[UIColor colorWithRed:195.0/255 green:195.0/255 blue:195.0/255 alpha:0.5]CGColor];
    self.button_dropDown.layer.masksToBounds = YES;
    
    [self refreshDataForSelectionType:Duration_Day];
//    [self refreshPerformanceGraph];
//    [self refreshPerformanceChart];
}

-(void)refreshDataForSelectionType:(SelectedDurationType)type {
    
    durationType = type;
    double GMTsecs = customDataeFormatter.secondsFromGMT;
    GMTsecs = 0.0;
    
    self.label_selectedDate.text = [[GWDateFormatter sharedManager] getDateString:selectedDate];
    [self.button_dropDown setTitle:selectedDropDownValue forState:UIControlStateNormal];
    NSTimeInterval fromTimeStamp;
    NSTimeInterval toTimeStamp = [[NSDate date] timeIntervalSince1970] + GMTsecs;
    self.button_forward.enabled = ([selectedDate timeIntervalSince1970] < (toTimeStamp - kSecondInDay));

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
            
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:selectedDate];
            NSInteger dayofweek = [[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:selectedDate] weekday];// this will give you current day of week
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

    performanceIndex = selectedDropDownValue;
    if ([performanceIndex.lowercaseString rangeOfString:[@"Average" lowercaseString]].location == NSNotFound) {
        if ([performanceIndex.lowercaseString rangeOfString:[@"Efficient" lowercaseString]].location == NSNotFound) {
            if ([performanceIndex.lowercaseString rangeOfString:[@"Neighbourhood" lowercaseString]].location == NSNotFound) {
                performanceIndex = nil;
            }
            else {
                performanceIndex = @"Neighbourhood";
            }
        }
        else {
            performanceIndex = @"Efficient household";
        }
    }
    else {
        performanceIndex = @"Average household";
    }
    
    [self callApiForPerformanceFrom:fromTimeStamp to:toTimeStamp];
    
    BOOL isCost = ([selectedDropDownValue.lowercaseString rangeOfString:[@"($)" lowercaseString]].location != NSNotFound);
    self.label_Y_axisUnit.text = (isCost ? @"$" : @"kWh");
    self.label_X_axisUnit.text = ((durationType == Duration_Day) ? @"hour" : @"day");
}

-(void)refreshPerformanceChart {
    
    if (chartView_performance == nil) {
     
        chartView_performance = [[LineChartView alloc] initWithFrame:CGRectMake(10.0, 10.0, [[UIScreen mainScreen] bounds].size.width - 40.0, 240.0)];
        [chartView_performance setDrawGridBackgroundEnabled:YES];
        [chartView_performance setGridBackgroundColor:[UIColor clearColor]];
        [chartView_performance setDescriptionText:@""];
        //[chartView_performance setNoDataTextDescription:@""];
        [chartView_performance setScaleXEnabled:YES];
        [chartView_performance setScaleYEnabled:YES];
        [chartView_performance setDragEnabled:YES];
        [chartView_performance setScaleEnabled:YES];
        [chartView_performance setPinchZoomEnabled:YES];
        [chartView_performance setHighlightPerTapEnabled:NO];
        [chartView_performance setHighlightPerDragEnabled:NO];

        ChartYAxis *leftAxis = chartView_performance.leftAxis;
        [leftAxis setAxisMinimum:0.0];
       // [leftAxis setStartAtZeroEnabled:YES];
        [leftAxis setGridLineWidth:1.0];
        [leftAxis setDrawLimitLinesBehindDataEnabled:YES];
        
        ChartXAxis *rightAxis = chartView_performance.xAxis;
        [rightAxis setGridLineWidth:1.0];
        [rightAxis setLabelPosition:XAxisLabelPositionBottom];
        [rightAxis setAxisLineWidth:1.0];
        [rightAxis setAxisLineColor:[UIColor blackColor]];
        
        chartView_performance.rightAxis.enabled = NO;
        ChartLegend *legend = chartView_performance.legend;
        legend.enabled = NO;
        
        [self.view_container addSubview:chartView_performance];
    }
   
    //clear all values
    [chartView_performance clear];
    [chartView_performance clearValues];
    [chartView_performance notifyDataSetChanged];

    BOOL isCost = ([selectedDropDownValue.lowercaseString rangeOfString:[@"($)" lowercaseString]].location != NSNotFound);
    
    NSMutableArray *real_data = [NSMutableArray array];
    NSMutableArray *benchmark_Data = [NSMutableArray array];
  
    LineChartDataSet *realDataSet = [LineChartDataSet new];
    //LineChartDataSet *realDataSet = [[LineChartDataSet alloc] initWithYVals:real_data label:nil];
    realDataSet.drawCubicEnabled = YES;
    realDataSet.lineDashLengths = @[@1.0, @0.0f];
    realDataSet.highlightLineDashLengths = @[@0.0, @0.0f];
    [realDataSet setColor:[[UIColor appGraphColor] colorWithAlphaComponent:0.5]];
    realDataSet.lineWidth = 0.5;
    realDataSet.drawCircleHoleEnabled = NO;
    realDataSet.drawFilledEnabled = YES;
    realDataSet.drawCirclesEnabled = YES;
    realDataSet.circleRadius = 3.0;
    [realDataSet setCircleColor:[UIColor appRedColor]];
    realDataSet.valueFont = [UIFont systemFontOfSize:9.f];
    realDataSet.fillAlpha = 1.0;
    realDataSet.fillColor = [[UIColor appGraphColor] colorWithAlphaComponent:0.4];
    
    LineChartDataSet *benchMarkDataSet = [LineChartDataSet new];
//    LineChartDataSet *benchMarkDataSet = [[LineChartDataSet alloc] initWithYVals:benchmark_Data label:nil];
    realDataSet.drawCubicEnabled = YES;
    benchMarkDataSet.lineDashLengths = @[@0.1, @0.0f];
    benchMarkDataSet.highlightLineDashLengths = @[@0.0, @0.0f];
    [benchMarkDataSet setColor:[[UIColor appGraphColor] colorWithAlphaComponent:0.25]];
    [benchMarkDataSet setCircleColor:UIColor.blackColor];
    benchMarkDataSet.lineWidth = 0.5;
    benchMarkDataSet.drawCirclesEnabled = YES;
    benchMarkDataSet.drawCircleHoleEnabled = YES;
    benchMarkDataSet.circleRadius = 5.0;
    benchMarkDataSet.drawFilledEnabled = YES;
    benchMarkDataSet.valueFont = [UIFont systemFontOfSize:9.f];
    benchMarkDataSet.fillAlpha = 1.0;
    benchMarkDataSet.fillColor = [[UIColor appGraphColor] colorWithAlphaComponent:0.15];
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:realDataSet];
    [dataSets addObject:benchMarkDataSet];
    
    NSMutableArray *labelIndexTitle = [NSMutableArray array];
    for(int i = 0; i < [real_data count]; i++)
        [labelIndexTitle addObject:((durationType == Duration_Week) ? [array_weekDay objectAtIndex:i] : [NSString stringWithFormat:@"%d",i+1])];

    LineChartData *lineData = [LineChartData new];
//    LineChartData *lineData = [[LineChartData alloc] initWithXVals:labelIndexTitle dataSets:dataSets];
    [lineData setValueTextColor:[UIColor clearColor]];
    chartView_performance.data = lineData;
    [chartView_performance fitScreen];
    [chartView_performance animateWithYAxisDuration:1.0];
}

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
        
        [self.view_container addSubview:lineChart_performance];
        [self.view_container clipsToBounds];
    }
    
    [lineChart_performance clearChartData];
    
    BOOL isCost = ([selectedDropDownValue.lowercaseString rangeOfString:[@"($)" lowercaseString]].location != NSNotFound);
    
    NSMutableArray *real_data;
    NSMutableArray *benchmark_Data;
    
    if (isCost) {
        
        real_data = self.array_realCost;
        benchmark_Data = self.array_benchMarkCost;
    }
    else {
        
        real_data = self.array_realLongEnergy;
        benchmark_Data = self.array_benchMarkLongEnergy;
    }
    
    
    BOOL isDataAvailable = (real_data.count > 0);
    
    if (isDataAvailable == NO)
        real_data = [NSMutableArray arrayWithObjects:@"0.0", nil];
    if (benchmark_Data.count < 1)
        benchmark_Data = [NSMutableArray arrayWithObjects:@"0.0", nil];
    
//    [real_data addObject:@"0"];
//    [real_data insertObject:@"" atIndex:0];
//    [benchmark_Data addObject:@"0"];
//    [benchmark_Data insertObject:@"" atIndex:0];
    NSMutableArray *labelIndexTitle = [NSMutableArray array];
    
//    for(int i = 0; i < [real_data count]; i++){
//        [labelIndexTitle addObject:((durationType == Duration_Week) ? [array_weekDay objectAtIndex:i] : [NSString stringWithFormat:@"%d",i+1])];
//    }
    for(int i = 0; i < [real_data count] + 2; i++){
        if (_segmentController_duration.selectedSegmentIndex == Duration_Day) {
            if (i == 0) {
                [labelIndexTitle addObject:@""];
            } else if (i == real_data.count + 1){
                [labelIndexTitle addObject:@""];
            } else {
                [labelIndexTitle addObject:[NSString stringWithFormat:@"%d",i]];
            }
        } else if (_segmentController_duration.selectedSegmentIndex == Duration_Week) {
            if (i == 0) {
                [labelIndexTitle addObject:@""];
            } else if (i == real_data.count + 1){
                [labelIndexTitle addObject:@""];
            } else {
                [labelIndexTitle addObject:[array_weekDay objectAtIndex:i]];
            }
        } else {
            if (i == 0) {
                [labelIndexTitle addObject:@""];
            } else if (i == real_data.count + 1){
                [labelIndexTitle addObject:@""];
            } else {
                [labelIndexTitle addObject:[NSString stringWithFormat:@"%d",i]];
            }
        }
    }
    
    [real_data addObject:[real_data lastObject]];
    [real_data insertObject:[real_data firstObject] atIndex:0];
    [benchmark_Data addObject:[benchmark_Data lastObject]];
    [benchmark_Data insertObject:[benchmark_Data firstObject] atIndex:0];

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
        
        lineChart_performance.fillColorOne = [[UIColor darkGrayColor] colorWithAlphaComponent:0.4];
        lineChart_performance.color = [[UIColor appGraphColor] colorWithAlphaComponent:0.5];
        [lineChart_performance setChartData2:real_data shouldDisplayDatapoints:isDataAvailable];// bar chart
        
        lineChart_performance.fillColorTwo = [[UIColor darkGrayColor] colorWithAlphaComponent:0.15];
        lineChart_performance.color = [[UIColor appGraphColor] colorWithAlphaComponent:0.25];
        [lineChart_performance setChartData:benchmark_Data shouldDisplayDatapoints:NO]; // line chart
    }
    else {
        
        lineChart_performance.fillColorTwo = [[UIColor darkGrayColor] colorWithAlphaComponent:0.15];
        lineChart_performance.color = [[UIColor appGraphColor] colorWithAlphaComponent:0.25];
        [lineChart_performance setChartData:benchmark_Data shouldDisplayDatapoints:NO]; // line chart
        
        lineChart_performance.fillColorOne = [[UIColor darkGrayColor] colorWithAlphaComponent:0.4];
        lineChart_performance.color = [[UIColor appGraphColor] colorWithAlphaComponent:0.5];
        [lineChart_performance setChartData2:real_data shouldDisplayDatapoints:isDataAvailable];// bar chart
    }
}

#pragma mark - IBAction Methods
- (IBAction)segmentActionValueChanged:(UISegmentedControl *)sender {
    
    [self refreshDataForSelectionType:sender.selectedSegmentIndex];
}

- (IBAction)buttonActionCommon:(UIButton *)sender {
    
    switch (sender.tag) {
            
        case 10: {
            //backwork
            
            selectedDate = [selectedDate dateByAddingTimeInterval:-(24 * 60 * 60)];
            [self refreshDataForSelectionType:durationType];
        }
            break;
         
        case 11: {
            //Forward
            
            selectedDate = [selectedDate dateByAddingTimeInterval:(24 * 60 * 60)];
            [self refreshDataForSelectionType:durationType];
        }
            break;
            
        case 12 : {
            //Cal
            
            [[CustomPickerController instance] showPicker:PickerType_Date withData:nil selectedData:selectedDate controller:nil completionBlock:^(id selectedData) {
                
                if (selectedData) {
                    selectedDate = [(NSDate*)selectedData dateByAddingTimeInterval:customDataeFormatter.secondsFromGMT];
                    [self refreshDataForSelectionType:durationType];
                }
            }];
        }
            break;
            
        case 13: {
            //drop down
            
            [[CustomPickerController instance] showPicker:PickerType_Default withData:array_options selectedData:selectedDropDownValue controller:nil completionBlock:^(id selectedData) {
                
                if (selectedData) {
                    selectedDropDownValue = (NSString*)selectedData;
                    [self refreshDataForSelectionType:durationType];
                }
            }];
        }
            break;
            
        default:
            break;
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

#pragma mark - Service Helper Delegate methods
-(void)serviceResponse:(id)response andMethodName:(WebMethodType)methodName {
    
    switch (methodName) {
            
        case WebMethodType_performanceIndex: {
            
            [self.array_performanceInfo removeAllObjects];
            [self.array_realCost removeAllObjects];
            [self.array_benchMarkCost removeAllObjects];
            [self.array_realLongEnergy removeAllObjects];
            [self.array_benchMarkLongEnergy removeAllObjects];

            NSArray *tempArray = (NSArray*)response;
            for (NSDictionary *performanceItem in tempArray) {
                
                PerformanceInfo *performance = [[PerformanceInfo alloc] initWithAttributes:performanceItem];
                [self.array_performanceInfo addObject:performance];
                if ([performance.circuitID isEqualToString:performanceIndex]) {
                    
                    [self.array_benchMarkCost addObject:performance.cost];
                    [self.array_benchMarkLongEnergy addObject:performance.longEnergy];
                }
                else {
                    
                    [self.array_realCost addObject:performance.cost];
                    [self.array_realLongEnergy addObject:performance.longEnergy];
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
    
    [self.array_performanceInfo removeAllObjects];
    [self.array_realCost removeAllObjects];
    [self.array_benchMarkCost removeAllObjects];
    [self.array_realLongEnergy removeAllObjects];
    [self.array_benchMarkLongEnergy removeAllObjects];
    
//    [self refreshPerformanceGraph];
    [self refreshPerformanceChart];
    
    NSString *message = [response objectForKey:@"errorMessage" expectedType:String];
    [[[UIAlertView alloc]initWithTitle:@"Sorry!" message:((message.length < 1) ? [response objectForKey:kLocalizedError] : message) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
}

@end
