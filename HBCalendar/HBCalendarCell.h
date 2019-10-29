//
//  HBCalendarCell.h
//  HBCalendar
//
//  Created by chenergou on 2017/11/2.
//  Copyright © 2017年 Hepburn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBCalendarDayModel.h"

@interface HBCalendarCell : UICollectionViewCell

@property(nonatomic, strong) UILabel *label;
@property(nonatomic, strong) UIView *pointView;
@property(nonatomic, strong) HBCalendarDayModel *model;

@end
