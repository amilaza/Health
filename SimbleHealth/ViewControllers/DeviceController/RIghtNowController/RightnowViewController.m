//
//  RightnowViewController.m
//  ElectricityVersion2
//
//  Created by Krishna Kant Kaira on 04/02/16.
//  Copyright © 2016 Mobiloitte Inc. All rights reserved.
//

#import "RightnowViewController.h"
#import "LMGaugeView.h"
#import "ServiceHelper.h"
#import "AppliancesTableCell.h"
#import "FlickerImageView.h"

#define kMaxNumberOfAppliances 4

@interface RightnowViewController () <UITableViewDataSource, UITableViewDelegate, ServiceHelperDelegate> {
    
    ServiceHelper *appWebEngine;
    NSTimer *timer_refreshData;
    AppUser *loggedInUser;
    double totalEnergy;
    NSArray *array_color;
}

@property (nonatomic, strong) NSMutableArray *array_eneryDevices;

@property (strong, nonatomic) IBOutlet UITableView *tableView_appliances;
@property (strong, nonatomic) IBOutlet LMGaugeView *gaugeView_device;
@property (strong, nonatomic) IBOutlet UIImageView *imageView_onlineState;
@property (strong, nonatomic) IBOutlet UIButton *button_onlineState;
@property (strong, nonatomic) IBOutlet UIImageView *imageView_sensorStatus;
@property (strong, nonatomic) IBOutlet UIButton *button_sensorStatus;
@property (strong, nonatomic) IBOutlet UIView *viewBattery;
@property (strong, nonatomic) IBOutlet FlickerImageView *imvBattery;
@property (strong, nonatomic) IBOutlet UILabel *lblBattery;

- (IBAction)buttonAction_online:(UIButton *)sender;
- (IBAction)buttonAction_sensorStatus:(UIButton *)sender;

@end

@implementation RightnowViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupLoad];
    _viewBattery.hidden = YES;
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.tableView_appliances setContentOffset:CGPointZero];
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if ([timer_refreshData isValid]) [timer_refreshData invalidate];
    timer_refreshData = nil;
    timer_refreshData =  [NSTimer scheduledTimerWithTimeInterval:kRefreshTimeInterval target:self selector:@selector(callApiForLiveEnergyData) userInfo:nil repeats:YES];

    //refresh Data
    [self callApiForLiveEnergyData];
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
    
    if ([timer_refreshData isValid]) [timer_refreshData invalidate];
    timer_refreshData = nil;
    
    //remove the delegate on deallocation of the controller
    [appWebEngine setServiceHelperDelegate:nil];
    appWebEngine = nil;
}

#pragma mark - Other Helper Methods
-(void)setupLoad {
    
    loggedInUser = [AppUser sharedUser];
    self.array_eneryDevices = [NSMutableArray array];
    totalEnergy = 0.0;
    
    array_color = [NSArray arrayWithObjects:[UIColor appOrangeColor], [UIColor appRedColor], [UIColor appGreenColor], [UIColor appPurpleColor], [UIColor appBlueColor], nil];

    [self.tableView_appliances registerClass:[AppliancesTableCell class] forCellReuseIdentifier:@"AppliancesTableCellID"];
    [self.tableView_appliances registerNib:[UINib nibWithNibName:@"AppliancesTableCell" bundle:nil] forCellReuseIdentifier:@"AppliancesTableCellID"];

    [self.tableView_appliances setDelegate:self];
    [self.tableView_appliances setDataSource:self];
    
    self.gaugeView_device.showLimitDot = NO;
    self.gaugeView_device.ringThickness = 25.0f;

    self.gaugeView_device.numOfDivisions = 1;
    self.gaugeView_device.divisionsColor = [UIColor clearColor];
    self.gaugeView_device.numOfSubDivisions = 0;
    self.gaugeView_device.subDivisionsColor = [UIColor clearColor];
    [self.gaugeView_device setValueTextColor:[UIColor appOrangeColor]];
    self.gaugeView_device.minValue = 0.0f;

    self.gaugeView_device.ringBackgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
    [self.gaugeView_device setValueFont:[UIFont fontWithName:@"Roboto-Light" size:12.0]];
    [self.gaugeView_device setUnitOfMeasurementFont:[UIFont fontWithName:@"Roboto-Regular" size:16.0]];
    
    [self refreshGraphData];
    [self renderRefreshedDataOnUI];
    
//    [self callApiForLiveEnergyData];
}

-(void)refreshGraphData {
    
    self.gaugeView_device.maxValue = [loggedInUser.device.maxThreshold doubleValue];
    
    if ([[loggedInUser.device online] boolValue]) {
        //online
        
        [self.gaugeView_device setValueTextColor:[UIColor appOrangeColor]];
        self.gaugeView_device.value = [loggedInUser.device.realEnergy doubleValue];
        
        [self.gaugeView_device setUnitOfMeasurement:[NSString stringWithFormat:@"%.0f / %.0f %@",[loggedInUser.device.realEnergy doubleValue],[loggedInUser.device.maxThreshold doubleValue],loggedInUser.device.unit]];
        [self.gaugeView_device setCustomValueText:[NSString stringWithFormat:@"$ %0.2f\nPER DAY",[loggedInUser.device.dailyCost doubleValue]]];
    }
    else {
        //offline
        
        self.gaugeView_device.value = 0.0;
        
        [self.gaugeView_device setValueTextColor:[UIColor grayColor]];
        [self.gaugeView_device setCustomValueText:[NSString stringWithFormat:@"$ %0.2f\nPER DAY",[loggedInUser.device.dailyCost doubleValue]]];
        [self.gaugeView_device setUnitOfMeasurement:[NSString stringWithFormat:@"- / %.0f %@",[loggedInUser.device.maxThreshold doubleValue],loggedInUser.device.unit]];
    }
}

- (void)setSensorBatteryStatus:(DeviceInfo *)deviceInfo {
    if ([deviceInfo.battery boolValue] == NO) {
        _imvBattery.image = [UIImage imageNamed:@"ic_battery_good"];
        _lblBattery.textColor = BATTERY_GOOD_COLOR;
        _lblBattery.text = @"battery: good";
    } else {
        _imvBattery.image = [UIImage imageNamed:@"ic_low_battery"];
        _lblBattery.textColor = BATTERY_LOW_COLOR;
        _lblBattery.text = @"battery: low";
    }
}

- (void)setSmartPlugStatus:(DeviceInfo *)deviceInfo {
    self.imageView_sensorStatus.hidden = NO;
    self.button_sensorStatus.hidden = NO;
    
    if ([deviceInfo.online boolValue] == YES) {
        _button_sensorStatus.enabled = YES;
        if ([deviceInfo.sensorStatus boolValue]) {
            self.imageView_sensorStatus.image = [UIImage imageNamed:@"Power_on.png"];
            [self.button_sensorStatus setTitle:@"Power On" forState:UIControlStateNormal];
        }
        else {
            self.imageView_sensorStatus.image = [UIImage imageNamed:@"Power_off.png"];
            [self.button_sensorStatus setTitle:@"Power Off" forState:UIControlStateNormal];
        }
    }
    else {
        self.imageView_sensorStatus.image = [UIImage imageNamed:@"Power_off.png"];
        [self.button_sensorStatus setTitle:@"Power Off" forState:UIControlStateNormal];
        _button_sensorStatus.enabled = NO;
    }
}

-(void)renderRefreshedDataOnUI {
    
    DeviceInfo *deviceInfo = loggedInUser.device;
    
    if ([deviceInfo.online boolValue]) {
        self.imageView_onlineState.image = [UIImage imageNamed:@"Wifi_open.png"];
        [self.button_onlineState setTitle:@"Online" forState:UIControlStateNormal];
    }
    else {
        self.imageView_onlineState.image = [UIImage imageNamed:@"Wifi_close.png"];
        [self.button_onlineState setTitle:@"Offline" forState:UIControlStateNormal];
    }
    if (deviceInfo.deviceSensorType == DeviceSensorType_PulseReader) {
        [self setSensorBatteryStatus:deviceInfo];
    }
    
    if (deviceInfo.deviceSensorType == DeviceSensorType_SmartPlug){
        [self setSmartPlugStatus:deviceInfo];
    } else {
        self.imageView_sensorStatus.hidden = YES;
        self.button_sensorStatus.hidden = YES;
    }
    
    [self.tableView_appliances reloadData];
}

#pragma mark - IBAction
- (IBAction)buttonAction_sensorStatus:(UIButton *)sender {
    
    [self callApiToTogglePowerStatus];
}

- (IBAction)buttonAction_online:(UIButton *)sender {
    
}

#pragma mark - TableView Delegate and Data Source  Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger rowsCount = 0;
    
    DeviceInfo *deviceInfo = loggedInUser.device;
    if ((deviceInfo.deviceSensorType == DeviceSensorType_SmartPlug) && [deviceInfo.online boolValue]) {
        rowsCount = self.array_eneryDevices.count;
    }
    
    return rowsCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AppliancesTableCell *appliancesCell = (AppliancesTableCell *)[tableView dequeueReusableCellWithIdentifier:@"AppliancesTableCellID" forIndexPath:indexPath];
    [appliancesCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    appliancesCell.backgroundColor = [UIColor clearColor];
    appliancesCell.contentView.backgroundColor = [UIColor clearColor];
    UIColor *color = [array_color objectAtIndex:(indexPath.row%array_color.count)];
    appliancesCell.label_applianceTitle.textColor = color;
    appliancesCell.label_percentage.textColor = color;
    appliancesCell.view_progress.backgroundColor = color;
    
    appliancesCell.constraint_progressViewTrailing.constant = 0.0;
    [appliancesCell.contentView layoutIfNeeded];
    
    DeviceInfo *device = [self.array_eneryDevices objectAtIndex:indexPath.row];
    appliancesCell.label_applianceTitle.text = device.name;
    appliancesCell.label_percentage.text = [NSString stringWithFormat:@"%.0f%%",[device.energyConsumptionPercentage doubleValue]];
    appliancesCell.progressView_appliance.progress = ([device.energyConsumptionPercentage doubleValue] / 100.0);

    appliancesCell.constraint_progressViewTrailing.constant = (appliancesCell.view_progress.bounds.size.width - ((appliancesCell.view_progress.bounds.size.width / 100.0) * [device.energyConsumptionPercentage doubleValue])) * (-1);
    [appliancesCell.contentView layoutIfNeeded];
    
    return appliancesCell;
}

#pragma mark - Service Helper Methods
-(ServiceHelper *)getAppEngine {
    
    if (!appWebEngine) appWebEngine = [[ServiceHelper alloc] init];
    
    [appWebEngine setServiceHelperDelegate:self];
    
    return appWebEngine;
}

-(void)callApiForLiveEnergyData {
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"token"] = loggedInUser.token;
    //[[self getAppEngine] callGetMethodWithData:params andMethodName:WebMethodType_EnergyRealTimeCircuits forPath:[NSString stringWithFormat:@"%@", loggedInUser.device.circuitID] andController:[APPDELEGATE navController] headerValue:loggedInUser.token authenticationValue:@"Bearer"];
    [[self getAppEngine] callGetMethodWithData:params andMethodName:WebMethodType_LiveEnergy forPath:[NSString stringWithFormat:@"%@/tree",loggedInUser.building.buildingID] andController:[APPDELEGATE navController] headerValue:loggedInUser.token authenticationValue:@"Bearer"];
}

-(void)callApiToTogglePowerStatus {
    
    [[self getAppEngine] callGetMethodWithData:[NSMutableDictionary dictionary] andMethodName:WebMethodType_CircuitPowerToggle forPath:[NSString stringWithFormat:@"%@/toggle",loggedInUser.device.circuitID] andController:[APPDELEGATE navController] headerValue:loggedInUser.token authenticationValue:@"Bearer"];
}

#pragma mark - Service Helper Delegate methods
-(void)serviceResponse:(id)response andMethodName:(WebMethodType)methodName {
    
    switch (methodName) {
            
        case WebMethodType_LiveEnergy: {
            
            NSArray *tempData = (NSArray*)response;
            [self.array_eneryDevices removeAllObjects];

            BOOL isCurrentDeviceFound = NO;
            totalEnergy = 0.0;
            NSInteger extraAppliances = 0;
            double totalEnergyForOtherAppliances = 0.0;
            for (NSInteger index = 0; index < tempData.count; index++) {
                
                NSDictionary *dict = [tempData objectAtIndex:index];
                if([dict objectForKey:@"online" expectedType:String] && ([[dict objectForKey:@"sensorType" expectedType:String] isEqualToString:@"SMARTPLUG"] || [[dict objectForKey:@"sensorType" expectedType:String] isEqualToString:@"PULSEREADER"])) {
                    
                    if (self.array_eneryDevices.count >= kMaxNumberOfAppliances) {
                        
                        totalEnergyForOtherAppliances += [[dict objectForKey:@"realEnergy" expectedType:String] doubleValue];
                        totalEnergy += [[dict objectForKey:@"realEnergy" expectedType:String] doubleValue];
                        extraAppliances++;
                    }
                    else {
                        
                        DeviceInfo *device = [[DeviceInfo alloc] initWithLiveEnergyAttributes:dict];
                        totalEnergy += [device.realEnergy doubleValue];
                        [self.array_eneryDevices addObject:device];
                    }
                }
                
                if((isCurrentDeviceFound == NO) && [loggedInUser.device.circuitID isEqualToString:[dict objectForKey:@"circuitID"]]) {
                    
                    [loggedInUser.device updateForLiveEnergyAttribute:dict];
                    isCurrentDeviceFound = YES;
                }
            }
            if (extraAppliances > 0) {
                
                DeviceInfo *otherDevice = [[DeviceInfo alloc] init];
                otherDevice.name = [NSString stringWithFormat:@"Other [%ld]",(long)extraAppliances];
                otherDevice.realEnergy = [NSString stringWithFormat:@"%f",totalEnergyForOtherAppliances];
                [self.array_eneryDevices addObject:otherDevice];
            }
            
            for (int index = 0; index < self.array_eneryDevices.count; index++) {
                
                DeviceInfo *device = [self.array_eneryDevices objectAtIndex:index];
                
                if (totalEnergy != 0.0) {
                    double percentage = (([device.realEnergy doubleValue] * 100.0) / totalEnergy);
                    device.energyConsumptionPercentage = [NSString stringWithFormat:@"%f",percentage];
                }
                else
                    device.energyConsumptionPercentage = @"0.0";
            }
            
            [self.array_eneryDevices sortUsingComparator:^NSComparisonResult(DeviceInfo* obj1, DeviceInfo* obj2) {
                return [obj2.energyConsumptionPercentage compare:obj1.energyConsumptionPercentage options:NSNumericSearch];
            }];

            [self refreshGraphData];
            
            //log event
            //[[GAHelper instance] sendEventOfType:LogType_RightNowScreen forUser:loggedInUser];
        }
            break;
            
        case WebMethodType_CircuitPowerToggle: {
            
            loggedInUser.device.sensorStatus = [response objectForKey:@"status" expectedType:String];
            
            //log event
            //[[GAHelper instance] sendEventOfType:([loggedInUser.device.sensorStatus boolValue] ? LogType_RightNowScreen_DevicePowerOn : LogType_RightNowScreen_DevicePowerOff) forUser:loggedInUser];
        }
            break;
            
        default: break;
    }
    
    [self renderRefreshedDataOnUI];
}

-(void)serviceError:(id)response andMethodName:(WebMethodType)methodName {
    
    NSString *message = [response objectForKey:@"errorMessage" expectedType:String];
    [[[UIAlertView alloc]initWithTitle:@"Sorry!" message:((message.length < 1) ? [response objectForKey:kLocalizedError] : message) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
}

@end
