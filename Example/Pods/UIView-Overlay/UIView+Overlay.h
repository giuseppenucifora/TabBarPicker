//
//  UIView+Overlay.h
//  Strannik
//
//  Created by Anton Gubarenko on 03.07.15.
//  Copyright (c) 2015 Anton Gubarenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Overlay)

- (void) ag_addOverlayWithColor: (UIColor*) color;
- (void) ag_addOverlayToTheBackWithColor: (UIColor*) color;
- (void) ag_removeOverlay;

@end
