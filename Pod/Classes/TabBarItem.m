//
//  TabBarItem.m
//  Pods
//
//  Created by Giuseppe Nucifora on 15/07/15.
//
//

#import "TabBarItem.h"
#import <PureLayout/PureLayout.h>
#import "NSString+HexColor.h"
#import "UIButton+BackgroundColor.h"
#import <UIKit/UIKit.h>

@interface TabBarItem()


@property (nonatomic, strong) UIButton *itemButton;
@property (nonatomic) UIDeviceOrientation orientation;
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, strong) UIView *switchBarView;
@property (nonatomic, strong) UISwitch *itemSwich;
@property (nonatomic, strong) UILabel *switchBarLabel;

@end

@implementation TabBarItem

- (instancetype) initWithSubItemView:(TabBarPickerSubItemsView*) itemSubView {
    
    return [self initWithSubItemView:itemSubView needLocalization:NO];
}

- (instancetype) initWithSubItemView:(TabBarPickerSubItemsView*) itemSubView needLocalization:(BOOL) needLocalitazion {
    self = [self initForAutoLayout];
    if (self) {
        NSAssert(itemSubView, @"itemSubView cannot be nil");
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name: UIDeviceOrientationDidChangeNotification object: nil];
        
        _orientation = [[UIDevice currentDevice] orientation];
        _itemSubView = itemSubView;
        
        _itemButton = [[UIButton alloc] initForAutoLayout];
        [_itemButton addTarget:self action:@selector(itemButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [_itemButton setBackgroundColor:[@"ff4e50" colorFromHex] forState:UIControlStateHighlighted];
        
        [self addSubview:_itemButton];

    }
    return self;
}

- (void) layoutSubviews {
    
    //[_itemButton autoPinEdgesToSuperviewMargins];
    if (!_didSetupConstraints) {
        [_itemButton autoCenterInSuperview];
        [_itemButton autoSetDimension:ALDimensionHeight toSize:44];
        [_itemButton autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self];

        _didSetupConstraints = YES;
    }
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
    //Obtain current device orientation
    _orientation = [[UIDevice currentDevice] orientation];
    
    [self layoutSubviews];
}

- (void) setImage:(UIImage *)image {
    [_itemButton setImage:image forState:UIControlStateNormal];
}

- (void) setSelectedImage:(UIImage *)selectedImage {
    
    [_itemButton setImage:selectedImage forState:UIControlStateSelected];
    [_itemButton setImage:selectedImage forState:UIControlStateSelected|UIControlStateHighlighted];
}

- (void) setHighlightedImage:(UIImage *)highlightedImage {
    [_itemButton setImage:highlightedImage forState:UIControlStateHighlighted];
    [_itemButton setImage:highlightedImage forState:UIControlStateHighlighted|UIControlStateNormal];
}

- (void) setHighlightedColor:(UIColor *)highlightedColor {
    
    _highlightedColor = highlightedColor;
    [_itemButton setBackgroundColor:_highlightedColor forState:UIControlStateHighlighted];
}

- (void) setHighlighted:(BOOL) highlighted {
    [_itemButton setHighlighted:highlighted];
}

- (void) itemButtonTapped {
    if (_delegate && [_delegate respondsToSelector:@selector(tabBarItemSelected:)]) {
        [_delegate tabBarItemSelected:self];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.00001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setHighlighted:YES];
    });
}



- (void)openSettings
{
    BOOL canOpenSettings = (&UIApplicationOpenSettingsURLString != NULL);
    if (canOpenSettings) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
