//
//  HBCalendarHearder.h
//  HBCalendar
//
//  Created by chenergou on 2017/11/2.
//  Copyright © 2017年 Hepburn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBCalendarHearder : UIView

@property(nonatomic,strong) UIFont *titleFont;
@property(nonatomic,strong) UIButton *leftBtn;
@property(nonatomic,strong) UIButton *rightBtn;
@property(nonatomic,strong) UILabel *dateLabel;
@property(nonatomic,assign) BOOL isShowLeftAndRightBtn; //是否显示左右两侧按钮
@property(nonatomic,strong) NSString *dateStr;
@property(nonatomic,strong) void(^leftClickBlock)(void);
@property(nonatomic,strong) void(^rightClickBlock)(void);

@end
