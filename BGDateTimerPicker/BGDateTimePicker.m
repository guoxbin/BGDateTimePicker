//
//  BGDateTimePicker.m
//  BGDateTimePicker
//
//  Created by GB on 16/3/9.
//  Copyright © 2016年 binguo. All rights reserved.
//

#import "BGDateTimePicker.h"

const NSInteger DefaultMinuteInterval = 1;

const NSInteger Repeat = 100;
const NSInteger NumberOfComponents = 7;

const NSInteger NumberOfMonths = 12;
const NSInteger NumberOfDays = 31;
const NSInteger NumberOfHours = 24;
const NSInteger NumberOfMinutes = 60;

const NSInteger ComponentYear = 0;
const NSInteger ComponentMonth = 1;
const NSInteger ComponentDay = 2;
const NSInteger ComponentDHSep = 3;
const NSInteger ComponentHour = 4;
const NSInteger ComponentHMSep = 5;
const NSInteger ComponentMinute = 6;

@interface BGDateTimePicker()

@property (nonatomic, strong) NSDateFormatter *yFmt;
@property (nonatomic, strong) NSDateFormatter *MFmt;
@property (nonatomic, strong) NSDateFormatter *dFmt;
@property (nonatomic, strong) NSDateFormatter *hFmt;
@property (nonatomic, strong) NSDateFormatter *mmFmt;

@property (nonatomic, strong) NSMutableArray *yearList;
@property (nonatomic, strong) NSMutableArray *monthList;
@property (nonatomic, strong) NSMutableArray *dayList;
@property (nonatomic, strong) NSMutableArray *hourList;
@property (nonatomic, strong) NSMutableArray *minuteList;

@end

@implementation BGDateTimePicker

-(instancetype)init{
    if (self = [super init]){
        [self reset];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self reset];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self reset];
}

- (void)setMinimumDate:(NSDate *)minimumDate{
    _minimumDate = minimumDate;
    
    [self reset];
}

- (void)setMaximumDate:(NSDate *)maximumDate{
    _maximumDate = maximumDate;
    
    [self reset];
}

- (void)setMinuteInterval:(NSInteger)minuteInterval{
    _minuteInterval = minuteInterval;
    
    [self reset];
}

-(void)setDate:(NSDate *)date{
    
    [self setDate:date animated:false];
    
}

-(void)setDate:(NSDate *)date animated:(BOOL)animated{
    
    _date = date;
    [self render:animated];
    
}

-(void)reset{
    
    _date = self.date==nil ? [NSDate date] : self.date;
    
    _minimumDate = self.minimumDate == nil ? [NSDate distantPast] : self.minimumDate;
    
    _maximumDate = self.maximumDate == nil ? [NSDate distantFuture] : self.maximumDate;
    
    _minuteInterval = self.minuteInterval == 0 ? DefaultMinuteInterval : self.minuteInterval;
    
    _date = [self getTrimedDate:_date];
    _minimumDate = [self getTrimedDate:_minimumDate];
    _maximumDate = [self getTrimedDate:_maximumDate];
    
    self.delegate = self;
    self.dataSource = self;
    
    self.yFmt = [[NSDateFormatter alloc]init];
    [self.yFmt setDateFormat:@"yyyy"];
    
    self.MFmt = [[NSDateFormatter alloc]init];
    [self.MFmt setDateFormat:@"MM"];
    
    self.dFmt = [[NSDateFormatter alloc]init];
    [self.dFmt setDateFormat:@"dd"];
    
    self.hFmt = [[NSDateFormatter alloc]init];
    [self.hFmt setDateFormat:@"HH"];
    
    self.mmFmt = [[NSDateFormatter alloc]init];
    [self.mmFmt setDateFormat:@"mm"];
    
    [self refreshYearList];
    
    [self refreshMonthList];
    
    [self refreshDayList];
    
    [self refreshHourList];
    
    [self refreshMinuteList];
    
    [self render:false];
    
}

- (void)render:(bool)animated{
    
    [self selectRow:[self rowForYear] inComponent:ComponentYear animated:animated];
    [self selectRow:[self rowForMonth] inComponent:ComponentMonth animated:animated];
    [self selectRow:[self rowForDay] inComponent:ComponentDay animated:animated];
    [self selectRow:[self rowForHour] inComponent:ComponentHour animated:animated];
    [self selectRow:[self rowForMinute] inComponent:ComponentMinute animated:animated];

}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return NumberOfComponents;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    NSInteger numberOfRows = 1;
    
    switch (component) {
        case ComponentYear:
            numberOfRows = self.yearList.count * Repeat;
            break;
            
        case ComponentMonth:
            numberOfRows = self.monthList.count * Repeat;
            break;
            
        case ComponentDay:
            numberOfRows = self.dayList.count * Repeat;
            break;
        
        case ComponentDHSep:
            numberOfRows = 0;
            break;
            
        case ComponentHour:
            numberOfRows = self.hourList.count * Repeat;
            break;
            
        case ComponentHMSep:
            numberOfRows = 1;
            break;
            
        case ComponentMinute:
            numberOfRows = self.minuteList.count * Repeat;
            break;
            
        default:
            break;
    }
    
    return numberOfRows;
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    CGFloat width = 44;
    switch (component) {
            
        case ComponentYear:
            width = 88;
            break;
            
        case ComponentDHSep:
            width = 14;
            break;
            
        case ComponentHMSep:
            width = 14;
            break;
            
        default:
            break;
    }
    return width;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSString *title = nil;
    
    switch (component) {
        case ComponentYear:
            row = row % self.yearList.count;
            title = self.yearList[row];
            break;
            
        case ComponentMonth:
            row = row % self.monthList.count;
            title = self.monthList[row];
            break;
            
        case ComponentDay:
            row = row % self.dayList.count;
            title = self.dayList[row];
            break;
            
        case ComponentHour:
            row = row % self.hourList.count;
            title = self.hourList[row];
            break;
            
        case ComponentHMSep:
            title = @":";
            break;
            
        case ComponentMinute:
            row = row % self.minuteList.count;
            title = self.minuteList[row];
            break;

            
        default:
            break;
    }
    
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    bool adjusted = false;
    
    _date = [self dateForSelection:&adjusted];
    
    if(adjusted){
    
        [self render:true];
        
    }
    
    NSLog(@"date updated date=%@", self.date);
    
    [self.pickerDelegate dateChanged:self.date];
    
}

- (void)refreshYearList{
    
    self.yearList = [NSMutableArray array];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *diffComp = [[NSDateComponents alloc] init];
    [diffComp setYear:1];
    [diffComp setMonth:0];
    [diffComp setDay:0];
    NSDate *currentDate = [NSDate distantPast];
    while(true){
        if([currentDate compare:[NSDate distantFuture]]>0){
            break;
        }
        NSString *year = [self.yFmt stringFromDate:currentDate];
        [self.yearList addObject:year];
        
        currentDate = [calendar dateByAddingComponents:diffComp toDate:currentDate options:0];
    }
    
}

- (void)refreshMonthList{
    
    self.monthList = [NSMutableArray array];
    
    for (int i=0; i<NumberOfMonths; i++) {
        NSString *month = [NSString stringWithFormat:@"%02d", i+1];
        [self.monthList addObject:month];
    }
    
}

- (void)refreshDayList{
    
    self.dayList = [NSMutableArray array];
    
    for (int i=0; i<NumberOfDays; i++) {
        NSString *day = [NSString stringWithFormat:@"%02d", i+1];
        [self.dayList addObject:day];
    }
}

- (void)refreshHourList{
    self.hourList = [NSMutableArray array];
    
    for (int i=0; i<NumberOfHours; i++) {
        NSString *hour = [NSString stringWithFormat:@"%02d", i];
        [self.hourList addObject:hour];
    }
}

//minuteInterval aware
- (void)refreshMinuteList{
    
    NSInteger interval = 60%self.minuteInterval==0 ? self.minuteInterval : DefaultMinuteInterval;
    
    self.minuteList = [NSMutableArray array];
    
    for (int i=0; i<NumberOfMinutes; i+=interval) {
        NSString *minute = [NSString stringWithFormat:@"%02d", i];
        [self.minuteList addObject:minute];
    }
    
}

//util

- (NSInteger)rowForYear{
    
    NSString *year = [self.yFmt stringFromDate:self.date];
    
    NSUInteger index = [self.yearList indexOfObject:year];
    
    index = NSNotFound==index ? 0 : index;
    
    NSInteger row = index+(self.yearList.count*Repeat/2);
    
    return row;
}

- (NSInteger)rowForMonth{
    
    NSString *month = [self.MFmt stringFromDate:self.date];
    
    NSUInteger index = [self.monthList indexOfObject:month];
    
    index = NSNotFound==index ? 0 : index;
    
    NSInteger row = index+(self.monthList.count*Repeat/2);
    
    return row;
}

- (NSInteger)rowForDay{
    
    NSString *day = [self.dFmt stringFromDate:self.date];
    
    NSUInteger index = [self.dayList indexOfObject:day];
    
    index = NSNotFound==index ? 0 : index;
    
    NSInteger row = index+(self.dayList.count*Repeat/2);
    
    return row;
}

- (NSInteger)rowForHour{
    
    NSString *hour = [self.hFmt stringFromDate:self.date];
    
    NSUInteger index = [self.hourList indexOfObject:hour];
    
    index = NSNotFound==index ? 0 : index;
    
    NSInteger row = index+(self.hourList.count*Repeat/2);
    
    return row;
}

- (NSInteger)rowForMinute{
    
    NSString *minute = [self.mmFmt stringFromDate:self.date];
    
    NSUInteger index = [self.minuteList indexOfObject:minute];
    
    index = NSNotFound==index ? 0 : index;
    
    NSInteger row = index+(self.minuteList.count*Repeat/2);
    
    return row;
}

- (NSDate *)dateForSelection:(bool *)adjusted{
    
    *adjusted = false;
    
    NSInteger yRow = [self selectedRowInComponent:ComponentYear];
    NSInteger mRow = [self selectedRowInComponent:ComponentMonth];
    NSInteger dRow = [self selectedRowInComponent:ComponentDay];
    NSInteger hRow = [self selectedRowInComponent:ComponentHour];
    NSInteger mmRow = [self selectedRowInComponent:ComponentMinute];
    
    NSString *year = self.yearList[yRow%self.yearList.count];
    NSString *month = self.monthList[mRow%self.monthList.count];
    NSString *day = self.dayList[dRow%self.dayList.count];

    NSString *hour = self.hourList[hRow%self.hourList.count];
    NSString *minute = self.minuteList[mmRow%self.minuteList.count];
    
    long long lYear = [year longLongValue];
    long long lMonth = [month longLongValue];
    long long lDay = [day longLongValue];
    long long lHour = [hour longLongValue];
    long long lMinute = [minute longLongValue];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [[NSDateComponents alloc] init];
    [comp setYear:lYear];
    [comp setMonth:lMonth];
    [comp setDay:lDay];
    [comp setHour:lHour];
    [comp setMinute:lMinute];
    [comp setSecond:0];
    [comp setNanosecond:0];
    
    NSDate *date = [calendar dateFromComponents:comp];
    
    while(true){
        
        NSString *monthForDate = [self.MFmt stringFromDate:date];
        
        if([monthForDate isEqualToString:month]){
            break;
        }
        
        NSDateComponents *diffComp = [[NSDateComponents alloc] init];
        [diffComp setYear:0];
        [diffComp setMonth:0];
        [diffComp setDay:-1];
        
        date = [calendar dateByAddingComponents:diffComp toDate:date options:0];
        
        *adjusted = true;
        
    }
    
    if([date compare:self.minimumDate]<0){
        date = self.minimumDate;
        *adjusted = true;
    }
    
    if([date compare:self.maximumDate]>0){
        date = self.maximumDate;
        *adjusted = true;
    }

    return date;
}

- (NSDate *)getTrimedDate:(NSDate *)date{
    
    NSInteger time = [date timeIntervalSince1970];
    NSInteger intervalInS = _minuteInterval * 60;
    
    time = (time/intervalInS)*intervalInS;
    
    NSDate *trimedDate = [NSDate dateWithTimeIntervalSince1970:time];
    
    return trimedDate;
}


@end
