//
//  UIButton+AFNetworking.h
//  GetWithIt!
//
//  Created by Apoorve Tyagi on 9/25/13.
//  Copyright (c) 2013 Halosys Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFImageRequestOperation.h"

#import <Availability.h>

#if __IPHONE_OS_VERSION_MIN_REQUIRED
#import <UIKit/UIKit.h>

/**
 This category adds methods to the UIKit framework's `UIImageView` class. The methods in this category provide support for loading remote images asynchronously from a URL.
 */
@interface UIButton (AFNetworking)

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage forState:(UIControlState)state;

- (void)setBackgroundImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage forState:(UIControlState)state;


@end

#endif