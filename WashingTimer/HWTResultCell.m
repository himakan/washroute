//
//  HWTResultCell.m
//  WashingTimer
//
//  Created by yusuke on 2014/02/15.
//  Copyright (c) 2014年 Himakan. All rights reserved.
//

#import "HWTResultCell.h"

@interface HWTResultCell ()
@property (nonatomic) UIImageView *fastIconView;
@property (nonatomic) UIImageView *easyIconView;
@end

@implementation HWTResultCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    if (self.showsEasyIcon) {
        [self addSubview:self.easyIconView];
    } else {
        [self.easyIconView removeFromSuperview];
    }
    
    if (self.showsFastIcon) {
        [self addSubview:self.fastIconView];
    } else {
        [self.fastIconView removeFromSuperview];
    }
}

- (void)layoutSubviews {
    CGRect f;
    
    CGFloat width = CGRectGetMaxX(self.routeLabel.frame);
    
    if (self.showsEasyIcon) {
        f = self.easyIconView.frame;
        f.origin.x = width + 5;
        f.origin.y = self.routeLabel.frame.origin.y + (self.routeLabel.frame.size.height - f.size.height) / 2;
        self.easyIconView.frame = f;
        width = CGRectGetMaxX(self.easyIconView.frame);
    }
    
    if (self.showsFastIcon) {
        f = self.fastIconView.frame;
        f.origin.x = width + 5;
        f.origin.y = self.routeLabel.frame.origin.y + (self.routeLabel.frame.size.height - f.size.height) / 2;
        self.fastIconView.frame = f;
        width = CGRectGetMaxX(self.fastIconView.frame);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Getter

- (UIImageView *)fastIconView {
    if (!_fastIconView) {
        _fastIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_fast"]];
    }
    return _fastIconView;
}

- (UIImageView *)easyIconView {
    if (!_easyIconView) {
        _easyIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_easy"]];
    }
    return _easyIconView;
}

#pragma mark - Setter

- (void)setShowsEasyIcon:(BOOL)value {
    _showsEasyIcon = value;
    [self setNeedsDisplay];
}

- (void)setShowsFastIcon:(BOOL)value {
    _showsFastIcon = value;
    [self setNeedsDisplay];
}

@end
