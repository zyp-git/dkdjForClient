//
//  ActivityPayTypeTableViewCell.m
//  AlongWithUs4iPhone
//
//  Created by zhengjianfeng on 12-9-15.
//
//

#import "ActivityPayTypeTableViewCell.h"

@implementation ActivityPayTypeTableViewCell

@synthesize value;

__strong NSArray *valuesp = nil;

+ (void)initialize {

    //values = [NSArray arrayWithObjects:@"Value 1", @"Value 2", @"Value 3", @"Value 4", @"Value 5", nil];
    valuesp = [[NSArray alloc] initWithObjects:@"自行组织并收费",@"申请通过along组织并收费", nil];
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
	[self.picker selectRow:[valuesp indexOfObject:value] inComponent:0 animated:YES];
}

#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [valuesp count];
}

#pragma mark -
#pragma mark UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [valuesp objectAtIndex:row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
	return 44.0f;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	return 300.0f; //pickerView.bounds.size.width - 20.0f;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	self.value = [valuesp objectAtIndex:row];
    
	if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewCell:didEndEditingWithValue:)]) {
		[self.delegate tableViewCell:self APdidEndEditingWithValue:self.value];
	}
}

@end