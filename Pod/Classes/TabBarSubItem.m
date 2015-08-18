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
@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation TabBarSubItem


- (instancetype) initWithName:(NSString *) name andValue:(id)value {
    
    self = [self initForAutoLayout];
    if (self) {
        
         //[[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(deviceOrientationDidChange:) name: UIDeviceOrientationDidChangeNotification object: nil];
        
        _name = name;
        _subItemButton = [[UIButton alloc] initForAutoLayout];
        [_subItemButton setTitle:_name forState:UIControlStateNormal];
        _value = value;
    }
    return self;
}

+ (instancetype) tabBarSubItemWithName:(NSString*)name andValue:(id)value {
    return [[self alloc] initWithName:name andValue:value];
}

- (void) setName:(NSString *)name {
    _name = name;
    [_subItemButton setTitle:_name forState:UIControlStateNormal];
}


- (void)deviceOrientationDidChange:(NSNotification *)notification {
    //Obtain current device orientation
    _orientation = [[UIDevice currentDevice] orientation];
    
    [self layoutSubviews];
}

- (void) layoutSubviews {
    
    /*if ([self.constraints count] > 0) {
        
        [NSLayoutConstraint deactivateConstraints:self.constraints];
        
    }*/
    
    if (_didSetupConstraints) {
        
        
        _didSetupConstraints = YES;
    }
}


@end
