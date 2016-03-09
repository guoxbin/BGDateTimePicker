# BGDateTimePicker
A date time picker which can choose year, month, day, hour, minute separately

## Feature
1. setting min date
1. setting max date
1. setting minute interval
1. avoid bad selection (like 2016-2-30), and adjust to the nearest date automatically.

## Usage
1. drag foler "BGDateTimerPicker" to your project.
1. code as below

```
BGDateTimePicker *picker = [[BGDateTimePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
    
picker.date = [NSDate dateWithTimeIntervalSinceNow:3600];
picker.minuteInterval = 5;
picker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:-365*24*60*60];
picker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:+365*24*60*60];
picker.pickerDelegate = self;
    
[self.view addSubview:picker];
```