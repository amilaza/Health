//
//  DateCommon.h
//  ChildPass
//
//  Created by Steven Pham on 12/23/16.
//  Copyright © 2016 dungdtiosdeveloper. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DateCommon : NSObject
@property(strong, nonatomic) NSDateFormatter *dateFormater;

+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format;
+ (NSDate *)getDateFromString:(NSString *)stringDate;
+ (NSInteger)getYearFromDate:(NSDate *)date;
+ (NSInteger)getYearFromString:(NSString *)stringDate;
+ (NSString *)convertDay:(NSString *)date fromFormat:(NSString *)fromFormat toFormat:(NSString *)tagetFormat;
+ (NSInteger)getDayOfMonthFormDate:(NSDate *)date;
+ (NSInteger)getMonthOfYearFormDate:(NSDate *)date;
+ (NSInteger)getWeekOfYearFromDate:(NSDate *)date;
+ (NSInteger)getYearForWeekOfYearFromDate:(NSDate *)date;
+ (NSArray *)getAllDaysOfMonthFromDate:(NSDate *)date;
+ (NSInteger)numberOfDaysOnMonthFromDate:(NSDate *)date;
+ (NSInteger)compareDate:(NSDate *)currentDate withDate:(NSDate *)compareDate;

+ (double)convertTimeStampFromDate:(NSDate *)date;
+ (double)getTimeStampFromBeginOfDate:(NSDate *)date;
+ (double)getTimeStampFromBeginOfWeekByDate:(NSDate *)date;
+ (double)getTimeStampFromBeginOfMonthByDate:(NSDate *)date;
+ (double)getTimeStampFromBeginOfYearByDate:(NSDate *)date;
+ (double)getTimeStampFromEndOfDate:(NSDate *)date;
+ (double)getTimeStampFromEndOfWeekByDate:(NSDate *)date;
+ (double)getTimeStampFromEndOfMonthByDate:(NSDate *)date;
+ (double)getTimeStampFromEndOfYearByDate:(NSDate *)date;

+ (NSDate *)dateBeforeDays:(NSInteger)since ofDay:(NSDate *)date;
+ (NSDate *)dateSinceOneWeekFromDate:(NSDate *)date;
+ (NSDate *)dateSinceOneMonthFromDate:(NSDate *)date;
+ (NSDate *)dateSinceOneYearFromDate:(NSDate *)date;
+ (NSDate *)yesterDayFromDate:(NSDate *)date;
+ (NSDate *)startDayOfMonthFromDate:(NSDate *)date;
+ (NSDate *)endDayOfMonthFromDate:(NSDate *)date;

+ (NSString *)getTimePeriodFromNowToTimeStamp:(double)timestamp;
@end
