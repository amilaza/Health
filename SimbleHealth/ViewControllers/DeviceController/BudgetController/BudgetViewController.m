//
//  BugetViewController.m
//  ElectricityVersion2
//
//  Created by Krishna Kant Kaira on 04/02/16.
//  Copyright © 2016 Mobiloitte Inc. All rights reserved.
//

#import "BudgetViewController.h"
#import "ServiceHelper.h"
#import "BudgetData.h"
#import "GWDateFormatter.h"
#import "DateCommon.h"
@interface BudgetViewController () <ServiceHelperDelegate> {
    
    AppUser *loggedInUser;
    ServiceHelper *appWebEngine;
    UserPreference *preference;
    NSDate *selectedDate;
    
    NSDateComponents *dateComponents;
    GWDateFormatter *customDataeFormatter;
    NSArray *baseColorArray;
    CGFloat sliderMaxWidth;
    NSTimer *timer_refreshData;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView_budget;
@property (strong, nonatomic) IBOutlet UIButton *button_backward;
@property (strong, nonatomic) IBOutlet UIButton *button_forward;
@property (strong, nonatomic) IBOutlet UILabel *label_duration;
@property (strong, nonatomic) IBOutlet UIImageView *imageView_budgetIcon;
@property (strong, nonatomic) IBOutlet UILabel *label_budgetValue;
@property (strong, nonatomic) IBOutlet UILabel *label_monthlyBudgetPreference;
@property (strong, nonatomic) IBOutlet UIView *view_toDate;
@property (strong, nonatomic) IBOutlet UIView *view_tracking;
@property (strong, nonatomic) IBOutlet UIButton *button_cost;
@property (strong, nonatomic) IBOutlet UIButton *button_kwh;
@property (strong, nonatomic) IBOutlet UIImageView *imageView_popup;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_popupLeading;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imvBudgetConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_trackingViewWidth;

@property (strong, nonatomic) BudgetData *object_budgetData;
@property (strong, nonatomic) NSMutableArray *array_energy;

- (IBAction)buttonAction_common:(UIButton *)sender;

@end

@implementation BudgetViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    preference = [[AppUser sharedUser] preference];
    [self setupLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView_budget setContentOffset:CGPointZero];
    [self animateImageView];
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if ([timer_refreshData isValid]) [timer_refreshData invalidate];
    timer_refreshData = nil;
    timer_refreshData =  [NSTimer scheduledTimerWithTimeInterval:kRefreshTimeInterval target:self selector:@selector(callApiForBudget) userInfo:nil repeats:YES];
    
    //refresh Data
    [self callApiForBudget];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    if ([timer_refreshData isValid]) [timer_refreshData invalidate];
    timer_refreshData = nil;
    [[self getAppEngine] cancelRequestwithName:WebMethodType_consumption];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {
    
    if ([timer_refreshData isValid]) [timer_refreshData invalidate];
    timer_refreshData = nil;
    
    //remove the delegate on deallocation of the controller
    [appWebEngine setServiceHelperDelegate:nil];
    appWebEngine = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Other Helper Methods
-(void)setupLoad {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(awakeFromBackground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    sliderMaxWidth = [[UIScreen mainScreen] bounds].size.width - 62.0;
    loggedInUser = [AppUser sharedUser];
    self.label_duration.textColor = [UIColor appPurpleColor];
    baseColorArray = [NSArray arrayWithObjects:[UIColor appRedColor], [UIColor appBlueColor], [UIColor appGreenColor], [UIColor appYellowColor], [UIColor appPurpleColor], nil];

    self.array_energy = [NSMutableArray array];
    self.button_cost.selected = YES;
    self.button_kwh.selected = !self.button_cost.selected;
    self.imageView_popup.image = [[UIImage imageNamed:@"Popup_line.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(58.0, 0.0, 0.0, 0.0)];
    self.label_monthlyBudgetPreference.text = [NSString stringWithFormat:@"BUDGET\n$ 0"];

    customDataeFormatter = [GWDateFormatter sharedManager];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    dateComponents = [calendar components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:[NSDate date]];
    dateComponents.day = 1;
    selectedDate = [[calendar dateFromComponents:dateComponents] dateByAddingTimeInterval:customDataeFormatter.secondsFromGMT];
    self.label_duration.text = [[GWDateFormatter sharedManager] getMonth:selectedDate];
    
    self.button_forward.hidden = ![self isCurrentOrFutureMonth:selectedDate];
    
    [self refreshUI];
}

-(BOOL)isCurrentOrFutureMonth:(NSDate*)date {

    return ([[NSCalendar currentCalendar] components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:date toDate:[NSDate date] options:0].month > 0);
}

-(void)refreshUI {
    
    double monetaryThreshold = [self.object_budgetData.monetaryThreshold doubleValue];
    double monetaryTrend = [self.object_budgetData.monetaryTrend doubleValue];
    double consumptionThreshold = [self.object_budgetData.consumptionThreshold doubleValue];
    double consumptionTrend = [self.object_budgetData.consumptionTrend doubleValue];
    
    double trackingMaxValue = 0.0;
    double trackingValue = 0.0;
    double toDateTotalValue = 0.0;
    BOOL isUnderBudget = NO;
    
    if (self.button_cost.selected) {
        //cost ($) == monetary
        
        double toatalCostPercentage = ((preference.monthlyBudget_pound == 0) ? 0.0 : ((monetaryTrend * 100) / [preference.monthlyBudget_pound doubleValue]));
        toDateTotalValue = [[self.array_energy valueForKeyPath:@"@sum.self.cost.doubleValue"] doubleValue];
        
        self.label_budgetValue.text = [NSString stringWithFormat:@"%.0f %%",toatalCostPercentage];
        self.label_monthlyBudgetPreference.text = [NSString stringWithFormat:@"BUDGET\n$ %@",preference.monthlyBudget_pound];
        
        NSInteger daysOfMonth = [DateCommon numberOfDaysOnMonthFromDate:[NSDate date]];
        NSInteger today = [DateCommon getDayOfMonthFormDate:[NSDate date]];
        trackingValue = toDateTotalValue * (daysOfMonth/today);
        for (UIView *view in [_view_tracking subviews]) {
            [view removeFromSuperview];
        }
        
        UILabel *label = [[UILabel alloc]initWithFrame:_view_tracking.bounds];
        label.font = [UIFont systemFontOfSize:17];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor whiteColor];
        label.text = [NSString stringWithFormat:@"    TRACKING : $ %.0f",trackingValue];
        [_view_tracking addSubview:label];
        
        isUnderBudget = (toatalCostPercentage < 100.0);
        trackingMaxValue = MAX(monetaryThreshold, monetaryTrend);
    }
    else {
        //kWh == Cunsumpsion
        
        double toatalPowerPercentage = ((preference.monthlyBudget_kwh == 0) ? 0.0 : ((consumptionTrend * 100) / [preference.monthlyBudget_kwh doubleValue]));
        toDateTotalValue = [[self.array_energy valueForKeyPath:@"@sum.self.usage.doubleValue"] doubleValue];
        NSInteger daysOfMonth = [DateCommon numberOfDaysOnMonthFromDate:[NSDate date]];
        NSInteger today = [DateCommon getDayOfMonthFormDate:[NSDate date]];
        trackingValue = toDateTotalValue * ((double)daysOfMonth/(double)today);
        self.label_budgetValue.text = [NSString stringWithFormat:@"%.0f %%",toatalPowerPercentage];
        self.label_monthlyBudgetPreference.text = [NSString stringWithFormat:@"BUDGET\n %@ kWh",preference.monthlyBudget_kwh];
        
        
        for (UIView *view in [_view_tracking subviews]) {
            [view removeFromSuperview];
        }
        
        UILabel *label = [[UILabel alloc]initWithFrame:_view_tracking.bounds];
        label.font = [UIFont systemFontOfSize:17];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor whiteColor];
        label.text = [NSString stringWithFormat:@"    TRACKING : %.0f kWh",trackingValue];
        [_view_tracking addSubview:label];
        
        isUnderBudget = (toatalPowerPercentage < 100.0);
        trackingValue = trackingValue;
        trackingMaxValue = MAX(consumptionThreshold, consumptionTrend);
    }
    
    /*
     * Top Expression icon
     */
    self.imageView_budgetIcon.image = [UIImage imageNamed:(isUnderBudget ? @"HappyExpression.png" : @"SadExpression.png")];
    [self animateImageView];
    self.label_budgetValue.textColor = (isUnderBudget ? [UIColor appGreenColor] : [UIColor appRedColor]);
    
    
    /*
     * Budget pop-up
     */
    double constant = 0.0;
    double budgetValue = (self.button_cost.selected ? monetaryThreshold : consumptionThreshold);
    constant = ((trackingMaxValue != 0.0) ? ((budgetValue * sliderMaxWidth) / trackingMaxValue) : 0.0);
    constant -= (self.imageView_popup.bounds.size.width/2.0);
    self.constraint_popupLeading.constant = constant;
    [self.view layoutIfNeeded];
    _imvBudgetConstraint.constant = WINDOW_WIDTH - 62 - 65;
    
    /*
     * To DATE
     */
    //remove all subviews from 'view_toDate'
    for (UIView *subview in self.view_toDate.subviews)
        [subview removeFromSuperview];
    
    double totalUsage = [[self.array_energy valueForKeyPath:@"@sum.self.usage.doubleValue"] doubleValue];
    double totalCost = [[self.array_energy valueForKeyPath:@"@sum.self.cost.doubleValue"] doubleValue];
    double maxToDateValue = (self.button_cost.selected ? MAX(trackingMaxValue, totalCost) : MAX(trackingMaxValue, totalUsage));
    //call a resucrsive function for adding subviews
    [self addEnergyAtIndex:0 withMaxValue:maxToDateValue andTotalValue:toDateTotalValue];
    [self.view_toDate setBackgroundColor:((toDateTotalValue == 0.0) ? [UIColor lightGrayColor] : [UIColor clearColor])];
   
    /*
     * TRACKING
     */
    //set background view
    if (trackingValue == 0.0) {
        self.constraint_trackingViewWidth.constant = sliderMaxWidth;
        [self.view_tracking setBackgroundColor:[UIColor lightGrayColor]];
    }
    else {
        self.constraint_trackingViewWidth.constant = ((trackingMaxValue != 0.0) ? ((trackingValue * sliderMaxWidth) / trackingMaxValue) : 0.0);
        if (isUnderBudget) {
            self.view_tracking.backgroundColor = [UIColor colorWithRed:50.0/255.0 green:150.0/255.0 blue:76.0/255.0 alpha:1.0];
        } else {
            self.view_tracking.backgroundColor = [UIColor appRedColor];
        }
//        self.view_tracking.backgroundColor = (isUnderBudget ? [UIColor appGreenColor] : [UIColor appRedColor]);
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(void)addEnergyAtIndex:(NSInteger)index withMaxValue:(double)maxVal andTotalValue:(double)totalValue {
    if ((index >= 0) && (index < self.array_energy.count)) {
        double width = 0.0;
        width = ((maxVal != 0) ? ((totalValue * sliderMaxWidth) / maxVal) : 90.0);
        
        CGRect viewFrame = CGRectMake(0, 0.0, 0.0, self.view_toDate.bounds.size.height);
        UIView *newView = [[UIView alloc] initWithFrame:viewFrame];
        if (maxVal == 0) {
            newView.backgroundColor = [UIColor clearColor];
        } else {
            newView.backgroundColor = [baseColorArray objectAtIndex:1];
        }
        
        
        [self.view_toDate addSubview:newView];
        viewFrame.size.width = width;
        [UIView animateWithDuration:0.2 animations:^{
            newView.frame = viewFrame;
        } completion:^(BOOL finished) {
            UILabel *label = [[UILabel alloc]initWithFrame:newView.bounds];
            
            NSString *strName = @"    To Date";
            if (width < 80) {
                label.font = [UIFont systemFontOfSize:12];
            } else {
                label.font = [UIFont systemFontOfSize:17];
            }
            if (self.button_cost.selected == YES) {
                strName = [NSString stringWithFormat:@"%@ %.0f $", [strName uppercaseString],totalValue];
            } else {
                strName = [NSString stringWithFormat:@"%@ %.0f kwh", [strName uppercaseString],totalValue];
            }
            label.adjustsFontSizeToFitWidth = YES;
            label.minimumScaleFactor = 0.5;
            label.text = strName;
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentLeft;
            [newView addSubview:label];
        }];
        
    }
    else {
        return;
    }
}

-(void)animateImageView {
    
    self.imageView_budgetIcon.transform = CGAffineTransformMakeScale(1.0, 1.0);
    [UIView animateWithDuration:0.5 delay:0.0 options:(UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat|UIViewAnimationOptionAllowUserInteraction) animations:^{
        self.imageView_budgetIcon.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:NULL];
}

-(void)awakeFromBackground:(id)sender {
    
    [self animateImageView];
}

#pragma mark - IBAction
- (IBAction)buttonAction_common:(UIButton *)sender {
    
    switch (sender.tag) {
            
        case 10: {
            //backward
            
            dateComponents.month -= 1;
            selectedDate = [[[NSCalendar currentCalendar] dateFromComponents:dateComponents] dateByAddingTimeInterval:customDataeFormatter.secondsFromGMT];
            self.label_duration.text = [[GWDateFormatter sharedManager] getMonth:selectedDate];
            
            self.button_forward.hidden = ![self isCurrentOrFutureMonth:selectedDate];
        }
            break;
            
        case 11: {
            //forward
            
            dateComponents.month += 1;
            selectedDate = [[[NSCalendar currentCalendar] dateFromComponents:dateComponents] dateByAddingTimeInterval:customDataeFormatter.secondsFromGMT];
            self.label_duration.text = [[GWDateFormatter sharedManager] getMonth:selectedDate];
            
            self.button_forward.hidden = ![self isCurrentOrFutureMonth:selectedDate];
        }
            break;
            
        case 12: {
            //$
            
            self.button_cost.selected = YES;
            self.button_kwh.selected = NO;
        }
            break;
            
        case 13: {
            //kWh
            
            self.button_kwh.selected = YES;
            self.button_cost.selected = NO;
        }
            break;
            
        default:
            break;
    }
    
    [self callApiForBudget];
}

#pragma mark - Service Helper Methods
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
            
            self.object_budgetData = [[BudgetData alloc] initWithAttributes:[response objectForKey:@"budget" expectedType:Dictionary]];
            [self.array_energy removeAllObjects];
            
            NSArray *arrya_temp = [response objectForKey:@"energy" expectedType:Array];
            for (NSDictionary *item in arrya_temp)
                [self.array_energy addObject:[[EnergyItem alloc] initWithAttributes:item]];
            
            [self refreshUI];
            
            //log event
//            [[GAHelper instance] sendEventOfType:LogType_BudgetScreen forUser:loggedInUser];
        }
            break;
            
        default: break;
    }
}

-(void)serviceError:(id)response andMethodName:(WebMethodType)methodName {
    
    self.object_budgetData = nil;
    [self.array_energy removeAllObjects];
    [self refreshUI];

    NSString *message = [response objectForKey:@"errorMessage" expectedType:String];
    [[[UIAlertView alloc]initWithTitle:@"Sorry!" message:((message.length < 1) ? [response objectForKey:kLocalizedError] : message) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
}

@end
