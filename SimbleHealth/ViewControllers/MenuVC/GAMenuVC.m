//
//  GAMenuVC.m
//  ElectricityVersion2
//
//  Created by Mohit Kumar on 12/7/15.
//  Copyright © 2015 Mobiloitte Inc. All rights reserved.
//

#import "GAMenuVC.h"
#import "GAPreferencesVC.h"
#import "BuildingsVC.h"

@interface GAMenuVC () <UITableViewDataSource, UITableViewDelegate> {
    
    NSMutableArray *menuItemsArray,*menuImagesArray;
}

@property (strong, nonatomic) IBOutlet UITableView *menuTblView;

@end

@implementation GAMenuVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setUpLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setUpLoad {
    
//    menuItemsArray = [[NSMutableArray alloc] initWithObjects:@"My Devices",@"Alerts",@"Preferences",@"Contact Us",@"Logout", nil];
//    menuImagesArray = [[NSMutableArray alloc] initWithObjects:@"menue_wifi",@"bell",@"setting",@"chat",@"lock2", nil];
    
    menuItemsArray = [[NSMutableArray alloc] initWithObjects:@"My Devices",@"Preferences", @"Building", @"Contact Us",@"Logout", nil];
    menuImagesArray = [[NSMutableArray alloc] initWithObjects:@"menue_wifi", @"setting", @"ic_buildings", @"chat",@"lock2", nil];
    
    [self.menuTblView reloadData];
}

#pragma mark - TableView Delegate and Data Source  Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return menuItemsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GAMenuCell *cell = (GAMenuCell *)[tableView dequeueReusableCellWithIdentifier:@"GAMenuCell"];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GAMenuCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    cell.imgMenu.image = [UIImage imageNamed:[menuImagesArray objectAtIndex:indexPath.row]];
    cell.lblMenuName.text = [menuItemsArray objectAtIndex:indexPath.row];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
            
        case 0: {
            
            UIViewController *controller_temp = nil;
            for (NSInteger index = (self.navigationController.viewControllers.count-1); index >= 0; index--) {
                UIViewController *controller = [[self.navigationController viewControllers] objectAtIndex:index];
                if ([controller isKindOfClass:[GAMyDevicesVC class]]) {
                    controller_temp = controller;
                    break;
                }
            }
            
            if (controller_temp) {
                [self.navigationController popToViewController:controller_temp animated:YES];
            }
            else {
                [self.navigationController pushViewController:[[GAMyDevicesVC alloc] initWithNibName:@"GAMyDevicesVC" bundle:nil] animated:YES];
            }
            
        }
            break;
            
        case 1: {
            UIViewController *controller_temp = nil;
            for (NSInteger index = (self.navigationController.viewControllers.count-1); index >= 0; index--) {
                UIViewController *controller = [[self.navigationController viewControllers] objectAtIndex:index];
                if ([controller isKindOfClass:[GAPreferencesVC class]]) {
                    controller_temp = controller;
                    break;
                }
            }
            
            if (controller_temp) {
                [self.navigationController popToViewController:controller_temp animated:YES];
            }
            else {
                [self.navigationController pushViewController:[[GAPreferencesVC alloc] initWithNibName:@"GAPreferencesVC" bundle:nil] animated:YES];
            }
        }
            break;
            
        case 2: {
            UIViewController *controller_temp = nil;
            for (NSInteger index = (self.navigationController.viewControllers.count-1); index >= 0; index--) {
                UIViewController *controller = [[self.navigationController viewControllers] objectAtIndex:index];
                if ([controller isKindOfClass:[BuildingsVC class]]) {
                    controller_temp = controller;
                    break;
                }
            }
            
            if (controller_temp) {
                [self.navigationController popToViewController:controller_temp animated:YES];
            }
            else {
                [self.navigationController pushViewController:[[BuildingsVC alloc] initWithNibName:@"BuildingsVC" bundle:nil] animated:YES];
            }
        }
            break;
            
        case 3: {
            UIViewController *controller_temp = nil;
            for (NSInteger index = (self.navigationController.viewControllers.count-1); index >= 0; index--) {
                UIViewController *controller = [[self.navigationController viewControllers] objectAtIndex:index];
                if ([controller isKindOfClass:[GAContactUs class]]) {
                    controller_temp = controller;
                    break;
                }
            }
            
            if (controller_temp) {
                [self.navigationController popToViewController:controller_temp animated:YES];
            }
            else {
                [self.navigationController pushViewController:[[GAContactUs alloc] initWithNibName:@"GAContactUs" bundle:nil] animated:YES];
            }
        }
            break;
            
        case 4: {
            //log event
//            [[GAHelper instance] sendEventOfType:LogType_Logout forUser:[AppUser sharedUser]];
            
            //clear all shared values stored
            [[AppUser sharedUser] userLoggedOut];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Button Action Method
- (IBAction)closeBtnAction:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

@end
