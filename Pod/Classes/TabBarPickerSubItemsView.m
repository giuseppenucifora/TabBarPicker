//
//  TabBarPickerSubItemsView.m
//  Pods
//
//  Created by Giuseppe Nucifora on 17/07/15.
//
//

#import "TabBarPickerSubItemsView.h"
#import <PureLayout/PureLayout.h>

@implementation TabBarPickerSubItemsView

- (instancetype) initWithTabBarItems:(NSArray *) items {
    self = [self initForAutoLayout];
    
    if (self) {
        _itemsArray = [[NSMutableArray alloc] initWithArray:items];
    }
    
    [self updateConstraintsIfNeeded];
    
    return self;
}


- (void) layoutSubviews {
    
    if ([self.constraints count] > 0) {
        
        [NSLayoutConstraint deactivateConstraints:self.constraints];
        
        for (TabBarItem *item in _itemsArray) {
            for (TabBarSubItem *subItem in item.subItems) {
                [subItem.constraints autoRemoveConstraints];
            }
        }
    }
    
    [self autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.superview withOffset:0 relation:NSLayoutRelationEqual];
    [self autoSetDimension:ALDimensionHeight toSize:44];
    
    [self autoConstrainAttribute:ALEdgeTop toAttribute:ALMarginTop ofView:self.superview withOffset:self.superview.frame.size.height];
}

@end
