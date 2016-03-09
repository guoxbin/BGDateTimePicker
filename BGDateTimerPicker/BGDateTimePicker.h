//
//  BGDateTimePicker.h
//  BGDateTimePicker
//
//  Created by GB on 16/3/9.
//  Copyright © 2016年 binguo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BGDateTimePicker : UIPickerView<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) NSDate *date;        // default is current date when picker created.

@property (nullable, nonatomic, strong) NSDate *minimumDate; // specify min/max date range. default is nil.
@property (nullable, nonatomic, strong) NSDate *maximumDate; // default is nil.

@property (nonatomic) NSInteger      minuteInterval;    // display minutes wheel with interval. interval must be evenly divided into 60. default is 1. min is 1, max is 30

- (void)setDate:(NSDate *)date animated:(BOOL)animated; // if animated is YES, animate the wheels of time to display the new date


@end
