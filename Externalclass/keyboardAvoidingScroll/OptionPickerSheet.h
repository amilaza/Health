
//
//  OptionPickerSheet.h
//  mColleagues
//
//  Created by Sunil Verma on 24/06/13.
//  Copyright (c) 2013 Halosys. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OptionPickerSheet;
@protocol OptionPickerSheetDelegate
@optional
/**
 * OptionPickerSheet delegate method fire when need selected picker data
 */
- (void)pickerSheet:(OptionPickerSheet*)pickerSheet didSelectOption:(NSString*)selectedValue;
/**
 * OptionPickerSheet delegate method fire when need selected picker index
 */
- (void)pickerSheet:(OptionPickerSheet*)pickerSheet didSelectIndex:(NSInteger)index;
@end


@protocol OptionPickerSheetDatasource
@optional
/**
 * OptionPickerSheet datasource method return number options in picker
 */
- (NSInteger)numberOfOptionsInPickerSheet:(OptionPickerSheet*)pickerSheet;

/**
 * OptionPickerSheet datasource method return options in picker
 */

- (NSString*)pickerSheet:(OptionPickerSheet*)pickerSheet optionForIndex:(NSInteger)index;
@end

@interface OptionPickerSheet : UIActionSheet<UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate>{
    id <OptionPickerSheetDelegate> odelegate;
    id <OptionPickerSheetDatasource> odatasource;
    NSArray  *pickerOptions;
    UIPickerView *picker;
    NSInteger   currentPick;
}
@property (nonatomic, assign) id <OptionPickerSheetDelegate> odelegate;
@property (nonatomic, assign) id <OptionPickerSheetDatasource> odatasource;
@property (nonatomic, readwrite) NSInteger   currentPick;
- (void)showPickerSheetWithOptions:(NSArray*)options;
//- (void)show;
- (void)showPickerSheetWithOptions:(NSArray*)options title:(NSString*)title;
- (void)showWithTitle:(NSString*)title ;
@end
