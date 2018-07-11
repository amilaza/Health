//
//  BasePresenter.h
//  ElectricityVersion2
//
//  Created by Nguyen Ba Linh on 9/11/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasePresenter : NSObject
- (NSError *)createErrorWithDescription:(NSString *)message;
- (NSError *)createErrorFromResponse:(id)responseObject;
@end
