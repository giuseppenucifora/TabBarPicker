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
@property (nonatomic, strong) NSMutableArray *subItemsArray;

/**
 *  <#Description#>
 */
@property (nonatomic, assign) id<TabBarPickerSubItemsViewDelegate> delegate;

/**
 *  <#Description#>
 *
 *  @param items       <#items description#>
 *  @param itemsPerRow <#itemsPerRow description#>
 *
 *  @return <#return value description#>
 */
- (instancetype) initWithTabBarItem:(TabBarItem *) item andsubItemsPerRow:(NSUInteger) itemsPerRow;

@end
