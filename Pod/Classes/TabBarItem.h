//
//  TabBarItem.h
//  Pods
//
//  Created by Giuseppe Nucifora on 15/07/15.
//
//

#import <Foundation/Foundation.h>
#import "TabBarSubItem.h"
#import "TabBarPickerSubItemsView.h"

@class TabBarItem;

@protocol TabBarItemDelegate <NSObject>

@required

- (void) tabBarItemSelected:(TabBarItem*) selectedItem;

@end

@interface TabBarItem : UIView

/**
 *  Represents the image visible in picker when item is not selected.
 */
@property (nonatomic, strong) UIImage *image;

/**
 *  Represents the image visible in picker when item is selected.
 */
@property (nonatomic, strong) UIImage *selectedImage;

/**
 *  Represents the image visible in picker when item is highlited.
 */
@property (nonatomic, strong) UIImage *highlightedImage;

/**
 *  Represents the color of picker item when is highlited.
 */
@property (nonatomic, strong) UIColor *highlightedColor;

/**
 *  Represents the name of the item that can be shown in picker.
 */
@property (nonatomic, strong) NSString *itemName;

/**
 *  Represents the sub items that appeare when you select the item in picker.
 */
@property (nonatomic, strong) TabBarPickerSubItemsView *itemSubView;

/**
 *  <#Description#>
 */
@property (nonatomic, assign) id<TabBarItemDelegate> delegate;

/**
 *  <#Description#>
 *
 *  @param array <#array description#>
 *
 *  @return <#return value description#>
 */
- (instancetype) initWithSubItemView:(TabBarPickerSubItemsView*) itemSubView;

/**
 *  <#Description#>
 *
 *  @param highlighted <#highlighted description#>
 */
- (void) setHighlighted:(BOOL) highlighted;


@end
