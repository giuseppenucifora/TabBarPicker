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


@interface TabBarPicker()

@property (nonatomic) UIDeviceOrientation orientation;

@end

@implementation TabBarPicker

- (instancetype) initWithTabBarItems:(NSArray *)items forPosition:(TabBarPickerPosition)position {
    
    return [self initWithTabBarItems:items withTabBarSize:CGSizeZero forPosition:position];
    
}

- (instancetype) initWithTabBarItems:(NSArray*) items withTabBarSize:(CGSize) size forPosition:(TabBarPickerPosition) position {
    
    self = [self initForAutoLayout];
    if (self) {
        
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        
         [[NSNotificationCenter defaultCenter] addObserver: self selector:   @selector(deviceOrientationDidChange:) name: UIDeviceOrientationDidChangeNotification object: nil];

        NSAssert(items, @"TabBar Items array cannot be nil!");
        
        if (CGSizeEqualToSize(size, CGSizeZero)) {
            _tabBarSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width, 44);
        }
        
        _tabBarItems = [[NSMutableArray alloc] init];

        for (NSObject *item in items) {
            if ([item isKindOfClass:[TabBarItem class]]) {
                [_tabBarItems addObject:item];
            }
        }
    }
        
    return self;
}

- (void) layoutSubviews {
    
    [self autoSetDimension:ALDimensionHeight toSize:44];
    [self autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.superview];
    [self autoPinEdgeToSuperviewMargin:ALEdgeBottom];
    
    
    for (TabBarItem *item in _tabBarItems) {
        
    }
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
    //Obtain current device orientation
    _orientation = [[UIDevice currentDevice] orientation];
    
    [self layoutSubviews];
}

- (void) layoutSubviewsPortrait {
    
}

- (void) layoutSubviewsLandScape {
    
}

@end
