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
@property (nonatomic, readonly) CGSize tabBarSize;
@property (nonatomic) TabBarPickerPosition position;

+ (NSString*) tabBarVersion;

/**
 *  Init TabBarPicker with items. When is selected an item the picher show down subitems.
 *  By default when one of more subItems are selected the selected item become selected.
 *  By default the tabBar size is max screen width and 100px height
 *  The picker size is dinamically based the max subitems of items.
 *
 *  @param items Represents tab bar items. That array cannot be nil.
 *
 *  @param position Represents the posizion in the Screen:
 *                      - TabBarPickerPositionLeft : Is positioned in vertical on left of the screen and shows the picker at its right
 *                      - TabBarPickerPositionRight : Is positioned in vertical on right of the screen and shows the picker at its left
 *                      - TabBarPickerPositionBottom : Is positioned in horizontal on bottom of the screen and shows the picker at its top
 *                      - TabBarPickerPositionTop : Is positioned in horizontal on top of the screen and shows the picker at its bottom
 *
 *  @return raturn instance of TabBarPicker object.
 */
- (instancetype) initWithTabBarItems:(NSArray *)items forPosition:(TabBarPickerPosition)position;

/**
 *  Init TabBarPicker with items. When is selected an item the picher show down subitems.
 *  By default when one of more subItems are selected the selected item become selected.
 *  The picker size is dinamically based the max subitems of items
 *
 *  @param items Represents tab bar items. That array cannot be nil.
 *
 *  @param size  Represents the tabbar size
 *
 *  @param position Represents the posizion in the Screen: 
 *                      - TabBarPickerPositionLeft : Is positioned in vertical on left of the screen and shows the picker at its right
 *                      - TabBarPickerPositionRight : Is positioned in vertical on right of the screen and shows the picker at its left
 *                      - TabBarPickerPositionBottom : Is positioned in horizontal on bottom of the screen and shows the picker at its top
 *                      - TabBarPickerPositionTop : Is positioned in horizontal on top of the screen and shows the picker at its bottom
 *
 *  @return raturn instance of TabBarPicker object.
 */
- (instancetype) initWithTabBarItems:(NSArray*) items withTabBarSize:(CGSize) size forPosition:(TabBarPickerPosition) position;

@end
