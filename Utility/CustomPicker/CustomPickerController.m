//
//  CustomPickerController.m
//  ElectricityVersion2
//
//  Created by Krishna Kant Kaira on 09/02/16.
//  Copyright © 2016 Mobiloitte Inc. All rights reserved.
//

#import "CustomPickerController.h"
#import "AppDelegate.h"

#define kAnimationDuration 0.27
#define kBackgroundColor [[UIColor blackColor] colorWithAlphaComponent:0.5]

@interface CustomPickerController () <UIPickerViewDataSource, UIPickerViewDelegate> {
    UIView *view_container;
}

@property (nonatomic, strong) IBOutlet UIDatePicker * datePicker;
@property (nonatomic, strong) IBOutlet UIPickerView * pickerView;

@property (nonatomic, strong) NSArray *array_dataSource;
@property (nonatomic, assign) PickerType pickerType;

- (IBAction)buttonAction_common:(UIBarButtonItem *)sender;

@property (nonatomic, copy) CustomPickerCompletionBlock completionBlock;

@end

@implementation CustomPickerController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+(CustomPickerController*)instance {
    
    static CustomPickerController *sharedInstance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance loadViewIfNeeded];
    });
    
    return sharedInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.maximumDate = [NSDate date];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view setBackgroundColor:[UIColor clearColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)showPicker : (PickerType)pickerType
         withData : (NSArray *)dataSourceData
     selectedData : (id)selectedData
       controller : (UIViewController*)controller
  completionBlock : (CustomPickerCompletionBlock)complitionBlock {
    
    self.array_dataSource = dataSourceData;
    self.pickerType = pickerType;
    if (complitionBlock) self.completionBlock = complitionBlock;

    switch (pickerType) {
            
        case PickerType_Date: {
            
            [self.datePicker setHidden:NO];
            [self.pickerView setHidden:YES];
            NSDate *date = (NSDate*)selectedData;
            if (!date || ![date isKindOfClass:[NSDate class]]) date = [NSDate date];
            [self.datePicker setDate:date];
        }
            break;
            
        case PickerType_Default: {
            
            [self.datePicker setHidden:YES];
            [self.pickerView setHidden:NO];
            [self.pickerView setDataSource:self];
            [self.pickerView setDelegate:self];
            NSInteger index = [self.array_dataSource indexOfObject:selectedData];
            if (index != NSNotFound) [self.pickerView selectRow:index inComponent:0 animated:YES];
            [self.pickerView reloadAllComponents];
        }
            break;
            
        default: {
            
            [self.datePicker setHidden:YES];
            [self.pickerView setHidden:YES];
            self.completionBlock(nil);
            return;
        }
            break;
    }

    if (controller == nil) {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        controller = appDelegate.navController;
    }
    
    view_container = [[UIView alloc] initWithFrame:controller.view.bounds];
    view_container.backgroundColor = [UIColor clearColor];
    [controller.view addSubview:view_container];
    
    [controller addChildViewController:self];
    
    CGRect viewFrame = view_container.bounds;
    viewFrame.origin.y = viewFrame.size.height;
    [self.view setFrame:viewFrame];
    [view_container addSubview:self.view];
    [controller.view setNeedsLayout];
    [self.view setNeedsLayout];
    
    [self didMoveToParentViewController:controller];
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        [self.view setFrame:view_container.bounds];
        view_container.backgroundColor = kBackgroundColor;
    }];
}

-(IBAction)buttonAction_common:(UIBarButtonItem *)sender {
    
    id selectedData = nil;
    
    if ([sender tag] == 555) {
        
        switch (self.pickerType) {
                
            case PickerType_Date:
                selectedData = [self.datePicker date];
                break;
                
            case PickerType_Default:
                selectedData = [self.array_dataSource objectAtIndex:[self.pickerView selectedRowInComponent:0]];
                break;
                
            default: break;
        }
    }
    
    [self dismissPopupWithData:selectedData];
}

- (IBAction)buttonAction_backgroundTap:(UIButton *)sender {
    
    [self dismissPopupWithData:nil];
}

-(void)dismissPopupWithData:(id)selectedData {
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        
        CGRect viewFrame = view_container.bounds;
        viewFrame.origin.y = viewFrame.size.height;
        [self.view setFrame:viewFrame];
        
        view_container.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        
        self.completionBlock(selectedData);
        
        for (UIView *subview in view_container.subviews)
            [subview removeFromSuperview];
        
        [view_container removeFromSuperview];
        
        [self removeFromParentViewController];
    }];
}

#pragma mark - UIPickerViewDataSource Methods

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.array_dataSource count];
}

#pragma mark - UIPickerViewDelegate Methods

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40.0;
}

// these methods return either a plain NSString, a NSAttributedString, or a view (e.g UILabel) to display the row for the component.
// for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
// If you return back a different object, the old one will be released. the view will be centered in the row rect
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.array_dataSource objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
}

@end
