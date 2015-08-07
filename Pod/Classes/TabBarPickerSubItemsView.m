//
//  TabBarPickerSubItemsView.m
//  Pods
//
//  Created by Giuseppe Nucifora on 17/07/15.
//
//

#import "TabBarPickerSubItemsView.h"
#import <PureLayout/PureLayout.h>

@interface TabBarPickerSubItemsView()

@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic) TabBarPickerSubItemsViewType type;
@property (nonatomic, strong) NSMutableArray *elementsArray;

@end

@implementation TabBarPickerSubItemsView

- (instancetype) initWithType:(TabBarPickerSubItemsViewType) type andElements:(NSArray*) elements {
    self = [self initForAutoLayout];
    
    if (self) {
        _type = type;
        _elementsArray = [[NSMutableArray alloc] initWithArray:elements];
    }
    
    [self updateConstraintsIfNeeded];
    
    return self;
}


- (void) layoutSubviews {
    
    if (!_didSetupConstraints) {
        
        [self autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.superview withOffset:0 relation:NSLayoutRelationEqual];
        [self autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.superview withOffset:0 relation:NSLayoutRelationEqual];
        
        _didSetupConstraints = YES;
    }
}

@end
