//
//  SWWindow.h
//  stop-walking-iPhone
//
//  Created by taiki on 11/13/13.
//  Copyright (c) 2013 yashigani. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SWIWindowController;

@interface SWIWindow : UIWindow
@property (weak) SWIWindowController *controller;
@property (strong) UIView *warningView;
@property (readonly, getter=isTouching) BOOL touching;

@end
