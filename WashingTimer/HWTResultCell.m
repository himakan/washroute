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

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage alloc] init]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    if (self.showsEasyIcon) {
        [self.resultBackgroundView addSubview:self.easyIconView];
    } else {
        [self.easyIconView removeFromSuperview];
    }
    
    if (self.showsFastIcon) {
        [self.resultBackgroundView addSubview:self.fastIconView];
    } else {
        [self.fastIconView removeFromSuperview];
    }

    CGRect f;
    
    [self.routeLabel sizeToFit];
    CGFloat width = CGRectGetMaxX(self.routeLabel.frame);
    
    if (self.showsEasyIcon) {
        f = self.easyIconView.frame;
        f.origin.x = width + 5;
        f.origin.y = self.routeLabel.frame.origin.y + 5;
        self.easyIconView.frame = f;
        width = CGRectGetMaxX(self.easyIconView.frame);
    }
    
    if (self.showsFastIcon) {
        f = self.fastIconView.frame;
        f.origin.x = width + 5;
        f.origin.y = self.routeLabel.frame.origin.y + 5;
        self.fastIconView.frame = f;
        width = CGRectGetMaxX(self.fastIconView.frame);
    }
    
    [self.resultBackgroundView addSubview:self.timeStartLabel];
    [self.timeStartLabel sizeToFit];
    f = self.timeStartLabel.frame;
    f.origin.x = 42.f;
    f.origin.y = 11.f;
    self.timeStartLabel.frame = f;
    
    [self.resultBackgroundView addSubview:self.arrowImageView];
    f = self.arrowImageView.frame;
    f.origin.x = CGRectGetMaxX(self.timeStartLabel.frame) + 5;
    f.origin.y = self.timeStartLabel.frame.origin.y + (self.timeStartLabel.bounds.size.height - f.size.height) / 2;
    self.arrowImageView.frame = f;

    [self.resultBackgroundView addSubview:self.timeEndLabel];
    [self.timeEndLabel sizeToFit];
    f = self.timeEndLabel.frame;
    f.origin.x = CGRectGetMaxX(self.arrowImageView.frame) + 5;
    f.origin.y = self.timeStartLabel.frame.origin.y;
    self.timeEndLabel.frame = f;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    [self applySelectedColorSubviews:highlighted animated:animated];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self applySelectedColorSubviews:selected animated:animated];
}

- (void)applySelectedColorSubviews:(BOOL)selected animated:(BOOL)animated {
    [UIView animateWithDuration:(animated ? 0.3f : 0) animations:^{
        self.resultBackgroundView.backgroundColor = selected ? UIColorFromRGB(0x9cced3) : UIColorFromRGB(0xc7eef2);
        self.verticalLineView.backgroundColor = selected ? [UIColor lightGrayColor] : [UIColor whiteColor];
    }];
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

- (UILabel *)timeStartLabel {
    if (!_timeStartLabel) {
        _timeStartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _timeStartLabel.backgroundColor = [UIColor clearColor];
        _timeStartLabel.font = [UIFont boldSystemFontOfSize:24];
        _timeStartLabel.textColor = UIColorFromRGB(0x3c4849);
    }
    return _timeStartLabel;
}

- (UILabel *)timeEndLabel {
    if (!_timeEndLabel) {
        _timeEndLabel = [UILabel new];
        _timeEndLabel.backgroundColor = [UIColor clearColor];
        _timeEndLabel.font = [UIFont boldSystemFontOfSize:24];
        _timeEndLabel.textColor = UIColorFromRGB(0x3c4849);
    }
    return _timeEndLabel;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_time_arrow"]];
    }
    return _arrowImageView;
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
