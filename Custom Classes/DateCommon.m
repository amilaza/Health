//
//  DateCommon.m
//  ChildPass
//
//  Created by Steven Pham on 12/23/16.
//  Copyright © 2016 dungdtiosdeveloper. All rights reserved.
//

#import "DateCommon.h"

static NSDateFormatter *commonDateFormatter;
static NSCalendar *commonCalendar;
@implementation DateCommon

+ (NSString *)stringFromDate:(NSDate *)date {
    if (commonDateFormatter == nil) {
        commonDateFormatter = [NSDateFormatter new];
    }
    commonDateFormatter.dateFormat = @"dd-MM-yyyy";
    [commonDateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]]];
    return [commonDateFormatter stringFromDate:date];
}
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format {
    if (commonDateFormatter == nil) {
        commonDateFormatter = [NSDateFormatter new];
    }
    commonDateFormatter.dateFormat = format;
    [commonDateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]]];
    return [commonDateFormatter stringFromDate:date];
}
+ (NSDate *)getDateFromString:(NSString *)stringDate {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"dd-MM-yyyy";
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]]];
    NSDate *date = [dateFormatter dateFromString:stringDate];
    return date;
}

+ (NSInteger)getYearFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy";
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]]];
    NSString *strDate = [dateFormatter stringFromDate:date];
    NSInteger year = [strDate integerValue];
    return year;
}
+ (NSInteger)getYearFromString:(NSString *)stringDate {
    NSDate *date = [self getDateFromString:stringDate];
    NSInteger year = [self getYearFromDate:date];
    return year;
}

+ (NSString *)convertDay:(NSString *)date fromFormat:(NSString *)fromFormat toFormat:(NSString *)tagetFormat {
    if (commonDateFormatter == nil) {
        commonDateFormatter = [NSDateFormatter new];
    }
    commonDateFormatter.dateFormat = fromFormat;
    NSDate *tempDate = [commonDateFormatter dateFromString:date];
    return [self stringFromDate:tempDate withFormat:tagetFormat];
}

+ (NSInteger)getDayOfMonthFormDate:(NSDate *)date {
    if (commonCalendar == nil) {
        commonCalendar = [NSCalendar currentCalendar];
    }
    NSDateComponents *dateComponent = [commonCalendar components:(NSCalendarUnitDay) fromDate:date];
    dateComponent.timeZone = [NSTimeZone localTimeZone];
    return dateComponent.day;
}
+ (NSInteger)getMonthOfYearFormDate:(NSDate *)date {
    if (commonCalendar == nil) {
        commonCalendar = [NSCalendar currentCalendar];
    }
    NSDateComponents *dateComponent = [commonCalendar components:(NSCalendarUnitMonth) fromDate:date];
    dateComponent.timeZone = [NSTimeZone localTimeZone];
    return dateComponent.month;
}

+ (NSInteger)getYearForWeekOfYearFromDate:(NSDate *)date {
    if (commonCalendar == nil) {
        commonCalendar = [NSCalendar currentCalendar];
    }
    NSDateComponents *dateComponent = [commonCalendar components:(NSCalendarUnitWeekOfYear|NSCalendarUnitYearForWeekOfYear) fromDate:date];
    dateComponent.timeZone = [NSTimeZone localTimeZone];
    return [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitWeekOfYear inUnit:NSCalendarUnitYear forDate:date].length;

}
+ (NSInteger)getWeekOfYearFromDate:(NSDate *)date {
    if (commonCalendar == nil) {
        commonCalendar = [NSCalendar currentCalendar];
    }
    NSDateComponents *dateComponent = [commonCalendar components:(NSCalendarUnitWeekOfYear) fromDate:date];
    dateComponent.timeZone = [NSTimeZone localTimeZone];
    return dateComponent.weekOfYear;
}
//+ (NSArray *)getAllDaysOfMonthFromDate:(NSDate *)date{
//    if (date == nil) {
//        date = [NSDate date];
//    }
//    NSMutableArray *datesThisMonth = [NSMutableArray new];
//    if (commonCalendar == nil) {
//        commonCalendar = [NSCalendar currentCalendar];
//    }
//    NSRange range = [commonCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
//
//    NSDateComponents *components = [commonCalendar components:(NSCalendarUnitDay | NSCalendarUnitMonth) fromDate:date];
//    [components setHour:0];
//    [components setMinute:0];
//    [components setSecond:0];
//    
//    for (NSInteger i = range.location; i < NSMaxRange(range); i++) {
//        [components setDay:i];
//        NSDate *dayInMonth = [commonCalendar dateFromComponents:components];
//        DateObject *obj = [DateObject new];
//        obj.day = [DateCommon stringFromDate:dayInMonth withFormat:@"EEE"];
//        obj.date = [DateCommon stringFromDate:dayInMonth withFormat:@"dd"];
//        [datesThisMonth addObject:obj];
//    }
//    return datesThisMonth;
//}
+ (NSInteger)numberOfDaysOnMonthFromDate:(NSDate *)date {
    if (commonCalendar == nil) {
        commonCalendar = [NSCalendar currentCalendar];
    }
    NSRange range = [commonCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return range.length;
}
+ (NSInteger)compareDate:(NSDate *)currentDate withDate:(NSDate *)compareDate {
    NSInteger currentMonthInt = [[DateCommon stringFromDate:currentDate withFormat:@"M"]integerValue];
    NSInteger compareMonthInt = [[DateCommon stringFromDate:compareDate withFormat:@"M"]integerValue];
    
    NSInteger currentInt = [[DateCommon stringFromDate:currentDate withFormat:@"d"]integerValue];
    NSInteger compareInt = [[DateCommon stringFromDate:compareDate withFormat:@"d"]integerValue];
    NSInteger currentYearInt = [[DateCommon stringFromDate:currentDate withFormat:@"yyyy"]integerValue];
    NSInteger compareYearInt = [[DateCommon stringFromDate:compareDate withFormat:@"yyyy"]integerValue];
    
    if (currentYearInt < compareYearInt) {
        return 2;//currentDate is earlier than compareDate
    } else if(currentYearInt > compareYearInt) {
        return 1;//currentDate is later than compareDate
    } else { //same year
        if (currentMonthInt < compareMonthInt) {
            return 2;//currentDate is earlier than compareDate
        } else if (currentMonthInt > compareMonthInt){
            return 1;//currentDate is later than compareDate
        } else { // same month
            if (compareInt == currentInt)  {
                return 0;//dates are the same
            } else if (compareInt < currentInt){
                return 1;//currentDate is later than compareDate
            } else {
                return 2;//currentDate is earlier than compareDate
            }
        }
    }
    
    
    
//    if ([currentDate compare:compareDate] == NSOrderedDescending) {
//        return 1;//currentDate is later than compareDate
//    } else if ([currentDate compare:compareDate] == NSOrderedAscending) {
//        return 2;//currentDate is earlier than compareDate
//    } else {
//        return 0;//dates are the same
//    }
}
+ (NSDate *)yesterDayFromDate:(NSDate *)date {
    if (commonCalendar == nil) {
        commonCalendar = [NSCalendar currentCalendar];
    }
    NSDateComponents *components = [commonCalendar components:(NSCalendarUnitDay | NSCalendarUnitMonth|NSCalendarUnitYear) fromDate:date];
    [components setDay:-1];
    [components setYear:0];
    [components setMonth:0];
    return [commonCalendar dateByAddingComponents:components toDate: date options:0];
}
+ (NSDate *)dateBeforeDays:(NSInteger)since ofDay:(NSDate *)date {
    if (commonCalendar == nil) {
        commonCalendar = [NSCalendar currentCalendar];
    }
    NSDateComponents *components = [commonCalendar components:(NSCalendarUnitDay | NSCalendarUnitMonth|NSCalendarUnitYear) fromDate:date];
    [components setDay:since];
    return [commonCalendar dateByAddingComponents:components toDate: date options:0];
}
+ (NSDate *)dateSinceOneWeekFromDate:(NSDate *)date {
    if (commonCalendar == nil) {
        commonCalendar = [NSCalendar currentCalendar];
    }
    NSDateComponents *components = [commonCalendar components:(NSCalendarUnitDay | NSCalendarUnitMonth|NSCalendarUnitYear) fromDate:date];
    [components setDay:-7];
    [components setYear:0];
    [components setMonth:0];
    return [commonCalendar dateByAddingComponents:components toDate: date options:0];
}
+ (NSDate *)dateSinceOneMonthFromDate:(NSDate *)date{
    if (commonCalendar == nil) {
        commonCalendar = [NSCalendar currentCalendar];
    }
    NSDateComponents *components = [commonCalendar components:( NSCalendarUnitMonth | NSCalendarUnitWeekOfMonth | NSCalendarUnitDay ) fromDate:date];
    [components setMonth:-1];
    [components setWeekOfMonth:0];
    [components setDay:0];
    return [commonCalendar dateByAddingComponents:components toDate: date options:0];
}
+ (NSDate *)dateSinceOneYearFromDate:(NSDate *)date{
    if (commonCalendar == nil) {
        commonCalendar = [NSCalendar currentCalendar];
    }
    NSDateComponents *components =[commonCalendar components:( NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay ) fromDate:date];
    [components setYear:-1];
    [components setMonth:0];
    [components setDay:0];
    return [commonCalendar dateByAddingComponents:components toDate: date options:0];
//    return [commonCalendar dateFromComponents:components];
}
+ (double)convertTimeStampFromDate:(NSDate *)date {
    return [date timeIntervalSince1970];
}

+ (double)getTimeStampFromBeginOfDate:(NSDate *)date {
    if (commonCalendar == nil) {
        commonCalendar = [NSCalendar currentCalendar];
    }
    NSDateComponents *components = [commonCalendar components:(NSCalendarUnitDay | NSCalendarUnitMonth|NSCalendarUnitYear) fromDate:date];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:1];
    
    NSDate *morningStart = [commonCalendar dateFromComponents:components];
    return [morningStart timeIntervalSince1970];
}

+ (double)getTimeStampFromBeginOfWeekByDate:(NSDate *)date {
    if (commonCalendar == nil) {
        commonCalendar = [NSCalendar currentCalendar];
    }
    NSDateComponents *components = [commonCalendar components:(NSCalendarUnitDay | NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitWeekday) fromDate:date];
    NSInteger dayofweek = [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:date] weekday];
    [components setDay:([components day] - ((dayofweek) - 2))]; // for beginning of the week.

    NSDate *tempdate = [commonCalendar dateFromComponents:components];
    return [tempdate timeIntervalSince1970];
}

+ (double)getTimeStampFromBeginOfMonthByDate:(NSDate *)date {
    if (commonCalendar == nil) {
        commonCalendar = [NSCalendar currentCalendar];
    }
    NSDateComponents *components = [commonCalendar components:(NSCalendarUnitDay | NSCalendarUnitMonth|NSCalendarUnitYear) fromDate:date];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    [components setDay:1];
    
    NSDate *firstOfMonth = [commonCalendar dateFromComponents:components];
    return [firstOfMonth timeIntervalSince1970];
}

+ (double)getTimeStampFromBeginOfYearByDate:(NSDate *)date {
    if (commonCalendar == nil) {
        commonCalendar = [NSCalendar currentCalendar];
    }
    NSDateComponents *components = [commonCalendar components:(NSCalendarUnitDay | NSCalendarUnitMonth|NSCalendarUnitYear) fromDate:date];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    [components setDay:1];
    [components setMonth:1];
    
    NSDate *firstOfYear = [commonCalendar dateFromComponents:components];
    return [firstOfYear timeIntervalSince1970];
}



+ (double)getTimeStampFromEndOfDate:(NSDate *)date {
    if (commonCalendar == nil) {
        commonCalendar = [NSCalendar currentCalendar];
    }
    NSDateComponents *components = [commonCalendar components:(NSCalendarUnitDay | NSCalendarUnitMonth|NSCalendarUnitYear) fromDate:date];
    [components setHour:23];
    [components setMinute:59];
    [components setSecond:59];
    
    NSDate *morningStart = [commonCalendar dateFromComponents:components];
    double time = [morningStart timeIntervalSince1970];
    return time + 100;
}

+ (double)getTimeStampFromEndOfWeekByDate:(NSDate *)date {
    if (commonCalendar == nil) {
        commonCalendar = [NSCalendar currentCalendar];
    }
    NSDateComponents *components = [commonCalendar components:(NSCalendarUnitDay | NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitWeekday) fromDate:date];
    NSInteger dayofweek = [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:date] weekday];
    [components setDay:([components day]+(7- dayofweek)+1)];// for end day of the week
    
    NSDate *tempdate = [commonCalendar dateFromComponents:components];
    double time = [tempdate timeIntervalSince1970];
    return time + 100;
}

+ (double)getTimeStampFromEndOfMonthByDate:(NSDate *)date {
    if (commonCalendar == nil) {
        commonCalendar = [NSCalendar currentCalendar];
    }
    NSDateComponents *components = [commonCalendar components:(NSCalendarUnitDay | NSCalendarUnitMonth|NSCalendarUnitYear) fromDate:date];
    NSRange range = [commonCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    [components setHour:23];
    [components setMinute:59];
    [components setSecond:59];
    [components setDay:range.length];
    
    NSDate *tempdate = [commonCalendar dateFromComponents:components];
    double time = [tempdate timeIntervalSince1970];
    return time + 100;

}

+ (double)getTimeStampFromEndOfYearByDate:(NSDate *)date {
    if (commonCalendar == nil) {
        commonCalendar = [NSCalendar currentCalendar];
    }
    NSDateComponents *components = [commonCalendar components:(NSCalendarUnitDay | NSCalendarUnitMonth|NSCalendarUnitYear) fromDate:date];

    [components setHour:23];
    [components setMinute:59];
    [components setSecond:59];
    [components setDay:31];
    [components setMonth:12];
    
    NSDate *tempdate = [commonCalendar dateFromComponents:components];
    double time = [tempdate timeIntervalSince1970];
    return time + 100;
}

+ (NSDate *)startDayOfMonthFromDate:(NSDate *)date{
    if (commonCalendar == nil) {
        commonCalendar = [NSCalendar currentCalendar];
    }
    NSDateComponents *components = [commonCalendar components:(NSCalendarUnitDay | NSCalendarUnitMonth|NSCalendarUnitYear) fromDate:date];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    [components setDay:1];
    return [commonCalendar dateFromComponents:components];
    
}
+ (NSDate *)endDayOfMonthFromDate:(NSDate *)date{
    if (commonCalendar == nil) {
        commonCalendar = [NSCalendar currentCalendar];
    }
    NSDateComponents *components = [commonCalendar components:(NSCalendarUnitDay | NSCalendarUnitMonth|NSCalendarUnitYear) fromDate:date];
    NSRange range = [commonCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    [components setHour:23];
    [components setMinute:59];
    [components setSecond:59];
    [components setDay:range.length];
    
    return [commonCalendar dateFromComponents:components];
}
+ (NSString *)getTimePeriodFromNowToTimeStamp:(double)timestamp{
    NSDate *date = [NSDate date];
    NSTimeInterval now = [date timeIntervalSince1970];
    double period = (now - timestamp)/1000;
    if (period < 60) {
        return [NSString stringWithFormat:@"%d seconds ago.", (int)period];
    } else if (period < 60 * 60) {
        return [NSString stringWithFormat:@"%d minutes ago.", (int)(period/60)];
    } else if (period < 24 * 3600) {
        return [NSString stringWithFormat:@"%d hours ago.", (int)(period/3600)];
    } else if (period < 24 * 3600 * 2) {
        return [NSString stringWithFormat:@"%d days ago.", (int)(period/(3600 * 24))];
    } else {
        return [NSString stringWithFormat:@"%d days ago.", (int)(period/(3600 * 24))];
    }
}

@end

