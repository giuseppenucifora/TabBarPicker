//
//  TabBarSubItem.h
//  Pods
//
//  Created by Giuseppe Nucifora on 15/07/15.
//
//

#import <Foundation/Foundation.h>
//#import "PureLayout.h"

@interface TabBarSubItem : UIView

@property (nonatomic, strong) NSString *name;

+ (instancetype) tabBarSubItemWithName:(NSString*)name;

@end
