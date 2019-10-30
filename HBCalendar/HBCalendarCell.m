//
//  HBCalendarCell.m
//  HBCalendar
//
//  Created by chenergou on 2017/11/2.
//  Copyright © 2017年 Hepburn. All rights reserved.
//

#import "HBCalendarCell.h"
#import <HBBasicLib/HBBasicLib.h>

@interface HBCalendarCell()

@end

@implementation HBCalendarCell

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:CGFloatAutoFit(16)];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

- (UIView *)pointView {
    if (!_pointView) {
        _pointView = [[UIView alloc] init];
        _pointView.backgroundColor = UICOLORHEX(@"F2BE6A");
        _pointView.cornerRadius = 2;
        _pointView.shouldRasterize = YES;
        _pointView.hidden = YES;
    }
    return _pointView;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.label];
        CGFloat width = round(frame.size.width*0.8);
        self.label.frame = CGRectMake((frame.size.width-width)/2, (frame.size.height-width)/2, width, width);
        self.label.autoresizingMask = UIViewAutoresizingFlexibleFourMargin;
        [self addSubview:self.pointView];
        self.pointView.frame = CGRectMake((frame.size.width-4)/2, CGRectGetMaxY(self.label.frame)-6, 4, 4);
        self.pointView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin;
    }
    return self;
}

- (void)setModel:(HBCalendarDayModel *)model{
    _model = model;
    self.label.text = [NSString stringWithFormat:@"%d",(int)model.day];
    self.label.cornerRadius = 0.0;
    self.label.backgroundColor = [UIColor whiteColor];
    self.pointView.backgroundColor = model.pointColor;
    
    if (model.isNextMonth || model.isLastMonth) {
        self.userInteractionEnabled = NO;
        self.pointView.hidden = YES;
        if (model.isShowLastAndNextDate) {
            self.label.hidden = NO;
            if (model.isNextMonth) {
                self.label.textColor = model.nextMonthTitleColor? model.nextMonthTitleColor:UICOLORWHITE(0.85);
            }
            if (model.isLastMonth) {
                self.label.textColor = model.lastMonthTitleColor? model.lastMonthTitleColor:UICOLORWHITE(0.85);
            }
        }
        else{
            self.label.hidden = YES;
        }
    }
    else{
        self.pointView.hidden = !model.isShowPoint;
        self.label.hidden = NO;
        self.userInteractionEnabled = YES;
        self.label.textColor = model.currentMonthTitleColor;
        if (model.isToday) {
            self.label.cornerRadius = self.label.width/2;
            self.label.textColor = model.todayTitleColor?model.todayTitleColor:UICOLORHEX(@"0x333333");
            self.label.backgroundColor = model.todayBackColor?model.todayBackColor:UICOLORHEX(@"EAEAEA");
            self.pointView.backgroundColor = model.todayPointColor;
        }
        if (model.isSelected) {
            self.label.cornerRadius = self.label.width/2;
            self.label.backgroundColor = model.selectBackColor;
            self.label.textColor = model.selectTitleColor;
            self.pointView.backgroundColor = model.selectPointColor;
            if (model.isHaveAnimation) {
                 [self addAnimaiton];
            }
        }
    }
}

- (void)addAnimaiton{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.values = @[@0.6,@1.2,@1.0];
//    anim.fromValue = @0.6;
    anim.keyPath = @"transform.scale";  // transform.scale 表示长和宽都缩放
    anim.calculationMode = kCAAnimationPaced;
    anim.duration = 0.25;                // 设置动画执行时间
//    anim.repeatCount = MAXFLOAT;        // MAXFLOAT 表示动画执行次数为无限次
    
//    anim.autoreverses = YES;            // 控制动画反转 默认情况下动画从尺寸1到0的过程中是有动画的，但是从0到1的过程中是没有动画的，设置autoreverses属性可以让尺寸0到1也是有过程的
    
    [self.label.layer addAnimation:anim forKey:nil];
}

@end
