//
//  HWTResultViewController.m
//  WashingTimer
//
//  Created by yusuke on 2014/02/15.
//  Copyright (c) 2014年 Himakan. All rights reserved.
//

#import "HWTResultViewController.h"
#import "HWTResultCell.h"

static NSString * const kCellIdentifier = @"CellIdentifier";

@interface HWTResultViewController ()
@property (nonatomic) UIImageView *logoView;
@property (nonatomic) UILabel *startTimeLabel;
@property (nonatomic) UISegmentedControl *segmentedControl;
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
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"H:m";
    self.startTimeLabel.text = [NSString stringWithFormat:@"開始時刻 %@",
                                [dateFormatter stringFromDate:[NSDate date]]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CGRect f = self.logoView.frame;
    f.origin.x = (self.view.bounds.size.width - f.size.width) / 2;
    f.origin.y = -170;
    self.logoView.frame = f;
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HWTResultCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    cell.numberLabel.text = [NSString stringWithFormat:@"%@", @(indexPath.row + 1)];
    cell.showsFastIcon = YES;
    cell.showsEasyIcon = YES;
    
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
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"早さ順",
                                                                        @"楽さ順",
                                                                        @"コスト順"]];
        _segmentedControl.tintColor = UIColorFromRGB(0x73c6d3);
        _segmentedControl.selectedSegmentIndex = 0;
    }
    return _segmentedControl;
}

@end
