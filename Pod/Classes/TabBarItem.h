//
//  TabBarItem.h
//  Pods
//
//  Created by Giuseppe Nucifora on 15/07/15.
//
//

#import <Foundation/Foundation.h>
#import "TabBarSubItem.h"

@interface TabBarItem : NSObject

/**
 *  Represents the image visible in picker when item is not selected.
 */
@property (nonatomic, strong) UIImage *image;
/**
 *  Represents the image visible in picker when item is selected.
 */
@property (nonatomic, strong) UIImage *selectedImage;
/**
 *  Represents the name of the item that can be shown in picker.
 */
@property (nonatomic, strong) NSString *itemName;
/**
 *  Represents the sub items that appeare when you select the item in picker.
 */
@property (nonatomic, strong) NSMutableArray *subItems;

/**
 *  <#Description#>
 *
 *  @param array <#array description#>
 *
 *  @return <#return value description#>
 */
- (instancetype) initWithSubItems:(NSArray*) array;


@end
