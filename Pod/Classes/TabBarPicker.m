//
//  TabBarPicker.m
//  Pods
//
//  Created by Giuseppe Nucifora on 15/07/15.
//
//

#import "TabBarPicker.h"

@implementation TabBarPicker

- (instancetype) initWithTabBarItems:(NSArray*) items withSize:(CGSize) size forPosition:(TabBarPickerPosition) position {
    
    self = [super init];
    if (self) {

        NSAssert(items, @"TabBar Items array cannot be nil!");
        
        _tabBarItems = [[NSMutableArray alloc] init];

        for (NSObject *item in items) {
            if ([item isKindOfClass:[TabBarItem class]]) {
                [_tabBarItems addObject:item];
            }
        }
    }
    return self;
}

@end
