//
//  TabBarPicker.m
//  Pods
//
//  Created by Giuseppe Nucifora on 15/07/15.
//
//

#import "TabBarPicker.h"
#import <PureLayout/PureLayout.h>

#define tabBarSizeVertical CGSizeMake()


@interface TabBarPicker(){
    
}


@end

@implementation TabBarPicker


+ (NSString*) tabBarVersion {
    return @"1";
}

- (instancetype) initWithTabBarItems:(NSArray *)items forPosition:(TabBarPickerPosition)position {
    NSLog(@"init");
    return [self initWithTabBarItems:items withTabBarSize:CGSizeZero forPosition:position];
    
}

- (instancetype) initWithTabBarItems:(NSArray*) items withTabBarSize:(CGSize) size forPosition:(TabBarPickerPosition) position {
    
    self = [self initForAutoLayout];
    if (self) {

        NSAssert(items, @"TabBar Items array cannot be nil!");
        
        if (CGSizeEqualToSize(size, CGSizeZero)) {
            _tabBarSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width, 100);
        }
        
        _tabBarItems = [[NSMutableArray alloc] init];

        for (NSObject *item in items) {
            if ([item isKindOfClass:[TabBarItem class]]) {
                [_tabBarItems addObject:item];
            }
        }
    }
    
    NSLog(@"prova");
    
    [self autoSetDimension:ALDimensionWidth toSize:[[UIScreen mainScreen] bounds].size.width relation:NSLayoutRelationLessThanOrEqual];
    [self autoSetDimension:ALDimensionHeight toSize:_tabBarSize.height relation:NSLayoutRelationLessThanOrEqual];
    
    for (TabBarItem *item in _tabBarItems) {
        
    }
    
    return self;
}

- (void) layoutSubviews {
    
    
}

@end
