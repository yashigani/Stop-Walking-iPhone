//
//  SWManager.h
//  stop-walking-iPhone
//
//  Created by taiki on 11/12/13.
//  Copyright (c) 2013 yashigani. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kSWIManagerWarningWillShowNotificaiton;
extern NSString * const kSWIManagerWarningWillHideNotificaiton;

@interface SWIManager : NSObject
@property (assign) NSTimeInterval seconds;
@property (nonatomic) UIView *warningView;
@property UIImage *image;
@property (copy) NSString *text;
+ (BOOL)isAvailable;
+ (instancetype)sharedManager;
- (void)start;
- (void)stop;
- (void)showWarning;
- (void)hideWarning;

@end
