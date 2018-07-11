//
//  GAContactUs.m
//  ElectricityApp
//
//  Created by Priyanka Singh on 07/12/15.
//  Copyright © 2015 Mobiloitte Inc. All rights reserved.
//

#import "GAContactUs.h"
#import "Header.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface GAContactUs () <UITextViewDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITextView *textView_contactMessage;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_textViewBottomMargin;
@property (strong, nonatomic) IBOutlet MIBadgeButton *button_message;

- (IBAction)buttonAction_menu:(id)sender;
- (IBAction)buttonAction_alert:(UIButton *)sender;
- (IBAction)buttonAction_thankYou:(UIButton *)sender;

@end

@implementation GAContactUs

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.textView_contactMessage setDelegate:self];
}

-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    [self.button_message setBadgeEdgeInsets:UIEdgeInsetsMake(15.0, 0.0, 0.0, 10.0)];
    [self.button_message setBadgeString:[APPDELEGATE alertCount]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITextViewDelegate methods
- (void)textViewDidBeginEditing:(UITextView *)textView {

    self.constraint_textViewBottomMargin.constant = 255.0;
    [UIView animateWithDuration:0.3 animations:^{ [self.view layoutIfNeeded]; }];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    self.constraint_textViewBottomMargin.constant = 95.0;
    [UIView animateWithDuration:0.3 animations:^{ [self.view layoutIfNeeded]; }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    else {
        return YES;
    }
}
#pragma mark - IBAction

- (IBAction)buttonAction_alert:(UIButton *)sender {
    
    UIViewController *alertVC = nil;
    for (NSInteger index = (self.navigationController.viewControllers.count-1); index >= 0; index--) {
        UIViewController *controller = [[self.navigationController viewControllers] objectAtIndex:index];
        if ([controller isKindOfClass:[GAAlertsVC class]]) {
            alertVC = controller;
            break;
        }
    }
    
    if (alertVC) {
        [self.navigationController popToViewController:alertVC animated:YES];
    }
    else {
        [self.navigationController pushViewController:[[GAAlertsVC alloc] initWithNibName:@"GAAlertsVC" bundle:nil] animated:YES];
    }
}

- (IBAction)buttonAction_menu:(id)sender {
    
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

- (IBAction)buttonAction_thankYou:(UIButton *)sender {
    
    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:@"Feedback"];
        [mc setMessageBody:self.textView_contactMessage.text isHTML:NO];
        [mc setToRecipients:[NSArray arrayWithObject:@"support@acresta.com"]];
        [self presentViewController:mc animated:YES completion:NULL];
    }
    else
        [[[UIAlertView alloc]initWithTitle:nil message:@"Please check device settings, Your mail is not configured correctly." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
}

#pragma mark - Mail Composer delegates
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
