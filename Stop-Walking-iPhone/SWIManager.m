//
//  SWManager.m
//  stop-walking-iPhone
//
//  Created by taiki on 11/12/13.
//  Copyright (c) 2013 yashigani. All rights reserved.
//

#import "SWIManager.h"

#import <CoreMotion/CoreMotion.h>

#import "SWIWarningView.h"
#import "SWIWindowController.h"

NSString * const kSWIManagerWarningDidShowNotificaiton = @"kSWIManagerWarningDidShowNotificaiton";
NSString * const kSWIManagerWarningDidHideNotificaiton = @"kSWIManagerWarningDidHideNotificaiton";

@interface SWIManager ()
@property (strong) CMMotionActivityManager *manager;
@property (assign, getter=isWorking) BOOL working;
@property (strong) NSTimer *timer;

@property (strong) SWIWindowController *windowController;
@end

@implementation SWIManager
@synthesize warningView = _warningView;

+ (BOOL)isAvailable
{
    return CMMotionActivityManager.isActivityAvailable;
}

+ (instancetype)sharedManager
{
    static SWIManager *_sharedManager = nil;
    static dispatch_once_t o;
    dispatch_once(&o, ^{
        _sharedManager = [self.class new];
    });
    return _sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _manager = [CMMotionActivityManager new];
        _seconds = 1.5;
        _windowController = [SWIWindowController new];
    }
    return self;
}

- (void)start
{
    if (!_working) {
        _working = YES;

        NSNotificationCenter *center = NSNotificationCenter.defaultCenter;
        [center addObserver:self
                   selector:@selector(windowDidBecomeKey:)
                       name:UIWindowDidBecomeKeyNotification
                     object:nil];
        [center addObserver:self
                   selector:@selector(windowDidResignKey:)
                       name:UIWindowDidResignKeyNotification
                     object:nil];

        __weak __typeof(self) wself = self;
        void (^handler)(CMMotionActivity *) = ^(CMMotionActivity *activity) {
            [wself handleActivity:activity];
        };
        [_manager startActivityUpdatesToQueue:NSOperationQueue.new
                                  withHandler:handler];
    }
}

- (void)stop
{
    [self hideWarning];
    _working = NO;
    [_manager stopActivityUpdates];
}

- (void)handleActivity:(CMMotionActivity *)activity
{
    BOOL shouldWarn = activity.walking || activity.running;
    if (!_windowController.window) {
        if (shouldWarn && !_timer) {
            self.timer = [self timerWithInterval:_seconds
                                        selector:@selector(showWarningFromTimer:)];
        }
        else if (!shouldWarn) {
            self.timer = nil;
        }
    }
    else {
        if (!_windowController.isManual && !shouldWarn) {
            __weak __typeof(self) wself = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [wself hideWarning];
            });
        }
    }
}

- (UIView *)warningView
{
    if (!_warningView) {
        SWIWarningView *v = [SWIWarningView new];
        v.image = self.image;
        v.text = self.text;
        [v sizeToFit];
        self.warningView = v;
    }
    return _warningView;
}

#pragma mark - Timer

- (NSTimer *)timerWithInterval:(NSTimeInterval)seconds selector:(SEL)selector
{
    NSDate *d = [NSDate dateWithTimeIntervalSinceNow:seconds];
    NSTimer *t = [[NSTimer alloc] initWithFireDate:d
                                          interval:0
                                            target:self
                                          selector:selector
                                          userInfo:nil
                                           repeats:NO];
    NSRunLoop *mainRunLoop = NSRunLoop.mainRunLoop;
    [mainRunLoop addTimer:t forMode:mainRunLoop.currentMode];
    return t;
}

- (void)setShowTimer:(NSTimer *)timer
{
    [_timer invalidate];
    _timer = timer;
}

#pragma mark - Show/Hide

- (void)showWarningFromTimer:(id)sender
{
    self.timer = nil;
    __weak __typeof(self) wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [wself showWarning:NO];
    });
}

- (void)showWarning
{
    [self showWarning:YES];
}

- (void)showWarning:(BOOL)manual
{
    _windowController.warningView = self.warningView;
    _windowController.manual = manual;
    [_windowController show];
}

- (void)hideWarning
{
    [self.windowController hide:YES];
}

#pragma mark - Window Notifications

- (void)windowDidBecomeKey:(NSNotification *)notification
{
    if (notification.object == _windowController.window) {
        __weak __typeof(self) wself = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [NSNotificationCenter.defaultCenter postNotificationName:kSWIManagerWarningDidShowNotificaiton
                                                              object:wself];
        });
    }
}

- (void)windowDidResignKey:(NSNotification *)notification
{
    if (notification.object == _windowController.window) {
        __weak __typeof(self) wself = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [NSNotificationCenter.defaultCenter postNotificationName:kSWIManagerWarningDidHideNotificaiton
                                                              object:wself];
        });
    }
}

@end
