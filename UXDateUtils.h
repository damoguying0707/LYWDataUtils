//
//  UXDateUtils.h
//  YouxinClient
//
//  Created by vincent.li on 16/2/23.
//  Copyright © 2016年 UXIN CO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UXDateUtils : NSObject

/**
 *  IM模块将cell中的消息时间 转化为 特定要求显示
 */
+ (NSString *)dataTimeForIMCell:(NSDate *)date;

/**
 *  时间格式化为字符串
 */
+ (NSString *)getStringFromDate:(NSDate *)date;

/**
 *  字符串格式化为时间
 */
+ (NSDate *)getDateFromString:(NSString *)str;

/**
 *  统一设置时间格式
 *
 *  @param type type = 0;obj 表示的是NSString type = 1;obj 表示的是NSDate
 *  @param obj
 */
+ (NSString *)setTheRightDateFormateForUI:(int)type  obj:(id)obj;

+ (NSString *)setTheRightDateFormateLineForUI:(int)type  obj:(id)obj;

/**
 *  通过月份和日期计算星座
 */
+ (NSString *)getXingzuoWithMonth:(NSInteger)nMonth withDays:(NSInteger)nDays;

/**
 *  为详情视图格式化要显示的日期时间字符串，例如通话记录详情、消息详情
 *
 *  @param dateString 完整的日期时间格式字符串
 *
 *  @return 格式化好的要显示的日期时间字符串
 */
+ (NSString *)formattedDateStringForDetaisViewFromString:(NSString *)dateString;

/**
 *  为详情视图格式化要显示的日期时间字符串，例如通话记录详情、消息详情
 *
 *  @param formattedDate 日期对象
 *
 *  @return 格式化好的要显示的日期时间字符串
 */
+ (NSString *)formattedDateStringForDetaisViewFromDate:(NSDate *)formattedDate;

/**
 *  计算指定时间到当前时间差值
 */
+ (double)intervalSinceNow:(NSString *)theDate;

/**
 *  终身xx次，每xx天一次判断
 */
+ (BOOL)ruleFor:(NSString *)key count:(int)count interval:(NSTimeInterval)ival;

+ (NSDateFormatter *)defaultDateFormatter;

@end
