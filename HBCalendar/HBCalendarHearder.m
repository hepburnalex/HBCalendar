//
//  HBCalendarHearder.m
//  HBCalendar
//
//  Created by chenergou on 2017/11/2.
//  Copyright © 2017年 Hepburn. All rights reserved.
//

#import "HBCalendarHearder.h"
#import <Masonry/Masonry.h>
#import <HBBasicLib/HBBasicLib.h>

@interface HBCalendarHearder()
@end
@implementation HBCalendarHearder

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    self.dateLabel.font = titleFont;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [UILabel CreateLabel:@"" font:UISystemFont(19) color:[UIColor colorWithRed:0.14 green:0.09 blue:0.08 alpha:1.0]];
        _dateLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _dateLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _dateLabel;
}

- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [UIButton CreateImageButton:UIIMAGE_NAME(@"leftArrow") selectImage:nil];
        _leftBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleRightMargin;
        [_leftBtn addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton CreateImageButton:UIIMAGE_NAME(@"rightArrow") selectImage:nil];
        _rightBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin;
        [_rightBtn addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

-(void)setDateStr:(NSString *)dateStr{
    _dateStr = dateStr;
    self.dateLabel.text = dateStr;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.dateLabel];
        [self addSubview:self.leftBtn];
        [self addSubview:self.rightBtn];
        
        CGFloat height = frame.size.height;
        self.dateLabel.frame = self.bounds;
        self.leftBtn.frame = CGRectMake(0, 0, height, height);
        self.rightBtn.frame = CGRectMake(frame.size.width-height, 0, height, height);
    }
    return self;
}

- (void)leftClick:(UIButton *)sender {
    if (self.leftClickBlock) {
        self.leftClickBlock();
    }
}

- (void)rightClick:(UIButton *)sender {
    if (self.rightClickBlock) {
        self.rightClickBlock();
    }
}

- (void)setIsShowLeftAndRightBtn:(BOOL)isShowLeftAndRightBtn {
    _isShowLeftAndRightBtn = isShowLeftAndRightBtn;
    self.leftBtn.hidden = self.rightBtn.hidden = !isShowLeftAndRightBtn;
}

@end
