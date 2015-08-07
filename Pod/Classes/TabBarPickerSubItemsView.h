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

typedef NS_ENUM(NSInteger, TabBarPickerSubItemsViewType) {
    // Informational
    TabBarPickerSubItemsViewTypeData,
    TabBarPickerSubItemsViewTypeString,
    TabBarPickerSubItemsViewTypeButtons,
    TabBarPickerSubItemsViewTypeCheckBox
};

@protocol TabBarPickerSubItemsViewDelegate <NSObject>

@required

- (void) tabarPickerSubItemsView:(TabBarPickerSubItemsView*) tabarPickerSubItemsView didSelect:(TabBarItem*) item;

@end

@interface TabBarPickerSubItemsView : UIView

/**
 *  <#Description#>
 */
@property (nonatomic, assign) id<TabBarPickerSubItemsViewDelegate> delegate;


@end
