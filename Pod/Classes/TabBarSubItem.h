//
//  TabBarSubItem.h
//  Pods
//
//  Created by Giuseppe Nucifora on 15/07/15.
//
//

#import <Foundation/Foundation.h>

@interface TabBarSubItem : UIView

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIButton *subItemButton;

+ (instancetype) tabBarSubItemWithName:(NSString*)name;

@end
