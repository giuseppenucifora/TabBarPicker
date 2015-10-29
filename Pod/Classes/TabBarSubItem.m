//
//  TabBarSubItem.m
//  Pods
//
//  Created by Giuseppe Nucifora on 15/07/15.
//
//

#import "TabBarSubItem.h"
#import <PureLayout/PureLayout.h>
#import "NSString+HexColor.h"

@interface TabBarSubItem()

@property (nonatomic) UIDeviceOrientation orientation;
@property (nonatomic, assign) BOOL didSetupConstraints;

@property (nonatomic) CGFloat buttonCornerRadius;

@end

@implementation TabBarSubItem


- (instancetype) initWithName:(NSString *) name firstValue:(id)firstValue secondValue:(id) secondValue reference:(id) reference forType:(TabBarSubItemsViewType) type {
    
    self = [self initForAutoLayout];
    if (self) {
    
        _name = name;
        _type = type;
        
        _subItemButton = [UIButton newAutoLayoutView];
        [_subItemButton setTitle:_name forState:UIControlStateNormal];
        [_subItemButton addTarget:self action:@selector(itemSelected:) forControlEvents:UIControlEventTouchUpInside];
        [_subItemButton setBackgroundColor:[UIColor whiteColor]];
        [_subItemButton setTitleColor:[@"999999" colorFromHex] forState:UIControlStateNormal];
        [_subItemButton setTitleColor:[@"ff4e50" colorFromHex] forState:UIControlStateSelected];
        
        switch (_type) {
            case TabBarSubItemsViewTypeCheckBox: {
                
                [_subItemButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
                [_subItemButton setImage:[UIImage imageNamed:@"checkBox"] forState:UIControlStateNormal];
                [_subItemButton setImage:[UIImage imageNamed:@"checkBoxSelected"] forState:UIControlStateSelected];
                [_subItemButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
                //CGFloat textWidth = [_subItemButton.currentTitle sizeWithAttributes:[_subItemButton.titleLabel.attributedText attributesAtIndex:0 effectiveRange:NULL]].width;
                _subItemButton.imageEdgeInsets = UIEdgeInsetsMake(0, 22, 0, 0);
                _subItemButton.titleEdgeInsets = UIEdgeInsetsMake(0, _subItemButton.imageView.frame.size.width + 10, 0, 0);
                //[_subItemButton setContentEdgeInsets:UIEdgeInsetsMake(5, 15, 5, 15)];
                
                _subItemSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width/2, 66);
                
                break;
            }
            case TabBarSubItemsViewTypeButton: {
                
                [_subItemButton.layer setBorderColor:[[@"999999" colorFromHex] CGColor]];
                [_subItemButton.layer setBorderWidth:1];
                
                //[_subItemButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
                [_subItemButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
                [_subItemButton setContentEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 10)];
                
                CGSize size = [_subItemButton sizeThatFits:[[UIScreen mainScreen] bounds].size];
                _buttonCornerRadius = size.height/2;
                _subItemSize = size;
                _subItemSize.width = _subItemSize.width + _subItemButton.contentEdgeInsets.left/2 + _subItemButton.contentEdgeInsets.right/2;
                _subItemSize.height = _subItemSize.height+ _subItemButton.contentEdgeInsets.top + _subItemButton.contentEdgeInsets.bottom;
                
                break;
            }
            default: {
                break;
            }
        }
        
    
        [self addSubview:_subItemButton];
        
        _firstValue = ( firstValue ? firstValue : @"");
        _objectReference = (reference ? reference : _firstValue);
        _secondValue = secondValue;
    }
    
    [self updateConstraintsIfNeeded];
    
    return self;
}

+ (instancetype) tabBarSubItemWithName:(NSString*)name value:(id) value andReference:(id)reference {
    return [[self alloc] initWithName:name firstValue:value secondValue:nil reference:reference forType:TabBarSubItemsViewTypeButton];
}

+ (instancetype) tabBarSubItemWithName:(NSString*)name value:(id) value andReference:(id)reference forType:(TabBarSubItemsViewType) type {
    return [[self alloc] initWithName:name firstValue:value secondValue:nil reference:reference forType:type];
}

+ (instancetype) tabBarSubItemWithName:(NSString *) name firstValue:(id)firstValue secondValue:(id) secondValue andReference:(id) reference {
    return [[self alloc] initWithName:name firstValue:firstValue secondValue:secondValue reference:reference forType:TabBarSubItemsViewTypeButton];
}

+ (instancetype) tabBarSubItemWithName:(NSString *) name firstValue:(id)firstValue secondValue:(id) secondValue andReference:(id) reference forType:(TabBarSubItemsViewType) type {
    return [[self alloc] initWithName:name firstValue:firstValue secondValue:secondValue reference:reference forType:type];
}

- (void) setName:(NSString *)name {
    _name = name;
    [_subItemButton setTitle:_name forState:UIControlStateNormal];
}

- (NSUInteger) numberOfValues {
    NSUInteger response = 0;
    
    if (_firstValue) {
        response++;
    }
    
    if (_secondValue) {
        response++;
    }
    
    return response;
}

- (NSString *) getValueForPrice:(NSInteger) value {
    NSString *responseString;
    switch (value) {
        case 0:
            if ([_firstValue isKindOfClass:[NSString class]]) {
                return _firstValue;
            }
            else {
                responseString = [NSString stringWithFormat:@"%@ %00.02f",_name,[_firstValue floatValue]];
            }
            break;
        default:{
            if ([_secondValue isKindOfClass:[NSString class]]) {
                return _secondValue;
            }
            else {
                responseString = [NSString stringWithFormat:@"%@ %00.02f",_name,[_secondValue floatValue]];
            }
            
        }
            break;
    }
    return responseString;
}

- (void) layoutSubviews {
    
    if (!_didSetupConstraints) {
        
        [self autoSetDimension:ALDimensionHeight toSize:_subItemSize.height relation:NSLayoutRelationGreaterThanOrEqual];
        [self autoSetDimension:ALDimensionWidth toSize:_subItemSize.width relation:NSLayoutRelationGreaterThanOrEqual];
        
        [_subItemButton autoCenterInSuperview];
        
        if (_type == TabBarSubItemsViewTypeCheckBox) {
        
            [_subItemButton autoSetDimension:ALDimensionHeight toSize:_subItemSize.height];
            [_subItemButton autoSetDimension:ALDimensionWidth toSize:_subItemSize.width];
        }
        
        if (_type == TabBarSubItemsViewTypeButton) {
            [_subItemButton.layer setCornerRadius:_buttonCornerRadius];
        }
        _didSetupConstraints = YES;
    }
    
}

- (void) itemSelected:(UIButton *) button {
    [button setSelected:!button.isSelected];
    
    if (button.isSelected) {
        [_subItemButton.layer setBorderColor:[[@"ff4e50" colorFromHex] CGColor]];
    }
    else {
        [_subItemButton.layer setBorderColor:[[@"999999" colorFromHex] CGColor]];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(tabBarSubItem:didSelected:)]) {
        [_delegate tabBarSubItem:self didSelected:button.isSelected];
    }
}

- (void) setSelected:(BOOL) selected {
    [_subItemButton setSelected:selected];
    
    if (_subItemButton.isSelected) {
        [_subItemButton.layer setBorderColor:[[@"ff4e50" colorFromHex] CGColor]];
    }
    else {
        [_subItemButton.layer setBorderColor:[[@"999999" colorFromHex] CGColor]];
    }
}

- (BOOL) isSelected {
    return [_subItemButton isSelected];
}

@end
