//
//  ZYQCalenderTool.m
//  日历
//
//  Created by bjzyzl on 2017/7/31.
//  Copyright © 2017年 bjzyzl. All rights reserved.
//

#import "ZYQCalenderTool.h"

@implementation ZYQCalenderTool

+ (NSString *)getDate:(NSDate *)date{ //获取当前日期
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    // 获取不同时间字段的信息
    NSDateComponents* comp = [gregorian components:unitFlags fromDate:date];
    
    NSString * month ;
    NSString * day;
    // 获取各时间字段的数值
    if (comp.month < 10) {
        
        month = [NSString stringWithFormat:@"0%ld",comp.month];
    }else
    {
        month = [NSString stringWithFormat:@"%ld",comp.month];
    }
    
    if (comp.day < 10) {
        
        day = [NSString stringWithFormat:@"0%ld",comp.day];
    }else
    {
        day = [NSString stringWithFormat:@"%ld",comp.day];
    }
    
    NSString * DateTime = [NSString stringWithFormat:@"%ld-%@-%@",comp.year,month,day];
    
    return DateTime;
}

+ (NSInteger)getNumberOfDaysInMonth:(NSDate *)date //获取某月天数
{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // 指定日历的算法
    NSDate * currentDate = date;
    // 只要个时间给日历,就会帮你计算出来。这里的时间取当前的时间。
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay
                                   inUnit: NSCalendarUnitMonth
                                  forDate:currentDate];
    return range.length;
}

+ (NSDate *)dayInThePreviousMonth:(NSInteger)month // 某个月
{
    NSDate * date = [NSDate date];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = month;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
}

+ (NSInteger)getWeeklyOrdinality:(NSUInteger)index Page:(NSInteger)page // 计算这个月的第一天是礼拜几
{
    NSDate * date = [self dayInThePreviousMonth:page];
    
    BOOL ok = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitMonth startDate:&date interval:NULL forDate:date];
    
    NSAssert1(ok, @"Failed to calculate the first day of the month based on %@", self);
    
    NSUInteger i = [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfYear forDate:date];
    
    switch (i) {
        case 1:
            return index + 1;
            break;
        case 2:
            return index + 1 - 1;
            break;
        case 3:
            return index + 1 - 2;
            break;
        case 4:
            return index + 1 - 3;
            break;
        case 5:
            return index + 1 - 4;
            break;
        case 6:
            return index + 1 - 5;
            break;
        case 7:
            return index + 1 - 6;
            break;
        default:
            return index;
            break;
    }
}
@end
