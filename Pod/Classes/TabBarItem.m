//
//  TabBarItem.m
//  Pods
//
//  Created by Giuseppe Nucifora on 15/07/15.
//
//

#import "TabBarItem.h"
#import <PureLayout/PureLayout.h>

@implementation TabBarItem

- (instancetype) initWithSubItems:(NSArray*) array {
    self = [self initForAutoLayout];
    if (self) {
        NSAssert(array, @"SubItemsArray cannot be nil");
        
        
        _subItems = [[NSMutableArray alloc] init];
        
        for (NSObject *subItem in array) {
            if ([subItem isKindOfClass:[TabBarSubItem class]]) {
                [_subItems addObject:subItem];
            }
        }
    }
    return self;
}

@end
