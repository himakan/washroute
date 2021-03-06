//
//  HWTResultViewController.m
//  WashingTimer
//
//  Created by yusuke on 2014/02/15.
//  Copyright (c) 2014年 Himakan. All rights reserved.
//

#import "HWTResultViewController.h"

#import <DejalActivityView/DejalActivityView.h>
#import <MKNetworkKit/MKNetworkKit.h>

#import "HWTPlanViewController.h"
#import "HWTResultCell.h"

static NSString * const kCellIdentifier = @"CellIdentifier";

@interface HWTResultViewController ()
@property (nonatomic) UIImageView *logoView;
@property (nonatomic) UILabel *startTimeLabel;
@property (nonatomic) UISegmentedControl *segmentedControl;
@property (nonatomic) NSArray *plansData;
@property (nonatomic) NSArray *originalPlansData;
@end

@implementation HWTResultViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        UINib *nib = [UINib nibWithNibName:@"HWTResultCell" bundle:nil];
        [self.tableView registerNib:nib forCellReuseIdentifier:kCellIdentifier];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // scrollViewの自動拡張をオフ
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    // ナビゲーションバーを削除
    self.navigationItem.titleView = nil;
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init]
                                                  forBarMetrics:UIBarMetricsDefault];

    // ナビゲーションバーの下線を削除する
    for (UIView *view in self.navigationController.navigationBar.subviews) {
        if ([NSStringFromClass([view class]) isEqualToString:@"_UINavigationBarBackground"]) {
            for (UIView *subview in view.subviews) {
                if ([subview isKindOfClass:[UIImageView class]]) {
                    [subview removeFromSuperview];
                    break;
                }
            }
        }
    }
    
    [self.tableView addSubview:self.logoView];
    [self.tableView addSubview:self.startTimeLabel];
    [self.tableView addSubview:self.segmentedControl];
    self.tableView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CGRect f = self.logoView.frame;
    f.origin.x = (self.view.bounds.size.width - f.size.width) / 2;
    f.origin.y = -170;
    self.logoView.frame = f;
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"H:m";
    self.startTimeLabel.text = [NSString stringWithFormat:@"開始時刻 %@",
                                [dateFormatter stringFromDate:[NSDate date]]];
    
    [self.startTimeLabel sizeToFit];
    f = self.startTimeLabel.frame;
    f.origin.x = (self.view.bounds.size.width - f.size.width) / 2;
    f.origin.y = CGRectGetMaxY(self.logoView.frame) + 20;
    self.startTimeLabel.frame = f;
    
    f = self.segmentedControl.frame;
    f.origin.x = (self.view.bounds.size.width - f.size.width) / 2;
    f.origin.y = CGRectGetMaxY(self.startTimeLabel.frame) + 20;
    self.segmentedControl.frame = f;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.plansData) {
        [self startLoading];
    }
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)startLoading {
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"読み込み中..."];

    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"H:m";
    self.startTimeLabel.text = [NSString stringWithFormat:@"開始時刻 %@",
                                [dateFormatter stringFromDate:[NSDate date]]];
    
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:@"wu-tang.sakura.ne.jp"];
    MKNetworkOperation *op = [engine operationWithPath:@"ohd/washRoute.php"];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        [self endLoading];
        
        NSDictionary *result = [completedOperation responseJSON];
        self.plansData = self.originalPlansData = [self addBadgeData:result[@"plans"]];
        [self segmentedControlChanged:self.segmentedControl];
        [self.tableView reloadData];
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [self endLoading];
    }];
    [engine enqueueOperation:op];
}

- (void)endLoading {
    [DejalBezelActivityView removeViewAnimated:YES];
}

- (NSArray *)addBadgeData:(NSArray *)sourceData {
    
    if (sourceData.count == 0) {
        return sourceData;
    }
    
    NSMutableArray *sourceDataMutable = [NSMutableArray array];
    NSDictionary *mostEasyPlan, *mostFastPlan;
    
    for (NSDictionary *plan in sourceData) {
        NSMutableDictionary *mutablePlan = [plan mutableCopy];
        [sourceDataMutable addObject:mutablePlan];
        
        if ([mutablePlan[@"endTime"] isEqual:[NSNull null]]) {
            mutablePlan[@"endTime"] = [mutablePlan[@"events"] lastObject][@"finishTime"];
        }

        if (!mostFastPlan && !mostFastPlan) {
            mostFastPlan = mutablePlan;
            mostEasyPlan = mutablePlan;
            continue;
        }
        
        if ([mostEasyPlan[@"events"] count] > [mutablePlan[@"events"] count]) {
            mostEasyPlan = mutablePlan;
        }
        
        if ([mostFastPlan[@"endTime"] doubleValue] - [mostFastPlan[@"beginTime"] doubleValue] >
            [mutablePlan[@"endTime"] doubleValue] - [mutablePlan[@"beginTime"] doubleValue]) {
            mostFastPlan = mutablePlan;
        }
    }
    
    for (NSMutableDictionary *plan in sourceDataMutable) {
        if ([mostFastPlan isEqual:plan]) {
            plan[@"fast"] = @YES;
        }
        if ([mostEasyPlan isEqual:plan]) {
            plan[@"easy"] = @YES;
        }
    }
    
    DLog(@"sourceDataMutable = %@", sourceDataMutable);

    return sourceDataMutable;
}

- (void)segmentedControlChanged:(UISegmentedControl *)control {
    if (control.selectedSegmentIndex == 0) {
        self.plansData = self.originalPlansData;
    }
    else if (control.selectedSegmentIndex == 1) {
        self.plansData = [self.plansData sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1,
                                                                                        NSDictionary *obj2) {
            if ([obj1[@"endTime"] doubleValue] - [obj1[@"beginTime"] doubleValue] >
                [obj2[@"endTime"] doubleValue] - [obj2[@"beginTime"] doubleValue]) {
                return NSOrderedDescending;
            } else {
                return NSOrderedAscending;
            }
        }];
    } else {
        self.plansData = [self.plansData sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1,
                                                                                        NSDictionary *obj2) {
            if ([obj1[@"events"] count] < [obj2[@"events"] count]) {
                return NSOrderedAscending;
            } else {
                return NSOrderedDescending;
            }
        }];
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.plansData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HWTResultCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.numberLabel.text = [NSString stringWithFormat:@"%@", @(indexPath.row + 1)];
    
    NSDictionary *data = self.plansData[indexPath.row];
    NSDate *beginTime = [NSDate dateWithTimeIntervalSince1970:[data[@"beginTime"] doubleValue]];
    NSDate *endTime = [NSDate dateWithTimeIntervalSince1970:[data[@"endTime"] doubleValue]];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"H:mm";
    
    cell.timeStartLabel.text = [dateFormatter stringFromDate:beginTime];
    
    NSTimeInterval duration = [endTime timeIntervalSinceDate:beginTime];
    NSInteger hour = (NSInteger)(duration / 60.f / 60.f);
    
    NSDateFormatter *hourFormatter = [NSDateFormatter new];
    hourFormatter.dateFormat = @"H";
    NSInteger beforeHour = [[hourFormatter stringFromDate:beginTime] integerValue];
    
    NSString *endPrefix = @"";
    if (hour + beforeHour >= 24) {
        endPrefix = @"翌";
    }
    if (hour + beforeHour >= 48) {
        endPrefix = @"翌々";
    }
    cell.timeEndLabel.text = [NSString stringWithFormat:@"%@%@",
                              endPrefix,
                              [dateFormatter stringFromDate:endTime]];
    
    cell.timeIntervalLabel.text = [NSString stringWithFormat:@"%@hour", @(hour)];
    
    cell.showsFastIcon = [data[@"fast"] boolValue];
    cell.showsEasyIcon = [data[@"easy"] boolValue];
    
    if ([data[@"events"] count] > 1) {
        cell.routeLabel.text = data[@"events"][1][@"title"];
    } else {
        cell.routeLabel.text = [data[@"events"] lastObject][@"title"];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.f;
}

#pragma mark - Getter

- (UIImageView *)logoView {
    if (!_logoView) {
        _logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    }
    return _logoView;
}

- (UILabel *)startTimeLabel {
    if (!_startTimeLabel) {
        _startTimeLabel = [UILabel new];
        _startTimeLabel.backgroundColor = [UIColor clearColor];
        _startTimeLabel.textColor = UIColorFromRGB(0x4e5a5b);
    }
    return _startTimeLabel;
}

- (UISegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"快適順",
                                                                        @"早さ順",
                                                                        @"楽さ順",]];
        _segmentedControl.tintColor = UIColorFromRGB(0x73c6d3);
        _segmentedControl.selectedSegmentIndex = 0;
        [_segmentedControl addTarget:self
                              action:@selector(segmentedControlChanged:)
                    forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)cell {
    if ([segue.identifier isEqualToString:@"detail"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        NSDictionary *data = self.plansData[indexPath.row];
        
        HWTPlanViewController *planViewController = segue.destinationViewController;
        planViewController.title = [NSString stringWithFormat:@"プラン%@", @(indexPath.row + 1)];
        planViewController.eventsData = data[@"events"];
    }
}

- (IBAction)reloadButtonTapped:(id)sender {
    [self startLoading];
}

@end
