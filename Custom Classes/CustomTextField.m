//
//  customTextField.m
//  TongueLineApp
//
//  Created by Abhishek Tyagi on 07/12/15.
//  Copyright © 2015 Mobiloitte Inc. All rights reserved.
//

#import "CustomTextField.h"
#import "Header.h"

@implementation CustomTextField : UITextField

//for left margin of text and placeholder
static CGFloat leftMargin = 10;

- (CGRect)textRectForBounds:(CGRect)bounds
{
    bounds.origin.x += leftMargin;
    
    return bounds;
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    bounds.origin.x += leftMargin;
    
    return bounds;
}

//setting attributes of uitextField
//- (id)initWithCoder:(NSCoder *)inCoder {
//    if (self = [super initWithCoder:inCoder]) {
//        self.delegate = self;
//        [self setBackgroundColor:([UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0])];
//        
//        UIColor *borderColor = [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1.0];
//        
//        self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
//        self.leftViewMode = UITextFieldViewModeAlways;
//        
//        self.layer.borderColor = [borderColor CGColor];
//        self.layer.borderWidth = 1.0f;
//    }
//    return self;
//}


//to change the color of placeholder
- (void)drawPlaceholderInRect:(CGRect)rect
{
  NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1], NSFontAttributeName: self.font};
        CGRect boundingRect = [self.placeholder boundingRectWithSize:rect.size options:0 attributes:attributes context:nil];
 [self.placeholder drawAtPoint:CGPointMake(0, (rect.size.height/2)-boundingRect.size.height/2) withAttributes:attributes];
    
}

@end
