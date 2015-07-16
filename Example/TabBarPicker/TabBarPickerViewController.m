//
//  TabBarPickerViewController.m
//  TabBarPicker
//
//  Created by Giuseppe Nucifora on 07/15/2015.
//  Copyright (c) 2015 Giuseppe Nucifora. All rights reserved.
//

#import "TabBarPickerViewController.h"
#import "TabBarPicker.h"

@interface TabBarPickerViewController () {
    TabBarPicker *tabbar;
}

@end

@implementation TabBarPickerViewController


- (instancetype) init {
    self = [super init];
    
    if (self) {
        NSLog(@"%ld",(long)[TabBarPicker tabBarVersion]);
        
        
        TabBarSubItem *subItem1 = [TabBarSubItem tabBarSubItemWithName:@"Peppe"];
        TabBarSubItem *subItem2 = [TabBarSubItem tabBarSubItemWithName:@"Peppe1"];
        TabBarSubItem *subItem3 = [TabBarSubItem tabBarSubItemWithName:@"Peppe2"];
        TabBarSubItem *subItem4 = [TabBarSubItem tabBarSubItemWithName:@"Peppe3"];
        TabBarSubItem *subItem5 = [TabBarSubItem tabBarSubItemWithName:@"Peppe4"];
        TabBarSubItem *subItem6 = [TabBarSubItem tabBarSubItemWithName:@"Peppe5"];
        TabBarSubItem *subItem7 = [TabBarSubItem tabBarSubItemWithName:@"Peppe6"];
        
        
        TabBarItem *location = [[TabBarItem alloc] initWithSubItems:@[subItem1,subItem2,subItem3,subItem4,subItem5,subItem6,subItem7]];
        [location setItemName:@"Location"];
        [location setImage:[UIImage imageNamed:@"location_off"]];
        [location setSelectedImage:[UIImage imageNamed:@"location_on"]];
        
        TabBarItem *calendar = [[TabBarItem alloc] initWithSubItems:@[subItem1,subItem2,subItem3,subItem4,subItem5,subItem6,subItem7]];
        [calendar setItemName:@"Calendar"];
        [calendar setImage:[UIImage imageNamed:@"calendar_off"]];
        [calendar setSelectedImage:[UIImage imageNamed:@"calendar_on"]];
        
        TabBarItem *type = [[TabBarItem alloc] initWithSubItems:@[subItem1,subItem2,subItem3,subItem4,subItem5,subItem6,subItem7]];
        [type setItemName:@"Type"];
        [type setImage:[UIImage imageNamed:@"type_off"]];
        [type setSelectedImage:[UIImage imageNamed:@"type_on"]];
        
        TabBarItem *price = [[TabBarItem alloc] initWithSubItems:@[subItem1,subItem2,subItem3,subItem4,subItem5,subItem6,subItem7]];
        [price setItemName:@"Price"];
        [price setImage:[UIImage imageNamed:@"price_off"]];
        [price setSelectedImage:[UIImage imageNamed:@"price_on"]];
        
        TabBarItem *allergen = [[TabBarItem alloc] initWithSubItems:@[subItem1,subItem2,subItem3,subItem4,subItem5,subItem6,subItem7]];
        [allergen setItemName:@"Allergen"];
        [allergen setImage:[UIImage imageNamed:@"allergen_off"]];
        [allergen setSelectedImage:[UIImage imageNamed:@"allergen_on"]];
        
        tabbar = [[TabBarPicker alloc] initWithTabBarItems:@[location,calendar,type,price,allergen] forPosition:TabBarPickerPositionBottom];
        [tabbar setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (void) loadView {
    
    UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [contentView addSubview:tabbar];
    
    NSLog(@"%f %f",tabbar.frame.size.width,tabbar.frame.size.height);
    
    self.view = contentView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self.view setBackgroundColor:[UIColor lightGrayColor]];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
