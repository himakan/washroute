//
//  HWTTimeLineCell.m
//  WashingTimer
//
//  Created by yusuke on 2014/02/15.
//  Copyright (c) 2014年 Himakan. All rights reserved.
//

#import "HWTTimeLineCell.h"

@implementation HWTTimeLineCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
