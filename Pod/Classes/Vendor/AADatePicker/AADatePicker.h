//
//  AADatePicker.h
//  CustomDatePicker
//
//  Created by Amit Attias on 3/26/14.
//  Copyright (c) 2014 I'm IT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AADatePicker;

@protocol AADatePickerDelegate <NSObject>

@optional

-(void)dateChanged:(AADatePicker*)datePicker;

@end

@interface AADatePicker : UIControl

@property (nonatomic, strong) id<AADatePickerDelegate> delegate;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic) BOOL showOnlyValidDates;
@property (nonatomic) BOOL showsSelectionIndicator;

- (instancetype) initWithFrame:(CGRect)frame maxDate:(NSDate *)maxDate minDate:(NSDate *)minDate showValidDatesOnly:(BOOL)showValidDatesOnly;

- (void) resetPicker;

@end
