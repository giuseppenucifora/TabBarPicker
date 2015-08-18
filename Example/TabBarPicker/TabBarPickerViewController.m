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
       
        TabBarSubItem *subItem1 = [TabBarSubItem tabBarSubItemWithName:@"Peppe" andValue:@"Peppe"];
        TabBarSubItem *subItem2 = [TabBarSubItem tabBarSubItemWithName:@"Peppe1" andValue:@"Peppe1"];
        TabBarSubItem *subItem3 = [TabBarSubItem tabBarSubItemWithName:@"Peppe2" andValue:@"Peppe2"];
        TabBarSubItem *subItem4 = [TabBarSubItem tabBarSubItemWithName:@"Peppe3" andValue:@"Peppe3"];
        TabBarSubItem *subItem5 = [TabBarSubItem tabBarSubItemWithName:@"Peppe4" andValue:@"Peppe4"];
        TabBarSubItem *subItem6 = [TabBarSubItem tabBarSubItemWithName:@"Peppe5" andValue:@"Peppe5"];
        TabBarSubItem *subItem7 = [TabBarSubItem tabBarSubItemWithName:@"Peppe6" andValue:@"Peppe6"];
        
        TabBarPickerSubItemsView *locationSubview = [[TabBarPickerSubItemsView alloc] initWithType:TabBarPickerSubItemsViewTypeButtons subItems:@[subItem1,subItem2,subItem3,subItem4,subItem5,subItem6,subItem7] needsLocalization:YES];
        
        TabBarItem *location = [[TabBarItem alloc] initWithSubItemView:locationSubview];
        [location setItemName:@"Location"];
        [location setImage:[UIImage imageNamed:@"location"]];
        [location setSelectedImage:[UIImage imageNamed:@"location_selected"]];
        [location setHighlightedImage:[UIImage imageNamed:@"location_highlighted"]];
        
        TabBarPickerSubItemsView *locationSubview1 = [[TabBarPickerSubItemsView alloc] initWithType:TabBarPickerSubItemsViewTypeButtons subItems:@[subItem1,subItem2,subItem3,subItem4,subItem5,subItem6,subItem7] needsLocalization:NO];
        
        TabBarItem *location1 = [[TabBarItem alloc] initWithSubItemView:locationSubview1];
        [location1 setItemName:@"Location2"];
        [location1 setImage:[UIImage imageNamed:@"location"]];
        [location1 setSelectedImage:[UIImage imageNamed:@"location_selected"]];
        [location1 setHighlightedImage:[UIImage imageNamed:@"location_highlighted"]];
        
        TabBarPickerSubItemsView *locationSubview2 = [[TabBarPickerSubItemsView alloc] initWithType:TabBarPickerSubItemsViewTypeButtons subItems:@[subItem1,subItem2,subItem3,subItem4,subItem5,subItem6,subItem7] needsLocalization:NO];
        
        TabBarItem *location2 = [[TabBarItem alloc] initWithSubItemView:locationSubview2];
        [location2 setItemName:@"Location3"];
        [location2 setImage:[UIImage imageNamed:@"location"]];
        [location2 setSelectedImage:[UIImage imageNamed:@"location_selected"]];
        [location2 setHighlightedImage:[UIImage imageNamed:@"location_highlighted"]];
        
        TabBarPickerSubItemsView *locationSubview3 = [[TabBarPickerSubItemsView alloc] initWithType:TabBarPickerSubItemsViewTypeButtons subItems:@[subItem1,subItem2,subItem3,subItem4,subItem5,subItem6,subItem7] needsLocalization:NO];
        
        TabBarItem *location3 = [[TabBarItem alloc] initWithSubItemView:locationSubview3];
        [location3 setItemName:@"Location4"];
        [location3 setImage:[UIImage imageNamed:@"location"]];
        [location3 setSelectedImage:[UIImage imageNamed:@"location_selected"]];
        [location3 setHighlightedImage:[UIImage imageNamed:@"location_highlighted"]];
        
        TabBarPickerSubItemsView *locationSubview4 = [[TabBarPickerSubItemsView alloc] initWithType:TabBarPickerSubItemsViewTypeButtons subItems:@[subItem1,subItem2,subItem3,subItem4,subItem5,subItem6,subItem7] needsLocalization:NO];
        
        TabBarItem *location4 = [[TabBarItem alloc] initWithSubItemView:locationSubview4];
        [location4 setItemName:@"Location5"];
        [location4 setImage:[UIImage imageNamed:@"location"]];
        [location4 setSelectedImage:[UIImage imageNamed:@"location_selected"]];
        [location4 setHighlightedImage:[UIImage imageNamed:@"location_highlighted"]];
        
        tabbar = [[TabBarPicker alloc] initWithTabBarItems:@[location,location1,location2,location3,location4] forPosition:TabBarPickerPositionBottom];
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
    
    //[tabbar selectItem:0];
    
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
