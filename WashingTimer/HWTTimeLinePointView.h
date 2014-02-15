//
//  HWTTimeLinePointView.h
//  WashingTimer
//
//  Created by yusuke on 2014/02/15.
//  Copyright (c) 2014年 Himakan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HWTTimeLinePointType) {
    kHWTTimeLinePointTypeBegin,
    kHWTTimeLinePointTypeCircle,
    kHWTTimeLinePointTypeEnd,
};

@interface HWTTimeLinePointView : UIView
@property (nonatomic) HWTTimeLinePointType type;
@end
