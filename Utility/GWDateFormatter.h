//
//  GWDateFormatter.h
//  GetWithIt
//
//  Created by Apoorve Tyagi on 8/8/13.
//

#import <Foundation/Foundation.h>

@interface GWDateFormatter : NSDateFormatter

+ (id)sharedManager;

//+ (id)sharedLocalTimeManager;

@property (nonatomic, assign) NSTimeInterval secondsFromGMT;
@property (nonatomic, assign) NSTimeInterval daylightOffset;
@property (nonatomic, assign) BOOL isDayLightEnabled;

-(NSString*)getTimeString:(NSTimeInterval)timestamp;

-(NSString*)getDateString:(NSDate*)date;

-(NSString*)getMonth:(NSDate*)date;

@end
