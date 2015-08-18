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
    TabBarPickerSubItemsViewTypeData,
    TabBarPickerSubItemsViewTypeString,
    TabBarPickerSubItemsViewTypeButtons,
    TabBarPickerSubItemsViewTypeCheckBox
};

@protocol TabBarPickerSubItemsViewDelegate <NSObject>

@required

- (void) tabarPickerSubItemsView:(TabBarPickerSubItemsView*) tabarPickerSubItemsView didSelectTabBarSubItem:(TabBarSubItem*) subItem forTabBarItem:(TabBarItem*) item;

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

- (instancetype) initWithType:(TabBarPickerSubItemsViewType) type subItems:(NSArray*) subItems;

- (instancetype) initWithType:(TabBarPickerSubItemsViewType) type subItems:(NSArray*) subItems needsLocalization:(BOOL) needsLocalization;

- (void) setItemName:(NSString *) itemName;
@end
