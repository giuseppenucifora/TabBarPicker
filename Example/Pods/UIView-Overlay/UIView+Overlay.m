//
//  UIView+Overlay.m
//  Strannik
//
//  Created by Anton Gubarenko on 03.07.15.
//  Copyright (c) 2015 Anton Gubarenko. All rights reserved.
//

#import "UIView+Overlay.h"

static const NSInteger kOverlayTag = 1001;
static NSString* const kOverlayKey = @"kOverlayKey";

@implementation UIView (Overlay)

- (void) ag_addOverlayWithColor: (UIColor*) color
{
    CALayer *overlay = [self ag_layer];
    if (!overlay)
    {
        CALayer *overlayLayer = [CALayer layer];
        overlayLayer.frame = self.frame;
        [overlayLayer setValue: [NSNumber numberWithInt: kOverlayTag]
                        forKey: kOverlayKey];
        [overlayLayer setBackgroundColor: color.CGColor];
        [self.layer addSublayer: overlayLayer];
    }
    else
    {
        [overlay setBackgroundColor: color.CGColor];
    }
}

- (void) ag_addOverlayToTheBackWithColor: (UIColor*) color
{
    CALayer *overlay = [self ag_layer];
    if (!overlay)
    {
        CALayer *overlayLayer = [CALayer layer];
        overlayLayer.frame = self.frame;
        [overlayLayer setValue: [NSNumber numberWithInt: kOverlayTag]
                        forKey: kOverlayKey];
        [overlayLayer setBackgroundColor: color.CGColor];
        [self.layer insertSublayer: overlayLayer
                           atIndex: 0 ];
    }
    else
    {
        [overlay setBackgroundColor: color.CGColor];
    }
}

- (CALayer*) ag_layer
{
    for (CALayer *subLayer in [self.layer sublayers])
    {
        if ([subLayer valueForKey: kOverlayKey])
        {
            return subLayer;
        }
    }
    return nil;
}

- (void) ag_removeOverlay
{
    CALayer *overlay = [self ag_layer];
    if (overlay)
    {
        [overlay removeFromSuperlayer];
    }
}

- (void) layoutSubviews
{
    for (CALayer *subLayer in [self.layer sublayers])
    {
        if ([subLayer valueForKey: kOverlayKey])
        {
            subLayer.frame = self.frame;
            break;
        }
    }
}

@end
