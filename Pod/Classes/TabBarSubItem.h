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
@property (nonatomic, strong) id value;

+ (instancetype) tabBarSubItemWithName:(NSString*)name andValue:(id) value;;

@end
