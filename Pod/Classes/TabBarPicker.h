//
//  TabBarPicker.h
//  Pods
//
//  Created by Giuseppe Nucifora on 15/07/15.
//
//

#import <UIKit/UIKit.h>
#import "TabbarItem.h"
#import "TabBarSubItem.h"

typedef enum
{
    // Informational
    TabBarPickerPositionLeft,
    TabBarPickerPositionRight,
    TabBarPickerPositionBottom
    
} TabBarPickerPosition;

@interface TabBarPicker : UIView



@property (nonatomic, strong) NSMutableArray *tabBarItems;
@property (nonatomic) CGFloat maxHeight;
@property (nonatomic) CGFloat maxWidth;
@property (nonatomic) TabBarPickerPosition position;

/**
 *  Init TabBarPicker with items. When is selected an item the picher show down subitems.
 *  By default when one of more subItems are selected the selected item become selected.
 *
 *  @param items Represents tab bar items. That array cannot be nil.
 *
 *  @return raturn instance of TabBarPicker object.
 */
- (instancetype) initWithTabBarItems:(NSArray*) items withSize:(CGSize) size forPosition:(TabBarPickerPosition) position;

@end
