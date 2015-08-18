//
//  NSString+HexColor.h
//  Seating
//
//  Created by Giuseppe Nucifora on 20/10/12.
//  Copyright (c) 2012 Meedori S.r.l. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HexColor)

- (UIColor*)colorFromHex;

@end