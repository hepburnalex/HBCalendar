//
//  HBCalendarView.h
//  HBCalendar
//
//  Created by chenergou on 2017/11/2.
//  Copyright © 2017年 Hepburn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBCalendarHearder.h"
#import "HBCalendarWeekView.h"

@interface HBCalendarView : UIView

//顶部头部
@property(nonatomic,strong) HBCalendarHearder *calendarHeader;
//星期头部
@property(nonatomic,strong) HBCalendarWeekView *calendarWeekView;
//
@property(nonatomic,strong) NSArray<NSNumber *> *dayPoints;

//选中的回调
@property(nonatomic,copy) void(^selectBlock)(NSInteger year ,NSInteger month ,NSInteger day);
//月份切换
@property(nonatomic,copy) void(^monthChangeBlock)(NSInteger month);

//当前月的title颜色
@property(nonatomic, strong) UIColor *currentMonthTitleColor;
//上月的title颜色
@property(nonatomic, strong) UIColor *lastMonthTitleColor;
//下月的title颜色
@property(nonatomic, strong) UIColor *nextMonthTitleColor;

//选中的字体颜色
@property(nonatomic, strong) UIColor *selectTitleColor;
//今日的title颜色
@property(nonatomic, strong) UIColor *todayTitleColor;

//选中的背景颜色
@property(nonatomic, strong) UIColor *selectBackColor;
//今日的背景颜色
@property(nonatomic, strong) UIColor *todayBackColor;

//提示点颜色
@property(nonatomic, strong) UIColor *pointColor;
//选中提示点颜色
@property(nonatomic, strong) UIColor *selectPointColor;
//今日提示点颜色
@property(nonatomic, strong) UIColor *todayPointColor;

//选中的是否动画效果
@property(nonatomic, assign) BOOL isHaveAnimation;
//是否禁止手势滚动
@property(nonatomic, assign) BOOL isCanScroll;
//是否显示上月，下月的按钮
@property(nonatomic, assign) BOOL isShowLastAndNextBtn;
//是否显示上月，下月的的数据
@property(nonatomic, assign) BOOL isShowLastAndNextDate;
//是否显示标题栏
@property(nonatomic, assign) BOOL isShowTitle;
//是否折叠
@property(nonatomic, assign) BOOL isFold;

//在配置好上面的属性之后执行
- (void)dealData;

@end
