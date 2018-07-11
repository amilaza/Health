//
//  GWDateFormatter.m
//  GetWithIt
//
//  Created by Apoorve Tyagi on 8/8/13.
//

#import "GWDateFormatter.h"

static GWDateFormatter *dateFormatterSingleton;
static GWDateFormatter *dateFormatterLocalSingleton;


@implementation GWDateFormatter

+ (id)sharedManager {
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        dateFormatterSingleton = [[GWDateFormatter alloc] init];
        dateFormatterSingleton.secondsFromGMT = [[NSTimeZone systemTimeZone] secondsFromGMT];
        dateFormatterSingleton.daylightOffset = [[NSTimeZone systemTimeZone] daylightSavingTimeOffset];
    });
    return dateFormatterSingleton;
}

+ (id)sharedLocalTimeManager{
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        dateFormatterLocalSingleton = [[GWDateFormatter alloc] initWiyjLocalTimeZone];
    });
    return dateFormatterLocalSingleton;
}

-(id)initWiyjLocalTimeZone{
    self =  [super init];
    if (self) {
        [self setTimeZone:[NSTimeZone systemTimeZone]];

        self.isDayLightEnabled = [[self timeZone] isDaylightSavingTime];
        self.daylightOffset = [[self timeZone] daylightSavingTimeOffset];
    }
    
    return self;
}

-(id)init {
    
    self =  [super init];
    if (self) {
        [self setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    }
    return self;
}

-(NSString*)getTimeString:(NSTimeInterval)timestamp {
    
    [self setDateFormat:@"hh:mma"];
    return [self stringFromDate:[NSDate dateWithTimeIntervalSince1970:timestamp]];
}

-(NSString*)getDateString:(NSDate*)date {
    
    [self setDateFormat:@"yyyy-MM-dd"];
    return [self stringFromDate:date];
}

-(NSString*)getMonth:(NSDate*)date {
    
    [self setDateFormat:@"MMMM"];
    [self setDateFormat:@"MMMM yyyy"];
    return [self stringFromDate:date];
}


@end
