//
//  HWTResultCell.h
//  WashingTimer
//
//  Created by yusuke on 2014/02/15.
//  Copyright (c) 2014年 Himakan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HWTResultCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *resultBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeStartLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeEndLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeIntervalLabel;
@property (weak, nonatomic) IBOutlet UILabel *routeLabel;
@property (weak, nonatomic) IBOutlet UIView *verticalLineView;

@property (nonatomic) BOOL showsFastIcon;
@property (nonatomic) BOOL showsEasyIcon;

@end
