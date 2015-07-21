//
//  TabBarPickerSubItemsView.h
//  Pods
//
//  Created by Giuseppe Nucifora on 17/07/15.
//
//

#import <UIKit/UIKit.h>
#import "TabBarItem.h"

@class TabBarPickerSubItemsView;

@protocol TabBarPickerSubItemsViewDelegate <NSObject>

@required

- (void) tabarPickerSubItemsView:(TabBarPickerSubItemsView*) tabarPickerSubItemsView didSelect:(TabBarItem*) item;

@end

@interface TabBarPickerSubItemsView : UIView

/**
 *  <#Description#>
 */
@property (nonatomic, strong) NSMutableArray *itemsArray;

/**
 *  <#Description#>
 */
@property (nonatomic, assign) id<TabBarItemDelegate> delegate;

/**
 *  <#Description#>
 *
 *  @param items <#items description#>
 *
 *  @return <#return value description#>
 */
- (instancetype) initWithTabBarItems:(NSArray *) items;

@end
