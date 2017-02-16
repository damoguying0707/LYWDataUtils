//
//  UXDateUtils.m
//  YouxinClient
//
//  Created by vincent.li on 16/2/23.
//  Copyright © 2016年 UXIN CO. All rights reserved.
//

#import "UXDateUtils.h"

@implementation UXDateUtils

+ (NSString *)dataTimeForIMCell:(NSDate *)date {
    
    NSString *timeString = @"";
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSTimeInterval late =[date timeIntervalSince1970]*1;
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    
    [formatter setDateFormat:@"H"];
    int today =   [[formatter stringFromDate:dat] intValue] *3600;
    
    [formatter setDateFormat:@"m"];
    today +=  [[formatter stringFromDate:dat] intValue]*60;
    
    NSTimeInterval cha= now - late  ;
    [formatter setDateFormat:@"HH:mm"];
    timeString=[formatter stringFromDate:date];
    
    if (cha < today) {
        timeString=[formatter stringFromDate:date];
    } else if (cha >today &&cha< today +24*3600) {
        timeString= [NSString stringWithFormat:@"昨天 %@",timeString];
    } else if (cha >today &&cha< today +24*3600*2) {
        timeString= [NSString stringWithFormat:@"前天 %@",timeString];
    } else {
        [formatter setDateFormat:@"yyyy"];
        BOOL isSameYear = [[formatter stringFromDate:date] isEqualToString:[formatter stringFromDate:[NSDate date]]];
        if (isSameYear) {
            [formatter setDateFormat:@"MM-dd HH:mm"];
            timeString=[formatter stringFromDate:date];
        } else {
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            timeString=[formatter stringFromDate:date];
        }
    }
    
    return timeString;
}

+ (NSString *)getStringFromDate:(NSDate *)date {
    
    if (date == nil) date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [formatter stringFromDate:date];
}

+ (NSDate *)getDateFromString:(NSString *)str {
    
    if (str == nil||[str isEqualToString:@""]) return [NSDate dateWithTimeIntervalSince1970:0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [formatter dateFromString:str];
}

/**
 *  返回两个日期之间的间隔天数。同一天返回0，昨天返回1，前天返回2...
 *
 *  @param minDateStr 不包含时间部分的小日期 2014-08-13
 *  @param maxDateStr 不包含时间部分的大日期 2014-08-15
 *
 *  @return 天数间隔
 */
+ (NSInteger)dateDiffBetweenMinDate:(NSDate *)minDateD maxDate:(NSDate *)maxDateD {
    
    NSInteger retValue = 0;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd 00:00:00"];
    
    NSString *minStr = [dateFormatter stringFromDate:minDateD];
    NSString *maxStr = [dateFormatter stringFromDate:maxDateD];
    
    NSDate * minDate = [dateFormatter dateFromString:minStr];
    NSDate * maxDate = [dateFormatter dateFromString:maxStr];
    dateFormatter = nil;
    
    if ([maxDate timeIntervalSinceDate:minDate] > 0) {
        long offset = [maxDate timeIntervalSinceDate:minDate];
        int oneDaySeconds = 24 * 60 * 60;
        retValue = (NSInteger)(offset/oneDaySeconds);
    } else {
        if ([maxDate isEqual:minDate]) {
            //同一天
            retValue = 0;
        } else {
            //maxDate 小于 minDate，返回-1
            retValue = -1;
        }
    }
    
    return retValue;
}

/**
 *  返回两个日期之间的间隔天数。同一天返回0，昨天返回1，前天返回2...
 *
 *  @param minDateStr 不包含时间部分的小日期 2014-08-13
 *  @param maxDateStr 不包含时间部分的大日期 2014-08-15
 *
 *  @return 天数间隔
 */
+ (NSInteger)dateDiffBetweenMinDateStr:(NSString *)minDateStr maxDateStr:(NSString *)maxDateStr {
    
    NSInteger retValue = 0;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate * minDate = [dateFormatter dateFromString:minDateStr];
    NSDate * maxDate = [dateFormatter dateFromString:maxDateStr];
    dateFormatter = nil;
    
    if ([maxDate timeIntervalSinceDate:minDate] > 0) {
        long offset = [maxDate timeIntervalSinceDate:minDate];
        int oneDaySeconds = 24 * 60 * 60;
        retValue = (NSInteger)(offset/oneDaySeconds);
    } else {
        if ([maxDate isEqual:minDate]) {
            //同一天
            retValue = 0;
        } else {
            //maxDate 小于 minDate，返回-1
            retValue = -1;
        }
    }
    return retValue;
}

/*
 type = 0;obj 表示的是NSString
 type = 1;obj 表示的是NSDate
 */
+ (NSString *)setTheRightDateFormateForUI:(int)type  obj:(id)obj {

    if (nil == obj) {
        return nil;
    }
    NSDate *realDate = nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    if (type == 0) {

        if ([obj isKindOfClass:[NSString class]]) {

            [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
            NSDate * tempDate = [dateFormatter dateFromString:obj];
            if (tempDate != nil) {
                realDate = [tempDate copy];
            }

            if (realDate == nil) {
                return nil;
            }
        }
        else
        {
            return nil;
        }
    } else if (type == 1) {

        if (obj && [obj isKindOfClass:[NSDate class]]) {

            realDate = [(NSDate *)obj copy];

            [dateFormatter setDateFormat:@"yyyy/MM/dd 00:00:00"];
            NSString *ttt = [dateFormatter stringFromDate:obj];

            if ([ttt length] < 10) {
                return nil;
            }
        } else {
            return nil;
        }
    } else {
        return nil;
    }

    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *HourAndMin = [[dateFormatter stringFromDate:realDate] copy];
    if ([HourAndMin length] < 1) {
        return nil;
    }

    NSCalendar *cal = [NSCalendar currentCalendar];
    cal.timeZone = [NSTimeZone localTimeZone];
    cal.firstWeekday = 2;//周一算一周的第一天

    NSDate *now = [NSDate date];

    NSDateComponents * c1 = [cal components:NSCalendarUnitYear|NSCalendarUnitWeekOfYear|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:now];

    NSDateComponents * c2 = [cal components:NSCalendarUnitYear|NSCalendarUnitWeekOfYear|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:realDate];

    if (c1.year != c2.year) {
        [dateFormatter setDateFormat:@"yyyy/MM/dd"];
        NSString *value = [dateFormatter stringFromDate:realDate];
        NSString *value1 = [value substringWithRange:NSMakeRange(5, 1)];
        NSString *value2 = [value substringWithRange:NSMakeRange(8, 1)];
        BOOL b1 = [value1 isEqualToString:@"0"];
        BOOL b2 = [value2 isEqualToString:@"0"];

        if (b1 && b2) {
            value = [[NSString alloc] initWithFormat:@"%@%@%@",[value substringToIndex:5],[value substringWithRange:NSMakeRange(6, 2)],[value substringFromIndex:9]];
        } else if (b1) {
            value = [[NSString alloc] initWithFormat:@"%@%@",[value substringToIndex:5],[value substringFromIndex:6]];
        } else if (b2) {
            value = [[NSString alloc] initWithFormat:@"%@%@",[value substringToIndex:8],[value substringFromIndex:9]];
        }

        value = [value substringFromIndex:2];
        return [[NSString alloc] initWithString:value];
    }


    NSDateComponents * c3 = [cal components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond) fromDate:realDate toDate:now options:0];

    NSInteger offSetDate = [[self class] dateDiffBetweenMinDate:realDate maxDate:now];

    if (offSetDate >= 0) {
        switch (offSetDate) {
            case 1:
                return [[NSString alloc] initWithFormat:@"昨天 %@",HourAndMin];

            default: {
                //判断两个时间是否在同一周
                if(c1.weekOfYear == c2.weekOfYear) { //同一周
                    if (offSetDate == 0) { //同一天

                        NSTimeInterval offsetSecond = [now timeIntervalSinceDate:realDate];

                        int hour = offsetSecond/60/60;
                        int minit  = offsetSecond/60;

                        if (hour >  0) { //显示 12:00格式
                            return HourAndMin;
                        } else if (minit > 0) {
                            //显示 12:00格式
                            return HourAndMin;
                        } else if (c3.second > 0) {
                            return @"刚刚";
                        } else {
                            return @"刚刚";
                        }
                    }

                    switch (c2.weekday) {
                        case 1:
                            return @"周日";
                        case 2:
                            return @"周一";
                        case 3:
                            return @"周二";
                        case 4:
                            return @"周三";
                        case 5:
                            return @"周四";
                        case 6:
                            return @"周五";
                        case 7:
                            return @"周六";
                        default:
                            return @"未知";
                    }
                } else {
                    //不在同一周、显示 月-日 格式
                    [dateFormatter setDateFormat:@"MM/dd"];
                }
            }
                break;
        }


        NSString *ttt = [dateFormatter stringFromDate:realDate];
        if ([ttt length] < 1) {
            return nil;
        } else if ([ttt length] == 5) {
            NSString *temp = [ttt substringToIndex:1];
            if ([temp isEqualToString:@"0"]) {
                ttt = [ttt substringFromIndex:1];
            }

            temp = [ttt substringWithRange:NSMakeRange(2, 1)];
            if ([temp isEqualToString:@"0"]) {
                ttt = [[NSString alloc] initWithFormat:@"%@%@",[ttt substringToIndex:2],[ttt substringFromIndex:3]];
            }
        }

        return [[NSString alloc] initWithString:ttt];
    } else {
        NSLog(@"比较时间大于当前时间,不正常的情况。");
        [dateFormatter setDateFormat:@"yyyy/MM/dd"];
        NSString *value = [dateFormatter stringFromDate:realDate];
        NSString *value1 = [value substringWithRange:NSMakeRange(5, 1)];
        NSString *value2 = [value substringWithRange:NSMakeRange(8, 1)];
        BOOL b1 = [value1 isEqualToString:@"0"];
        BOOL b2 = [value2 isEqualToString:@"0"];

        if (b1 && b2) {
            value = [[NSString alloc] initWithFormat:@"%@%@%@",[value substringToIndex:5],[value substringWithRange:NSMakeRange(6, 2)],[value substringFromIndex:9]];
        } else if (b1) {
            value = [[NSString alloc] initWithFormat:@"%@%@",[value substringToIndex:5],[value substringFromIndex:6]];
        } else if (b2) {
            value = [[NSString alloc] initWithFormat:@"%@%@",[value substringToIndex:8],[value substringFromIndex:9]];
        }
        value = [value substringFromIndex:2];
        return [[NSString alloc] initWithString:value];
    }

    return nil;
}


+ (NSString *)setTheRightDateFormateLineForUI:(int)type  obj:(id)obj {

    NSString *timeString = @"";
    if (nil == obj) {
        return timeString;
    }
    NSDate *realDate = nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    if (type == 0) {

        if ([obj isKindOfClass:[NSString class]]) {

            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate * tempDate = [dateFormatter dateFromString:obj];
            if (tempDate != nil) {
                realDate = [tempDate copy];
            }

            if (realDate == nil) {
                return timeString;
            }
        }
        else
        {
            return timeString;
        }
    } else if (type == 1) {

        if (obj && [obj isKindOfClass:[NSDate class]]) {

            realDate = [(NSDate *)obj copy];

            [dateFormatter setDateFormat:@"yyyy-MM-dd 00:00:00"];
            NSString *ttt = [dateFormatter stringFromDate:obj];

            if ([ttt length] < 10) {
                return timeString;
            }
        } else {
            return timeString;
        }
    } else {
        return timeString;
    }

    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *HourAndMin = [[dateFormatter stringFromDate:realDate] copy];
    if ([HourAndMin length] < 1) {
        return timeString;
    }

    NSCalendar *cal = [NSCalendar currentCalendar];
    cal.timeZone = [NSTimeZone localTimeZone];
    cal.firstWeekday = 2;//周一算一周的第一天

    NSDate *now = [NSDate date];

    NSDateComponents * c1 = [cal components:NSCalendarUnitYear|NSCalendarUnitWeekOfYear|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:now];

    NSDateComponents * c2 = [cal components:NSCalendarUnitYear|NSCalendarUnitWeekOfYear|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:realDate];

    if (c1.year != c2.year) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *value = [dateFormatter stringFromDate:realDate];
        NSString *value1 = [value substringWithRange:NSMakeRange(5, 1)];
        NSString *value2 = [value substringWithRange:NSMakeRange(8, 1)];
        BOOL b1 = [value1 isEqualToString:@"0"];
        BOOL b2 = [value2 isEqualToString:@"0"];

        if (b1 && b2) {
            value = [[NSString alloc] initWithFormat:@"%@%@%@",[value substringToIndex:5],[value substringWithRange:NSMakeRange(6, 2)],[value substringFromIndex:9]];
        } else if (b1) {
            value = [[NSString alloc] initWithFormat:@"%@%@",[value substringToIndex:5],[value substringFromIndex:6]];
        } else if (b2) {
            value = [[NSString alloc] initWithFormat:@"%@%@",[value substringToIndex:8],[value substringFromIndex:9]];
        }

        value = [value substringFromIndex:2];
        return [[NSString alloc] initWithString:value];
    }


    NSDateComponents * c3 = [cal components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond) fromDate:realDate toDate:now options:0];

    NSInteger offSetDate = [[self class] dateDiffBetweenMinDate:realDate maxDate:now];

    if (offSetDate >= 0) {
        switch (offSetDate) {
            case 1:
                return [[NSString alloc] initWithFormat:@"昨天 %@",HourAndMin];

            default: {
                //判断两个时间是否在同一周
                if(c1.weekOfYear == c2.weekOfYear) { //同一周
                    if (offSetDate == 0) { //同一天

                        NSTimeInterval offsetSecond = [now timeIntervalSinceDate:realDate];

                        int hour = offsetSecond/60/60;
                        int minit  = offsetSecond/60;

                        if (hour >  0) { //显示 12:00格式
                            return HourAndMin;
                        } else if (minit > 0) {
                            //显示 12:00格式
                            return HourAndMin;
                        } else if (c3.second > 0) {
                            return @"刚刚";
                        } else {
                            return @"刚刚";
                        }
                    }

                    switch (c2.weekday) {
                        case 1:
                            return @"周日";
                        case 2:
                            return @"周一";
                        case 3:
                            return @"周二";
                        case 4:
                            return @"周三";
                        case 5:
                            return @"周四";
                        case 6:
                            return @"周五";
                        case 7:
                            return @"周六";
                        default:
                            return @"未知";
                    }
                } else {
                    //不在同一周、显示 月-日 格式
                    [dateFormatter setDateFormat:@"MM-dd"];
                }
            }
                break;
        }


        NSString *ttt = [dateFormatter stringFromDate:realDate];
        if ([ttt length] < 1) {
            return timeString;
        } else if ([ttt length] == 5) {
            NSString *temp = [ttt substringToIndex:1];
            if ([temp isEqualToString:@"0"]) {
                ttt = [ttt substringFromIndex:1];
            }

            temp = [ttt substringWithRange:NSMakeRange(2, 1)];
            if ([temp isEqualToString:@"0"]) {
                ttt = [[NSString alloc] initWithFormat:@"%@%@",[ttt substringToIndex:2],[ttt substringFromIndex:3]];
            }
        }

        return [[NSString alloc] initWithString:ttt];
    } else {
        NSLog(@"比较时间大于当前时间,不正常的情况。");
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *value = [dateFormatter stringFromDate:realDate];
        NSString *value1 = [value substringWithRange:NSMakeRange(5, 1)];
        NSString *value2 = [value substringWithRange:NSMakeRange(8, 1)];
        BOOL b1 = [value1 isEqualToString:@"0"];
        BOOL b2 = [value2 isEqualToString:@"0"];

        if (b1 && b2) {
            value = [[NSString alloc] initWithFormat:@"%@%@%@",[value substringToIndex:5],[value substringWithRange:NSMakeRange(6, 2)],[value substringFromIndex:9]];
        } else if (b1) {
            value = [[NSString alloc] initWithFormat:@"%@%@",[value substringToIndex:5],[value substringFromIndex:6]];
        } else if (b2) {
            value = [[NSString alloc] initWithFormat:@"%@%@",[value substringToIndex:8],[value substringFromIndex:9]];
        }
        value = [value substringFromIndex:2];
        return [[NSString alloc] initWithString:value];
    }

    return timeString;
}

+ (NSString *)getXingzuoWithMonth:(NSInteger)nMonth withDays:(NSInteger)nDays {
    //计算星座
    NSString *retStr=@"";
    NSInteger i_month=nMonth;
    NSInteger i_day=nDays;
    /*
     摩羯座 12月22日------1月19日
     水瓶座 1月20日-------2月18日
     双鱼座 2月19日-------3月20日
     白羊座 3月21日-------4月19日
     金牛座 4月20日-------5月20日
     双子座 5月21日-------6月21日
     巨蟹座 6月22日-------7月22日
     狮子座 7月23日-------8月22日
     处女座 8月23日-------9月22日
     天秤座 9月23日------10月23日
     天蝎座 10月24日-----11月21日
     射手座 11月22日-----12月21日
     */
    switch (i_month) {
        case 1:
            if(i_day>=20 && i_day<=31){
                retStr=@"水瓶座";
            }
            if(i_day>=1 && i_day<=19){
                retStr=@"摩羯座";
            }
            break;
        case 2:
            if(i_day>=1 && i_day<=18){
                retStr=@"水瓶座";
            }
            if(i_day>=19 && i_day<=31){
                retStr=@"双鱼座";
            }
            break;
        case 3:
            if(i_day>=1 && i_day<=20){
                retStr=@"双鱼座";
            }
            if(i_day>=21 && i_day<=31){
                retStr=@"白羊座";
            }
            break;
        case 4:
            if(i_day>=1 && i_day<=19){
                retStr=@"白羊座";
            }
            if(i_day>=20 && i_day<=31){
                retStr=@"金牛座";
            }
            break;
        case 5:
            if(i_day>=1 && i_day<=20){
                retStr=@"金牛座";
            }
            if(i_day>=21 && i_day<=31){
                retStr=@"双子座";
            }
            break;
        case 6:
            if(i_day>=1 && i_day<=21){
                retStr=@"双子座";
            }
            if(i_day>=22 && i_day<=31){
                retStr=@"巨蟹座";
            }
            break;
        case 7:
            if(i_day>=1 && i_day<=22){
                retStr=@"巨蟹座";
            }
            if(i_day>=23 && i_day<=31){
                retStr=@"狮子座";
            }
            break;
        case 8:
            if(i_day>=1 && i_day<=22){
                retStr=@"狮子座";
            }
            if(i_day>=23 && i_day<=31){
                retStr=@"处女座";
            }
            break;
        case 9:
            if(i_day>=1 && i_day<=22){
                retStr=@"处女座";
            }
            if(i_day>=23 && i_day<=31){
                retStr=@"天秤座";
            }
            break;
        case 10:
            if(i_day>=1 && i_day<=23){
                retStr=@"天秤座";
            }
            if(i_day>=24 && i_day<=31){
                retStr=@"天蝎座";
            }
            break;
        case 11:
            if(i_day>=1 && i_day<=21){
                retStr=@"天蝎座";
            }
            if(i_day>=22 && i_day<=31){
                retStr=@"射手座";
            }
            break;
        case 12:
            if(i_day>=1 && i_day<=21){
                retStr=@"射手座";
            }
            if(i_day>=21 && i_day<=31){
                retStr=@"摩羯座";
            }
            break;
    }
    return retStr;
}

+ (NSString *)formattedDateStringForDetaisViewFromString:(NSString *)dateString {
    
    NSString * retStr = nil;
    if (dateString == nil || ![dateString isKindOfClass:[NSString class]] || dateString.length == 0) {
        return retStr;
    }
    dateString = [dateString copy];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * formattedDate = [dateFormatter dateFromString:dateString];
    if (formattedDate != nil) {
        retStr = [UXDateUtils formattedDateStringForDetaisViewFromDate:formattedDate];
    } else {
        UXLogError(@"leiym -(%s)- 准备格式化的日期字符串，格式不正确！Errorrrrrrrrrr!!!!!", __FUNCTION__);
    }
    dateFormatter = nil;
    dateString = nil;
    
    return retStr;
}

+ (NSString *)formattedDateStringForDetaisViewFromDate:(NSDate *)formattedDate {
    NSString * retStr = nil;
    if (formattedDate == nil || ![formattedDate isKindOfClass:[NSDate class]]) {
        return retStr;
    }
    formattedDate = [formattedDate copy];
    NSDate * currentDate = [NSDate date];
    NSCalendar * calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone localTimeZone]];
    //1表示周日,2表示周一为每一周第一天
    [calendar setFirstWeekday:2];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"HH:mm"];
    //时间部分
    NSString * timeComponent = [dateFormatter stringFromDate:formattedDate];
    if (timeComponent.length > 0) {
        //用于时间间隔计算，因此用完整日期格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString * formattedDateStr = [dateFormatter stringFromDate:formattedDate];
        NSString * currentDateStr = [dateFormatter stringFromDate:currentDate];
        
        //当前日期的周数
        NSDateComponents * currentDateComponent = [calendar components:NSCalendarUnitWeekOfYear | NSCalendarUnitYear fromDate:currentDate];
        NSInteger currentWeekNum = [currentDateComponent weekOfYear];
        NSInteger currentYearNum = [currentDateComponent year];
        NSDateComponents * formattedDateComponent = [calendar components:NSCalendarUnitWeekOfYear | NSCalendarUnitYear | NSCalendarUnitWeekday fromDate:formattedDate];
        NSInteger formattedDateWeekNum = [formattedDateComponent weekOfYear];
        NSInteger formattedYearNum = [formattedDateComponent year];
        NSInteger formattedWeekDay = [formattedDateComponent weekday];
        
        NSInteger dateDiff = [[self class] dateDiffBetweenMinDateStr:formattedDateStr maxDateStr:currentDateStr];
        //与当前时间做比较
        switch (dateDiff) {
            case -1: {
                NSLog(@"leiym -- 记录生成时间大于当前时间，非法数据，直接显示完整的发生日期时间。");
                //格式后多一个空格
                [dateFormatter setDateFormat:@"yy-M-d "];
                retStr = [dateFormatter stringFromDate:formattedDate];
            } break;
            case 0:{
                retStr = @"今天 ";
            } break;
            case 1:{
                retStr = @"昨天 ";
            } break;
            case 2:{
                retStr = @"前天 ";
            } break;
            case 3:
            case 4:
            case 5:
            case 6:{
                if (currentWeekNum == formattedDateWeekNum) {
                    //在同一周，显示 周X 23:44:22
                    
                    NSString * abbreviationWeekDayStr = @"";
                    //替换文字 为 周一
                    switch (formattedWeekDay) {
                        case 1: {
                            abbreviationWeekDayStr = @"周日";
                        } break;
                        case 2: {
                            abbreviationWeekDayStr = @"周一";
                        } break;
                        case 3: {
                            abbreviationWeekDayStr = @"周二";
                        } break;
                        case 4: {
                            abbreviationWeekDayStr = @"周三";
                        } break;
                        case 5: {
                            abbreviationWeekDayStr = @"周四";
                        } break;
                        case 6: {
                            abbreviationWeekDayStr = @"周五";
                        } break;
                        case 7: {
                            abbreviationWeekDayStr = @"周六";
                        } break;
                        default:
                            break;
                    }
                    //检测，如不合法，直接跳过，最终返回nil
                    if (abbreviationWeekDayStr.length > 0) {
                        retStr = [NSString stringWithFormat:@"%@ ", abbreviationWeekDayStr];
                    }
                    
                } else {
                    //不在同一周，显示具体日期
                    if (currentYearNum != formattedYearNum) {
                        //如果不在同一年，则额外需要显示年份
                        [dateFormatter setDateFormat:@"yy-M-d "];
                    } else {
                        [dateFormatter setDateFormat:@"M-d "];
                    }
                    NSString * tempDateStr = [dateFormatter stringFromDate:formattedDate];
                    if (tempDateStr.length > 0) {
                        retStr = tempDateStr;
                    }
                }
            }
                break;
            default:{
                //大于7天，显示具体日期
                if (currentYearNum != formattedYearNum) {
                    //如果不在同一年，则额外需要显示年份
                    [dateFormatter setDateFormat:@"yy-M-d "];
                } else {
                    [dateFormatter setDateFormat:@"M-d "];
                }
                
                NSString * tempDateStr = [dateFormatter stringFromDate:formattedDate];
                if (tempDateStr.length > 0) {
                    retStr = tempDateStr;
                }
            } break;
        }
        
        //判断，如果retStr有值，再附上具体时间
        if (retStr != nil && retStr.length > 0) {
            retStr = [retStr stringByAppendingString:timeComponent];
        }
        
    } else {
        UXLogError(@"leiym -(%s)- 日期字符串格式化时，时间部分数据非法！Errorrrrrrrrrr!!!!!", __FUNCTION__);
    }
    dateFormatter = nil;
    formattedDate = nil;
    return retStr;
}

+ (double)intervalSinceNow:(NSString *)theDate {
    
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:[theDate integerValue]];
    NSTimeInterval late = [d timeIntervalSince1970]*1;
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now = [dat timeIntervalSince1970]*1;
    NSTimeInterval timeDiff = now - late;
    
    return timeDiff/3600;
}

/**
 * @brief 间隔判断辅助函数
 * @return YES满足在规定的时间、未达到最大次数
 */
+ (BOOL)ruleFor:(NSString *)key count:(int)maxcount interval:(NSTimeInterval)ival {
    
    BOOL ret = NO;
    
    NSString *countKey = [NSString stringWithFormat:@"%@_count_rule_", key, nil];
    NSString *dateKey = [NSString stringWithFormat:@"%@_date_rule_", key, nil];
    
    int count = (int)[UXUserDefaultManager getLocalDataInt:countKey];
    NSString *currDateStr = [UXDateUtils getStringFromDate:nil];
    if (count == 0) {
        ret = YES;
    } else if (count < maxcount) {
        NSString *lastDateStr = [UXUserDefaultManager getLocalDataString:dateKey];
        NSDate *lastDate = [UXDateUtils getDateFromString:lastDateStr];
        
        NSTimeInterval overallTimeTaken = [[NSDate date] timeIntervalSinceDate:lastDate];
        if (overallTimeTaken >= ival) {
            ret = YES;
        }
    }
    // 回写结果
    if (ret) {
        [UXUserDefaultManager setLocalDataInt:count+1 key:countKey];
        [UXUserDefaultManager setLocalDataString:currDateStr key:dateKey];
    }
    return ret;
}

+ (NSDateFormatter *)defaultDateFormatter {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return formatter;
}

@end
