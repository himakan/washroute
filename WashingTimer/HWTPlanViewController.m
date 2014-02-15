//
//  HWTPlanViewController.m
//  WashingTimer
//
//  Created by yusuke on 2014/02/15.
//  Copyright (c) 2014年 Himakan. All rights reserved.
//

#import "HWTPlanViewController.h"

#import <AMBlurView.h>
#import "HWTTimeLineEventCell.h"
#import "HWTTimeLinePointView.h"
#import "HWTTimeLineWeatherCell.h"
#import "HWTCommitCell.h"

@interface HWTPlanViewController ()
@property (nonatomic) AMBlurView *navigationBackgroundView;
@property (nonatomic) NSArray *verticalLineViews;
@property (nonatomic) NSArray *timelineData;
@end

@implementation HWTPlanViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"H:mm";

    NSMutableArray *timelineData = [NSMutableArray array];
    for (NSDictionary *event in self.eventsData) {
        
        NSString *type;
        if ([self.eventsData firstObject] == event) {
            type = @"begin";
        }
        else {
            type = @"circle";
        }
        
        NSDate *beginTime = [NSDate dateWithTimeIntervalSince1970:[event[@"beginTime"] doubleValue]];
        [timelineData addObject:@{@"cell" : @"event",
                                  @"type" : type,
                                  @"title" : event[@"title"],
                                  @"time" : [dateFormatter stringFromDate:beginTime]}];
        
        [timelineData addObject:@{@"type" : @"weather",
                                  @"weather" : event[@"weather"],
                                  @"temparature" : event[@"temparature"],
                                  @"windSpeed" : event[@"windSpeed"],
                                  @"humidity" : event[@"humidity"],}];
    }
    
    NSDictionary *event = [self.eventsData lastObject];
    NSDate *finishTime = [NSDate dateWithTimeIntervalSince1970:[event[@"finishTime"] doubleValue]];

    [timelineData addObject:@{@"cell" : @"event",
                              @"type" : @"end",
                              @"title" : @"洗濯終了",
                              @"time" : [dateFormatter stringFromDate:finishTime]}];

    
    self.timelineData = timelineData;
    
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.navigationController.navigationBar insertSubview:self.navigationBackgroundView atIndex:0];\
    UIEdgeInsets insets = UIEdgeInsetsMake(-20, 0, 0, 0);
    self.navigationBackgroundView.frame = UIEdgeInsetsInsetRect(self.navigationController.navigationBar.bounds,
                                                                insets);
    
    if (animated) {
        self.navigationBackgroundView.alpha = 0;
        [UIView animateWithDuration:0.3f animations:^{
            self.navigationBackgroundView.alpha = 1;
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    if (!animated) {
        [self.navigationBackgroundView removeFromSuperview];
        return;
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        self.navigationBackgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.navigationBackgroundView removeFromSuperview];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getter

- (AMBlurView *)navigationBackgroundView {
    if (!_navigationBackgroundView) {
        _navigationBackgroundView = [AMBlurView new];
        _navigationBackgroundView.userInteractionEnabled = NO;
    }
    return _navigationBackgroundView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 1;
    }
    return self.timelineData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kEventCellIdentifier = @"EventCell";
    static NSString *kWeatherCellIdentifier = @"WeatherCell";
    static NSString *kCommitCellIdentifier = @"CommitCell";
    
    if (indexPath.section == 1) {
        HWTCommitCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommitCellIdentifier
                                                              forIndexPath:indexPath];
        return cell;
    }
    
    NSDictionary *data = self.timelineData[indexPath.row];
    
    UITableViewCell *cell;
    if ([data[@"cell"] isEqualToString:@"event"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:kEventCellIdentifier
                                               forIndexPath:indexPath];
        
        HWTTimeLinePointType type;
        if ([data[@"type"] isEqualToString:@"begin"]) {
            type = kHWTTimeLinePointTypeBegin;
        }
        else if ([data[@"type"] isEqualToString:@"end"]) {
            type = kHWTTimeLinePointTypeEnd;
        }
        else {
            type = kHWTTimeLinePointTypeCircle;
        }
        
        HWTTimeLineEventCell *eventCell = (HWTTimeLineEventCell *)cell;
        eventCell.type = type;
        eventCell.titleLabel.text = data[@"title"];
        eventCell.timeLabel.text = data[@"time"];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:kWeatherCellIdentifier
                                               forIndexPath:indexPath];
        
        HWTTimeLineWeatherCell *weatherCell = (HWTTimeLineWeatherCell *)cell;
        weatherCell.mainLabel.text = [NSString stringWithFormat:@"%@ %@℃",
                                      data[@"weather"],
                                      data[@"temparature"]];
        weatherCell.subLabel.text = [NSString stringWithFormat:@"風速: %@m/s 湿度: %@%%",
                                     data[@"windSpeed"],
                                     data[@"humidity"]];
        
        
        NSString *weather = data[@"weather"];
        if ([weather rangeOfString:@"くもり"].location != NSNotFound) {
            weatherCell.weatherIconView.image = [UIImage imageNamed:@"icon_cloudy"];
        }
        else if ([weather rangeOfString:@"雨"].location != NSNotFound) {
            weatherCell.weatherIconView.image = [UIImage imageNamed:@"icon_rainy"];
        }
        else {
            weatherCell.weatherIconView.image = [UIImage imageNamed:@"icon_sunny"];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return 80.f;
    }
    NSDictionary *data = self.timelineData[indexPath.row];
    if ([data[@"cell"] isEqualToString:@"event"]) {
        return 50.f;
    }
    else {
        return 80.f;
    }
}

#pragma mark - UITableView Delegate

#pragma mark - Private Methods

//- (void)drawVerticalEventLines {
//    
//    HWTTimeLineEventCell *beginCell = nil;
//    CGRect beginCellRect = CGRectZero;
//    
//    if (self.verticalLineViews) {
//        for (UIView *lineView in self.verticalLineViews) {
//            [lineView removeFromSuperview];
//        }
//    }
//    
//    NSMutableArray *views = [NSMutableArray array];
//    
//    for (NSInteger i = 0, len = [self.tableView numberOfRowsInSection:0]; i < len; i++) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//        HWTTimeLineEventCell *cell = (HWTTimeLineEventCell *)[self.tableView cellForRowAtIndexPath:indexPath];
//        if (![cell isMemberOfClass:[HWTTimeLineEventCell class]]) {
//            continue;
//        }
//        
//        if (!beginCell) {
//            beginCell = cell;
//            beginCellRect = [self.tableView rectForRowAtIndexPath:indexPath];
//            continue;
//        }
//        
//        HWTTimeLineEventCell *endCell = cell;
//        CGRect rect = CGRectZero;
//        CGPoint beginCenter = [beginCell convertPoint:beginCell.pointView.center toView:beginCell];
//        beginCenter.y += beginCellRect.origin.y;
//        
//        CGRect endCellRect = [self.tableView rectForRowAtIndexPath:indexPath];
//        CGPoint endCenter = [endCell convertPoint:endCell.pointView.center toView:endCell];
//        endCenter.y += endCellRect.origin.y;
//        
//        rect.origin.x = beginCenter.x - 2;
//        rect.size.width = 4;
//        rect.origin.y = beginCenter.y + beginCell.pointView.bounds.size.height / 2;
//        rect.size.height = endCenter.y - endCell.pointView.bounds.size.height / 2 - rect.origin.y;
//
//        UIView *lineView = [UIView new];
//        lineView.backgroundColor = UIColorFromRGB(0x73c6d3);
//        lineView.frame = rect;
//        [self.tableView addSubview:lineView];
//        [views addObject:lineView];
//        
//        beginCell = endCell;
//        beginCellRect = endCellRect;
//    }
//    self.verticalLineViews = views;
//}

@end
