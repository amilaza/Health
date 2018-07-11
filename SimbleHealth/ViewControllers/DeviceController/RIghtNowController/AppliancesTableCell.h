//
//  AppliancesTableCell.h
//  ElectricityVersion2
//
//  Created by Krishna Kant Kaira on 04/02/16.
//  Copyright © 2016 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppliancesTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *label_applianceTitle;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView_appliance;
@property (strong, nonatomic) IBOutlet UILabel *label_percentage;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_progressViewTrailing;
@property (strong, nonatomic) IBOutlet UIView *view_progress;

@end
