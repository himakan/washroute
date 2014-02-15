//
//  HWTTimeLineEventCell.h
//  WashingTimer
//
//  Created by yusuke on 2014/02/15.
//  Copyright (c) 2014年 Himakan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWTTimeLinePointView.h"

@interface HWTTimeLineEventCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *eventBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet HWTTimeLinePointView *pointView;
@property (weak, nonatomic) IBOutlet UIView *verticalTopLine;
@property (weak, nonatomic) IBOutlet UIView *verticalBottomLine;

@property (nonatomic) HWTTimeLinePointType type;

@end
