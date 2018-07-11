//
//  BuildingsVC.m
//  ElectricityVersion2
//
//  Created by Nguyen Ba Linh on 9/11/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "BuildingsVC.h"
#import "BuildingCell.h"
#import "BuildingResponse.h"
#import "IBuildingView.h"
#import "BuildingPresenter.h"
#import "AppUser.h"
#import "Header.h"

@interface BuildingsVC ()
<UITableViewDelegate, UITableViewDataSource, IBuildingView> {
    
    IBOutlet UITableView *tbvBuilding;
    
    
    NSMutableArray *buildings;
    BuildingPresenter *preseneter;
    AppUser *loggedInUser;
    NSIndexPath *lastIndexPath;
    
}

@end

@implementation BuildingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self loadUIs];
    // Do any additional setup after loading the view from its nib.
}

- (void)loadData{
    buildings = [NSMutableArray new];
    preseneter = [BuildingPresenter new];
    preseneter.delegate = self;
    loggedInUser = [AppUser sharedUser];
    
    [self getListBuildings];
}

- (void)loadUIs{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getListBuildings{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"token"] = loggedInUser.token;
    [preseneter getListBuildingswithParam:params];
}
- (IBAction)touchMenu:(id)sender {
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

#pragma mark - TableView Delegate and Data Source  Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return buildings.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BuildingCell *cell = (BuildingCell *)[tableView dequeueReusableCellWithIdentifier:@"BuildingCell"];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BuildingCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    BuildingResponse *obj = [buildings objectAtIndex:indexPath.row];
    cell.buildingObj = obj;
    
    NSString *selectedBuilding = [[NSUserDefaults standardUserDefaults]objectForKey:SELECTED_BUILDING_ID];
    if ([obj.buildingID isEqualToString:selectedBuilding]) {
        lastIndexPath = indexPath;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BuildingResponse *obj = [buildings objectAtIndex:indexPath.row];
    loggedInUser.building = obj;
    [[NSUserDefaults standardUserDefaults]setObject:obj.buildingID forKey:SELECTED_BUILDING_ID];
    BuildingCell *oldCell = [tableView cellForRowAtIndexPath:lastIndexPath];
    oldCell.backgroundColor = [UIColor whiteColor];
    oldCell.accessoryType = UITableViewCellAccessoryNone;
    
    BuildingCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    newCell.backgroundColor = [UIColor lightGrayColor];
    newCell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    lastIndexPath = indexPath;
}


#pragma mark - IBuidlingView

- (void)getListBuildingsFail:(NSError *)error{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [[[UIAlertView alloc]initWithTitle:@"Sorry!" message:error.debugDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
}

- (void)getListBuildingsSuccess:(NSArray *)data {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [buildings removeAllObjects];
    [buildings addObjectsFromArray:data];
    [tbvBuilding reloadData];
}

@end
