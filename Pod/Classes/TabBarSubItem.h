//
//  TabBarSubItem.h
//  Pods
//
//  Created by Giuseppe Nucifora on 15/07/15.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TabBarSubItemsViewType) {
    TabBarSubItemsViewTypeDistance,
    TabBarSubItemsViewTypeDateAndTime,
    TabBarSubItemsViewTypePrice,
    TabBarSubItemsViewTypeCheckBox,
    TabBarSubItemsViewTypeButton,
};

@class TabBarSubItem;

@protocol TabBarSubItemDelegate <NSObject>

@required

- (void) tabBarSubItem:(TabBarSubItem*) item didSelected:(BOOL) selected;

@end

@interface TabBarSubItem : UIView

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIButton *subItemButton;
@property (nonatomic, strong) id firstValue;
@property (nonatomic, strong) id secondValue;
@property (nonatomic, strong) id objectReference;
@property (nonatomic, readonly) CGSize subItemSize;
@property (nonatomic) TabBarSubItemsViewType type;
@property (nonatomic) BOOL isLast;

@property (nonatomic, strong) id<TabBarSubItemDelegate> delegate;

+ (instancetype) tabBarSubItemWithName:(NSString*) name value:(id) value andReference:(id)reference;

+ (instancetype) tabBarSubItemWithName:(NSString*) name value:(id) value andReference:(id)reference forType:(TabBarSubItemsViewType) type;

+ (instancetype) tabBarSubItemWithName:(NSString *) name firstValue:(id)firstValue secondValue:(id) secondValue andReference:(id) reference;

+ (instancetype) tabBarSubItemWithName:(NSString *) name firstValue:(id)firstValue secondValue:(id) secondValue andReference:(id) reference forType:(TabBarSubItemsViewType) type;

- (NSUInteger) numberOfValues;

- (NSString *) getValueForPrice:(NSInteger) value;

- (void) setSelected:(BOOL) selected;

- (BOOL) isSelected;

@end
