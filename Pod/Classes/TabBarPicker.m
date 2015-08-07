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
#import <UIView-Overlay/UIView+Overlay.h>

#define DEFAULT_SUB_ITEMS_PER_ROW 2
#define DEFAULT_SUB_ITEM_HEIGHT 44

@interface TabBarPicker() <TabBarPickerSubItemsViewDelegate,TabBarItemDelegate>

@property (nonatomic) UIDeviceOrientation orientation;
@property (nonatomic) NSUInteger subItemRows;
@property (nonatomic, strong) NSMutableArray *subItemSelectors;
@property (nonatomic, strong) NSMutableArray *subItemSelectorsConstraints;
@property (nonatomic) BOOL isShow;
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, strong) NSLayoutConstraint *showConstraint;
@property (nonatomic, strong) NSLayoutConstraint *hideConstraint;
@property (nonatomic, strong) NSMutableArray *tabBarItemsConstraints;
@property (nonatomic, strong) TabBarItem *selectedTabBarItem;
@property (nonatomic, strong) MMCPSScrollView *subItemScrollView;

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
        _dimWhenShow = YES;
        _subItemSelectors = [[NSMutableArray alloc] init];
        _tabBarItemsConstraints = [[NSMutableArray alloc] init];
        _subItemSelectorsConstraints = [[NSMutableArray alloc] init];
        _dimColor = [[UIColor blackColor] colorWithAlphaComponent: 0.5];
        
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        
        [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object: nil];
        
        NSAssert(items, @"TabBar Items array cannot be nil!");
        
        if (CGSizeEqualToSize(size, CGSizeZero)) {
            _tabBarSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width, 44);
        }
        
        _tabBarItems = [[NSMutableArray alloc] init];
        
        for (NSObject *item in items) {
            if (item && [item isKindOfClass:[TabBarItem class]]) {
                
                [_tabBarItems addObject:item];
                [(TabBarItem*)item setDelegate:self];
                [self addSubview:item];
            }
        }
        
        _subItemScrollView = [[MMCPSScrollView alloc] initForAutoLayout];
        [_subItemScrollView setType:MMCPSScrollHorizontal];
        [_subItemScrollView setMMCPSDelegate:self];
        [_subItemScrollView setPagingEnabled:YES];
        [_subItemScrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        
        [self addSubview:_subItemScrollView];
        
        if ([_tabBarItems count] > 0) {
            int i = 0;
            for (TabBarItem *item in _tabBarItems) {
                TabBarPickerSubItemsView *subItemSelector = [[TabBarPickerSubItemsView alloc] initWithTabBarItem:item andsubItemsPerRow:_subItemPerRow];
                [subItemSelector setDelegate:self];
                switch (i) {
                    case 0:
                        [subItemSelector setBackgroundColor:[UIColor lightGrayColor]];
                        break;
                    case 1:{
                        [subItemSelector setBackgroundColor:[UIColor redColor]];
                    }
                        break;
                    case 2:{
                        [subItemSelector setBackgroundColor:[UIColor greenColor]];
                    }
                        break;
                    case 3: {
                        [subItemSelector setBackgroundColor:[UIColor yellowColor]];
                    }
                        break;
                    default:
                        break;
                }
                i++;
                [_subItemScrollView addSubview:subItemSelector];
                
                [_subItemSelectors addObject:subItemSelector];
            }
            [_subItemScrollView setPageSize:1];
        }
    }
    
    [self updateConstraintsIfNeeded];
    
    return self;
}

- (void) layoutSubviews {
   
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
                
                [_tabBarItemsConstraints addObjectsFromArray:[_tabBarItems autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:_itemSpacing insetSpacing:YES matchedSizes:YES]];
                
                
                
                [_subItemScrollView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self];
                [_subItemScrollView autoSetDimension:ALDimensionHeight toSize:343];
                [_subItemScrollView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:[_tabBarItems firstObject]];
                [_subItemScrollView autoAlignAxisToSuperviewAxis:ALAxisVertical];
                
                //[_subItemScrollView setPageSize:343];
                [_subItemScrollView setSegmentSize:[[UIScreen mainScreen] bounds].size.width];
                
                [_subItemSelectors autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:0 insetSpacing:YES matchedSizes:YES];
                [_subItemSelectors autoSetViewsDimension:ALDimensionHeight toSize:343];
                [_subItemSelectors autoSetViewsDimension:ALDimensionWidth toSize:[[UIScreen mainScreen] bounds].size.width];
                
                [[_subItemSelectors firstObject] autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
                
                [_subItemScrollView setContentSize:CGSizeMake([_subItemSelectors count]*[[UIScreen mainScreen] bounds].size.width , 343)];
                
            }
                break;
        }
        
        
        _didSetupConstraints = YES;
        
        [self updateConstraintsIfNeeded];
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
                                 
                                 [self.superview ag_addOverlayWithColor:_dimColor];
                                 self.layer.zPosition = 999;
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
                                     
                                     _showConstraint = [self autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:_subItemScrollView.frame.size.height];
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
                                 [self.superview ag_removeOverlay];
                                 self.layer.zPosition = 0;
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
                                     
                                     _hideConstraint = [self autoPinEdgeToSuperviewMargin:ALEdgeBottom];
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

#pragma mark TabBarPickerSubItemsViewDelegate

- (void) tabarPickerSubItemsView:(TabBarPickerSubItemsView*) tabarPickerSubItemsView didSelect:(TabBarItem*) item {
    
}

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
    NSLog(@"The MMCPSScrollView is now on page %i.", pageIndex);
}

- (void)scrollView:(MMCPSScrollView *)scrollView willScrollToPage:(NSUInteger)pageIndex {
    NSLog(@"The MMCPSScrollView is now going to page %i.", pageIndex);
}

#pragma mark -

@end
