//
//  HWTPlanViewController.h
//  WashingTimer
//
//  Created by yusuke on 2014/02/15.
//  Copyright (c) 2014年 Himakan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HWTPlanViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (nonatomic, copy) NSArray *eventsData;

@end
