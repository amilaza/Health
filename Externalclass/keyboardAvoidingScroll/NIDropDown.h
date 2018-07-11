//
//  NIDropDown.h
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NIDropDown;

@protocol NIDropDownDelegate
-(void)didSelectWithName:(NSString*)name andSelIndex:(NSInteger)index;
@end

@interface NIDropDown : UIView <UITableViewDelegate, UITableViewDataSource> {
    
    NSString *animationDirection;
    UIImageView *imgView;
}

@property (nonatomic, retain) id <NIDropDownDelegate> delegate;
@property (nonatomic, retain) NSString *animationDirection;
-(void)hideDropDown:(UIButton *)b;
//- (id)showDropDown:(UIButton *)b:(CGFloat *)height:(NSArray *)arr:(NSArray *)imgArr:(NSString *)direction;
-(id)showDropDownWith:(UIView *)b :(UIButton *)sender :(CGFloat)height :(NSArray *)arr :(NSString *)direction;
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

-(id)showDropDownWithTxt:(UITextField *)txt :(CGFloat)height :(NSArray *)arr :(NSString *)direction;
-(void)hideDropDownTxt:(UITextField *)b;

@end
