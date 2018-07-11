//
//  SolarCell.h
//  ElectricityVersion2
//
//  Created by Nguyen Ba Linh on 5/16/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceInfo.h"

@interface SolarCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblOffline;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_connectionState;
@property (weak, nonatomic) IBOutlet UILabel *label_DeviceName;
@property (weak, nonatomic) IBOutlet UIView *viewDeviceName;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_device;
@property (weak, nonatomic) IBOutlet UILabel *lblEnergy;
@property (weak, nonatomic) IBOutlet UILabel *lblOutput;
@property (weak, nonatomic) IBOutlet UIView *viewOutput;
@property (weak, nonatomic) IBOutlet UIButton *button_power;
@property (weak, nonatomic) IBOutlet UILabel *lblRightNow;



@property (weak, nonatomic) DeviceInfo *deviceInfo;
@property (weak, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) NSArray *array_deviceList;
@end
