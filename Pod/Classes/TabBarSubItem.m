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


- (instancetype) initWithName:(NSString *) name firstValue:(id)firstValue secondValue:(id) secondValue {
    
    self = [self initForAutoLayout];
    if (self) {
        
        _name = name;
        _subItemButton = [[UIButton alloc] initForAutoLayout];
        [_subItemButton setTitle:_name forState:UIControlStateNormal];
        _firstValue = ( firstValue ? firstValue : @"");
        _secondValue = ( secondValue ? secondValue : @"");
    }
    return self;
}

+ (instancetype) tabBarSubItemWithName:(NSString*)name andValue:(id)value {
    return [[self alloc] initWithName:name firstValue:value secondValue:nil];
}

+ (instancetype) initWithName:(NSString *) name firstValue:(id)firstValue secondValue:(id) secondValue {
    return [[self alloc] initWithName:name firstValue:firstValue secondValue:secondValue];
}

- (void) setName:(NSString *)name {
    _name = name;
    [_subItemButton setTitle:_name forState:UIControlStateNormal];
}

- (NSUInteger) numberOfValues {
    NSUInteger response = 0;
    
    if (_firstValue) {
        response++;
    }
    
    if (_secondValue) {
        response++;
    }
    
    return response;
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
