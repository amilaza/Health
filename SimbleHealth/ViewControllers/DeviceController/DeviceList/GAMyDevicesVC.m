//
//  GAMyDevicesVC.m
//  ElectricityVersion2
//
//  Created by Mohit Kumar on 12/7/15.
//  Copyright © 2015 Mobiloitte Inc. All rights reserved.
//

#import "Header.h"
#import "GAMyDeviceCell.h"
#import "MyDevicePopupViewController.h"
#import "DevicePageController.h"
#import "SolarCell.h"
#import "MotionCell.h"
#import "SmartPlugCell.h"
#import "DateCommon.h"
#import "KeyFobCell.h"
#import "SmokeCell.h"
#import "Header.h"

@interface GAMyDevicesVC () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIPageViewControllerDelegate, ServiceHelperDelegate, MyDevicePopUpDelegate, SmartPlugCellDelegate> {
    
    ServiceHelper *appWebEngine;
    NSInteger selectedIndex;
    AppUser *loggedInUser;
    NSTimer *timer_refreshData;
    
    NSArray *baseColorArray;
}

@property (strong, nonatomic) NSMutableArray *array_deviceList;
@property (strong, nonatomic) NSString *data;

@property (strong, nonatomic) IBOutlet MIBadgeButton *button_message;

@property (strong, nonatomic) UICollectionViewFlowLayout *colectionViewFlow;
@property (strong, nonatomic) IBOutlet UICollectionView *myDevicesCollectionView;

- (IBAction)buttonAction_menu:(UIButton *)sender;
- (IBAction)buttonAction_alert:(MIBadgeButton *)sender;

@end

@implementation GAMyDevicesVC
static NSString *solarIdentifier = @"SolarCell";
static NSString *electricityIdentifier = @"GAMyDeviceCell";
static NSString *motionCellIdentifier = @"MotionCell";
static NSString *smartPlugCellIdentifier = @"SmartPlugCell";
static NSString *keyFobCellIdentifier = @"KeyFobCell";
static NSString *smokeCellIdentifier = @"SmokeCell";
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //get a local instance of the shared user
    loggedInUser = [AppUser sharedUser];

    //initialize/setup the controller view and other stuff
    [self setUpOnLoad];
    
    //log event
    //[[GAHelper instance] sendEventOfType:LogType_DeviceListScreen forUser:[AppUser sharedUser]];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //get a local instance of the shared user
    loggedInUser = [AppUser sharedUser];
    
    //set the alert count on top message icon
    [self.button_message setBadgeEdgeInsets:UIEdgeInsetsMake(15.0, 0.0, 0.0, 10.0)];
    [self.button_message setBadgeString:[APPDELEGATE alertCount]];
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if ([timer_refreshData isValid]) [timer_refreshData invalidate];
    timer_refreshData = nil;
    timer_refreshData =  [NSTimer scheduledTimerWithTimeInterval:kRefreshTimeInterval target:self selector:@selector(callApiForBuildingList) userInfo:nil repeats:YES];
    
    [self callApiForBuildingList];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    if ([timer_refreshData isValid]) [timer_refreshData invalidate];
    timer_refreshData = nil;

    [[self getAppEngine] cancelRequestwithName:WebMethodType_BuildingList];
    [[self getAppEngine] cancelRequestwithName:WebMethodType_EnergyDevicesOfBuilding];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {
    
    [timer_refreshData invalidate];

    //remove the delegate on deallocation of the controller
    [appWebEngine setServiceHelperDelegate:nil];
    appWebEngine = nil;
}

#pragma mark - Initial SetUp Method

-(void)setUpOnLoad {
   
    [self.myDevicesCollectionView setAlwaysBounceVertical:YES];
    self.array_deviceList = [NSMutableArray array];
    baseColorArray = [NSArray arrayWithObjects:[UIColor appRedColor], [UIColor appBlueColor], [UIColor appGreenColor], [UIColor appYellowColor], [UIColor appGrayColor], [UIColor appPurpleColor], nil];
    
    UINib *cellNib = [UINib nibWithNibName:@"GAMyDeviceCell" bundle:nil];
    [self.myDevicesCollectionView registerNib:cellNib forCellWithReuseIdentifier:electricityIdentifier];
    UINib *solarNib = [UINib nibWithNibName:solarIdentifier bundle:nil];
    [self.myDevicesCollectionView registerNib:solarNib forCellWithReuseIdentifier:solarIdentifier];
    UINib *motionNib = [UINib nibWithNibName:motionCellIdentifier bundle:nil];
    [self.myDevicesCollectionView registerNib:motionNib forCellWithReuseIdentifier:motionCellIdentifier];
    UINib *smartPlugNib = [UINib nibWithNibName:smartPlugCellIdentifier bundle:nil];
    [self.myDevicesCollectionView registerNib:smartPlugNib forCellWithReuseIdentifier:smartPlugCellIdentifier];
    UINib *keyFobNib = [UINib nibWithNibName:keyFobCellIdentifier bundle:nil];
    [self.myDevicesCollectionView registerNib:keyFobNib forCellWithReuseIdentifier:keyFobCellIdentifier];
    UINib *smokeFobNib = [UINib nibWithNibName:smokeCellIdentifier bundle:nil];
    [self.myDevicesCollectionView registerNib:smokeFobNib forCellWithReuseIdentifier:smokeCellIdentifier];
    self.navigationController.navigationBarHidden = YES;
    [self.myDevicesCollectionView setDataSource:self];
    [self.myDevicesCollectionView setDelegate:self];
    self.colectionViewFlow =[[UICollectionViewFlowLayout alloc]init];
    self.colectionViewFlow.minimumLineSpacing = 15.0f;
    self.colectionViewFlow.minimumInteritemSpacing = 10.0f;
    
    [self.colectionViewFlow setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.myDevicesCollectionView setCollectionViewLayout:self.colectionViewFlow];
    
//    [self callApiForBuildingList];
}

#pragma mark- UICollectionView Datasource Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.array_deviceList count];
}

- (SolarCell *)solarCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DeviceInfo *deviceInfo = [self.array_deviceList objectAtIndex:indexPath.row];
    SolarCell *menuCell = (SolarCell *)[collectionView dequeueReusableCellWithReuseIdentifier:solarIdentifier forIndexPath:indexPath];
    menuCell.array_deviceList = self.array_deviceList;
    menuCell.indexPath = indexPath;
    menuCell.deviceInfo = deviceInfo;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPress.minimumPressDuration = 0.5;
    [menuCell.button_power addGestureRecognizer:longPress];
    [menuCell.button_power addTarget:self action:@selector(buttonActionDidSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    menuCell.button_power.tag = indexPath.row;


    return menuCell;
    
}

- (GAMyDeviceCell *)electricityCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DeviceInfo *deviceInfo = [self.array_deviceList objectAtIndex:indexPath.row];
    
    GAMyDeviceCell *menuCell = (GAMyDeviceCell *)[collectionView dequeueReusableCellWithReuseIdentifier:electricityIdentifier forIndexPath:indexPath];
    menuCell.array_deviceList = self.array_deviceList;
    menuCell.indexPath = indexPath;
    menuCell.deviceInfo = deviceInfo;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPress.minimumPressDuration = 0.5;
    
    [menuCell.button_power addGestureRecognizer:longPress];
    [menuCell.button_power addTarget:self action:@selector(buttonActionDidSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    menuCell.button_power.tag = indexPath.row;
    return menuCell;
}

- (MotionCell *)motionCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DeviceInfo *deviceInfo = [self.array_deviceList objectAtIndex:indexPath.row];
    
    MotionCell *menuCell = (MotionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:motionCellIdentifier forIndexPath:indexPath];
    menuCell.array_deviceList = self.array_deviceList;
    menuCell.indexPath = indexPath;
    menuCell.deviceInfo = deviceInfo;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPress.minimumPressDuration = 0.5;
    
    [menuCell.button_power addGestureRecognizer:longPress];
    [menuCell.button_power addTarget:self action:@selector(buttonActionDidSelect:) forControlEvents:UIControlEventTouchUpInside];
    menuCell.button_power.tag = indexPath.row;
    return menuCell;
}

- (SmartPlugCell *)smartPlugCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DeviceInfo *deviceInfo = [self.array_deviceList objectAtIndex:indexPath.row];
    
    SmartPlugCell *menuCell = (SmartPlugCell *)[collectionView dequeueReusableCellWithReuseIdentifier:smartPlugCellIdentifier forIndexPath:indexPath];
    menuCell.array_deviceList = self.array_deviceList;
    menuCell.indexPath = indexPath;
    menuCell.deviceInfo = deviceInfo;
    menuCell.delegate = self;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPress.minimumPressDuration = 0.5;
    
    [menuCell.button_power addGestureRecognizer:longPress];
    [menuCell.button_power addTarget:self action:@selector(buttonActionDidSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    menuCell.button_power.tag = indexPath.row;
    return menuCell;
}

- (KeyFobCell *)keyFobCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DeviceInfo *deviceInfo = [self.array_deviceList objectAtIndex:indexPath.row];
    
    KeyFobCell *menuCell = (KeyFobCell *)[collectionView dequeueReusableCellWithReuseIdentifier:keyFobCellIdentifier forIndexPath:indexPath];
    menuCell.array_deviceList = self.array_deviceList;
    menuCell.indexPath = indexPath;
    menuCell.deviceInfo = deviceInfo;
//    menuCell.delegate = self;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPress.minimumPressDuration = 0.5;
    
    [menuCell.button_power addGestureRecognizer:longPress];
    [menuCell.button_power addTarget:self action:@selector(buttonActionDidSelect:) forControlEvents:UIControlEventTouchUpInside];
    menuCell.button_power.tag = indexPath.row;
    return menuCell;
    return menuCell;
}

- (SmokeCell *)smokeCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DeviceInfo *deviceInfo = [self.array_deviceList objectAtIndex:indexPath.row];
    
    SmokeCell *menuCell = (SmokeCell *)[collectionView dequeueReusableCellWithReuseIdentifier:smokeCellIdentifier forIndexPath:indexPath];
    menuCell.array_deviceList = self.array_deviceList;
    menuCell.indexPath = indexPath;
    menuCell.deviceInfo = deviceInfo;
    //    menuCell.delegate = self;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPress.minimumPressDuration = 0.5;
    
    [menuCell.button_power addGestureRecognizer:longPress];
    [menuCell.button_power addTarget:self action:@selector(buttonActionDidSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    menuCell.button_power.tag = indexPath.row;
    return menuCell;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DeviceInfo *deviceInfo = [self.array_deviceList objectAtIndex:indexPath.row];
    switch (deviceInfo.deviceSensorType) {
        case DeviceSensorType_MotionDetector: {
            return [self motionCollectionView:collectionView cellForItemAtIndexPath:indexPath];
        }
            break;
        case DeviceSensorType_PulseReader: {
            if (deviceInfo.deviceSensorUtility == DeviceSensorUtility_Solar) {
                return [self solarCollectionView:collectionView cellForItemAtIndexPath:indexPath];
            } else if (deviceInfo.deviceSensorUtility == DeviceSensorUtility_Generation) {
                return [self solarCollectionView:collectionView cellForItemAtIndexPath:indexPath];
            } else {
                return [self electricityCollectionView:collectionView cellForItemAtIndexPath:indexPath];
            }
            
        }
            break;
        case DeviceSensorType_WattWatcher:{
            if (deviceInfo.deviceSensorUtility == DeviceSensorUtility_Generation) {
                return [self solarCollectionView:collectionView cellForItemAtIndexPath:indexPath];
            } else {
                return [self electricityCollectionView:collectionView cellForItemAtIndexPath:indexPath];
            }
        }
        case DeviceSensorType_SmartPlug: {
            return [self smartPlugCollectionView:collectionView cellForItemAtIndexPath:indexPath];
        }
            break;
        case DeviceSensorType_WindowSensor:{
            return [self motionCollectionView:collectionView cellForItemAtIndexPath:indexPath];
        }
            break;
        case DeviceSensorType_KeyFob:{
            return [self keyFobCollectionView:collectionView cellForItemAtIndexPath:indexPath];
        }
            break;
        case DeviceSensorType_SmokeDetector: {
            return [self smokeCollectionView:collectionView cellForItemAtIndexPath:indexPath];
        }
            break;
            
        default:
            break;
            
    }

    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    DeviceInfo *deviceInfo = [self.array_deviceList objectAtIndex:indexPath.row];
    switch (deviceInfo.deviceSensorType) {
        
        case DeviceSensorType_SmartPlug: {
//            cell = (SmartPlugCell *)[collectionView cellForItemAtIndexPath:indexPath];
            SmartPlugCell *resetCell = (SmartPlugCell *)cell;
            [resetCell updateSwitchFrame];
        }
            break;
        
            
        default:
            break;
            
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellHeight = 130;
    DeviceInfo *deviceInfo = [self.array_deviceList objectAtIndex:indexPath.row];
    switch (deviceInfo.deviceSensorType) {
        case DeviceSensorType_MotionDetector: {
            cellHeight = 125;
        }
            break;
        case DeviceSensorType_PulseReader: {
            if ([deviceInfo.circuitType isEqualToString:@"Solar"]) {
                cellHeight = 125;
            } else {
                cellHeight = 140;
            }
            
        }
            break;
        case DeviceSensorType_WattWatcher:{
            cellHeight = 140;
        }
        case DeviceSensorType_SmartPlug: {
            if([deviceInfo.circuitSubtype isEqualToString:@"Lighting"]){
               cellHeight = 140;
            }
            else if ([deviceInfo.circuitSubtype isEqualToString:@"Kitchen appliance"]){
                cellHeight = 140;
            }
            else if ([deviceInfo.circuitSubtype isEqualToString:@"Ac heater"]){
               cellHeight = 140;
            }
            else{
                cellHeight = 140;
                //deviceIcon = [UIImage imageNamed:@"EnergyDevice_custom.png"];
            }
            
        }
            break;
        case DeviceSensorType_WindowSensor:{
           cellHeight = 140;
        }
            break;
            
        default:
            break;
            
    }
   return  CGSizeMake((self.myDevicesCollectionView.frame.size.width - 10.0), cellHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self buttonActionDidSelect:nil];
}
#pragma mark - Button Action Methods
-(void)btnPowerOffAction:(UIButton*)sender {
    
    selectedIndex = sender.tag;
    DeviceInfo *deviceInfo = [self.array_deviceList objectAtIndex:selectedIndex];
    [self callApiForCircuitPowerOffForCircuit:deviceInfo.circuitID];
}

-(void)buttonActionDidSelect:(UIButton*)sender {
    DeviceInfo *deviceInfo = [self.array_deviceList objectAtIndex:sender.tag];
    [[AppUser sharedUser] setDevice:deviceInfo];
    DevicePageController *pageController = [[DevicePageController alloc] initWithNibName:@"DevicePageController" bundle:nil];
    [self.navigationController pushViewController:pageController animated:YES];
}

- (void)longPress:(UILongPressGestureRecognizer*)gesture {
    
    if (gesture.state == UIGestureRecognizerStateBegan) {

        selectedIndex = gesture.view.tag;
        DeviceInfo *device = [self.array_deviceList objectAtIndex:selectedIndex];
        MyDevicePopupViewController *confirmationPopup = [[MyDevicePopupViewController alloc] initWithNibName:@"MyDevicePopupViewController" bundle:nil];
        confirmationPopup.deviceInfo = device;
        [confirmationPopup setDelegate:self];
        [self presentPopupViewController:confirmationPopup animationType:MJPopupViewAnimationFade];
    }
}


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

#pragma mark - Service Helper Methods
-(ServiceHelper *)getAppEngine {
    
    if (!appWebEngine) appWebEngine = [[ServiceHelper alloc] init];
    
    [appWebEngine setServiceHelperDelegate:self];
    
    return appWebEngine;
}

-(void)callApiForBuildingList {
    
    NSString *selectedBuilding = [[NSUserDefaults standardUserDefaults] objectForKey:SELECTED_BUILDING_ID];
    if (selectedBuilding == nil) {
        [[self getAppEngine] callGetMethodWithData:[NSMutableDictionary dictionary] andMethodName:WebMethodType_BuildingList forPath:@"" andController:self.navigationController headerValue:loggedInUser.token authenticationValue:@"Bearer"];
    } else {
        [self callApiForCiruits];
    }
    
}

-(void)callApiForCiruits {
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    
    NSDate *currentDate = [NSDate date];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = [[NSCalendar currentCalendar] ordinalityOfUnit:(NSCalendarUnitDay) inUnit:(NSCalendarUnitEra) forDate:currentDate];
    NSDate *dayBegin = [[NSCalendar currentCalendar] dateFromComponents:components];
    NSTimeInterval timeInMiliseconds = [dayBegin timeIntervalSince1970];
    double toTS = [DateCommon convertTimeStampFromDate:[NSDate date]];
    double fromTS = [DateCommon convertTimeStampFromDate:dayBegin];
    
    [paramDict setValue:[NSNumber numberWithDouble:fromTS] forKey:@"fromTS"];
    [paramDict setValue:[NSNumber numberWithDouble:toTS] forKey:@"toTS"];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"token"] = loggedInUser.token;
    [[self getAppEngine] callGetMethodWithData:paramDict andMethodName:WebMethodType_EnergyDevicesOfBuilding forPath:[NSString stringWithFormat:@"%@/tree",loggedInUser.building.buildingID] andController:self.navigationController headerValue:loggedInUser.token authenticationValue:@"Bearer"];
}


-(void)callApiForCircuitPowerOffForCircuit:(NSString*)cID {
    
    [[self getAppEngine] callGetMethodWithData:[NSMutableDictionary dictionary] andMethodName:WebMethodType_CircuitPowerToggle forPath:[NSString stringWithFormat:@"%@/toggle",cID] andController:self.navigationController headerValue:loggedInUser.token authenticationValue:@"Bearer"];
}

-(void)callApiForUpdateDevice:(DeviceInfo*)deivce {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:deivce.name forKey:@"name"];
    [dict setValue:deivce.circuitSubtype forKey:@"circuitSubtype"];
    [[self getAppEngine] callPUTMethodWithData:dict andMethodName:WebMethodType_CircuitUpdate andController:self.navigationController withPath:[NSString stringWithFormat:@"%@?token=%@",deivce.circuitID,loggedInUser.token]];
}

#pragma mark - Service Helper Delegate methods

-(void)serviceResponse:(id)response andMethodName:(WebMethodType)methodName {
    
    switch (methodName) {
            
        case WebMethodType_BuildingList: {
            
            NSArray *buildingData = (NSArray*)response;
            
            BuildingResponse *obj = [[BuildingResponse alloc]initWithDictionary:[buildingData firstObject] error:nil];
            loggedInUser.building = obj; //[[BuildingInfo alloc] initWithAttributes:[buildingData firstObject]];
            [[NSUserDefaults standardUserDefaults]setObject:loggedInUser.building.buildingID forKey:SELECTED_BUILDING_ID];
            
            [self callApiForCiruits];
        }
            break;
            
        case WebMethodType_EnergyDevicesOfBuilding: {
            
            NSArray *energyDeviceData = (NSArray*)response;
            [self.array_deviceList removeAllObjects];
            for (NSDictionary *deviceItem in energyDeviceData)
                [self.array_deviceList addObject:[[DeviceInfo alloc] initWithAttributes:deviceItem]];
            
            NSSortDescriptor *sortDescriptor;
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"deviceTag"
                                                         ascending:YES];
            NSArray *sortedArray = [self.array_deviceList sortedArrayUsingDescriptors:@[sortDescriptor]];
            [self.array_deviceList removeAllObjects];
            [self.array_deviceList addObjectsFromArray:sortedArray];
            [self.myDevicesCollectionView reloadData];
        }
            break;
            
        case WebMethodType_CircuitUpdate: {
            
            
        }
            break;
            
        case WebMethodType_Alerts: {
            
            NSArray *arrayAlert = (NSArray*)response;
           
            [APPDELEGATE setAlertCount:((arrayAlert.count > 0) ? [NSString stringWithFormat:@"%ld",(long)arrayAlert.count] : nil)];
            [self.button_message setBadgeString:[APPDELEGATE alertCount]];
            [self.myDevicesCollectionView reloadData];
        }
            break;
            
        case WebMethodType_CircuitPowerToggle: {
            
            DeviceInfo *deviceInfo = [self.array_deviceList objectAtIndex:selectedIndex];
            deviceInfo.sensorStatus = [response objectForKey:@"status" expectedType:String];
            [self.myDevicesCollectionView reloadData];
            
            //log event
            //[[GAHelper instance] sendEventOfType:([deviceInfo.sensorStatus boolValue] ? LogType_DeviceListScreen_DevicePowerOn : LogType_DeviceListScreen_DevicePowerOff) forUser:[AppUser sharedUser]];
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

#pragma mark - MyDevicePopUpDelegate Method

-(void)devicePopUpShouldDismissWithName:(NSString*)name andSubtype:(NSString*)subtype {
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];

    if (name.length > 0) {
        
        DeviceInfo *device = [self.array_deviceList objectAtIndex:selectedIndex];
        device.name = name;
        device.circuitSubtype = subtype;
        device.UI_deviceName = (device.circuitSubtype.length > 0) ? [NSString stringWithFormat:@"%@ : %@",device.name,device.circuitSubtype] : device.name;

        [self.myDevicesCollectionView reloadData];
        
        [self callApiForUpdateDevice:device];
    }
}

@end
