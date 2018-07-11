//
//  GAAlertsCell.h
//  ElectricityApp
//
//  Created by Priyanka Singh on 07/12/15.
//  Copyright © 2015 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSBouncyButton.h"

@interface GAAlertsCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *view_Container;
@property (strong, nonatomic) IBOutlet UIView *view_Internal;
@property (strong, nonatomic) IBOutlet UILabel *label_DaysAgo;
@property (strong, nonatomic) IBOutlet UILabel *label_AlertNotification;
@property (strong, nonatomic) IBOutlet UIButton *buttonAction;
@property (strong, nonatomic) IBOutlet UIImageView *imageview_frwdIcon;
@property (strong, nonatomic) IBOutlet SSBouncyButton *buttonBouncy;

@end
