//
//  DateInputTableViewCell.h
//  ShootStudio
//
//  Created by Tom Fewster on 18/10/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DateInputTableViewCell;

@protocol DateInputTableViewCellDelegate <NSObject>
@optional
- (void)tableViewCell:(DateInputTableViewCell *)cell didEndEditingWithDate:(NSDate *)value;
@end

@interface DateInputTableViewCell : UITableViewCell <UIPopoverControllerDelegate> {
	UIPopoverController *popoverController;
	UIToolbar *inputAccessoryView;
}

@property (nonatomic, strong) NSDate *dateValue;
@property (nonatomic, assign) UIDatePickerMode datePickerMode;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, retain) IBOutlet id<DateInputTableViewCellDelegate> delegate;

- (void)setMaxDate:(NSDate *)max;
- (void)setMinDate:(NSDate *)min;
- (void)setMinuteInterval:(NSUInteger)value;

@end
