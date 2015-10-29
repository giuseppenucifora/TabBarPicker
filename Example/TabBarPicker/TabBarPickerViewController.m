//
//  TabBarPickerViewController.m
//  TabBarPicker
//
//  Created by Giuseppe Nucifora on 07/15/2015.
//  Copyright (c) 2015 Giuseppe Nucifora. All rights reserved.
//

#import "TabBarPickerViewController.h"
#import <PureLayout/PureLayout.h>
#import <TabBarPicker/TabBarPicker.h>

@interface TabBarPickerViewController () {
    TabBarPicker *tabbar;
}

@end

@implementation TabBarPickerViewController


- (instancetype) init {
    self = [super init];
    
    if (self) {
        
        TabBarSubItem *subItem1 = [TabBarSubItem tabBarSubItemWithName:@"1 Km" value:[NSNumber numberWithInt:1] andReference:[NSNumber numberWithInt:1]];
        TabBarSubItem *subItem2 = [TabBarSubItem tabBarSubItemWithName:@"5 Km" value:[NSNumber numberWithInt:5] andReference:[NSNumber numberWithInt:5]];
        TabBarSubItem *subItem3 = [TabBarSubItem tabBarSubItemWithName:@"10 Km" value:[NSNumber numberWithInt:10] andReference:[NSNumber numberWithInt:10]];
        TabBarSubItem *subItem4 = [TabBarSubItem tabBarSubItemWithName:@"20 Km" value:[NSNumber numberWithInt:20] andReference:[NSNumber numberWithInt:20]];
        TabBarSubItem *subItem5 = [TabBarSubItem tabBarSubItemWithName:@"30 Km" value:[NSNumber numberWithInt:30] andReference:[NSNumber numberWithInt:30]];
        TabBarSubItem *subItem6 = [TabBarSubItem tabBarSubItemWithName:@"50 Km" value:[NSNumber numberWithInt:50] andReference:[NSNumber numberWithInt:50]];
        TabBarSubItem *subItem7 = [TabBarSubItem tabBarSubItemWithName:@"100 Km" value:[NSNumber numberWithInt:100] andReference:[NSNumber numberWithInt:100]];
        TabBarSubItem *subItem8 = [TabBarSubItem tabBarSubItemWithName:@"150 Km" value:[NSNumber numberWithInt:150] andReference:[NSNumber numberWithInt:150]];
        TabBarSubItem *subItem9 = [TabBarSubItem tabBarSubItemWithName:@"200 Km" value:[NSNumber numberWithInt:200] andReference:[NSNumber numberWithInt:200]];
        
        TabBarPickerSubItemsView *locationSubview = [[TabBarPickerSubItemsView alloc] initWithType:TabBarPickerSubItemsViewTypeDistance subItems:@[subItem1,subItem2,subItem3,subItem4,subItem5,subItem6,subItem7,subItem8,subItem9] needsLocalization:YES];
        
        TabBarItem *location = [[TabBarItem alloc] initWithSubItemView:locationSubview];
        [location setItemName:NSLocalizedString(@"Distanza", @"")];
        [location setItemSearchKey:@"location"];
        [location setImage:[UIImage imageNamed:@"location"]];
        [location setSelectedImage:[UIImage imageNamed:@"location_selected"]];
        [location setHighlightedImage:[UIImage imageNamed:@"location_highlighted"]];
        
        TabBarPickerSubItemsView *calendarSubView = [[TabBarPickerSubItemsView alloc] initWithType:TabBarPickerSubItemsViewTypeDateAndTime subItems:nil];
        
        TabBarItem *calendar = [[TabBarItem alloc] initWithSubItemView:calendarSubView];
        [calendar setItemName:NSLocalizedString(@"Data e ora", @"")];
        [calendar setItemSearchKey:@"reservationEndTime"];
        [calendar setImage:[UIImage imageNamed:@"location"]];
        [calendar setSelectedImage:[UIImage imageNamed:@"location_selected"]];
        [calendar setHighlightedImage:[UIImage imageNamed:@"location_highlighted"]];
        
        
        NSMutableArray *typesArray = [[NSMutableArray alloc] init];
        
        
        for (NSInteger i=0; i<100; i++) {
            
            TabBarSubItem *item = [TabBarSubItem tabBarSubItemWithName:[NSString stringWithFormat:@"Type %ld",i] value:[NSString stringWithFormat:@"Type %ld",i] andReference:@"Type %ld" forType:TabBarSubItemsViewTypeCheckBox];
            
            [typesArray addObject:item];
        }
        
        
        TabBarPickerSubItemsView *typeSubView = [[TabBarPickerSubItemsView alloc] initWithType:TabBarPickerSubItemsViewTypeCheckBox subItems:typesArray];
        
        TabBarItem *type = [[TabBarItem alloc] initWithSubItemView:typeSubView];
        [type setItemName:NSLocalizedString(@"Custom Type", @"")];
        [type setItemSearchKey:@"custom"];
        [type setImage:[UIImage imageNamed:@"location"]];
        [type setSelectedImage:[UIImage imageNamed:@"location_selected"]];
        [type setHighlightedImage:[UIImage imageNamed:@"location_highlighted"]];
        
        NSMutableArray *subItemsArray = [[NSMutableArray alloc] init];
        
        for (int i =0; i< 30; i++) {
            TabBarSubItem *item;
            if (i < 30-1) {
                item = [TabBarSubItem tabBarSubItemWithName:@"€" firstValue:[NSNumber numberWithInteger:i] secondValue:[NSNumber numberWithInteger:i+1] andReference:nil];
                
            }
            else {
                item = [TabBarSubItem tabBarSubItemWithName:@"€" firstValue:[NSNumber numberWithInteger:i] secondValue:@"MAX" andReference:nil];
                [item setIsLast:YES];
            }
            [subItemsArray addObject:item];
        }
        
        
        TabBarPickerSubItemsView *priceSubView = [[TabBarPickerSubItemsView alloc] initWithType:TabBarPickerSubItemsViewTypePrice subItems:subItemsArray];
        
        TabBarItem *price =[[TabBarItem alloc] initWithSubItemView:priceSubView];
        [price setItemName:NSLocalizedString(@"Prezzo", @"")];
        [price setItemSearchKey:@"price"];
        [price setImage:[UIImage imageNamed:@"location"]];
        [price setSelectedImage:[UIImage imageNamed:@"location_selected"]];
        [price setHighlightedImage:[UIImage imageNamed:@"location_highlighted"]];
        
        
        NSMutableArray *customsArray = [[NSMutableArray alloc] init];
        
        
        for (NSInteger i=0; i<100; i++) {
            
            TabBarSubItem *item = [TabBarSubItem tabBarSubItemWithName:[NSString stringWithFormat:@"Custom %ld",i] value:[NSString stringWithFormat:@"Custom %ld",i] andReference:@"Custom %ld"];
            
            [customsArray addObject:item];
        }
        
        TabBarPickerSubItemsView *customSubView = [[TabBarPickerSubItemsView alloc] initWithType:TabBarPickerSubItemsViewTypeButton subItems:@[subItem1,subItem2,subItem3,subItem4,subItem5,subItem6,subItem7,subItem8,subItem9]];
        
        TabBarItem *custom = [[TabBarItem alloc] initWithSubItemView:customSubView];
        [custom setItemName:NSLocalizedString(@"Custom", @"")];
        [custom setItemSearchKey:@"customs"];
        [custom setImage:[UIImage imageNamed:@"location"]];
        [custom setSelectedImage:[UIImage imageNamed:@"location_selected"]];
        [custom setHighlightedImage:[UIImage imageNamed:@"location_highlighted"]];
        
        tabbar = [[TabBarPicker alloc] initWithTabBarItems:@[location,calendar,type,price,custom] forPosition:TabBarPickerPositionBottom];
        [tabbar setItemSpacing:0];
        [tabbar setBackgroundColor:[UIColor whiteColor]];
        
        //[tabbar addItem:custom2];
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
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
