//
//  DevicePageController.m
//  ElectricityVersion2
//
//  Created by Krishna Kant Kaira on 04/02/16.
//  Copyright © 2016 Mobiloitte Inc. All rights reserved.
//

#import "Header.h"
#import "DevicePageController.h"
#import "CarbonKit.h"
#import "RightnowViewController.h"
#import "BudgetViewController.h"
#import "PerformanceViewController.h"
#import "MotionDetectorViewController.h"
#import "HistoryViewController.h"
#import "TargetVC.h"

@interface DevicePageController () <CarbonTabSwipeNavigationDelegate> {
    
    AppUser *loggedInUser;
    CarbonTabSwipeNavigation *carbonTabSwipeNavigation;
    UINavigationController *navigationController_container;
    NSArray *array_controller;
    NSArray *array_color;
    
    BOOL isFirstTimeLoad;
}

@property (nonatomic, strong) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet MIBadgeButton *button_message;
@property (strong, nonatomic) IBOutlet UILabel *label_title;
@property (strong, nonatomic) IBOutlet UIButton *button_allDevices;

- (IBAction)buttonAction_menu:(UIButton *)sender;
- (IBAction)buttonAction_alert:(MIBadgeButton *)sender;
- (IBAction)buttonAction_allDevices:(UIButton *)sender;

@end

@implementation DevicePageController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    loggedInUser = [AppUser sharedUser];
    [self setupPageLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //get a local instance of the shared user
    loggedInUser = [AppUser sharedUser];
    
    self.label_title.text = loggedInUser.device.UI_deviceName;
    
    //set the alert count on top message icon
    [self.button_message setBadgeEdgeInsets:UIEdgeInsetsMake(15.0, 0.0, 0.0, 10.0)];
    [self.button_message setBadgeString:[APPDELEGATE alertCount]];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (isFirstTimeLoad == NO) {
        
        NSInteger index = carbonTabSwipeNavigation.currentTabIndex;
        if ((index >= 0) && (index < array_controller.count)) {
            UIViewController *currentController = [array_controller objectAtIndex:carbonTabSwipeNavigation.currentTabIndex];
            if ([currentController isKindOfClass:[UIViewController class]] && [currentController respondsToSelector:@selector(viewDidAppear:)]) {
                [currentController viewDidAppear:animated];
            }
        }
    }
    
    isFirstTimeLoad = NO;
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    NSInteger index = carbonTabSwipeNavigation.currentTabIndex;
    if ((index >= 0) && (index < array_controller.count)) {
        UIViewController *currentController = [array_controller objectAtIndex:carbonTabSwipeNavigation.currentTabIndex];
        if ([currentController isKindOfClass:[UIViewController class]] && [currentController respondsToSelector:@selector(viewWillDisappear:)]) {
            [currentController viewWillDisappear:animated];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 
-(void)setupPageLoad {
    
    isFirstTimeLoad = YES;
    
    //initialize navigation controller
    UIViewController *blankViewController = [UIViewController new];
    blankViewController.view.backgroundColor = [UIColor clearColor];
    navigationController_container = [[UINavigationController alloc] initWithRootViewController:blankViewController];
    navigationController_container.navigationBarHidden = YES;
    
    NSArray *items;
    array_color = [NSArray arrayWithObjects:[UIColor appOrangeColor], [UIColor appGreenColor], [UIColor appPurpleColor], nil];
    
    if (loggedInUser.device.deviceSensorType == DeviceSensorType_MotionDetector || loggedInUser.device.deviceSensorType == DeviceSensorType_SmokeDetector || loggedInUser.device.deviceSensorType == DeviceSensorType_KeyFob||loggedInUser.device.deviceSensorType == DeviceSensorType_WindowSensor) {
        
        items = [NSArray arrayWithObjects:@"RIGHT NOW", @"HISTORY", nil];
        array_controller = [NSArray arrayWithObjects:[[MotionDetectorViewController alloc] initWithNibName:@"MotionDetectorViewController" bundle:nil], [[HistoryViewController alloc] initWithNibName:@"HistoryViewController" bundle:nil], nil];
    }
    else if ((loggedInUser.device.deviceSensorType == DeviceSensorType_PulseReader) && (loggedInUser.device.deviceSensorUtility == DeviceSensorUtility_Electricity)) {
        items = [NSArray arrayWithObjects:@"RIGHT NOW", @"PERFORMANCE", @"BUDGET", nil];
        array_controller = [NSArray arrayWithObjects:[[RightnowViewController alloc] initWithNibName:@"RightnowViewController" bundle:nil], [[PerformanceViewController alloc] initWithNibName:@"PerformanceViewController" bundle:nil], [[BudgetViewController alloc] initWithNibName:@"BudgetViewController" bundle:nil], nil];
    } else if ((loggedInUser.device.deviceSensorType == DeviceSensorType_WattWatcher) && (loggedInUser.device.deviceSensorUtility == DeviceSensorUtility_Electricity)) {
        items = [NSArray arrayWithObjects:@"RIGHT NOW", @"PERFORMANCE", @"BUDGET", nil];
        array_controller = [NSArray arrayWithObjects:[[RightnowViewController alloc] initWithNibName:@"RightnowViewController" bundle:nil], [[PerformanceViewController alloc] initWithNibName:@"PerformanceViewController" bundle:nil], [[BudgetViewController alloc] initWithNibName:@"BudgetViewController" bundle:nil], nil];
    }
    else if ((loggedInUser.device.deviceSensorType == DeviceSensorType_WattWatcher) && (loggedInUser.device.deviceSensorUtility == DeviceSensorUtility_Generation)) {
        items = [NSArray arrayWithObjects:@"PERFORMANCE", @"TARGET", nil];
        array_controller = [NSArray arrayWithObjects:[[PerformanceViewController alloc] initWithNibName:@"PerformanceViewController" bundle:nil], [[TargetVC alloc] initWithNibName:@"TargetVC" bundle:nil], nil];
    } else {
        items = [NSArray arrayWithObjects:@"RIGHT NOW", @"PERFORMANCE", nil];
        array_controller = [NSArray arrayWithObjects:[[RightnowViewController alloc] initWithNibName:@"RightnowViewController" bundle:nil], [[PerformanceViewController alloc] initWithNibName:@"PerformanceViewController" bundle:nil], nil];
    }
    
    carbonTabSwipeNavigation = [[CarbonTabSwipeNavigation alloc] initWithItems:items delegate:self];
    [carbonTabSwipeNavigation insertIntoRootViewController:blankViewController];
    [self style];

    [self addChildViewController:navigationController_container];
    [navigationController_container.view setFrame:self.containerView.bounds];
    [self.containerView addSubview:navigationController_container.view];
    [self.view setNeedsLayout];
    
    [navigationController_container didMoveToParentViewController:self];
}

- (void)style {
    
    // Custimize segmented control
    carbonTabSwipeNavigation.toolbar.translucent = NO;
    carbonTabSwipeNavigation.toolbar.clipsToBounds = YES;
    carbonTabSwipeNavigation.toolbar.barTintColor = self.containerView.backgroundColor;
    
    UIColor *color = [array_color firstObject];
    [carbonTabSwipeNavigation setIndicatorColor:color];
//    [carbonTabSwipeNavigation setTabExtraWidth:15.0];
    [carbonTabSwipeNavigation.carbonTabSwipeScrollView setScrollEnabled:NO];
    [carbonTabSwipeNavigation.carbonTabSwipeScrollView setBounces:NO];
    carbonTabSwipeNavigation.carbonSegmentedControl.indicatorPosition = IndicatorPositionTop;
    carbonTabSwipeNavigation.carbonSegmentedControl.indicatorHeight = 4.0;
    
    CGFloat tabWidth = ([[UIScreen mainScreen] bounds].size.width / array_controller.count);
    carbonTabSwipeNavigation.carbonSegmentedControl.indicatorWidth = tabWidth;
    
    for (int index = 0; index < array_controller.count; index++)
        [carbonTabSwipeNavigation.carbonSegmentedControl setWidth:tabWidth forSegmentAtIndex:index];
    
    [carbonTabSwipeNavigation setNormalColor:[UIColor darkGrayColor] font:[UIFont fontWithName:@"Roboto-Bold" size:13.0]];
    [carbonTabSwipeNavigation setSelectedColor:color font:[UIFont fontWithName:@"Roboto-Bold" size:13.0]];
}

#pragma mark - IBAction
- (IBAction)buttonAction_alert:(UIButton *)sender {
    
    UIViewController *alertVC = nil;
    for (NSInteger index = (self.navigationController.viewControllers.count-1); index >= 0; index--) {
        UIViewController *controller = [[self.navigationController viewControllers] objectAtIndex:index];
        if ([controller isKindOfClass:[GAAlertsVC class]]) {
            alertVC = controller;
            break;
        }
    }
    
    if (alertVC) {
        [self.navigationController popToViewController:alertVC animated:YES];
    }
    else {
        [self.navigationController pushViewController:[[GAAlertsVC alloc] initWithNibName:@"GAAlertsVC" bundle:nil] animated:YES];
    }
}

- (IBAction)buttonAction_menu:(id)sender {
    
    UIViewController *menuVC = nil;
    for (NSInteger index = (self.navigationController.viewControllers.count-1); index >= 0; index--) {
        UIViewController *controller = [[self.navigationController viewControllers] objectAtIndex:index];
        if ([controller isKindOfClass:[GAMenuVC class]]) {
            menuVC = controller;
            break;
        }
    }
    
    if (menuVC) {
        [self.navigationController popToViewController:menuVC animated:YES];
    }
    else {
        [self.navigationController pushViewController:[[GAMenuVC alloc] initWithNibName:@"GAMenuVC" bundle:nil] animated:YES];
    }
}

- (IBAction)buttonAction_allDevices:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - CarbonTabSwipeNavigation Delegate
//required
- (nonnull UIViewController *)carbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbontTab
                                 viewControllerAtIndex:(NSUInteger)index {
    return [array_controller objectAtIndex:index];
}

//optional
- (void)carbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbonTab
                 willMoveAtIndex:(NSUInteger)index {
    
    UIColor *color = [array_color objectAtIndex:index];
    self.button_allDevices.backgroundColor = color;
    [carbonTabSwipeNavigation setIndicatorColor:color];
    [carbonTabSwipeNavigation setSelectedColor:color font:[UIFont fontWithName:@"Roboto-Bold" size:13.0]];
}

- (void)carbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbonTab
                  didMoveAtIndex:(NSUInteger)index {
    
    UIColor *color = [array_color objectAtIndex:index];
    self.button_allDevices.backgroundColor = color;
    [carbonTabSwipeNavigation setIndicatorColor:color];
    [carbonTabSwipeNavigation setSelectedColor:color font:[UIFont fontWithName:@"Roboto-Bold" size:13.0]];
}

- (UIBarPosition)barPositionForCarbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbonTab {
    return UIBarPositionTop;
}

@end
