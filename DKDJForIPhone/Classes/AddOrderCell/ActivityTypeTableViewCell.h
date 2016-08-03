//
//  ActivityTypeTableViewCell.h
//  AlongWithUs4iPhone
//
//  Created by zhengjianfeng on 12-9-15.
//
//

#import <UIKit/UIKit.h>
#import "PickerInputTableViewCell.h"

@class ActivityTypeTableViewCell;

@protocol ActivityTypeTableViewCellDelegate <NSObject>
@optional
- (void)tableViewCell:(ActivityTypeTableViewCell *)cell didEndEditingWithValue:(NSString *)value;
@end

@interface ActivityTypeTableViewCell : PickerInputTableViewCell <UIPickerViewDataSource, UIPickerViewDelegate> {
	NSString *value;
}

@property (nonatomic, strong) NSString *value;
@property (nonatomic,retain) id <ActivityTypeTableViewCellDelegate> delegate;

@end
