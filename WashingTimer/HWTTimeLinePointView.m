//
//  HWTTimeLinePointView.m
//  WashingTimer
//
//  Created by yusuke on 2014/02/15.
//  Copyright (c) 2014年 Himakan. All rights reserved.
//

#import "HWTTimeLinePointView.h"

@interface HWTTimeLinePointView ()
@property (nonatomic) UILabel *label;
@property (nonatomic) UIView *circleView;
@end

@implementation HWTTimeLinePointView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if (self.type == kHWTTimeLinePointTypeBegin ||
        self.type == kHWTTimeLinePointTypeEnd) {
        
        CGRect rect = self.bounds;
        UIBezierPath *rectPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:1.5f];
        CAShapeLayer *rectLayer = [CAShapeLayer layer];
        rectLayer.path = rectPath.CGPath;
        rectLayer.fillColor = UIColorFromRGB(0x73c6d3).CGColor;
        [self.layer addSublayer:rectLayer];
        
        [self addSubview:self.label];
        self.label.frame = self.bounds;
        if (self.type ==    kHWTTimeLinePointTypeBegin) {
            self.label.text = @"開始";
        }
        else {
            self.label.text = @"終了";
        }
        
    }
    
    else {
        [self.label removeFromSuperview];
        
        CGSize size = rect.size;
        CGFloat radius = MIN(size.width, size.height) / 2;
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(size.width/2, size.height/2)
                                                                  radius:radius
                                                              startAngle:0.0f
                                                                endAngle:M_PI * 2.0f
                                                               clockwise:YES];
        
        CAShapeLayer *circleLayer = [CAShapeLayer layer];
        circleLayer.path = circlePath.CGPath;
        circleLayer.strokeColor = UIColorFromRGB(0x73c6d3).CGColor;
        circleLayer.fillColor = [UIColor whiteColor].CGColor;
        circleLayer.lineWidth = 2.0f;
        [self.layer addSublayer:circleLayer];
    }
}

#pragma mark - Getter

- (UILabel *)label {
    if (!_label) {
        _label = [UILabel new];
        _label.backgroundColor = [UIColor clearColor];
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont boldSystemFontOfSize:13];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

#pragma mark - Setter

- (void)setType:(HWTTimeLinePointType)type {
    _type = type;
    [self setNeedsDisplay];
}

@end
