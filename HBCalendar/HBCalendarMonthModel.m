
//
//  HBCalendarMonthModel.m
//  HBCalendar
//
//  Created by chenergou on 2017/11/2.
//  Copyright © 2017年 Hepburn. All rights reserved.
//

#import "HBCalendarMonthModel.h"
#import <HBBasicLib/HBBasicLib.h>

@implementation HBCalendarMonthModel
- (instancetype)initWithDate:(NSDate *)date {
    
    if (self = [super init]) {
        
        _monthDate = date;
        
        _totalDays = [self setupTotalDays];
        _firstWeekday = [self setupFirstWeekday];
        _year = [self setupYear];
        _month = [self setupMonth];
        
    }
    
    return self;
    
}


- (NSInteger)setupTotalDays {
    return _monthDate.numberOfDaysInMonth;
}

- (NSInteger)setupFirstWeekday {
    return _monthDate.firstWeekDayInMonth;
}

- (NSInteger)setupYear {
    return _monthDate.year;
}

- (NSInteger)setupMonth {
    return _monthDate.month;
}

@end
