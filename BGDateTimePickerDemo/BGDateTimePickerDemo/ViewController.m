//
//  ViewController.m
//  BGDateTimePickerDemo
//
//  Created by GB on 16/3/9.
//  Copyright © 2016年 binguo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    BGDateTimePicker *picker = [[BGDateTimePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
    
    picker.date = [NSDate dateWithTimeIntervalSinceNow:3600];
    picker.minuteInterval = 5;
    picker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:-365*24*60*60];
    picker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:+365*24*60*60];
    picker.pickerDelegate = self;
    
    [self.view addSubview:picker];
    
    NSLog(@"date=%@", picker.date);
    
    self.label  = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, 320, 20)];
    self.label.textAlignment = NSTextAlignmentCenter;

    [self.view addSubview:self.label];
    
    [self dateChanged:picker.date];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dateChanged:(NSDate *)date{
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateStr = [fmt stringFromDate:date];
    
    self.label.text = dateStr;
    
}

@end
