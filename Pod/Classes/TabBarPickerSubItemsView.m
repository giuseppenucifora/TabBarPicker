//
//  TabBarPickerSubItemsView.m
//  Pods
//
//  Created by Giuseppe Nucifora on 17/07/15.
//
//

#import "TabBarPickerSubItemsView.h"
#import <PureLayout/PureLayout.h>
#import "TabBarItem.h"
#import "NSString+HexColor.h"
#import "SharedLocationManager.h"
#import "UIAlertView+BlockExtension.h"
#import "AADatePicker.h"
#import "ToucheableScrollView.h"

@interface TabBarPickerSubItemsView() <UIPickerViewDataSource,UIPickerViewDelegate,AADatePickerDelegate,TabBarSubItemDelegate>

@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, strong) NSMutableArray *subItems;
@property (nonatomic, strong) UIView *switchBarView;
@property (nonatomic, strong) UISwitch *itemSwich;
@property (nonatomic, strong) UILabel *switchBarLabel;
@property (nonatomic, strong) UIButton *localizationButton;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) UIView *HUD;
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) AADatePicker *datePicker;

@property (nonatomic, strong) ToucheableScrollView *scrollView;

@property (nonatomic, strong) UILabel *minPrice;
@property (nonatomic, strong) UILabel *maxPrice;

@property (nonatomic) NSUInteger firstLoadFirstComponent;
@property (nonatomic) NSUInteger firstLoadSecondComponent;



@end

@implementation TabBarPickerSubItemsView

- (instancetype) initWithType:(TabBarPickerSubItemsViewType) type subItems:(NSArray*) subItems {
    return [self initWithType:type subItems:subItems needsLocalization:NO];
}

- (instancetype) initWithType:(TabBarPickerSubItemsViewType) type subItems:(NSArray*) subItems needsLocalization:(BOOL) needsLocalization{
    
    self = [self initForAutoLayout];
    
    if (self) {
        _firstLoadFirstComponent = 0;
        _firstLoadSecondComponent = 0;
        _selectedAllergens = [[NSMutableArray alloc] init];
        _selectedTypes = [[NSMutableArray alloc] init];
        [self setUserInteractionEnabled:YES];
        [self setBackgroundColor:[UIColor whiteColor]];
        _type               = type;
        _subItems = [[NSMutableArray alloc] init];
        
        for (NSObject *subItem in subItems) {
            if ([subItem isKindOfClass:[TabBarSubItem class]]) {
                [(TabBarSubItem*)subItem setType:(TabBarSubItemsViewType)_type];
                [_subItems addObject:subItem];
            }
        }
        
        _needsLocalization  = needsLocalization;
        _switchBarView      = [UIView newAutoLayoutView];
        [_switchBarView setBackgroundColor:[@"f7f7f7" colorFromHex]];
        
        _switchBarLabel     = [UILabel newAutoLayoutView];
        [_switchBarLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
        [_switchBarLabel setTextColor:[@"999999" colorFromHex]];
        [_switchBarView addSubview:_switchBarLabel];
        
        _itemSwich          = [UISwitch newAutoLayoutView];
        [_itemSwich setOnTintColor:[@"ff4e50" colorFromHex]];
        
        [_itemSwich.layer setBorderWidth:2];
        [_itemSwich.layer setBorderColor:[[@"cccccc" colorFromHex] CGColor]];
        [_itemSwich.layer setCornerRadius:_itemSwich.frame.size.height/2];
        [_itemSwich setUserInteractionEnabled:YES];
        [_itemSwich addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
        
        _contentView = [UIView newAutoLayoutView];
        
        
        [self addSubview:_contentView];
        
        switch (_type) {
            case TabBarPickerSubItemsViewTypeDateAndTime: {
                _datePicker = [AADatePicker newAutoLayoutView];
                [_datePicker setShowOnlyValidDates:YES];
                [_datePicker setDelegate:self];
                [_contentView addSubview:_datePicker];
                break;
            }
            case TabBarPickerSubItemsViewTypeDistance:{
                _pickerView = [UIPickerView newAutoLayoutView];
                [_pickerView setDelegate:self];
                [_pickerView setDataSource:self];
                [_contentView addSubview:_pickerView];
                break;
            }
            case TabBarPickerSubItemsViewTypePrice: {
                _pickerView = [UIPickerView newAutoLayoutView];
                [_pickerView setDelegate:self];
                [_pickerView setDataSource:self];
                [_contentView addSubview:_pickerView];
                
                _minPrice = [UILabel newAutoLayoutView];
                [_minPrice setTextAlignment:NSTextAlignmentCenter];
                [_minPrice setText:NSLocalizedString(@"KEY_FILTER_PRICE_MIN", @"")];
                [_minPrice setFont:[UIFont fontWithName:@"HelveticaNeue" size:10]];
                [_minPrice setTextColor:[@"999999" colorFromHex]];
                [_contentView addSubview:_minPrice];
                
                _maxPrice = [UILabel newAutoLayoutView];
                [_maxPrice setTextAlignment:NSTextAlignmentCenter];
                [_maxPrice setText:NSLocalizedString(@"KEY_FILTER_PRICE_MAX", @"")];
                [_maxPrice setFont:[UIFont fontWithName:@"HelveticaNeue" size:10]];
                [_maxPrice setTextColor:[@"999999" colorFromHex]];
                [_contentView addSubview:_maxPrice];
                break;
            }
            case TabBarPickerSubItemsViewTypeCheckBox:
            case TabBarPickerSubItemsViewTypeButton:{
                _scrollView = [ToucheableScrollView newAutoLayoutView];
                [_scrollView setBackgroundColor:[UIColor clearColor]];
                
                for (TabBarSubItem *item in _subItems) {
                    [item setDelegate:self];
                    
                    [_scrollView addSubview:item];
                }
                
                [_contentView addSubview:_scrollView];
                break;
            }
            default: {
                break;
            }
        }
        
        if (_needsLocalization) {
            
            _localizationView   = [UIView newAutoLayoutView];
            [_localizationView setBackgroundColor:[UIColor whiteColor]];
            [_localizationView setAlpha:0];
            
            _localizationButton = [UIButton newAutoLayoutView];
            [_localizationButton setTitle:NSLocalizedString(@"ATTIVA LOCALIZZAZIONE DISPOSITIVO", @"") forState:UIControlStateNormal];
            [_localizationButton addTarget:self action:@selector(openSettings) forControlEvents:UIControlEventTouchUpInside];
            [_localizationButton setBackgroundColor:[UIColor whiteColor]];
            [_localizationButton.layer setBorderColor:[[@"ff4e50" colorFromHex] CGColor]];
            [_localizationButton.layer setBorderWidth:1];
            [_localizationButton setTitleColor:[@"ff4e50" colorFromHex] forState:UIControlStateNormal];
            [_localizationButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
            [_localizationButton setContentEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 10)];
            
            [_localizationView addSubview:_localizationButton];
            
            [_contentView addSubview:_localizationView];
        }
        
        [self addSubview:_switchBarView];
        
        [_switchBarView addSubview:_itemSwich];
        
        _HUD = [UIView newAutoLayoutView];
        [_HUD setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.25]];
        [_HUD setAlpha:1];
        [_contentView addSubview:_HUD];
    }
    
    [self updateConstraintsIfNeeded];
    
    return self;
}

- (void) setTag:(NSInteger)tag {
    [super setTag:tag];
    for (UIView *subView in self.subviews) {
        [subView setTag:tag];
    }
    [_HUD setTag:tag];
    [_localizationButton setTag:tag];
    [_localizationView setTag:tag];
}


- (void) layoutSubviews {
    
    //NSAssert(_dataSource, @"TabBarPickerSubItemsView needs datasource");
    
    if (_needsLocalization) {
        
        [UIView animateWithDuration:0.5 animations:^{
            [_localizationView setAlpha:[[NSNumber numberWithBool:![[SharedLocationManager sharedManager] localizationIsAuthorized]] floatValue]];
            if ([[SharedLocationManager sharedManager] localizationIsAuthorized]) {
                [_itemSwich setUserInteractionEnabled:YES];
            }
            else {
                [_itemSwich setUserInteractionEnabled:NO];
                [_itemSwich setOn:NO];
            }
        }];
    }
    
    if (!_didSetupConstraints) {
        
        [self autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.superview withOffset:0 relation:NSLayoutRelationEqual];
        [self autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.superview withOffset:0 relation:NSLayoutRelationEqual];
        
        [_switchBarView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.superview];
        [_switchBarView autoSetDimension:ALDimensionHeight toSize:40];
        [_switchBarView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self];
        [_switchBarView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
        [_switchBarLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:20];
        [_switchBarLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        [_itemSwich autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_switchBarView withOffset:-20];
        [_itemSwich autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        [_contentView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_switchBarView];
        [_contentView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self];
        [_contentView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self];
        [_contentView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
        [_HUD autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:_contentView];
        [_HUD autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:_contentView];
        [_HUD autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [_HUD autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_contentView];
        
        switch (_type) {
            case TabBarPickerSubItemsViewTypeDateAndTime: {
                [_datePicker autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:_contentView];
                [_datePicker autoAlignAxisToSuperviewAxis:ALAxisVertical];
                [_datePicker autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
                break;
            }
            case TabBarPickerSubItemsViewTypeDistance:{
                [_pickerView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:_contentView];
                [_pickerView autoAlignAxisToSuperviewAxis:ALAxisVertical];
                [_pickerView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
                break;
            }
            case TabBarPickerSubItemsViewTypePrice: {
                [_minPrice autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_switchBarView withOffset:10];
                [_minPrice autoSetDimension:ALDimensionWidth toSize:[[UIScreen mainScreen] bounds].size.width/2];
                [_minPrice autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView];
                
                [_maxPrice autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_switchBarView withOffset:10];
                [_maxPrice autoSetDimension:ALDimensionWidth toSize:[[UIScreen mainScreen] bounds].size.width/2];
                [_maxPrice autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_contentView];
                
                [_pickerView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:_contentView];
                [_pickerView autoAlignAxisToSuperviewAxis:ALAxisVertical];
                [_pickerView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
                break;
            }
            case TabBarPickerSubItemsViewTypeButton:{
                [_scrollView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:_contentView];
                [_scrollView autoAlignAxisToSuperviewAxis:ALAxisVertical];
                [_scrollView autoPinEdgeToSuperviewEdge:ALEdgeTop];
                [_scrollView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:40];
                
                //[_subItems autoDistributeViewsAlongAxis:ALAxisVertical alignedTo:ALAttributeVertical withFixedSpacing:10 insetSpacing:YES matchedSizes:YES];
                
                //[[_subItems firstObject] autoAlignAxisToSuperviewAxis:ALAxisVertical];
                BOOL firstOfRow = YES;
                TabBarSubItem *prevItem;
                CGFloat currentWidth = 0;
                for (TabBarSubItem *item in _subItems) {
                    
                    if (currentWidth + item.subItemSize.width > [[UIScreen mainScreen] bounds].size.width) {
                        firstOfRow = YES;
                        currentWidth = 0;
                    }
                    
                    if (firstOfRow) {
                        if (prevItem) {
                            [item autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:prevItem withOffset:0];
                        }
                        else {
                            [item autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_scrollView withOffset:0];
                        }
                        [item autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_scrollView withOffset:0];
                        prevItem = item;
                        firstOfRow = NO;
                    }
                    else {
                        [item autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:prevItem withOffset:0];
                        [item autoAlignAxis:ALAxisHorizontal toSameAxisOfView:prevItem withOffset:0];
                        prevItem = item;
                        
                        if ([item isEqual:[_subItems lastObject]]) {
                            [item autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_scrollView withOffset:0];
                        }
                    }
                    currentWidth += item.subItemSize.width;
                }
                break;
            }
            case TabBarPickerSubItemsViewTypeCheckBox: {
                [_scrollView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:_contentView];
                [_scrollView autoAlignAxisToSuperviewAxis:ALAxisVertical];
                [_scrollView autoPinEdgeToSuperviewEdge:ALEdgeTop];
                [_scrollView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:40];
                
                TabBarSubItem *prevItem;
                BOOL firstOfRow = YES;
                
                for (TabBarSubItem *item in _subItems) {
                    if (firstOfRow) {
                        
                        if (prevItem) {
                            [item autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:prevItem withOffset:0];
                        }
                        else {
                            [item autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_scrollView withOffset:0];
                        }
                        [item autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_scrollView withOffset:0];
                        firstOfRow = NO;
                        prevItem = item;
                    }
                    else {
                        [item autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:prevItem withOffset:0];
                        [item autoAlignAxis:ALAxisHorizontal toSameAxisOfView:prevItem withOffset:0];
                        firstOfRow = YES;
                        
                        if ([item isEqual:[_subItems lastObject]]) {
                            [item autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_scrollView withOffset:0];
                            [prevItem autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_scrollView withOffset:0];
                        }
                    }
                }
                
                break;
            }
            default: {
                break;
            }
        }
        
        if (_needsLocalization) {
            
            [_localizationView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_contentView];
            [_localizationView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:_contentView];
            [_localizationView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
            [_localizationView autoAlignAxisToSuperviewAxis:ALAxisVertical];
            [_localizationButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
            [_localizationButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
            [_localizationButton autoSetDimension:ALDimensionHeight toSize:44 relation:NSLayoutRelationEqual];
            [_localizationButton autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:0.8];
            [_localizationButton.layer setCornerRadius:44/2];
            
        }
        
        _didSetupConstraints = YES;
    }
}

- (void) setBackgroundColor:(UIColor *)backgroundColor {
    [_contentView setBackgroundColor:backgroundColor];
}

- (void) enableLocalizationWithView:(UIView *) localizationView {
    _needsLocalization = YES;
    _localizationView = localizationView;
    
    [self addSubview:_localizationView];
}

- (void) dateChanged:(AADatePicker *)datePicker {
    
    _pickerSelectedDate = datePicker.date;
    _selectedDate = [TabBarSubItem tabBarSubItemWithName:@"date" firstValue:_pickerSelectedDate secondValue:nil andReference:_pickerSelectedDate];
    [_selectedDate setType:(TabBarSubItemsViewType)_type];
    [_tabBarItemReference setSelected:YES];
    
    if (_selectedDate) {
        if (_delegate && [_delegate respondsToSelector:@selector(tabBarPickerSubItemsView:didSelectTabBarSubItem:forTabBarItem:)]) {
            [_delegate tabBarPickerSubItemsView:self didSelectTabBarSubItem:_selectedDate forTabBarItem:_tabBarItemReference];
        }
    }
}
- (void) openSettings
{
    UIAlertView *alert = [UIAlertView alertViewWithTitle:NSLocalizedString(@"Settings", @"") message:NSLocalizedString(@"Open Settings?", @"")];
    
    [alert addButtonWithTitle:NSLocalizedString(@"KEY_OK", @"") actionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        NSURL *settings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:settings])
        {
            [[UIApplication sharedApplication] openURL:settings];
        }
    }];
    [alert addCancelButtonWithTitle:NSLocalizedString(@"CANCEL", @"") actionBlock:nil];
    [alert show];
    
}

- (void)changeSwitch:(UISwitch*)sender{
    
    [_HUD setAlpha:[[NSNumber numberWithBool:![sender isOn]] floatValue]];
    if([sender isOn]){
        NSLog(@"Switch is ON");
        
        switch (_type) {
            case TabBarPickerSubItemsViewTypeDistance: {
                if (!_selectedDistance) {
                    _selectedDistance = [_subItems objectAtIndex:[_pickerView selectedRowInComponent:0]];
                    [_tabBarItemReference setSelected:YES];
                }
                
                if (_delegate && [_delegate respondsToSelector:@selector(tabBarPickerSubItemsView:didSelectTabBarSubItem:forTabBarItem:)]) {
                    [_delegate tabBarPickerSubItemsView:self didSelectTabBarSubItem:_selectedDistance forTabBarItem:_tabBarItemReference];
                }
                break;
            }
            case TabBarPickerSubItemsViewTypeDateAndTime: {
                if (_selectedDate) {
                    if (_delegate && [_delegate respondsToSelector:@selector(tabBarPickerSubItemsView:didSelectTabBarSubItem:forTabBarItem:)]) {
                        [_delegate tabBarPickerSubItemsView:self didSelectTabBarSubItem:_selectedDate forTabBarItem:_tabBarItemReference];
                    }
                }
                
                break;
            }
            case TabBarPickerSubItemsViewTypePrice: {
                if ([_subItems  count] > 0) {
                    if (!_selectedMinPrice) {
                        _selectedMinPrice = [_subItems objectAtIndex:[_pickerView selectedRowInComponent:0]];
                    }
                    
                    if (!_selectedMaxPrice) {
                        _selectedMaxPrice = [_subItems objectAtIndex:[_pickerView selectedRowInComponent:1]];
                    }
                    
                    if ((_selectedMaxPrice || _selectedMinPrice) && _delegate && [_delegate respondsToSelector:@selector(tabBarPickerSubItemsView:didSelectTabBarSubItems:forTabBarItem:)]) {
                        //[_delegate tabBarPickerSubItemsView:self didSelectTabBarSubItem:_selectedMinPrice forTabBarItem:_tabBarItemReference];
                        [_tabBarItemReference setSelected:YES];
                        [_delegate tabBarPickerSubItemsView:self didSelectTabBarSubItems:@[_selectedMinPrice,_selectedMaxPrice] forTabBarItem:_tabBarItemReference];
                    }
                }
                else {
                    [_tabBarItemReference setSelected:NO];
                }
                break;
            }
            case TabBarPickerSubItemsViewTypeCheckBox: {
                if ([_selectedTypes count] > 0 && _delegate && [_delegate respondsToSelector:@selector(tabBarPickerSubItemsView:didSelectTabBarSubItems:forTabBarItem:)]) {
                    //[_delegate tabBarPickerSubItemsView:self didSelectTabBarSubItem:_selectedMinPrice forTabBarItem:_tabBarItemReference];
                    
                    [_delegate tabBarPickerSubItemsView:self didSelectTabBarSubItems:_selectedTypes forTabBarItem:_tabBarItemReference];
                }
                break;
            }
            case TabBarPickerSubItemsViewTypeButton: {
                if ([_selectedTypes count] > 0 && _delegate && [_delegate respondsToSelector:@selector(tabBarPickerSubItemsView:didSelectTabBarSubItems:forTabBarItem:)]) {
                    //[_delegate tabBarPickerSubItemsView:self didSelectTabBarSubItem:_selectedMinPrice forTabBarItem:_tabBarItemReference];
                    
                    [_delegate tabBarPickerSubItemsView:self didSelectTabBarSubItems:_selectedAllergens forTabBarItem:_tabBarItemReference];
                }
                break;
            }
            default: {
                break;
            }
        }
        
    } else{
        NSLog(@"Switch is OFF");
        
        switch (_type) {
            case TabBarPickerSubItemsViewTypeDistance: {
                _selectedDistance = nil;
                [_pickerView selectRow:0 inComponent:0 animated:YES];
                [self pickerView:_pickerView didSelectRow:0 inComponent:0];
                if (_delegate && [_delegate respondsToSelector:@selector(tabBarPickerSubItemsView:didResetTabBarSubItem:forTabBarItem:)]) {
                    [_delegate tabBarPickerSubItemsView:self didResetTabBarSubItem:_selectedDistance forTabBarItem:_tabBarItemReference];
                }
                break;
            }
            case TabBarPickerSubItemsViewTypeDateAndTime: {
                _selectedDate = nil;
                [_datePicker resetPicker];
                if (_delegate && [_delegate respondsToSelector:@selector(tabBarPickerSubItemsView:didResetTabBarSubItem:forTabBarItem:)]) {
                    [_delegate tabBarPickerSubItemsView:self didResetTabBarSubItem:_selectedDate forTabBarItem:_tabBarItemReference];
                }
                break;
            }
            case TabBarPickerSubItemsViewTypePrice: {
                _selectedMinPrice = nil;
                _selectedMaxPrice = nil;
                
                if ([_subItems count] > 0) {
                    [_pickerView selectRow:0 inComponent:0 animated:YES];
                    [_pickerView selectRow:0 inComponent:1 animated:YES];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self pickerView:_pickerView didSelectRow:0 inComponent:0 update:NO];
                        [self pickerView:_pickerView didSelectRow:0 inComponent:1 update:NO];
                        [[self tabBarItemReference] setSelected:NO];
                    });
                    if (_selectedMinPrice && _selectedMaxPrice) {
                        
                        if (_delegate && [_delegate respondsToSelector:@selector(tabBarPickerSubItemsView:didResetTabBarSubItems:forTabBarItem:)]) {
                            [_delegate tabBarPickerSubItemsView:self didResetTabBarSubItems:@[_selectedMinPrice,_selectedMaxPrice] forTabBarItem:_tabBarItemReference];
                        }
                    }
                    else {
                        if (_delegate && [_delegate respondsToSelector:@selector(tabBarPickerSubItemsView:didResetTabBarSubItems:forTabBarItem:)]) {
                            [_delegate tabBarPickerSubItemsView:self didResetTabBarSubItems:nil forTabBarItem:_tabBarItemReference];
                        }
                    }
                }
                break;
            }
            case TabBarPickerSubItemsViewTypeCheckBox: {
                for (TabBarSubItem* selectedType in _selectedTypes) {
                    [selectedType setSelected:NO];
                }
                
                [_selectedTypes removeAllObjects];
                if (_delegate && [_delegate respondsToSelector:@selector(tabBarPickerSubItemsView:didResetTabBarSubItems:forTabBarItem:)]) {
                    [_delegate tabBarPickerSubItemsView:self didResetTabBarSubItems:_selectedTypes forTabBarItem:_tabBarItemReference];
                }
                break;
            }
            case TabBarPickerSubItemsViewTypeButton: {
                
                for (TabBarSubItem* selectedAllergen in _selectedAllergens) {
                    [selectedAllergen setSelected:NO];
                }
                
                [_selectedAllergens removeAllObjects];
                if (_delegate && [_delegate respondsToSelector:@selector(tabBarPickerSubItemsView:didResetTabBarSubItems:forTabBarItem:)]) {
                    [_delegate tabBarPickerSubItemsView:self didResetTabBarSubItems:_selectedAllergens forTabBarItem:_tabBarItemReference];
                }
                
                break;
            }
            default: {
                break;
            }
        }
        
        [_tabBarItemReference setSelected:NO];
    }
}

- (void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event
{
    [super touchesEnded: touches withEvent: event];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [super touchesBegan: touches withEvent:event];
}

- (void) setItemName:(NSString *) itemName {
    [_switchBarLabel setText:itemName];
}

#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if ([_subItems count] > 0) {
        return [(TabBarSubItem*)[_subItems firstObject] numberOfValues];
        //return [_subItems count];
    }
    return 0;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_subItems count];
}

#pragma mark -

#pragma mark UIPickerViewDelegate


/*- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
 
 }*/

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    NSString *string;
    
    TabBarSubItem *subItem = [_subItems objectAtIndex:row];
    
    switch (_type) {
        case TabBarPickerSubItemsViewTypeDistance: {
            string = [subItem name];
            break;
        }
            
        case TabBarPickerSubItemsViewTypePrice: {
            string = [subItem getValueForPrice:component];
            /*if (component == 1 && [subItem isEqual:[_subItems objectAtIndex:[_subItems count]-1]]) {
             string = [@"" stringByAppendingString:string];
             }*/
            
            break;
        }
        default: {
            break;
        }
    }
    NSDictionary *attributeDict;
    
    if ((_firstLoadFirstComponent == 0 && component == 0) || ((_firstLoadSecondComponent == 0 && component == 1))) {
        attributeDict = @{NSForegroundColorAttributeName : [@"ff4e50" colorFromHex],NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:23]};
        if ((_firstLoadFirstComponent == 0 && component == 0)) {
            _firstLoadFirstComponent++;
        }
        else {
            _firstLoadSecondComponent++;
        }
    }
    else {
        attributeDict = @{NSForegroundColorAttributeName : [@"999999" colorFromHex],NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:16]};
    }
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:string attributes:attributeDict];
    
    // add the string to a label's attributedText property
    UILabel *labelView = [[UILabel alloc] init];
    [labelView setTextAlignment:NSTextAlignmentCenter];
    labelView.attributedText = attributedString;
    
    // return the label
    return labelView;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 74;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self pickerView:pickerView didSelectRow:row inComponent:component update:YES];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component update:(BOOL) update {
    [_tabBarItemReference setSelected:YES];
    
    UILabel *labelSelected = (UILabel*)[pickerView viewForRow:row forComponent:component];
    if (labelSelected) {
        
        NSDictionary *attributeDict = @{NSForegroundColorAttributeName : [@"ff4e50" colorFromHex],NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:23]};
        
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:labelSelected.text attributes:attributeDict];
        
        [labelSelected setAttributedText:attributedString];
    }
    
    switch (_type) {
        case TabBarPickerSubItemsViewTypeDistance: {
            _selectedDistance = [_subItems objectAtIndex:row];
            
            if (update) {
                
                if (_delegate && [_delegate respondsToSelector:@selector(tabBarPickerSubItemsView:didSelectTabBarSubItems:forTabBarItem:)]) {
                    
                    [_delegate tabBarPickerSubItemsView:self didSelectTabBarSubItem:_selectedDistance forTabBarItem:_tabBarItemReference];
                }
            }
            break;
        }
        case TabBarPickerSubItemsViewTypePrice: {
            switch (component) {
                case 0:{
                    if ([pickerView selectedRowInComponent:1] < row) {
                        [pickerView selectRow:row inComponent:1 animated:YES];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self pickerView:pickerView didSelectRow:row inComponent:1 update:NO];
                        });
                        
                    }
                    _selectedMinPrice = [_subItems objectAtIndex:row];
                    _selectedMaxPrice = [_subItems objectAtIndex:row];
                    break;
                }
                default:{
                    if ([pickerView selectedRowInComponent:0] > row) {
                        [pickerView selectRow:row inComponent:0 animated:YES];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self pickerView:pickerView didSelectRow:row inComponent:0 update:NO];
                        });
                    }
                    _selectedMinPrice = [_subItems objectAtIndex:row];
                    _selectedMaxPrice = [_subItems objectAtIndex:row];
                    break;
                }
            }
            
            if (!_selectedMinPrice) {
                _selectedMinPrice = [_subItems objectAtIndex:[_pickerView selectedRowInComponent:0]];
            }
            
            if (!_selectedMaxPrice) {
                _selectedMaxPrice = [_subItems objectAtIndex:[_pickerView selectedRowInComponent:1]];
            }
            
            if (update) {
                
                if (_delegate && [_delegate respondsToSelector:@selector(tabBarPickerSubItemsView:didSelectTabBarSubItems:forTabBarItem:)]) {
                    
                    [_delegate tabBarPickerSubItemsView:self didSelectTabBarSubItems:@[_selectedMinPrice,_selectedMaxPrice] forTabBarItem:_tabBarItemReference];
                }
            }
            break;
        }
        default: {
            break;
        }
    }
}

#pragma mark -

#pragma mark TabBarSubItemDelegate

- (void) tabBarSubItem:(TabBarSubItem*) item didSelected:(BOOL) selected {
    
    NSMutableArray *refArray;
    switch (_type) {
            
        case TabBarPickerSubItemsViewTypeCheckBox: {
            
            refArray = _selectedTypes;
            break;
        }
        case TabBarPickerSubItemsViewTypeButton: {
            refArray = _selectedAllergens;
            break;
        }
        default: {
            break;
        }
    }
    
    if (selected) {
        if (![refArray containsObject:item]) {
            [refArray addObject:item];
        }
    }
    else {
        if ([refArray containsObject:item]) {
            [refArray removeObject:item];
        }
    }
    
    if ([refArray count] > 0) {
        [_tabBarItemReference setSelected:YES];
    }
    else {
        [_tabBarItemReference setSelected:NO];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(tabBarPickerSubItemsView:didSelectTabBarSubItems:forTabBarItem:)]) {
        //[_delegate tabBarPickerSubItemsView:self didSelectTabBarSubItem:_selectedMinPrice forTabBarItem:_tabBarItemReference];
        
        [_delegate tabBarPickerSubItemsView:self didSelectTabBarSubItems:refArray forTabBarItem:_tabBarItemReference];
    }
}

#pragma mark -

@end
