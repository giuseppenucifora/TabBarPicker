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
        _highlightedColor = [@"ff4e50" colorFromHex];
        _itemButton = [UIButton newAutoLayoutView];
        [_itemButton addTarget:self action:@selector(itemButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [_itemButton setBackgroundColor:_highlightedColor forState:UIControlStateHighlighted];
        [_itemButton setBackgroundColor:_highlightedColor forState:UIControlStateSelected|UIControlStateHighlighted];
        
        [self addSubview:_itemButton];
        
    }
    return self;
}

- (void) layoutSubviews {
    
    if (!_didSetupConstraints) {
        [_itemButton autoCenterInSuperview];
        [_itemButton autoSetDimension:ALDimensionHeight toSize:44];
        [_itemButton autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self];

        _didSetupConstraints = YES;
    }
}

- (void) setTag:(NSInteger)tag {
    [super setTag:tag];
    for (UIView *subView in self.subviews) {
        [subView setTag:tag];
    }
    [_itemSubView setTag:tag];
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
    //[_itemButton setImage:selectedImage forState:UIControlStateSelected|UIControlStateHighlighted];
}

- (void) setHighlightedImage:(UIImage *)highlightedImage {
    [_itemButton setImage:highlightedImage forState:UIControlStateHighlighted];
    [_itemButton setImage:highlightedImage forState:UIControlStateHighlighted|UIControlStateNormal];
    [_itemButton setImage:highlightedImage forState:UIControlStateSelected|UIControlStateHighlighted];
}

- (void) setHighlightedColor:(UIColor *)highlightedColor {
    
    _highlightedColor = highlightedColor;
    [_itemButton setBackgroundColor:_highlightedColor forState:UIControlStateHighlighted];
    
}

- (void) setHighlighted:(BOOL) highlighted {
    [_itemButton setHighlighted:highlighted];
}

- (void) setSelected:(BOOL)selected {
    [_itemButton setSelected:selected];
}

- (void) setItemName:(NSString *)itemName {
    [_itemSubView setItemName:itemName];
    _itemName = itemName;
}

- (void) itemButtonTapped {
    if (_delegate && [_delegate respondsToSelector:@selector(tabBarItemSelected:)]) {
        [_delegate tabBarItemSelected:self];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.000001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setHighlighted:YES];
    });
}

@end
