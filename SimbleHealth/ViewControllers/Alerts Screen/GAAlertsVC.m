//
//  GAAlertsVC.m
//  ElectricityApp
//
//  Created by Priyanka Singh on 07/12/15.
//  Copyright © 2015 Mobiloitte Inc. All rights reserved.
//

#import "GAAlertsVC.h"
#import "AlertItem.h"

@interface GAAlertsVC () <ServiceHelperDelegate> {
    
    ServiceHelper *appWebEngine;

    NSMutableArray *tempDataArray;
}

@property(strong,nonatomic) NSMutableArray *array_AlertData;

@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet MIBadgeButton *button_message;

- (IBAction)buttonAction_menu:(id)sender;

@end

@implementation GAAlertsVC

#pragma mark - View life Cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.array_AlertData = [NSMutableArray array];
    tempDataArray = [NSMutableArray array];
    
    [self.tableview registerNib:[UINib nibWithNibName:@"GAAlertsCell" bundle:nil] forCellReuseIdentifier:@"GAAlertsCellID"];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.button_message setBadgeEdgeInsets:UIEdgeInsetsMake(15.0, 0.0, 0.0, 10.0)];
    [self.button_message setBadgeString:[APPDELEGATE alertCount]];
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self callApiForAlerts];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[self getAppEngine] cancelRequestwithName:WebMethodType_Alerts];
}

-(void)dealloc {
    
    //remove the delegate on deallocation of the controller
    [appWebEngine setServiceHelperDelegate:nil];
    appWebEngine = nil;
}

#pragma mark UITableView datasource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array_AlertData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 84;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GAAlertsCell  *cell  = (GAAlertsCell *)[tableView dequeueReusableCellWithIdentifier:@"GAAlertsCellID"];
    [cell.buttonAction addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    AlertItem *objAlert =  [self.array_AlertData objectAtIndex:indexPath.row];
    if (self.array_AlertData.count) {
        
        cell.label_AlertNotification .text = [NSString stringWithFormat:@"%@\n%@",objAlert.circuitName, objAlert.alertDescription];
        cell.label_DaysAgo.text = objAlert.UI_agoTime;
        
        UIColor *color = [UIColor grayColor];

        if ([objAlert.status isEqualToString:@"1"]) {
            [cell.buttonBouncy setImage:[UIImage imageNamed:@"EmailNotification_open.png"] forState:UIControlStateNormal];
            cell.imageview_frwdIcon.image = [UIImage imageNamed:@"DisclosureIndicator_red.png"];
            color = [UIColor appRedColor];
        }
        else {
            [cell.buttonBouncy setImage:[UIImage imageNamed:@"EmailNotification_close"] forState:UIControlStateNormal];
            cell.imageview_frwdIcon.image = [UIImage imageNamed:@"DisclosureIndicator_gray.png"];
            color = [UIColor appGrayColor];
        }
        
        [cell.label_DaysAgo setTextColor:color];
        [cell.label_AlertNotification setTextColor:color];
        [cell.buttonAction setTitleColor:color forState:UIControlStateNormal];

        //set the coloration of tickets
        if ([objAlert.priority isEqualToString:@"0"]) {
            color = [UIColor appYellowColor];
        }
        else if ([objAlert.priority isEqualToString:@"1"]){
            color = [UIColor appOrangeColor];
        }
        else if ([objAlert.priority isEqualToString:@"2"]){
            color = [UIColor appRedColor];
        }
        
        [cell.view_Container setBackgroundColor:color];
    }
    
    return cell;
}

#pragma mark- Memory management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Buttons Action Methods

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

- (void)buttonAction:(UIButton *)sender {
    
    [[[UIAlertView alloc] initWithTitle:nil message:@"In progress." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

#pragma mark - Service Helper Methods
-(ServiceHelper *)getAppEngine {
    
    if (!appWebEngine) appWebEngine = [[ServiceHelper alloc] init];
    
    [appWebEngine setServiceHelperDelegate:self];
    return appWebEngine;
}

-(void)callApiForAlerts {
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [[self getAppEngine] callGetMethodWithData:paramDict andMethodName:WebMethodType_Alerts forPath:[NSString stringWithFormat:@"%@/alerts",[AppUser sharedUser].building.buildingID] andController:self.navigationController headerValue:[AppUser sharedUser].token authenticationValue:@"Bearer"];
}

#pragma mark - Service Helper Delegate methods

-(void)serviceResponse:(id)response andMethodName:(WebMethodType)methodName {
    
    switch (methodName) {
            
        case WebMethodType_Alerts: {
            
            [self.array_AlertData removeAllObjects];
            [tempDataArray removeAllObjects];
            [self.tableview reloadData];

            tempDataArray = [NSMutableArray arrayWithArray:response];
            
            [APPDELEGATE setAlertCount:((tempDataArray.count > 0) ? [NSString stringWithFormat:@"%lu",(unsigned long)tempDataArray.count] : nil)];
            [self.button_message setBadgeString:[APPDELEGATE alertCount]];
            
            [self addNewItemFrom:tempDataArray];
            
            //log event
            //[[GAHelper instance] sendEventOfType:LogType_AlertScreen forUser:[AppUser sharedUser]];
        }
            break;
            
        default:
            break;
    }
}

-(void)serviceError:(id)response andMethodName:(WebMethodType)methodName {

    NSString *message = [response objectForKey:@"errorMessage" expectedType:String];
    [[[UIAlertView alloc]initWithTitle:@"Sorry!" message:((message.length < 1) ? [response objectForKey:kLocalizedError] : message) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
}

-(void)addNewItemFrom:(NSArray*)dataArray {
    
    if (self.array_AlertData.count < dataArray.count) {
        [self.array_AlertData addObject:[[AlertItem alloc] initWithAttributes:[dataArray objectAtIndex:self.array_AlertData.count]]];
        
        [self.tableview insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:(self.array_AlertData.count-1) inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
        [self performSelector:@selector(addNewItemFrom:) withObject:dataArray afterDelay:0.35];
    }
}

@end
