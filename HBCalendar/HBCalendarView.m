//
//  HBCalendarView.m
//  HBCalendar
//
//  Created by chenergou on 2017/11/2.
//  Copyright © 2017年 Hepburn. All rights reserved.
//

#import "HBCalendarView.h"
#import "HBCalendarCell.h"
#import "HBCalendarMonthModel.h"
#import "HBCalendarDayModel.h"
#import <HBBasicLib/HBBasicLib.h>

#define Calendar_Width CGFloatAutoFit(47)

@interface HBCalendarView()<UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic, strong) UICollectionView *collectionView;//日历
@property(nonatomic, strong) NSMutableArray *monthModels;//当月的模型集合
@property(nonatomic, strong) NSDate *currentMonthDate;//当月的日期
@property(nonatomic, strong) UISwipeGestureRecognizer *leftSwipe;//左滑手势
@property(nonatomic, strong) UISwipeGestureRecognizer *rightSwipe;//右滑手势
@property(nonatomic, strong) HBCalendarDayModel *selectModel;
@property(nonatomic, assign) NSInteger selectWeekNum;

@end

@implementation HBCalendarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.currentMonthDate = [NSDate date];
        [self setup];
    }
    return self;
}

- (void)dealData {
    [self responData];
}

- (void)setup {
    self.pointColor = kLightOrangeColor;
    self.selectPointColor = [UIColor whiteColor];
    self.todayPointColor = [UIColor whiteColor];
    self.currentMonthTitleColor = UICOLORHEX(@"0x333333");
    self.lastMonthTitleColor = UICOLORHEX(@"0xCCCCCC");
    self.nextMonthTitleColor = UICOLORHEX(@"0xCCCCCC");
    self.todayBackColor = UICOLORHEX(@"EAEAEA");
    self.todayTitleColor = UICOLORHEX(@"0x333333");
    self.selectBackColor = UICOLORHEX(@"F2BE6A");
    self.selectTitleColor = [UIColor whiteColor];
    
    [self addSubview:self.calendarHeader];
    WS(weakSelf);
    self.calendarHeader.leftClickBlock = ^{
        [weakSelf rightSlide];
    };
    self.calendarHeader.rightClickBlock = ^{
        [weakSelf leftSlide];
    };
    [self addSubview:self.calendarWeekView];
    [self addSubview:self.collectionView];
    
    self.height = self.collectionView.bottom;
    
    //添加左滑右滑手势
    self.leftSwipe =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftSlide)];
    self.leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.collectionView addGestureRecognizer:self.leftSwipe];
    
    self.rightSwipe =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightSlide)];
    self.rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.collectionView addGestureRecognizer:self.rightSwipe];
}

#pragma mark --左滑处理--
- (void)leftSlide {
    self.currentMonthDate = [self.currentMonthDate nextMonthDate];
    [self performAnimations:kCATransitionFromRight];
    [self responData];
}

#pragma mark --右滑处理--
- (void)rightSlide {
    self.currentMonthDate = [self.currentMonthDate previousMonthDate];
    [self performAnimations:kCATransitionFromLeft];
    [self responData];
}

#pragma mark--动画处理--
- (void)performAnimations:(NSString *)transition {
    CATransition *catransition = [CATransition animation];
    catransition.duration = 0.5;
    [catransition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    catransition.type = kCATransitionPush; //choose your animation
    catransition.subtype = transition;
    [self.collectionView.layer addAnimation:catransition forKey:nil];
}

#pragma mark--数据以及更新处理--
- (void)responData {
    [self.monthModels removeAllObjects];
    
    NSDate *previousMonthDate = [self.currentMonthDate previousMonthDate];
    
    //    NSDate *nextMonthDate = [self.currentMonthDate  nextMonthDate];
    
    HBCalendarMonthModel *monthModel = [[HBCalendarMonthModel alloc]initWithDate:self.currentMonthDate];
    HBCalendarMonthModel *lastMonthModel = [[HBCalendarMonthModel alloc]initWithDate:previousMonthDate];
    
    //     HBCalendarMonthModel *nextMonthModel = [[HBCalendarMonthModel alloc]initWithDate:nextMonthDate];
    
    self.calendarHeader.dateStr = [NSString stringWithFormat:@"%ld年%ld月",(long)monthModel.year,(long)monthModel.month];
    if (_monthChangeBlock) {
        _monthChangeBlock(monthModel.month);
    }
    
    NSInteger firstWeekday = monthModel.firstWeekday;
    NSInteger totalDays = monthModel.totalDays;
    
    for (int i = 0; i <42; i++) {
        HBCalendarDayModel *model =[[HBCalendarDayModel alloc] init];
        
        //配置外面属性
        [self configDayModel:model];
        
        model.firstWeekday = firstWeekday;
        model.totalDays = totalDays;
        model.month = monthModel.month;
        model.year = monthModel.year;

        //上个月的日期
        if (i < firstWeekday) {
            model.day = lastMonthModel.totalDays - (firstWeekday - i) + 1;
            model.isLastMonth = YES;
        }
        
        //当月的日期
        if (i >= firstWeekday && i < (firstWeekday + totalDays)) {
            model.day = i -firstWeekday +1;
            model.isCurrentMonth = YES;
            
            //标识是今天
            if ((monthModel.month == [NSDate date].month) && (monthModel.year == [NSDate date].year)) {
                if (i == [NSDate date].day + firstWeekday - 1) {
                    model.isToday = YES;
                    if (!self.selectModel) {
                        model.isSelected = YES;
                    }
                }
            }
        }
        //下月的日期
        if (i >= (firstWeekday + monthModel.totalDays)) {
            model.day = i -firstWeekday - monthModel.totalDays +1;
            model.isNextMonth = YES;
        }
        [self.monthModels addObject:model];
    }
    
    
    [self.monthModels enumerateObjectsUsingBlock:^(HBCalendarDayModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ((obj.year == self.selectModel.year) && (obj.month == self.selectModel.month) && (obj.day == self.selectModel.day)) {
            obj.isSelected = YES;
        }
    }];
    [self.collectionView reloadData];
}

- (void)configDayModel:(HBCalendarDayModel *)model {
    //配置外面属性
    model.isHaveAnimation = self.isHaveAnimation;
    model.currentMonthTitleColor = self.currentMonthTitleColor;
    model.lastMonthTitleColor = self.lastMonthTitleColor;
    model.nextMonthTitleColor = self.nextMonthTitleColor;
    model.selectTitleColor = self.selectTitleColor;
    model.todayTitleColor = self.todayTitleColor;
    model.selectBackColor = self.selectBackColor;
    model.todayBackColor = self.todayBackColor;
    model.pointColor = self.pointColor;
    model.todayPointColor = self.todayPointColor;
    model.selectPointColor = self.selectPointColor;
    model.isShowLastAndNextDate = self.isShowLastAndNextDate;
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.monthModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIndentifier = @"HBCalendarCell";
    HBCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifier forIndexPath:indexPath];
    if (!cell) {
        cell =[[HBCalendarCell alloc]init];
    }
    cell.model = self.monthModels[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HBCalendarDayModel *model = self.monthModels[indexPath.row];
    model.isSelected = YES;
    
    //选中的day
    self.selectModel = model;
    [self.monthModels enumerateObjectsUsingBlock:^(HBCalendarDayModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj != model) {
            obj.isSelected = NO;
        }
    }];
    
    if (self.selectBlock) {
        self.selectBlock(model.year, model.month, model.day);
    }
    [collectionView reloadData];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_isShowTitle) {
        self.calendarHeader.hidden = NO;
        self.calendarHeader.frame = CGRectMake(0, 0, self.width, Calendar_Width);
    }
    else {
        self.calendarHeader.hidden = YES;
        self.calendarHeader.frame = CGRectMake(0, 0, self.width, 0);
    }
    self.calendarWeekView.frame = CGRectMake(0, self.calendarHeader.bottom, self.width, Calendar_Width);
    if (_isFold) {
        self.collectionView.userInteractionEnabled = NO;
        self.collectionView.frame = CGRectMake(0, self.calendarWeekView.bottom, self.width, Calendar_Width);
        self.collectionView.contentOffset = CGPointMake(0, Calendar_Width*self.selectWeekNum);
        NSLog(@"%f, %f, %f", self.collectionView.contentOffset.y, Calendar_Width, self.width);
    }
    else {
        self.collectionView.userInteractionEnabled = YES;
        self.collectionView.frame = CGRectMake(0, self.calendarWeekView.bottom, self.width, 6 * Calendar_Width);
        self.collectionView.contentOffset = CGPointMake(0, 0);
    }
    CGRect frame = self.frame;
    frame.size.height = CGRectGetMaxY(self.collectionView.frame);
    self.frame = frame;
}

#pragma mark---懒加载
- (HBCalendarHearder *)calendarHeader {
    if (!_calendarHeader) {
        _calendarHeader = [[HBCalendarHearder alloc] initWithFrame:CGRectMake(0, 0, self.width, Calendar_Width)];
        _calendarHeader.backgroundColor = [UIColor whiteColor];
    }
    return _calendarHeader;
}

- (HBCalendarWeekView *)calendarWeekView {
    if (!_calendarWeekView) {
        _calendarWeekView = [[HBCalendarWeekView alloc] initWithFrame:CGRectMake(0, self.calendarHeader.bottom, self.width, Calendar_Width)];
        _calendarWeekView.weekTitles = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    }
    return _calendarWeekView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flow =[[UICollectionViewFlowLayout alloc]init];
        //325*403
        flow.minimumInteritemSpacing = 0;
        flow.minimumLineSpacing = 0;
        flow.sectionInset = UIEdgeInsetsMake(0 , 0, 0, 0);
        
        CGFloat width = Calendar_Width;
        CGFloat height = Calendar_Width;
        flow.itemSize = CGSizeMake(width, height);
        _collectionView =[[UICollectionView alloc] initWithFrame:CGRectMake(0, self.calendarWeekView.bottom, self.width, 6 * Calendar_Width) collectionViewLayout:flow];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollsToTop = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[HBCalendarCell class] forCellWithReuseIdentifier:@"HBCalendarCell"];
    }
    return _collectionView;
}

- (NSMutableArray *)monthModels {
    if (!_monthModels) {
        _monthModels = [NSMutableArray array];
    }
    return _monthModels;
}

#pragma mark - Property

- (void)setWeekTitles:(NSArray *)weekTitles {
    _weekTitles = weekTitles;
    _calendarWeekView.weekTitles = _weekTitles;
}

/*
 * 是否禁止手势滚动
 */
- (void)setIsCanScroll:(BOOL)isCanScroll{
    _isCanScroll = isCanScroll;
    self.leftSwipe.enabled = self.rightSwipe.enabled = isCanScroll;
}

/*
 * 是否显示上月，下月的按钮
 */
- (void)setIsShowLastAndNextBtn:(BOOL)isShowLastAndNextBtn{
    _isShowLastAndNextBtn  = isShowLastAndNextBtn;
    self.calendarHeader.isShowLeftAndRightBtn = isShowLastAndNextBtn;
}

- (void)setIsShowTitle:(BOOL)isShowTitle {
    _isShowTitle = isShowTitle;
    [self layoutSubviews];
}

- (void)setIsFold:(BOOL)isFold {
    _isFold = isFold;
    [self layoutSubviews];
}

- (NSInteger)selectWeekNum {
    NSInteger iSelectIndex = -1;
    NSInteger iTodayIndex = -1;
    for (int i = 0; i < self.monthModels.count; i ++) {
        HBCalendarDayModel *model = self.monthModels[i];
        if (model.isSelected) {
            iSelectIndex = i;
        }
        if (model.isToday) {
            iTodayIndex = i;
        }
    }
    if (iSelectIndex == -1) {
        if (iTodayIndex != -1) {
            NSInteger weekNum = iTodayIndex/7;
            if (iTodayIndex%7>0) {
                weekNum++;
            }
            return weekNum;
        }
    }
    else {
        NSInteger weekNum = iSelectIndex/7;
        if (iSelectIndex%7>0) {
            weekNum++;
        }
        return weekNum;
    }
    return 0;
}

- (void)setDayPoints:(NSArray<NSNumber *> *)dayPoints {
    _dayPoints = dayPoints;
    for (int i = 0; i < self.monthModels.count; i ++) {
        HBCalendarDayModel *model = self.monthModels[i];
        if (model.isCurrentMonth) {
            if (model.day < self.dayPoints.count) {
                BOOL isShowPoint = [_dayPoints[model.day-1] boolValue];
                model.isShowPoint = isShowPoint;
            }
        }
    }
    [self.collectionView reloadData];
}

@end
