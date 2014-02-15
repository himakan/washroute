//
//  HWTTimeLineEventCell.m
//  WashingTimer
//
//  Created by yusuke on 2014/02/15.
//  Copyright (c) 2014年 Himakan. All rights reserved.
//

#import "HWTTimeLineEventCell.h"

@implementation HWTTimeLineEventCell

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.eventBackgroundView.layer.borderWidth = 1.f;
        self.eventBackgroundView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
