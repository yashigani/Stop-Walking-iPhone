//
//  SWIWindowController.m
//  stop-walking-iPhone
//
//  Created by taiki on 11/25/13.
//  Copyright (c) 2013 yashigani. All rights reserved.
//

#import "SWIWindowController.h"

#import "SWIWindow.h"

@interface SWIWindowController ()
@property (strong, readwrite) SWIWindow *window;
@property (strong, ) UIWindow *originalWindow;
@property (assign, ) BOOL shouldHide;
@end

@implementation SWIWindowController

- (void)show
{
    if (!_window) {
        _originalWindow = UIApplication.sharedApplication.keyWindow;
        _window = [SWIWindow new];
        _window.controller = self;
        _window.warningView = _warningView;
        _warningView.center = _window.center;
        [_window addSubview:_warningView];
        _warningView.transform = CGAffineTransformIdentity;
        [NSNotificationCenter.defaultCenter addObserver:self
                                               selector:@selector(windowDidBecomeKey:)
                                                   name:UIWindowDidBecomeKeyNotification
                                                 object:_window];
        [_window makeKeyAndVisible];
    }
}

- (void)hide:(BOOL)animate
{
    if (_window.isTouching) {
        _shouldHide = YES;
    }
    else {
        __weak __typeof(self) wself = self;
        void (^completion)(BOOL) = ^(BOOL finished) {
            [NSNotificationCenter.defaultCenter removeObserver:self
                                                          name:UIWindowDidBecomeKeyNotification
                                                        object:wself.window];
            wself.window = nil;
            [wself.originalWindow makeKeyAndVisible];
        };
        if (animate) {
            [UIView transitionWithView:_window
                              duration:.25
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{ [wself.warningView removeFromSuperview]; }
                            completion:completion];
        }
        else {
            [_warningView removeFromSuperview];
            completion(YES);
        }
    }
}

- (void)hideIfNeeded
{
    if (!_manual && _shouldHide) {
        [self hide:YES];
    }
}

#pragma mark - UIWindow Notifications

- (void)windowDidBecomeKey:(NSNotification *)notification
{
    _window.warningView.alpha = 0;
    __weak __typeof(self) wself = self;
    [UIView transitionWithView:_window
                      duration:.25
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{ wself.warningView.alpha = 1; }
                    completion:nil];
}

@end
