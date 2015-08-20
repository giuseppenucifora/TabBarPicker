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

@interface TabBarPickerSubItemsView() <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic) TabBarPickerSubItemsViewType type;
@property (nonatomic, strong) NSMutableArray *subItems;
@property (nonatomic, strong) UIView *switchBarView;
@property (nonatomic, strong) UISwitch *itemSwich;
@property (nonatomic, strong) UILabel *switchBarLabel;
@property (nonatomic, strong) UIButton *localizationButton;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) UIView *HUD;
@property (nonatomic, strong) UIPickerView *pickerView;


@end

@implementation TabBarPickerSubItemsView

- (instancetype) initWithType:(TabBarPickerSubItemsViewType) type subItems:(NSArray*) subItems {
    return [self initWithType:type subItems:subItems needsLocalization:NO];
}

- (instancetype) initWithType:(TabBarPickerSubItemsViewType) type subItems:(NSArray*) subItems needsLocalization:(BOOL) needsLocalization{
    
    self                = [self initForAutoLayout];
    
    if (self) {
        [self setUserInteractionEnabled:YES];
        
        _subItems = [[NSMutableArray alloc] init];
        
        for (NSObject *subItem in subItems) {
            if ([subItem isKindOfClass:[TabBarSubItem class]]) {
                [_subItems addObject:subItem];
            }
        }
        
        _type               = type;
        _needsLocalization  = needsLocalization;
        _switchBarView      = [[UIView alloc] initForAutoLayout];
        [_switchBarView setBackgroundColor:[@"f7f7f7" colorFromHex]];
        
        _switchBarLabel     = [[UILabel alloc] initForAutoLayout];
        [_switchBarLabel setTextColor:[@"999999" colorFromHex]];
        [_switchBarView addSubview:_switchBarLabel];
        
        _itemSwich          = [[UISwitch alloc] initForAutoLayout];
        [_itemSwich setOnTintColor:[@"ff4e50" colorFromHex]];
        
        [_itemSwich.layer setBorderWidth:2];
        [_itemSwich.layer setBorderColor:[[@"cccccc" colorFromHex] CGColor]];
        [_itemSwich.layer setCornerRadius:_itemSwich.frame.size.height/2];
        [_itemSwich setUserInteractionEnabled:YES];
        [_itemSwich addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
        
        _contentView        = [[UIView alloc] initForAutoLayout];
        
        
        [self addSubview:_contentView];
        
        _HUD = [[UIView alloc] initForAutoLayout];
        [_HUD setAlpha:0];
        [_HUD setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.25]];
        
        [_contentView addSubview:_HUD];
        
        
        switch (_type) {
            case TabBarPickerSubItemsViewTypeDateAndTime: {
                
                break;
            }
            case TabBarPickerSubItemsViewTypeCheckBox: {
                
                break;
            }
            case TabBarPickerSubItemsViewTypeDistance: {
                _pickerView = [[UIPickerView alloc] initForAutoLayout];
                [_pickerView setDelegate:self];
                [_pickerView setDataSource:self];
                
                [_contentView addSubview:_pickerView];
                
                break;
            }
            case TabBarPickerSubItemsViewTypePrice: {
                
                break;
            }
            default: {
                break;
            }
        }
        
        if (_needsLocalization) {
            
            _localizationView   = [[UIView alloc] initForAutoLayout];
            [_localizationView setBackgroundColor:[UIColor whiteColor]];
            [_localizationView setAlpha:0];
            
            _localizationButton = [[UIButton alloc] initForAutoLayout];
            [_localizationButton setTitle:NSLocalizedString(@"ATTIVA LOCALIZZAZIONE DISPOSITIVO", @"") forState:UIControlStateNormal];
            [_localizationButton addTarget:self action:@selector(openSettings) forControlEvents:UIControlEventTouchUpInside];
            [_localizationButton setBackgroundColor:[UIColor whiteColor]];
            [_localizationButton.layer setBorderColor:[[@"ff4e50" colorFromHex] CGColor]];
            [_localizationButton.layer setBorderWidth:1];
            [_localizationButton setTitleColor:[@"ff4e50" colorFromHex] forState:UIControlStateNormal];
            [_localizationButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
            [_localizationButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
            
            [_localizationView addSubview:_localizationButton];
            
            [_contentView addSubview:_localizationView];
        }
        
        [self addSubview:_switchBarView];
        
        [_switchBarView addSubview:_itemSwich];
    }
    
    [self updateConstraintsIfNeeded];
    
    return self;
}


- (void) layoutSubviews {
    
    //NSAssert(_dataSource, @"TabBarPickerSubItemsView needs datasource");
    
    if (_needsLocalization) {
        
        [UIView animateWithDuration:0.5 animations:^{
            [_localizationView setAlpha:[[NSNumber numberWithBool:![[SharedLocationManager sharedManager] localizationIsAuthorized]] floatValue]];
            if ([[SharedLocationManager sharedManager] localizationIsAuthorized]) {
                [_itemSwich setUserInteractionEnabled:[[SharedLocationManager sharedManager] localizationIsAuthorized]];
            }
            else {
                [_itemSwich setUserInteractionEnabled:[[SharedLocationManager sharedManager] localizationIsAuthorized]];
                [_itemSwich setOn:[[SharedLocationManager sharedManager] localizationIsAuthorized]];
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
        
        if (_needsLocalization) {
            
            [_localizationView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_contentView];
            
            [_localizationView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:_contentView];
            [_localizationView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
            [_localizationView autoAlignAxisToSuperviewAxis:ALAxisVertical];
            
            [_localizationButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
            [_localizationButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
            [_localizationButton autoSetDimension:ALDimensionHeight toSize:44 relation:NSLayoutRelationLessThanOrEqual];
            [_localizationButton autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:0.8];
        }
        
        _didSetupConstraints = YES;
    }
    
    [_localizationButton.layer setCornerRadius:_localizationButton.frame.size.height/2];
}

- (void) setBackgroundColor:(UIColor *)backgroundColor {
    [_contentView setBackgroundColor:backgroundColor];
}

- (void) enableLocalizationWithView:(UIView *) localizationView {
    _needsLocalization = YES;
    _localizationView = localizationView;
    
    [self addSubview:_localizationView];
}


- (void)openSettings
{
    UIAlertView *alert = [UIAlertView alertViewWithTitle:NSLocalizedString(@"Settings", @"") message:NSLocalizedString(@"Open Settings?", @"")];
    
    [alert addButtonWithTitle:NSLocalizedString(@"OK", @"") actionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
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
        
    } else{
        NSLog(@"Switch is OFF");
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
        [(TabBarSubItem*)[_subItems firstObject] numberOfValues];
    }
    return 0;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
}

#pragma mark -

#pragma mark UIPickerViewDelegate

/*
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
}
*/

#pragma mark -

@end
