//
//  TabBarSubItem.m
//  Pods
//
//  Created by Giuseppe Nucifora on 15/07/15.
//
//

#import "TabBarSubItem.h"

@implementation TabBarSubItem


- (instancetype) initWithName:(NSString *) name {
    
    self = [super init];
    
    if (self) {
        _name = name;
    }
    return self;
}

+ (instancetype) tabBarSubItemWithName:(NSString*)name {
    return [[self alloc] initWithName:name];
}

@end
