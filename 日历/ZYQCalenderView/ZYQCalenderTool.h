//
//  ZYQCalenderTool.h
//  日历
//
//  Created by bjzyzl on 2017/7/31.
//  Copyright © 2017年 bjzyzl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYQCalenderTool : NSObject

+ (NSString *)getDate:(NSDate *)date;               //获取当前日期
+ (NSInteger)getNumberOfDaysInMonth:(NSDate *)date; //获取某月天数
+ (NSDate *)dayInThePreviousMonth:(NSInteger)month; // 某个月
+ (NSInteger)getWeeklyOrdinality:(NSUInteger)index Page:(NSInteger)page; // 计算这个月的第一天是礼拜几


@end
