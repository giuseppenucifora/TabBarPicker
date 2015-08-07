//
//  TabBarPickerViewController.m
//  TabBarPicker
//
//  Created by Giuseppe Nucifora on 07/15/2015.
//  Copyright (c) 2015 Giuseppe Nucifora. All rights reserved.
//

#import "TabBarPickerViewController.h"
#import "TabBarPicker.h"
#import <PureLayout/PureLayout.h>

@interface TabBarPickerViewController () {
    TabBarPicker *tabbar;
}

@end

@implementation TabBarPickerViewController


- (instancetype) init {
    self = [super init];
    
    if (self) {
       
        TabBarSubItem *subItem1 = [TabBarSubItem tabBarSubItemWithName:@"Peppe"];
        TabBarSubItem *subItem2 = [TabBarSubItem tabBarSubItemWithName:@"Peppe1"];
        TabBarSubItem *subItem3 = [TabBarSubItem tabBarSubItemWithName:@"Peppe2"];
        TabBarSubItem *subItem4 = [TabBarSubItem tabBarSubItemWithName:@"Peppe3"];
        TabBarSubItem *subItem5 = [TabBarSubItem tabBarSubItemWithName:@"Peppe4"];
        TabBarSubItem *subItem6 = [TabBarSubItem tabBarSubItemWithName:@"Peppe5"];
        TabBarSubItem *subItem7 = [TabBarSubItem tabBarSubItemWithName:@"Peppe6"];
        
        
        TabBarItem *location = [[TabBarItem alloc] initWithSubItems:@[subItem1,subItem2,subItem3,subItem4,subItem5,subItem6,subItem7]];
        [location setItemName:@"Location"];
        [location setImage:[UIImage imageNamed:@"location"]];
        [location setSelectedImage:[UIImage imageNamed:@"location_selected"]];
        [location setHighlightedImage:[UIImage imageNamed:@"location_highlighted"]];
        
        TabBarItem *calendar = [[TabBarItem alloc] initWithSubItems:@[subItem1,subItem2,subItem3,subItem4,subItem5,subItem6,subItem7]];
        [calendar setItemName:@"Calendar"];
        [calendar setImage:[UIImage imageNamed:@"calendar"]];
        [calendar setSelectedImage:[UIImage imageNamed:@"calendar_selected"]];
        [calendar setHighlightedImage:[UIImage imageNamed:@"calendar_highlighted"]];
        
        TabBarItem *type = [[TabBarItem alloc] initWithSubItems:@[subItem1,subItem2,subItem3,subItem4,subItem5,subItem6,subItem7]];
        [type setItemName:@"Type"];
        [type setImage:[UIImage imageNamed:@"type"]];
        [type setSelectedImage:[UIImage imageNamed:@"type_selected"]];
        [type setHighlightedImage:[UIImage imageNamed:@"type_highlighted"]];
        
        TabBarItem *price = [[TabBarItem alloc] initWithSubItems:@[subItem1,subItem2,subItem3,subItem4,subItem5,subItem6,subItem7]];
        [price setItemName:@"Price"];
        [price setImage:[UIImage imageNamed:@"price"]];
        [price setSelectedImage:[UIImage imageNamed:@"price_selected"]];
        [price setHighlightedImage:[UIImage imageNamed:@"price_highlighted"]];
        
        TabBarItem *allergen = [[TabBarItem alloc] initWithSubItems:@[subItem1,subItem2,subItem3,subItem4,subItem5,subItem6,subItem7]];
        [allergen setItemName:@"Allergen"];
        [allergen setImage:[UIImage imageNamed:@"allergen"]];
        [allergen setSelectedImage:[UIImage imageNamed:@"allergen_selected"]];
        [allergen setHighlightedImage:[UIImage imageNamed:@"allergen_highlighted"]];
        
        /*TabBarItem *allergen2 = [[TabBarItem alloc] initWithSubItems:@[subItem1,subItem2,subItem3,subItem4,subItem5,subItem6,subItem7]];
        [allergen2 setItemName:@"Allergen"];
        [allergen2 setImage:[UIImage imageNamed:@"allergen"]];
        [allergen2 setSelectedImage:[UIImage imageNamed:@"allergen_selected"]];
        */
        tabbar = [[TabBarPicker alloc] initWithTabBarItems:@[location,calendar,type,price,allergen] forPosition:TabBarPickerPositionBottom];
        [tabbar setItemSpacing:0];
        [tabbar setBackgroundColor:[UIColor whiteColor]];
        
        //[tabbar addItem:allergen2];
    }
    return self;
}

- (void) loadView {
    
    UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [contentView setBackgroundColor:[UIColor lightGrayColor]];
    
    [contentView addSubview:tabbar];
    
    self.view = contentView;
    
    [self.view setNeedsUpdateConstraints];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self.view setBackgroundColor:[UIColor lightGrayColor]];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void) viewDidAppear:(BOOL)animated {
    
    [tabbar selectItem:0];
    
    /*TabBarSubItem *subItem1 = [TabBarSubItem tabBarSubItemWithName:@"Peppe"];
    TabBarSubItem *subItem2 = [TabBarSubItem tabBarSubItemWithName:@"Peppe1"];
    TabBarSubItem *subItem3 = [TabBarSubItem tabBarSubItemWithName:@"Peppe2"];
    TabBarSubItem *subItem4 = [TabBarSubItem tabBarSubItemWithName:@"Peppe3"];
    TabBarSubItem *subItem5 = [TabBarSubItem tabBarSubItemWithName:@"Peppe4"];
    TabBarSubItem *subItem6 = [TabBarSubItem tabBarSubItemWithName:@"Peppe5"];
    TabBarSubItem *subItem7 = [TabBarSubItem tabBarSubItemWithName:@"Peppe6"];
    
    TabBarItem *allergen = [[TabBarItem alloc] initWithSubItems:@[subItem1,subItem2,subItem3,subItem4,subItem5,subItem6,subItem7]];
    [allergen setItemName:@"Allergen"];
    [allergen setImage:[UIImage imageNamed:@"allergen"]];
    [allergen setSelectedImage:[UIImage imageNamed:@"allergen_selected"]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tabbar addItem:allergen];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tabbar show];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tabbar hide];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tabbar show];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(12 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tabbar hide];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tabbar show];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(18 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tabbar hide];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(21 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tabbar show];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(24 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tabbar hide];
    });*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
