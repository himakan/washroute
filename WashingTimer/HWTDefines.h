//
//  HWTDefines.h
//  WashingTimer
//
//  Created by yusuke on 2014/02/15.
//  Copyright (c) 2014年 Himakan. All rights reserved.
//

#ifndef WashingTimer_HWTDefines_h
#define WashingTimer_HWTDefines_h

#ifdef DEBUG
#   define DLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#else
#   define DLog(...)
#endif

#define DateLog(fmt, date) ({\
NSDateFormatter *f = [[NSDateFormatter alloc] init]; \
f.dateStyle = f.timeStyle = NSDateFormatterShortStyle; \
DLog(fmt, [f stringFromDate:date])})

#ifndef NS_ENUM
#   define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#endif

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define NSStringFromBOOL(boolValue) (boolValue ? @"YES" : @"NO")

#define SAFE_BLOCK_CALL(__block) {if (__block) { __block(); }}
#define SAFE_BLOCK_CALL_ARG(__block, arg) {if (__block) { __block(arg); }}

#define OBJ_OR_NULL(obj) ((obj != nil) ? obj : [NSNull null])

// RGB color macro
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// RGB color macro with alpha
#define UIColorFromRGBWithAlpha(rgbValue,a) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

typedef void(^HWTBlock)(void);

#endif
