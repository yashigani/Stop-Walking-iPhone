//
//  SWIWarningView.m
//  DemoApp
//
//  Created by taiki on 12/10/13.
//  Copyright (c) 2013 yashigani. All rights reserved.
//

#import "SWIWarningView.h"

@interface SWIWarningView ()
@end

@implementation SWIWarningView

+ (NSDictionary *)attrs
{
    return @{
        NSForegroundColorAttributeName: [UIColor colorWithRed:0xee green:0xee blue:0xee alpha:1.0],
        NSFontAttributeName: [UIFont systemFontOfSize:16],
    };
}

+ (UIImage *)defaultImage
{
    NSArray *images = @[
        @"swi-plate-car",
        @"swi-plate-child",
        @"swi-plate-dog",
        @"swi-plate-hole",
        @"swi-plate-lion",
        @"swi-plate-train",
    ];
    return [UIImage imageNamed:images[arc4random_uniform(images.count)]];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    const CGFloat margin = 5.0;
    UIImage *image = self.image;
    CGRect bounds = [self.text boundingRectWithSize:CGSizeMake(image.size.width, 500)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:self.class.attrs
                                            context:nil];
    return CGSizeMake(image.size.width,
                      image.size.height + margin + CGRectGetHeight(bounds));
}

- (void)drawRect:(CGRect)frame
{
    [self.image drawAtPoint:CGPointZero];
    CGRect slice = CGRectNull;
    CGRect remainder = CGRectNull;
    CGRectDivide(frame, &slice, &remainder, self.image.size.height + 5, CGRectMinYEdge);
    [self.text drawInRect:remainder withAttributes:self.class.attrs];
}

- (UIImage *)image
{
    if (!_image) {
        _image = self.class.defaultImage;
    }
    return _image;
}

- (NSString *)text
{
    if (!_text) {
        _text = NSLocalizedString(@"Stop texting while walking.", nil);
    }
    return _text;
}

@end
