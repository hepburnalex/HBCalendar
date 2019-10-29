//
//  HBCalendarWeekView.h
//  HBCalendar
//
//  Created by chenergou on 2017/11/2.
//  Copyright © 2017年 Hepburn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBCalendarWeekView : UIView

@property(nonatomic,strong) UIFont *weekFont;
@property(nonatomic,strong) UIView *weekBackView;
@property(nonatomic,strong) NSArray *weekTitles;

@end
