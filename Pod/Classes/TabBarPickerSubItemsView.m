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

@interface TabBarPickerSubItemsView()

@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic) TabBarPickerSubItemsViewType type;
@property (nonatomic, strong) NSMutableArray *subItems;
@property (nonatomic, strong) UIView *switchBarView;
@property (nonatomic, strong) UISwitch *itemSwich;
@property (nonatomic, strong) UILabel *switchBarLabel;
@property (nonatomic, strong) UIButton *localizationButton;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation TabBarPickerSubItemsView

- (instancetype) initWithType:(TabBarPickerSubItemsViewType) type subItems:(NSArray*) subItems {
    return [self initWithType:type subItems:subItems needsLocalization:NO];
}

- (instancetype) initWithType:(TabBarPickerSubItemsViewType) type subItems:(NSArray*) subItems needsLocalization:(BOOL) needsLocalization{
    
    self                = [self initForAutoLayout];
    
    if (self) {
        [self setUserInteractionEnabled:YES];
        _type               = type;
        _needsLocalization  = needsLocalization;
        _switchBarView      = [[UIView alloc] initForAutoLayout];
        [_switchBarView setBackgroundColor:[@"f7f7f7" colorFromHex]];
        
        _switchBarLabel     = [[UILabel alloc] initForAutoLayout];
        [_switchBarLabel setTextColor:[@"999999" colorFromHex]];
        [_switchBarLabel setText:NSLocalizedString(@"Distance", @"")];
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
        
        if (_needsLocalization) {
            
            _localizationView   = [[UIView alloc] initForAutoLayout];
            [_localizationView setBackgroundColor:[UIColor purpleColor]];
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
    
    [UIView animateWithDuration:0.5 animations:^{
        [_localizationView setAlpha:[[NSNumber numberWithBool:[[SharedLocationManager sharedManager] localizationIsAuthorized]] floatValue]];
    }];
    
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

@end
