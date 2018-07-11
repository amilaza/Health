//
//  GAMyDeviceCell.h
//  ElectricityVersion2
//
//  Created by Mohit Kumar on 12/7/15.
//  Copyright © 2015 Mobiloitte Inc. All rights reserved.
//

#import "Header.h"
#import "DeviceInfo.h"
@interface GAMyDeviceCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageView_device;
//@property (strong, nonatomic) IBOutlet UIImageView *imageView_power;
@property (strong, nonatomic) IBOutlet UIImageView *imageView_connectionState;
@property (strong, nonatomic) IBOutlet UIButton *button_power;
@property (strong, nonatomic) IBOutlet UILabel *label_DeviceName;
@property (weak, nonatomic) IBOutlet UIView *viewDeviceName;
@property (weak, nonatomic) IBOutlet UILabel *lblOffline;
@property (weak, nonatomic) IBOutlet UILabel *lblEnergy;
@property (weak, nonatomic) IBOutlet UILabel *lblMoneyUnderbudget;
@property (weak, nonatomic) IBOutlet UILabel *lblPersentBudget;
@property (strong, nonatomic) IBOutlet UIView *viewLowBattery;


@property (weak, nonatomic) DeviceInfo *deviceInfo;
@property (weak, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) NSArray *array_deviceList;
@end
