//
//  ActivityTypeTableViewCell.m
//  AlongWithUs4iPhone
//
//  Created by zhengjianfeng on 12-9-15.
//
//

#import "ActivityTypeTableViewCell.h"

@implementation ActivityTypeTableViewCell

@synthesize value;

__strong NSArray *values = nil;

+ (void)initialize {
	//values = [NSArray arrayWithObjects:@"爱心/梦想",@"主题/节日",@"运动/桌游",@"影视/展演",@"派对/夜店",@"手作/沙龙",@"美食/集市",@"定制/其他", nil];
    //values = [NSArray arrayWithObjects:@"Value 1", @"Value 2", @"Value 3", @"Value 4", @"Value 5", nil];
    values = [[NSArray alloc] initWithObjects:@"爱心/梦想",@"主题/节日",@"运动/桌游",@"影视/展演",@"派对/夜店",@"手作/沙龙",@"美食/集市",@"定制/其他", nil];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
		self.picker.delegate = self;
		self.picker.dataSource = self;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
		self.picker.delegate = self;
		self.picker.dataSource = self;
    }
    return self;
}

- (void)setValue:(NSString *)v {
	value = v;
	self.detailTextLabel.text = value;
	[self.picker selectRow:[values indexOfObject:value] inComponent:0 animated:YES];
}

#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [values count];
}

#pragma mark -
#pragma mark UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [values objectAtIndex:row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
	return 44.0f;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	return 300.0f; //pickerView.bounds.size.width - 20.0f;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	self.value = [values objectAtIndex:row];
    
	if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewCell:didEndEditingWithValue:)]) {
		[self.delegate tableViewCell:self didEndEditingWithValue:self.value];
	}
}

@end
