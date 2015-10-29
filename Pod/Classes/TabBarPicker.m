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
#import "MMCPSScrollView.h"
#import "NSString+HexColor.h"
#import <QuartzCore/QuartzCore.h>

#define SUPERVIEW_TAG -9999

@interface TabBarPicker() <TabBarPickerSubItemsViewDelegate,TabBarItemDelegate,MMCPSScrollViewDelegate>

@property (nonatomic) UIDeviceOrientation orientation;
@property (nonatomic, strong) NSMutableArray *subItemSelectors;
@property (nonatomic, strong) NSMutableArray *subItemSelectorsConstraints;
@property (nonatomic) BOOL isShow;
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, strong) NSLayoutConstraint *showConstraint;
@property (nonatomic, strong) NSLayoutConstraint *hideConstraint;
@property (nonatomic, strong) NSMutableArray *tabBarItemsConstraints;
@property (nonatomic, strong) TabBarItem *selectedTabBarItem;

@property (nonatomic, strong) UIView *separator;
@property (nonatomic, strong) UIView *tabBarView;
@property (nonatomic, strong) MMCPSScrollView *subItemScrollView;

@property (nonatomic, strong) UIView* dimView;




@end

@implementation TabBarPicker

- (instancetype) initWithTabBarItems:(NSArray *) items forPosition:(TabBarPickerPosition) position {
    
    return [self initWithTabBarItems:items withTabBarSize:CGSizeZero forPosition:position andNSLayoutRelation:NSLayoutRelationEqual];
    
}

- (instancetype) initWithTabBarItems:(NSArray *) items forPosition:(TabBarPickerPosition) position andNSLayoutRelation:(NSLayoutRelation) relation {
    
    return [self initWithTabBarItems:items withTabBarSize:CGSizeZero forPosition:position andNSLayoutRelation:relation];
    
}

- (instancetype) initWithTabBarItems:(NSArray*) items withTabBarSize:(CGSize) size forPosition:(TabBarPickerPosition) position andNSLayoutRelation:(NSLayoutRelation) relation {
    
    self = [self initForAutoLayout];
    if (self) {
        [self setUserInteractionEnabled:YES];
        
        _filtersEnabled = [[NSMutableDictionary alloc] init];
        _itemSpacing = 10;
        _layoutRelation = relation;
        _position = position;
        _dimWhenShow = YES;
        _subItemSelectors = [[NSMutableArray alloc] init];
        _tabBarItemsConstraints = [[NSMutableArray alloc] init];
        _subItemSelectorsConstraints = [[NSMutableArray alloc] init];
        _dimColor = [[@"333333" colorFromHex] colorWithAlphaComponent: 0.5];
        
        _dimView = [UIView newAutoLayoutView];
        [_dimView setAlpha:0];
        [_dimView setBackgroundColor:_dimColor];
        
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        
        [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object: nil];
        
        NSAssert(items, @"TabBar Items array cannot be nil!");
        
        if (CGSizeEqualToSize(size, CGSizeZero)) {
            _tabBarSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width, 44);
        }
        
        _tabBarItems = [[NSMutableArray alloc] init];
        
        _tabBarView = [UIView newAutoLayoutView];
        
        _separator = [UIView newAutoLayoutView];
        [_separator.layer setMasksToBounds:NO];
        [_separator setBackgroundColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.3]];
        
        
        
        for (NSObject *item in items) {
            if (item && [item isKindOfClass:[TabBarItem class]]) {
                
                TabBarItem *_item = (TabBarItem*)item;
                [_item setTag:SUPERVIEW_TAG];;
                
                [_tabBarItems addObject:_item];
                [(TabBarItem*)_item setDelegate:self];
                [_tabBarView addSubview:_item];
            }
        }
        
        _subItemScrollView = [MMCPSScrollView newAutoLayoutView];
        [_subItemScrollView setPagingEnabled:YES];
        [_subItemScrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [_subItemScrollView setUserInteractionEnabled:YES];
        [_subItemScrollView setMMCPSDelegate:self];
        [_subItemScrollView setPageSize:1];
        
        [self addSubview:_subItemScrollView];
        
        [self addSubview:_tabBarView];
        
        [self addSubview:_separator];
        
        [self setTag:SUPERVIEW_TAG];
    }
    
    [self updateConstraintsIfNeeded];
    
    return self;
}

- (void) layoutSubviews {
    
    if (!_didSetupConstraints) {
        if (self.superview) {
            [self.superview insertSubview:_dimView belowSubview:self];
            
            [_dimView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.superview];
            [_dimView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.superview];
            [_dimView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.superview];
            [_dimView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.superview];
        }
        
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
                
                _hideConstraint = [self autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.superview withOffset:299 relation:NSLayoutRelationEqual];
                
                [self autoSetDimension:ALDimensionHeight toSize:343];
                [self autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.superview withOffset:0 relation:_layoutRelation];
                [self autoAlignAxisToSuperviewMarginAxis:ALAxisVertical];
                
                [_tabBarView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.superview];
                [_tabBarView autoSetDimension:ALDimensionHeight toSize:44];
                [_tabBarView autoAlignAxisToSuperviewAxis:ALAxisVertical];
                [_tabBarView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self];
                
                [_separator autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.superview];
                [_separator autoSetDimension:ALDimensionHeight toSize:1];
                [_separator autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_tabBarView];
                
                [_tabBarItems autoSetViewsDimension:ALDimensionHeight toSize:44.0];
                
                [[_tabBarItems firstObject] autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
                
                [_tabBarItemsConstraints addObjectsFromArray:[_tabBarItems autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:_itemSpacing insetSpacing:YES matchedSizes:YES]];
                
                [_subItemScrollView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self];
                [_subItemScrollView autoSetDimension:ALDimensionHeight toSize:343];
                [_subItemScrollView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:[_tabBarItems firstObject]];
                [_subItemScrollView autoAlignAxisToSuperviewAxis:ALAxisVertical];
                [_subItemScrollView setSegmentSize:[[UIScreen mainScreen] bounds].size.width    ];
                [_subItemScrollView setType:MMCPSScrollHorizontal];
                
                if ([_tabBarItems count] > 0) {
                    for (TabBarItem *item in _tabBarItems) {
                        
                        if ([item itemSubView]) {
                            [item setTag:SUPERVIEW_TAG];
                            [[item itemSubView] setDelegate:self];
                            [[item itemSubView] setTabBarItemReference:item];
                            
                            [_subItemScrollView addSubview:[item itemSubView]];
                            
                            [_subItemSelectors addObject:[item itemSubView]];
                            
                        }
                    }
                    [_subItemScrollView setPageSize:1];
                }
                
                [_subItemSelectors autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:0 insetSpacing:YES matchedSizes:YES];
                
                [[_subItemSelectors firstObject] autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
            }
                break;
        }
        
        _didSetupConstraints = YES;
        
        [self updateConstraintsIfNeeded];
    }
}

- (void) setTag:(NSInteger)tag {
    [super setTag:tag];
    for (UIView *subView in self.subviews) {
        [subView setTag:tag];
    }
    for (UIView *subView in _subItemScrollView.subviews) {
        [subView setTag:tag];
    }
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
        [item setDelegate:self];
        [self addSubview:item];
        
        [_tabBarItemsConstraints autoRemoveConstraints];
        
        [_tabBarItemsConstraints addObjectsFromArray:[_tabBarItems autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:_itemSpacing insetSpacing:YES matchedSizes:YES]];
    }
}

- (void) selectItem:(NSInteger) itemIndex {
    
    if ([_tabBarItems count] > itemIndex) {
        [(TabBarItem*)[_tabBarItems objectAtIndex:itemIndex] setHighlighted:YES];
    }
    [self show];
}

- (void) show {
    
    if (!_isShow) {
        
        _isShow = YES;
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
        
        [UIView animateWithDuration:1.5
                              delay:0.0
             usingSpringWithDamping:1
              initialSpringVelocity:0
                            options:0
                         animations:^{
                             if (_dimWhenShow) {
                                 //[self.superview insertSubview:_dimView belowSubview:self];
                                 [_dimView setAlpha:1];
                                 //[self.superview ag_addOverlayWithColor:_dimColor];
                                 //self.layer.zPosition = 999;
                             }
                             switch (_position) {
                                 case TabBarPickerPositionLeft: {
                                     
                                     break;
                                 }
                                 case TabBarPickerPositionRight: {
                                     
                                     break;
                                 }
                                     
                                 case TabBarPickerPositionTop: {
                                     
                                     break;
                                 }
                                 case TabBarPickerPositionBottom:
                                 default: {
                                     [_hideConstraint autoRemove];
                                     
                                     _showConstraint = [self autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.superview withOffset:0 relation:NSLayoutRelationEqual];
                                     break;
                                 }
                             }
                             
                             [self layoutIfNeeded];
                         }
                         completion:^(BOOL finished) {
                             // Run the animation again in the other direction
                         }];
    }
    
}

- (void) hide {
    if (_isShow) {
        
        _isShow = NO;
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
        
        [UIView animateWithDuration:1.5
                              delay:0.0
             usingSpringWithDamping:1
              initialSpringVelocity:0
                            options:0
                         animations:^{
                             if (_dimWhenShow) {
                                 //[self.superview ag_removeOverlay];
                                 //self.layer.zPosition = 0;
                                 
                                 [_dimView setAlpha:0];
                             }
                             switch (_position) {
                                 case TabBarPickerPositionLeft: {
                                     
                                     break;
                                 }
                                 case TabBarPickerPositionRight: {
                                     
                                     break;
                                 }
                                     
                                 case TabBarPickerPositionTop: {
                                     
                                     break;
                                 }
                                 case TabBarPickerPositionBottom:
                                 default: {
                                     [_showConstraint autoRemove];
                                     
                                     _hideConstraint = [self autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.superview withOffset:299 relation:NSLayoutRelationEqual];
                                     break;
                                 }
                             }
                             [_selectedTabBarItem setHighlighted:NO];
                             _selectedTabBarItem = nil;
                             [self layoutIfNeeded];
                         }
                         completion:^(BOOL finished) {
                             // Run the animation again in the other direction
                             //[_dimView removeFromSuperview];
                         }];
    }
}

#pragma mark TabBarPickerSubItemsViewDelegate

- (void) tabBarPickerSubItemsView:(TabBarPickerSubItemsView*) tabBarPickerSubItemsView didSelectTabBarSubItem:(TabBarSubItem*) subItem forTabBarItem:(TabBarItem*) item {
    
    switch (tabBarPickerSubItemsView.type) {
        case TabBarPickerSubItemsViewTypeDistance: {
            [_filtersEnabled setObject:subItem forKey:[item itemSearchKey]];
            break;
        }
        case TabBarPickerSubItemsViewTypeDateAndTime: {
            [_filtersEnabled setObject:subItem forKey:[item itemSearchKey]];
            break;
        }
        case TabBarPickerSubItemsViewTypePrice: {
            [_filtersEnabled setObject:subItem forKey:[item itemSearchKey]];
            break;
        }
        case TabBarPickerSubItemsViewTypeCheckBox: {
            [_filtersEnabled setObject:subItem forKey:[item itemSearchKey]];
            break;
        }
        case TabBarPickerSubItemsViewTypeButton: {
             [_filtersEnabled setObject:subItem forKey:[item itemSearchKey]];
            break;
        }
        default: {
            break;
        }
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(TabBarPicker:filtersDidChanges:)]) {
        [_delegate TabBarPicker:self filtersDidChanges:_filtersEnabled];
    }
}

- (void) tabBarPickerSubItemsView:(TabBarPickerSubItemsView*) tabBarPickerSubItemsView didSelectTabBarSubItems:(NSArray*) subItems forTabBarItem:(TabBarItem*) item {
    [_filtersEnabled setObject:subItems forKey:[item itemSearchKey]];
    
    if (_delegate && [_delegate respondsToSelector:@selector(TabBarPicker:filtersDidChanges:)]) {
        [_delegate TabBarPicker:self filtersDidChanges:_filtersEnabled];
    }
}

- (void) tabBarPickerSubItemsView:(TabBarPickerSubItemsView*) tabBarPickerSubItemsView didResetTabBarSubItem:(TabBarSubItem *)subItem forTabBarItem:(TabBarItem *)item {
    [_filtersEnabled removeObjectForKey:[item itemSearchKey]];
    
    if (_delegate && [_delegate respondsToSelector:@selector(TabBarPicker:filtersDidChanges:)]) {
        [_delegate TabBarPicker:self filtersDidChanges:_filtersEnabled];
    }
}

- (void) tabBarPickerSubItemsView:(TabBarPickerSubItemsView*) tabBarPickerSubItemsView didResetTabBarSubItems:(NSArray*) subItems forTabBarItem:(TabBarItem*) item {
    [_filtersEnabled removeObjectForKey:[item itemSearchKey]];
    
    if (_delegate && [_delegate respondsToSelector:@selector(TabBarPicker:filtersDidChanges:)]) {
        [_delegate TabBarPicker:self filtersDidChanges:_filtersEnabled];
    }
}

#pragma mark -

#pragma mark TabBarPickerSubItemsViewDataSource



#pragma mark -

#pragma mark TabBarItemDelegate

- (void) tabBarItemSelected:(TabBarItem *)selectedItem {
    for (TabBarItem *item in _tabBarItems) {
        if (![item isEqual:selectedItem]) {
            [item setHighlighted:NO];
        }
    }
    
    if (!_isShow) {
        [self show];
    }
    else {
        if(![_selectedTabBarItem isEqual:selectedItem]) {
            
        }
    }
    _selectedTabBarItem = selectedItem;
    
    [_subItemScrollView scrollToPage:[_tabBarItems indexOfObject:_selectedTabBarItem]];
}

#pragma mark -

#pragma mark MMCPSScrollViewDelegate

- (void)scrollView:(MMCPSScrollView *)scrollView didScrollToPage:(NSUInteger)pageIndex {
    if ([scrollView currentPage] > 0 && [_tabBarItems count] > [scrollView currentPage]-1) {
        
        TabBarItem *selectedItem = [_tabBarItems objectAtIndex:[scrollView currentPage]-1];
        
        for (TabBarItem *item in _tabBarItems) {
            if (![item isEqual:selectedItem]) {
                [item setHighlighted:NO];
            }
            else {
                [item setHighlighted:YES];
            }
        }
        
        if (!_isShow) {
            [self show];
        }
        else {
            if(![_selectedTabBarItem isEqual:selectedItem]) {
                
            }
        }
        _selectedTabBarItem = selectedItem;
    }
}

- (void)scrollView:(MMCPSScrollView *)scrollView willScrollToPage:(NSUInteger)pageIndex {

}


#pragma mark -

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.isUserInteractionEnabled || self.isHidden || self.alpha <= 0.01) {
        return nil;
    }
    if ([self pointInside:point withEvent:event]) {
        for (UIView *subview in [self.subviews reverseObjectEnumerator]) {
            CGPoint convertedPoint = [subview convertPoint:point fromView:self];
            UIView *hitTestView = [subview hitTest:convertedPoint withEvent:event];
            if (hitTestView) {
                return hitTestView;
            }
        }
        return self;
    }
    [self hide];
    return nil;
}

@end
