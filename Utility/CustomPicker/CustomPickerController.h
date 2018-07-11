//
//  CustomPickerController.h
//  ElectricityVersion2
//
//  Created by Krishna Kant Kaira on 09/02/16.
//  Copyright © 2016 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PickerType) {

    PickerType_Date,
    PickerType_Default
};

typedef void(^CustomPickerCompletionBlock)(id selectedData);


@interface CustomPickerController : UIViewController

+(CustomPickerController*)instance;

-(void)showPicker : (PickerType)pickerType
         withData : (NSArray *)dataSourceData
     selectedData : (id)selectedData
       controller : (UIViewController*)controller
  completionBlock : (CustomPickerCompletionBlock)complitionBlock;

@end
