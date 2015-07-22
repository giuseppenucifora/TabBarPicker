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

@property (nonatomic) NSUInteger itemsPerRow;
@property (nonatomic) NSUInteger rows;
@property (nonatomic, strong) UICollectionView *subItemCollectionView;

@end

@implementation TabBarPickerSubItemsView

- (instancetype) initWithTabBarItems:(NSArray *) items andsubItemsPerRow:(NSUInteger) itemsPerRow {
    self = [self initForAutoLayout];
    
    if (self) {
        _itemsPerRow = itemsPerRow;
        _itemsArray = [[NSMutableArray alloc] initWithArray:items];
        
        _rows = 0;
        
        for (TabBarItem *item in _itemsArray) {
            if (_rows < ([[item subItems] count]/_itemsPerRow)) {
                _rows = ceil(([[item subItems] count]/_itemsPerRow));
            }
        }
        [self setBackgroundColor:[UIColor whiteColor]];
        /*_subItemCollectionView = [[UICollectionView alloc] initForAutoLayout];
        [_subItemCollectionView setPagingEnabled:YES];
        [_subItemCollectionView setDelegate:self];
        [_subItemCollectionView setDataSource:self];
        
        [self addSubview:_subItemCollectionView];*/
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
    [self autoConstrainAttribute:ALEdgeTop toAttribute:ALMarginTop ofView:self.superview withOffset:self.superview.frame.size.height];
    [self autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.superview withOffset:0 relation:NSLayoutRelationEqual];
    [self autoSetDimension:ALDimensionHeight toSize:_rows*44];
    
    [_subItemCollectionView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self];
    [_subItemCollectionView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self];
    [_subItemCollectionView setBackgroundColor:[UIColor redColor]];
}

@end
