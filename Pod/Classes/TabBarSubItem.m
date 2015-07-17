//
//  TabBarSubItem.m
//  Pods
//
//  Created by Giuseppe Nucifora on 15/07/15.
//
//

#import "TabBarSubItem.h"
#import <PureLayout/PureLayout.h>

@interface TabBarSubItem()

@property (nonatomic) UIDeviceOrientation orientation;

@end

@implementation TabBarSubItem


- (instancetype) initWithName:(NSString *) name {
    
    self = [self initForAutoLayout];
    if (self) {
        
         [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(deviceOrientationDidChange:) name: UIDeviceOrientationDidChangeNotification object: nil];
        
        _name = name;
    }
    return self;
}

+ (instancetype) tabBarSubItemWithName:(NSString*)name {
    return [[self alloc] initWithName:name];
}


- (void)deviceOrientationDidChange:(NSNotification *)notification {
    //Obtain current device orientation
    _orientation = [[UIDevice currentDevice] orientation];
    
}


@end
