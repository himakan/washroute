//
//  HWTPlanViewController.m
//  WashingTimer
//
//  Created by yusuke on 2014/02/15.
//  Copyright (c) 2014年 Himakan. All rights reserved.
//

#import "HWTPlanViewController.h"

#import "HWTTimeLineEventCell.h"
#import "HWTTimeLinePointView.h"
#import "HWTTimeLineWeatherCell.h"

@interface HWTPlanViewController ()
@property (nonatomic) NSArray *verticalLineViews;
@property (nonatomic) NSArray *planData;
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

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"プラン1";
    
    [self.tableView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self drawVerticalEventLines];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getter

- (NSArray *)planData {
    if (!_planData) {
        _planData = @[@{@"cell" : @"event",  @"type" : @"begin", @"title" : @"洗濯開始", @"time" : @"10:00"},
                      @{@"cell" : @"weather"},
                      @{@"cell" : @"event", @"type" : @"circle", @"title" : @"洗濯終了、外干し", @"time" : @"10:40"},
                      @{@"cell" : @"weather"},
                      @{@"cell" : @"event", @"type" : @"circle", @"title" : @"雨なので部屋干し", @"time" : @"12:00"},
                      @{@"cell" : @"weather"},
                      @{@"cell" : @"event", @"type" : @"end", @"title" : @"乾燥終了", @"time" : @"18:00"},
                      ];
    }
    return _planData;
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
    return self.planData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kEventCellIdentifier = @"EventCell";
    static NSString *kWeatherCellIdentifier = @"WeatherCell";
    
    NSDictionary *data = self.planData[indexPath.row];
    
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
        ((HWTTimeLineEventCell *)cell).pointView.type = type;
        ((HWTTimeLineEventCell *)cell).titleLabel.text = data[@"title"];
        ((HWTTimeLineEventCell *)cell).timeLabel.text = data[@"time"];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:kWeatherCellIdentifier
                                               forIndexPath:indexPath];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *data = self.planData[indexPath.row];
    if ([data[@"cell"] isEqualToString:@"event"]) {
        return 50.f;
    }
    else {
        return 80.f;
    }
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

#pragma mark - Private Methods

- (void)drawVerticalEventLines {
    
    HWTTimeLineEventCell *beginCell = nil;
    CGRect beginCellRect = CGRectZero;
    
    if (self.verticalLineViews) {
        for (UIView *lineView in self.verticalLineViews) {
            [lineView removeFromSuperview];
        }
    }
    
    NSMutableArray *views = [NSMutableArray array];
    
    for (NSInteger i = 0, len = [self.tableView numberOfRowsInSection:0]; i < len; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        HWTTimeLineEventCell *cell = (HWTTimeLineEventCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        if (![cell isMemberOfClass:[HWTTimeLineEventCell class]]) {
            continue;
        }
        
        if (!beginCell) {
            beginCell = cell;
            beginCellRect = [self.tableView rectForRowAtIndexPath:indexPath];
            continue;
        }
        
        HWTTimeLineEventCell *endCell = cell;
        CGRect rect = CGRectZero;
        CGPoint beginCenter = [beginCell convertPoint:beginCell.pointView.center toView:beginCell];
        beginCenter.y += beginCellRect.origin.y;
        
        CGRect endCellRect = [self.tableView rectForRowAtIndexPath:indexPath];
        CGPoint endCenter = [endCell convertPoint:endCell.pointView.center toView:endCell];
        endCenter.y += endCellRect.origin.y;
        
        rect.origin.x = beginCenter.x - 2;
        rect.size.width = 4;
        rect.origin.y = beginCenter.y + beginCell.pointView.bounds.size.height / 2;
        rect.size.height = endCenter.y - endCell.pointView.bounds.size.height / 2 - rect.origin.y;

        UIView *lineView = [UIView new];
        lineView.backgroundColor = [UIColor darkGrayColor];
        lineView.frame = rect;
        [self.tableView addSubview:lineView];
        [views addObject:lineView];
        
        beginCell = endCell;
        beginCellRect = endCellRect;
    }
    self.verticalLineViews = views;
}

@end
