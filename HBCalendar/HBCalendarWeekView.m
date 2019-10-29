//
//  HBCalendarWeekView.m
//  HBCalendar
//
//  Created by chenergou on 2017/11/2.
//  Copyright © 2017年 Hepburn. All rights reserved.
//

#import "HBCalendarWeekView.h"
#import <HBBasicLib/HBBasicLib.h>

@implementation HBCalendarWeekView

- (UIView *)weekBackView {
    if (!_weekBackView) {
        _weekBackView = [[UIView alloc] init];
        _weekBackView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1.0];
        _weekBackView.layer.cornerRadius = 5;
        _weekBackView.layer.masksToBounds = YES;
    }
    return _weekBackView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.weekBackView];
        self.weekBackView.frame = CGRectMake(0, (frame.size.height-30)/2, frame.size.width, 30);
    }
    return self;
}

- (void)setWeekTitles:(NSArray *)weekTitles{
    _weekTitles = weekTitles;
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            [subView removeFromSuperview];
        }
    }
    CGFloat width = self.width /weekTitles.count;
    for (int i = 0; i< weekTitles.count; i++) {
        UILabel *weekLabel = [UILabel CreateLabel:weekTitles[i] font:UICustomFont(14) color:[UIColor blackColor]];
        weekLabel.textAlignment = NSTextAlignmentCenter;
        weekLabel.frame = CGRectMake(i * width, 0, width, self.height);
        [self addSubview:weekLabel];
    }
}
@end
