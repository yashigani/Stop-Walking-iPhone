//
//  SWIWindowController.h
//  stop-walking-iPhone
//
//  Created by taiki on 11/25/13.
//  Copyright (c) 2013 yashigani. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SWIWindow;

@interface SWIWindowController : NSObject
@property (strong, readonly) SWIWindow *window;
@property (strong) UIView *warningView;
@property (assign, getter=isManual) BOOL manual;
- (void)show;
- (void)hide:(BOOL)animate;
- (void)hideIfNeeded;

@end
