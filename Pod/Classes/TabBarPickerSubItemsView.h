//
//  TabBarPickerSubItemsView.h
//  Pods
//
//  Created by Giuseppe Nucifora on 17/07/15.
//
//

#import <UIKit/UIKit.h>

@class TabBarItem;
@class TabBarSubItem;
@class TabBarPickerSubItemsView;

typedef NS_ENUM(NSInteger, TabBarPickerSubItemsViewType) {
    // Informational
    TabBarPickerSubItemsViewTypeDistance,
    TabBarPickerSubItemsViewTypeDateAndTime,
    TabBarPickerSubItemsViewTypePrice,
    TabBarPickerSubItemsViewTypeCheckBox,
    TabBarPickerSubItemsViewTypeButton
};

@protocol TabBarPickerSubItemsViewDelegate <NSObject>

@required

- (void) tabBarPickerSubItemsView:(TabBarPickerSubItemsView*) tabBarPickerSubItemsView didSelectTabBarSubItem:(TabBarSubItem*) subItem forTabBarItem:(TabBarItem*) item;

- (void) tabBarPickerSubItemsView:(TabBarPickerSubItemsView*) tabBarPickerSubItemsView didSelectTabBarSubItems:(NSArray*) subItems forTabBarItem:(TabBarItem*) item;

- (void) tabBarPickerSubItemsView:(TabBarPickerSubItemsView*) tabBarPickerSubItemsView didResetTabBarSubItem:(TabBarSubItem*) subItem forTabBarItem:(TabBarItem*) item;

- (void) tabBarPickerSubItemsView:(TabBarPickerSubItemsView*) tabBarPickerSubItemsView didResetTabBarSubItems:(NSArray*) subItems forTabBarItem:(TabBarItem*) item;

@end

@interface TabBarPickerSubItemsView : UIView

/**
 *  <#Description#>
 */
@property (nonatomic, assign) id<TabBarPickerSubItemsViewDelegate> delegate;
/**
 *  <#Description#>
 */
@property (nonatomic) BOOL needsLocalization;
/**
 *  <#Description#>
 */
@property (nonatomic, strong) UIView *localizationView;
/**
 *  <#Description#>
 */

@property (nonatomic, strong) TabBarItem *tabBarItemReference;

@property (nonatomic,readonly) TabBarPickerSubItemsViewType type;

@property (nonatomic, strong, readonly) NSDate *pickerSelectedDate;
@property (nonatomic, strong, readonly) TabBarSubItem *selectedDate;

@property (nonatomic, strong, readonly) TabBarSubItem *selectedDistance;
@property (nonatomic, strong, readonly) TabBarSubItem *selectedMinPrice;
@property (nonatomic, strong, readonly) TabBarSubItem *selectedMaxPrice;
@property (nonatomic, strong, readonly) NSMutableArray *selectedAllergens;
@property (nonatomic, strong, readonly) NSMutableArray *selectedTypes;

- (instancetype) initWithType:(TabBarPickerSubItemsViewType) type subItems:(NSArray*) subItems;

- (instancetype) initWithType:(TabBarPickerSubItemsViewType) type subItems:(NSArray*) subItems needsLocalization:(BOOL) needsLocalization;

- (void) setItemName:(NSString *) itemName;
@end
