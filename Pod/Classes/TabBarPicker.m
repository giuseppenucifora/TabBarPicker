//
//  TabBarPicker.m
//  Pods
//
//  Created by Giuseppe Nucifora on 15/07/15.
//
//

#import "TabBarPicker.h"
#import <PureLayout/PureLayout.h>
#import "TabBarPickerSubItemsView.h"

#define DEFAULT_SUB_ITEMS_PER_ROW 2
#define DEFAULT_SUB_ITEM_HEIGHT 44

@interface TabBarPicker() <TabBarPickerSubItemsViewDelegate>

@property (nonatomic) UIDeviceOrientation orientation;
@property (nonatomic) NSUInteger subItemRows;
@property (nonatomic, strong) TabBarPickerSubItemsView *subItemSelector;
@property (nonatomic) BOOL show;
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, strong) NSLayoutConstraint *showConstraint;

@property (nonatomic, strong) NSLayoutConstraint *hideConstraint;

@end

@implementation TabBarPicker

- (instancetype) initWithTabBarItems:(NSArray *) items forPosition:(TabBarPickerPosition) position {
    
    return [self initWithTabBarItems:items withTabBarSize:CGSizeZero forPosition:position andNSLayoutRelation:NSLayoutRelationEqual subItemsPerRow:DEFAULT_SUB_ITEMS_PER_ROW subItemHeight:DEFAULT_SUB_ITEM_HEIGHT];
    
}

- (instancetype) initWithTabBarItems:(NSArray *) items forPosition:(TabBarPickerPosition) position andNSLayoutRelation:(NSLayoutRelation) relation {
    
    return [self initWithTabBarItems:items withTabBarSize:CGSizeZero forPosition:position andNSLayoutRelation:relation subItemsPerRow:DEFAULT_SUB_ITEMS_PER_ROW subItemHeight:DEFAULT_SUB_ITEM_HEIGHT];
    
}

- (instancetype) initWithTabBarItems:(NSArray *) items withTabBarSize:(CGSize) size forPosition:(TabBarPickerPosition) position andNSLayoutRelation:(NSLayoutRelation) relation {
    
    return [self initWithTabBarItems:items withTabBarSize:size forPosition:position andNSLayoutRelation:relation subItemsPerRow:DEFAULT_SUB_ITEMS_PER_ROW subItemHeight:DEFAULT_SUB_ITEM_HEIGHT];
}

- (instancetype) initWithTabBarItems:(NSArray*) items withTabBarSize:(CGSize) size forPosition:(TabBarPickerPosition) position andNSLayoutRelation:(NSLayoutRelation) relation subItemsPerRow:(NSUInteger) subItemsPerRow {
    
    return [self initWithTabBarItems:items withTabBarSize:size forPosition:position andNSLayoutRelation:relation subItemsPerRow:DEFAULT_SUB_ITEMS_PER_ROW subItemHeight:DEFAULT_SUB_ITEM_HEIGHT];
}



- (instancetype) initWithTabBarItems:(NSArray*) items withTabBarSize:(CGSize) size forPosition:(TabBarPickerPosition) position andNSLayoutRelation:(NSLayoutRelation) relation subItemsPerRow:(NSUInteger)  subItemsPerRow subItemHeight:(CGFloat) subItemHeight {
    
    self = [self initForAutoLayout];
    if (self) {
        _subItemPerRow = subItemsPerRow;
        _itemSpacing = 10;
        _layoutRelation = relation;
        _subItemHeight  = subItemHeight;
        _position = position;
        
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        
        [[NSNotificationCenter defaultCenter] addObserver: self selector:   @selector(deviceOrientationDidChange:) name: UIDeviceOrientationDidChangeNotification object: nil];
        
        NSAssert(items, @"TabBar Items array cannot be nil!");
        
        if (CGSizeEqualToSize(size, CGSizeZero)) {
            _tabBarSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width, 44);
        }
        
        _tabBarItems = [[NSMutableArray alloc] init];
        
        for (NSObject *item in items) {
            [self addItem:item];
        }
        
        if ([_tabBarItems count] > 0) {
            
            _subItemSelector = [[TabBarPickerSubItemsView alloc] initWithTabBarItems:_tabBarItems andsubItemsPerRow:_subItemPerRow];
            [_subItemSelector setDelegate:self];
            [self addSubview:_subItemSelector];
        }
    }
    
    [self updateConstraintsIfNeeded];
    
    return self;
}

- (void) layoutSubviews {
    
    /*if ([self.constraints count] > 0) {
     
     [NSLayoutConstraint deactivateConstraints:self.constraints];
     [NSLayoutConstraint deactivateConstraints:_subItemSelector.constraints];
     for (TabBarItem *item in _tabBarItems) {
     [item.constraints autoRemoveConstraints];
     }
     }*/
    if (!_didSetupConstraints) {
        
        switch (_position) {
            case TabBarPickerPositionLeft:{
                [self autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
                [self autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
                [self autoSetDimension:ALDimensionWidth toSize:44];
                [self autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.superview withOffset:0 relation:_layoutRelation];
                [self autoAlignAxisToSuperviewMarginAxis:ALAxisHorizontal];
                
                [_tabBarItems autoSetViewsDimension:ALDimensionWidth toSize:44.0];
                
                [_tabBarItems autoDistributeViewsAlongAxis:ALAxisVertical alignedTo:ALAttributeVertical withFixedSpacing:_itemSpacing insetSpacing:YES matchedSizes:YES];
                
                [[_tabBarItems firstObject] autoAlignAxisToSuperviewAxis:ALAxisVertical];
            }
                break;
            case TabBarPickerPositionRight:{
                [self autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
                [self autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
                [self autoSetDimension:ALDimensionWidth toSize:44];
                [self autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.superview withOffset:0 relation:_layoutRelation];
                [self autoAlignAxisToSuperviewMarginAxis:ALAxisHorizontal];
                
                [_tabBarItems autoSetViewsDimension:ALDimensionWidth toSize:44.0];
                
                [_tabBarItems autoDistributeViewsAlongAxis:ALAxisVertical alignedTo:ALAttributeVertical withFixedSpacing:_itemSpacing insetSpacing:YES matchedSizes:YES];
                
                [[_tabBarItems firstObject] autoAlignAxisToSuperviewAxis:ALAxisVertical];
            }
                break;
            case TabBarPickerPositionTop:{
                [self autoPinEdgeToSuperviewMargin:ALEdgeTop];
                [self autoSetDimension:ALDimensionHeight toSize:44];
                [self autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.superview withOffset:0 relation:_layoutRelation];
                [self autoAlignAxisToSuperviewMarginAxis:ALAxisVertical];
                
                [_tabBarItems autoSetViewsDimension:ALDimensionHeight toSize:44.0];
                
                [_tabBarItems autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:_itemSpacing insetSpacing:YES matchedSizes:YES];
                
                [[_tabBarItems firstObject] autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
            }
                break;
            case TabBarPickerPositionBottom:
            default:{
                
                _hideConstraint = [self autoPinEdgeToSuperviewMargin:ALEdgeBottom];
                [self autoSetDimension:ALDimensionHeight toSize:44];
                [self autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.superview withOffset:0 relation:_layoutRelation];
                [self autoAlignAxisToSuperviewMarginAxis:ALAxisVertical];
                
                [_tabBarItems autoSetViewsDimension:ALDimensionHeight toSize:44.0];
                
                [[_tabBarItems firstObject] autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
                
                [_tabBarItems autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:_itemSpacing insetSpacing:YES matchedSizes:YES];
            }
                break;
        }
        
        [_subItemSelector layoutSubviews];
        _didSetupConstraints = YES;
        
        [self updateConstraintsIfNeeded];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self show];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hide];
    });
}

- (void) setPosition:(TabBarPickerPosition)position {
    _position = position;
    
    if (self.superview) {
        [self layoutSubviews];
    }
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
    //Obtain current device orientation
    _orientation = [[UIDevice currentDevice] orientation];
}

- (void) addItem:(TabBarItem*) item {
    if (item && [item isKindOfClass:[TabBarItem class]]) {
        
        [_tabBarItems addObject:item];
        //[item setDelegate:self];
        [self addSubview:item];
        
        
        if (self.superview) {
            
            [self layoutSubviews];
        }
    }
}

- (void) show {
    
    if (!_show) {
        
        _show = YES;
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
        
        [UIView animateWithDuration:4
                              delay:0.0
             usingSpringWithDamping:0.6
              initialSpringVelocity:0
                            options:0
                         animations:^{
                             [_hideConstraint autoRemove];
                             
                             _showConstraint = [self autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:_subItemSelector.frame.size.height];
                         }
                         completion:^(BOOL finished) {
                             // Run the animation again in the other direction
                         }];
    }
}

- (void) hide {
    if (_show) {
        
        _show = NO;
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
        
        [UIView animateWithDuration:4
                              delay:0.0
             usingSpringWithDamping:0.6
              initialSpringVelocity:0
                            options:0
                         animations:^{
                             
                             [_showConstraint autoRemove];
                             
                             _hideConstraint = [self autoPinEdgeToSuperviewMargin:ALEdgeBottom];
                         }
                         completion:^(BOOL finished) {
                             // Run the animation again in the other direction
                         }];
    }
}

#pragma mark TabBarPickerSubItemsViewDelegate

- (void) tabarPickerSubItemsView:(TabBarPickerSubItemsView*) tabarPickerSubItemsView didSelect:(TabBarItem*) item {
    
}

#pragma mark -

@end
