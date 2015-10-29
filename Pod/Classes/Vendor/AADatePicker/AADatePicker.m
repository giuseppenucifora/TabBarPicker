//
//  AADatePicker.m
//  CustomDatePicker
//
//  Created by Amit Attias on 3/26/14.
//  Copyright (c) 2014 I'm IT. All rights reserved.
//

#import "AADatePicker.h"
#import <PureLayout/PureLayout.h>
#import "NSString+HexColor.h"
#import "NSDate+NSDate_Util.h"

@interface AADatePicker () <UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSInteger nDays;
}

@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSDate *minDate;
@property (nonatomic, strong) NSDate *maxDate;
@property (readonly, strong) NSDate *earliestPresentedDate;
@property (nonatomic) BOOL didSetupConstraints;

@end

@implementation AADatePicker

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (!self) {
        return nil;
    }
    
    _minDate = [NSDate date];
    
    [self commonInit];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame maxDate:(NSDate *)maxDate minDate:(NSDate *)minDate showValidDatesOnly:(BOOL)showValidDatesOnly
{
    self = [super initWithFrame:frame];
    
    if (!self) {
        return nil;
    }
    
    assert((((minDate) && (maxDate)) && ([minDate compare:maxDate] != NSOrderedDescending)));
    
    _minDate = minDate;
    _maxDate = maxDate;
    _showOnlyValidDates = showValidDatesOnly;
    
    [self commonInit];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    
    if (!self) {
        return nil;
    }
    
    [self commonInit];
    
    return self;
}


- (void) layoutSubviews {
    
    if (!_didSetupConstraints) {
        [_picker autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_picker autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [_picker autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self];
        [_picker autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self];
        [_picker autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self];
        [_picker autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self];
    }
}

- (void) resetPicker {
    
    [self showDateOnPicker:self.earliestPresentedDate];
}

-(NSDate *)earliestPresentedDate
{
    return _showOnlyValidDates ? _minDate : [NSDate date];
}

- (void)commonInit {
    [self setBackgroundColor:[UIColor clearColor]];
    _showsSelectionIndicator = YES;
    _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    _picker = [[UIPickerView alloc] initWithFrame:self.bounds];
    _picker.dataSource = self;
    _picker.delegate = self;
    [_picker setShowsSelectionIndicator:_showsSelectionIndicator];

    
    [self initDate];
    
    [self showDateOnPicker:_date];
    
    [self addSubview:_picker];
}

- (void) setShowsSelectionIndicator:(BOOL)showsSelectionIndicator {
    _showsSelectionIndicator = showsSelectionIndicator;
    [_picker setShowsSelectionIndicator:_showsSelectionIndicator];
}

-(void)showDateOnPicker:(NSDate *)date
{
    _date = date;
    
    NSDateComponents *components = [_calendar
                                    components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay
                                    fromDate:self.earliestPresentedDate];
    
    NSDate *fromDate = [_calendar dateFromComponents:components];
    
    
    components = [_calendar components:(NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute)
                                  fromDate:fromDate
                                    toDate:date
                                   options:0];
    
    NSInteger hour = [components hour] + 24 * (INT16_MAX / 120);
    NSInteger minute = [components minute] + 60 * (INT16_MAX / 120);
    NSInteger day = [components day];
    
    [_picker selectRow:day inComponent:0 animated:YES];
    [_picker selectRow:hour inComponent:1 animated:YES];
    [_picker selectRow:minute inComponent:2 animated:YES];
    
}

-(void)initDate
{
    NSInteger startDayIndex = 0;
    NSInteger startHourIndex = 0;
    NSInteger startMinuteIndex = 0;
    
    if ((_minDate) && (_maxDate) && _showOnlyValidDates) {
        NSDateComponents *components = [_calendar components:NSCalendarUnitDay
                                                        fromDate:_minDate
                                                          toDate:_maxDate
                                                         options:0];
        
        nDays = components.day + 1;
    } else {
        nDays = INT16_MAX;
    }
    NSDate *dateToPresent;
    
    if ([_minDate compare:[NSDate date]] == NSOrderedDescending) {
        dateToPresent = _minDate;
    } else if ([_maxDate compare:[NSDate date]] == NSOrderedAscending) {
        dateToPresent = _maxDate;
    } else {
        dateToPresent = [NSDate date];
    }
    
    NSDateComponents *todaysComponents = [_calendar components:NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute
                                                          fromDate:self.earliestPresentedDate
                                                            toDate:dateToPresent
                                                           options:0];
    
    startDayIndex = todaysComponents.day;
    startHourIndex = todaysComponents.hour;
    startMinuteIndex = todaysComponents.minute;
    
    _date = [NSDate dateWithTimeInterval:startDayIndex*24*60*60+startHourIndex*60*60+startMinuteIndex*60 sinceDate:self.earliestPresentedDate];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return nDays;
    }
    else if (component == 1)
    {
        return INT16_MAX;
    }
    else
    {
        return INT16_MAX;
    }
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return 150;
            break;
        case 1:
            return 50;
            break;
        case 2:
            return 50;
            break;
        default:
            return 0;
            break;
    }
}



-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 74;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *lblDate = [[UILabel alloc] init];
    [lblDate setBackgroundColor:[UIColor clearColor]];
    
    switch (component) {
        case 0:{
            NSDate *aDate = [NSDate dateWithTimeInterval:row*24*60*60 sinceDate:self.earliestPresentedDate];
            
            NSDateComponents *components = [_calendar components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:[NSDate date]];
            NSDate *today = [_calendar dateFromComponents:components];
            components = [_calendar components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:aDate];
            NSDate *otherDate = [_calendar dateFromComponents:components];
            
            if ([today isEqualToDate:otherDate]) {
                [lblDate setText:NSLocalizedString(@"Today",@"")];
            } else {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.locale = [NSLocale currentLocale];
                formatter.dateFormat = @"MMM d";
                
                [lblDate setText:[formatter stringFromDate:aDate]];
            }
            
            lblDate.textAlignment = NSTextAlignmentLeft;
            break;
        }
        case 1:{
            int max = (int)[_calendar maximumRangeOfUnit:NSCalendarUnitHour].length;
            [lblDate setText:[NSString stringWithFormat:@"%02d",(row % max)]]; // 02d = pad with leading zeros to 2 digits
            lblDate.textAlignment = NSTextAlignmentCenter;
            break;
        }
        case 2:{
            int max = (int)[_calendar maximumRangeOfUnit:NSCalendarUnitMinute].length;
            [lblDate setText:[NSString stringWithFormat:@"%02d",(row % max)]];
            lblDate.textAlignment = NSTextAlignmentLeft;
            break;
        }
        default:
            break;
    }
    
    NSDictionary *attributeDict = @{NSForegroundColorAttributeName : [@"ff4e50" colorFromHex],NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:23]};
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:lblDate.text attributes:attributeDict];
    lblDate.attributedText = attributedString;
    
    return lblDate;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSInteger daysFromStart;
    NSDate *chosenDate;
    
    daysFromStart = [pickerView selectedRowInComponent:0];
    chosenDate = [NSDate dateWithTimeInterval:daysFromStart*24*60*60 sinceDate:self.earliestPresentedDate];
    
    NSInteger hour = [pickerView selectedRowInComponent:1];
    NSInteger minute = [pickerView selectedRowInComponent:2];
    
    // Build date out of the components we got
    NSDateComponents *components = [_calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:chosenDate];
    
    components.hour = hour % 24;
    components.minute = minute % 60;
    
    _date = [[_calendar dateFromComponents:components] toLocalTime];
    
    if ([_date compare:_minDate] == NSOrderedAscending) {
        [self showDateOnPicker:_minDate];
    } else if ([_date compare:_maxDate] == NSOrderedDescending) {
        [self showDateOnPicker:_maxDate];
    }
    
    if ((_delegate) && ([_delegate respondsToSelector:@selector(dateChanged:)])) {
        [_delegate dateChanged:self];
    }
}
@end
