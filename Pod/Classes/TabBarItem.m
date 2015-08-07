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
#import <UIButton+BackgroundColor/UIButton+BackgroundColor.h>

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
        [_itemButton setBackgroundColor:[@"ff4e50" colorFromHex] forState:UIControlStateHighlighted];
        
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
    [_itemButton setImage:selectedImage forState:UIControlStateSelected|UIControlStateHighlighted];
}

- (void) setHighlightedImage:(UIImage *)highlightedImage {
    [_itemButton setImage:highlightedImage forState:UIControlStateHighlighted];
    [_itemButton setImage:highlightedImage forState:UIControlStateHighlighted|UIControlStateNormal];
}

- (void) setHighlightedColor:(UIColor *)highlightedColor {
    
    _highlightedColor = highlightedColor;
    
}

- (void) setHighlighted:(BOOL) highlighted {
    [_itemButton setHighlighted:highlighted];
    if ([_itemButton isHighlighted]) {
        
        [_itemButton setBackgroundColor:_highlightedColor];
        
    }
    else {
        [_itemButton setBackgroundColor:[UIColor clearColor]];
    }
    NSLog(@"%@",[NSNumber numberWithBool:[_itemButton isSelected]]);
    NSLog(@"%@",[NSNumber numberWithBool:[_itemButton isHighlighted]]);
    NSLog(@"%@",[NSNumber numberWithBool:[_itemButton isEnabled]]);
    NSLog(@"%ld",_itemButton.state);
}

- (void) itemButtonTapped {
    if ([_itemButton isHighlighted]) {
        
        [_itemButton setBackgroundColor:_highlightedColor];
    }
    else {
        [_itemButton setBackgroundColor:[UIColor clearColor]];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(tabBarItemSelected:)]) {
        [_delegate tabBarItemSelected:self];
    }
    NSLog(@"%@",[NSNumber numberWithBool:[_itemButton isSelected]]);
    NSLog(@"%@",[NSNumber numberWithBool:[_itemButton isHighlighted]]);
    NSLog(@"%@",[NSNumber numberWithBool:[_itemButton isEnabled]]);
    NSLog(@"%ld",_itemButton.state);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_itemButton setHighlighted:YES];
    });
}

@end
