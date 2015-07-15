//
//  TabBarSubItem.h
//  Pods
//
//  Created by Giuseppe Nucifora on 15/07/15.
//
//

#import <Foundation/Foundation.h>

@interface TabBarSubItem : NSObject

@property (nonatomic, strong) NSString *name;

+ (instancetype) tabBarSubItemWithName:(NSString*)name;

@end
