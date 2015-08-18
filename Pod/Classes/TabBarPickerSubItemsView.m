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

@interface TabBarPickerSubItemsView()

@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic) TabBarPickerSubItemsViewType type;
@property (nonatomic, strong) NSMutableArray *subItems;
@property (nonatomic, strong) UIView *switchBarView;
@property (nonatomic, strong) UISwitch *itemSwich;
@property (nonatomic, strong) UILabel *switchBarLabel;
@property (nonatomic, strong) UIButton *localizationButton;

@end

@implementation TabBarPickerSubItemsView

- (instancetype) initWithType:(TabBarPickerSubItemsViewType) type subItems:(NSArray*) subItems {
    return [self initWithType:type subItems:subItems needsLocalization:NO];
}

- (instancetype) initWithType:(TabBarPickerSubItemsViewType) type subItems:(NSArray*) subItems needsLocalization:(BOOL) needsLocalization{
    
    self = [self initForAutoLayout];
    
    if (self) {
        [self setUserInteractionEnabled:YES];
        _type = type;
        _needsLocalization = needsLocalization;
        _switchBarView = [[UIView alloc] initForAutoLayout];
        [_switchBarView setBackgroundColor:[@"f7f7f7" colorFromHex]];
        
        _switchBarLabel = [[UILabel alloc] initForAutoLayout];
        [_switchBarLabel setTextColor:[@"999999" colorFromHex]];
        [_switchBarLabel setText:NSLocalizedString(@"Distance", @"")];
        [_switchBarView addSubview:_switchBarLabel];
        
        _itemSwich = [[UISwitch alloc] initForAutoLayout];
        [_itemSwich setOnTintColor:[@"ff4e50" colorFromHex]];

        [_itemSwich.layer setBorderWidth:2];
        [_itemSwich.layer setBorderColor:[[@"cccccc" colorFromHex] CGColor]];
        [_itemSwich.layer setCornerRadius:_itemSwich.frame.size.height/2];
        [_itemSwich setUserInteractionEnabled:YES];
        [_itemSwich addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
        [_switchBarView addSubview:_itemSwich];
        
        if (_needsLocalization) {
            
            _localizationView = [[UIView alloc] initForAutoLayout];
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
            
            [self addSubview:_localizationView];
        }
        
        /*_subItems = [[NSMutableArray alloc] init];
         for (NSObject *subItem in subItems) {
         if ([subItem isKindOfClass:[TabBarSubItem class]]) {
         [_subItems addObject:subItem];
         }
         }*/
        [self addSubview:_switchBarView];
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
        
        [_localizationView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_itemSwich withOffset:4];
        [_localizationView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self];
        [_localizationView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self];
        
        [_localizationButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_localizationButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [_localizationButton autoSetDimension:ALDimensionHeight toSize:44 relation:NSLayoutRelationLessThanOrEqual];
        [_localizationButton autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:0.8];
        
        _didSetupConstraints = YES;
    }
    NSLog(@"%f %f",self.frame.size.width,self.frame.size.height);
    NSLog(@"%f %f",_switchBarView.frame.size.width,_switchBarView.frame.size.height);
    [_localizationButton.layer setCornerRadius:_localizationButton.frame.size.height/2];
}

- (void) enableLocalizationWithView:(UIView *) localizationView {
    _needsLocalization = YES;
    _localizationView = localizationView;
    
    [self addSubview:_localizationView];
}


- (void)openSettings
{
    BOOL canOpenSettings = (&UIApplicationOpenSettingsURLString != NULL);
    if (canOpenSettings) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }
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
