//
//  NIDropDown.m
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import "NIDropDown.h"
#import "QuartzCore/QuartzCore.h"
static UIView *view;
@interface NIDropDown ()
@property(nonatomic, strong) UITableView *table;
@property(nonatomic, strong) UIButton *btnSender;
//@property(nonatomic, strong) UIView *btnSender;
@property(nonatomic, strong) UITextField *txtfld;

@property(nonatomic, retain) NSArray *list;
@property(nonatomic, retain) NSArray *imageList;
@end

@implementation NIDropDown
@synthesize table;
@synthesize btnSender;
@synthesize list;
@synthesize imageList;
@synthesize delegate;
@synthesize animationDirection;

-(id)showDropDownWithTxt:(UITextField *)txt :(CGFloat)height :(NSArray *)arr :(NSString *)direction{
    _txtfld = txt;
    animationDirection = direction;
    
    if (self) {
        
        // Initialization code
        CGRect btn = txt.frame;
        self.list = [NSArray arrayWithArray:arr];
        if ([direction isEqualToString:@"up"]) {
            
            self.frame = CGRectMake(btn.origin.x, btn.origin.y, btn.size.width, 0);
            self.layer.shadowOffset = CGSizeMake(-5, -5);
        }
        else if ([direction isEqualToString:@"down"]) {
            
            self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, 0);
            self.layer.shadowOffset = CGSizeMake(-5, 5);
        }
        
        table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, btn.size.width, 0)];
        table.delegate = self;
        table.dataSource = self;
        [table setScrollEnabled:YES];
        
        table.backgroundColor = [UIColor redColor];
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        if ([direction isEqualToString:@"up"]) {
            
            self.frame = CGRectMake(btn.origin.x, btn.origin.y-height, btn.size.width, height);
        } else if([direction isEqualToString:@"down"]) {
            
            self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, height);
        }
        
        table.frame = CGRectMake(0, 0, btn.size.width, height);
        
        [table setUserInteractionEnabled:YES];
        [self setUserInteractionEnabled:YES];
        [UIView commitAnimations];
        [txt.superview addSubview:self];
        [self addSubview:table];
    }
    
    return self;
}

-(id)showDropDownWith:(UIView *)b :(UIButton *)sender :(CGFloat)height :(NSArray *)arr :(NSString *)direction {
    
    view=b;
    btnSender = sender;
    animationDirection = direction;
  
    if (self) {
        
        // Initialization code
        CGRect btn = b.frame;
        self.list = [NSArray arrayWithArray:arr];
        if ([direction isEqualToString:@"up"]) {
            
            self.frame = CGRectMake(btn.origin.x, btn.origin.y, btn.size.width, (self.list.count)*35);
            self.layer.shadowOffset = CGSizeMake(-5, -5);
        }
        else if ([direction isEqualToString:@"down"]) {
            
            self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, (self.list.count)*35);
            self.layer.shadowOffset = CGSizeMake(-5, 5);
        }
        
        table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, btn.size.width, (self.list.count)*35)];
        table.delegate = self;
        table.dataSource = self;
//        [table setContentOffset:table.contentOffset animated:NO];
        [table setScrollEnabled:YES];
        // table.se
        //         UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, height/2, b.frame.size.width, 1)];/// change size as you need.
        //        separatorLineView.backgroundColor = [UIColor lightGrayColor];// you can also put image here
        
        table.backgroundColor = [UIColor whiteColor];
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        if ([direction isEqualToString:@"up"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y-height, btn.size.width, height);
        }
        else if([direction isEqualToString:@"down"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, (self.list.count)*35);
        }
        
        table.frame = CGRectMake(0, 0, btn.size.width,(self.list.count)*35);
//        [table setContentInset:UIEdgeInsetsMake(0, 0, btn.size.width-180,0)];
        //        [table addSubview:separatorLineView];
        [table setUserInteractionEnabled:YES];
        [self setUserInteractionEnabled:YES];
        //        [table setBounces:NO];
        
        [UIView commitAnimations];
        [b.superview addSubview:self];
        [self addSubview:table];
    }
    
    return self;
}

-(void)hideDropDownTxt:(UITextField *)b {
    
    CGRect btn = b.frame;
    
    if ([animationDirection isEqualToString:@"up"]) {
        self.frame = CGRectMake(btn.origin.x, btn.origin.y, btn.size.width, 0);
    }
    else if ([animationDirection isEqualToString:@"down"]) {
        self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, 0);
    }
    table.frame = CGRectMake(0, 0, btn.size.width, 0);
    //[UIView commitAnimations];
}

-(void)hideDropDown:(UIView *)b {
    
    CGRect btn = b.frame;
    
    if ([animationDirection isEqualToString:@"up"]) {
        self.frame = CGRectMake(btn.origin.x, btn.origin.y, btn.size.width, 0);
    }
    else if ([animationDirection isEqualToString:@"down"]) {
        self.frame = CGRectMake(btn.origin.x, btn.origin.y+5, btn.size.width, 0);
    }
    
    table.frame = CGRectMake(0, 0, btn.size.width+100, 0);

    [self removeFromSuperview];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:15];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [tableView setSeparatorInset:UIEdgeInsetsMake(0, 0,25, 0)];

    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text =[list objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    table.delegate = self;
    table.dataSource = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *c = [tableView cellForRowAtIndexPath:indexPath];
    [self.delegate didSelectWithName:c.textLabel.text andSelIndex:indexPath.row];
    
    [self hideDropDown:btnSender];
}

-(void)dealloc {
    
//    [super dealloc];
//    [table release];
//    [self release];
}

@end
