//
//  MotionCell.h
//  ElectricityVersion2
//
//  Created by Nguyen Ba Linh on 5/17/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceInfo.h"

@interface MotionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblOffline;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_connectionState;
@property (weak, nonatomic) IBOutlet UILabel *label_DeviceName;
@property (weak, nonatomic) IBOutlet UIView *viewDeviceName;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_device;
@property (weak, nonatomic) IBOutlet UILabel *lblTemperature;
@property (weak, nonatomic) IBOutlet UIImageView *imvMotion;
@property (weak, nonatomic) IBOutlet UILabel *lblMotion;
@property (weak, nonatomic) IBOutlet UIButton *button_power;
@property (strong, nonatomic) IBOutlet UIImageView *imvLowBattery;


@property (weak, nonatomic) DeviceInfo *deviceInfo;
@property (weak, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) NSArray *array_deviceList;
@property (strong, nonatomic) IBOutlet UIView *viewLowBattery;
@property (strong, nonatomic) IBOutlet UILabel *lblLastStatus;

@end
