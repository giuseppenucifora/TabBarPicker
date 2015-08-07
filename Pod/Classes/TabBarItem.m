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

@interface TabBarItem()


@property (nonatomic, strong) UIButton *itemButton;
@property (nonatomic) UIDeviceOrientation orientation;
@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation TabBarItem

- (instancetype) initWithSubItems:(NSArray*) array {
    self = [self initForAutoLayout];
    if (self) {
        NSAssert(array, @"SubItemsArray cannot be nil");
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name: UIDeviceOrientationDidChangeNotification object: nil];
        
        _orientation = [[UIDevice currentDevice] orientation];
        
        _itemButton = [[UIButton alloc] initForAutoLayout];
        [_itemButton addTarget:self action:@selector(itemButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        _highlightColor = [@"ff4e50" colorFromHex];
        
        [self addSubview:_itemButton];
        
        _subItems = [[NSMutableArray alloc] init];
        
        for (NSObject *subItem in array) {
            if ([subItem isKindOfClass:[TabBarSubItem class]]) {
                [_subItems addObject:subItem];
            }
        }
    }
    return self;
}

- (void) layoutSubviews {
    
    //[_itemButton autoPinEdgesToSuperviewMargins];
    if (!_didSetupConstraints) {
    [_itemButton autoCenterInSuperview];
    [_itemButton autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self];
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
}

- (void) setHighlightColor:(UIColor *)highlightColor {
    
    _highlightColor = highlightColor;
}

- (void) setHighlighted:(BOOL) highlighted {
    [_itemButton setHighlighted:highlighted];
    if ([_itemButton isHighlighted]) {
        [_itemButton setBackgroundColor:_highlightColor];
        
    }
    else {
        [_itemButton setBackgroundColor:[UIColor clearColor]];
    }
}

- (void) itemButtonTapped {
    
    if ([_itemButton isHighlighted]) {
        [_itemButton setBackgroundColor:_highlightColor];
        
    }
    else {
        [_itemButton setBackgroundColor:[UIColor clearColor]];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(tabBarItemSelected:)]) {
        [_delegate tabBarItemSelected:self];
    }
}

@end
