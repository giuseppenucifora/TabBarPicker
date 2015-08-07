//
//  TabBarPickerSubItemsView.m
//  Pods
//
//  Created by Giuseppe Nucifora on 17/07/15.
//
//

#import "TabBarPickerSubItemsView.h"
#import <PureLayout/PureLayout.h>

#define DEFAULT_ITEM_HEIGHT 44

@interface TabBarPickerSubItemsView()

@property (nonatomic) NSUInteger itemsPerRow;
@property (nonatomic) CGFloat itemHeight;
@property (nonatomic) NSUInteger rows;
@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation TabBarPickerSubItemsView

- (instancetype) initWithTabBarItem:(TabBarItem *) item andsubItemsPerRow:(NSUInteger) itemsPerRow {
    self = [self initForAutoLayout];
    
    if (self) {
        _itemsPerRow = itemsPerRow;
        _subItemsArray = [[NSMutableArray alloc] initWithArray:[item subItems]];
        _itemHeight = DEFAULT_ITEM_HEIGHT;
        _rows = 0;
        
        _rows = ceil(([_subItemsArray count]/_itemsPerRow));
        
    }
    
    [self updateConstraintsIfNeeded];
    
    return self;
}


- (void) layoutSubviews {
    
    /*if ([self.constraints count] > 0) {
     
     [NSLayoutConstraint deactivateConstraints:self.constraints];
     
     for (TabBarItem *item in _itemsArray) {
     for (TabBarSubItem *subItem in item.subItems) {
     [subItem.constraints autoRemoveConstraints];
     }
     }
     }*/
    if (!_didSetupConstraints) {
        
        [self autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:-(_rows*_itemHeight)];
        [self autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.superview withOffset:0 relation:NSLayoutRelationEqual];
        [self autoSetDimension:ALDimensionHeight toSize:_rows*_itemHeight];
        
        _didSetupConstraints = YES;
    }
}

@end
