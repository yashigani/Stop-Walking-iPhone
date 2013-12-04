//
//  SWWindow.m
//  stop-walking-iPhone
//
//  Created by taiki on 11/13/13.
//  Copyright (c) 2013 yashigani. All rights reserved.
//

#import "SWIWindow.h"

#import "SWIWindowController.h"

@interface SWIWindow () <UICollisionBehaviorDelegate>
@property (strong) UIDynamicAnimator *animator;
@property (strong) UICollisionBehavior *collisionBehavior;
@property (strong) UIAttachmentBehavior *attachBehavior;
@property (strong) UIPushBehavior *pushBehavior;
@property (strong, readwrite) UIPanGestureRecognizer *panGesture;
@property (strong) UITapGestureRecognizer *tapGesture;
@end

@implementation SWIWindow
@synthesize warningView = _warningView;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = UIScreen.mainScreen.bounds;
        self.windowLevel = UIWindowLevelAlert;
        self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.6];

        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(handleAttachmentGesture:)];
        [self addGestureRecognizer:_panGesture];
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(handleTapGesture:)];
        [self addGestureRecognizer:_tapGesture];
    }
    return self;
}

- (BOOL)isTouching
{
    BOOL isTouching = NO;
    if (_panGesture.state != UIGestureRecognizerStateFailed) {
        isTouching = _panGesture.state != UIGestureRecognizerStatePossible && !_collisionBehavior;
    }
    return isTouching;
}

#pragma mark - handle gesture

- (void)handleAttachmentGesture:(id)sender
{
    CGPoint p = [_panGesture locationInView:self];
    if (_panGesture.state == UIGestureRecognizerStateBegan) {
        CGPoint center = _warningView.center;
        UIOffset offset = UIOffsetMake(p.x - center.x, p.y - center.y);
        _attachBehavior = [[UIAttachmentBehavior alloc] initWithItem:_warningView
                                                    offsetFromCenter:offset
                                                    attachedToAnchor:p];
        [_animator addBehavior:_attachBehavior];
    }
    else if (_panGesture.state == UIGestureRecognizerStateChanged) {
        _attachBehavior.anchorPoint = p;
    }
    else if ((_panGesture.state == UIGestureRecognizerStateEnded ||
             _panGesture.state == UIGestureRecognizerStateCancelled) &&
            _attachBehavior) {
        [_animator removeBehavior:_attachBehavior];
        _attachBehavior = nil;

        CGPoint velocity = [_panGesture velocityInView:self];
        velocity = CGPointMake(velocity.x / 30, velocity.y / 30);
        CGFloat magnitude = (CGFloat)sqrt(pow((double)velocity.x, 2.0) + pow((double)velocity.y, 2.0));
        if (magnitude > 30) {
            _collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[_warningView]];
            _collisionBehavior.collisionDelegate = self;
            CGFloat diagonal = -sqrt(pow(CGRectGetWidth(_warningView.frame), 2.0) +
                                     pow(CGRectGetHeight(_warningView.frame), 2.0));
            UIEdgeInsets insets = UIEdgeInsetsMake(diagonal, diagonal, diagonal, diagonal);
            [_collisionBehavior setTranslatesReferenceBoundsIntoBoundaryWithInsets:insets];
            [_animator addBehavior:_collisionBehavior];

            _pushBehavior =
                [[UIPushBehavior alloc] initWithItems:@[_warningView]
                                                 mode:UIPushBehaviorModeInstantaneous];
            CGPoint center = _warningView.center;
            UIOffset offset = UIOffsetMake((p.x - center.x) / 2.0, (p.y - center.y) / 2.0);
            [_pushBehavior setTargetOffsetFromCenter:offset forItem:_warningView];
            _pushBehavior.pushDirection = CGVectorMake(velocity.x, velocity.y);
            [_animator addBehavior:_pushBehavior];

            _panGesture.enabled = NO;
        }
        else {
            __weak __typeof(self) wself = self;
            [UIView animateWithDuration:.25
                             animations:^{
                                 _warningView.center = wself.center;
                                 _warningView.transform = CGAffineTransformIdentity;
                             }
                             completion:^(BOOL finished) {
                                 [wself.controller hideIfNeeded];
                             }];
        }
    }
}

- (void)handleTapGesture:(id)sendr
{
    CGPoint p = [_warningView convertPoint:[_tapGesture locationInView:_warningView]
                                    toView:self];
    if (!CGRectContainsPoint(_warningView.frame, p)) {
        [_controller hide:YES];
    }
}

#pragma mark - UICollisionBehaviorDelegate

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
    [_animator removeAllBehaviors];
    _pushBehavior = nil;
    _collisionBehavior = nil;
    [_controller hide:NO];
}

@end
