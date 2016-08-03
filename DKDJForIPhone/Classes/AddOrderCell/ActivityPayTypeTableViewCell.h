//
//  ActivityPayTypeTableViewCell.h
//  AlongWithUs4iPhone
//
//  Created by zhengjianfeng on 12-9-15.
//
//

#import <UIKit/UIKit.h>

#import "PickerInputTableViewCell.h"

@class ActivityPayTypeTableViewCell;

@protocol ActivityPayTypeTableViewCellDelegate <NSObject>
@optional
- (void)tableViewCell:(ActivityPayTypeTableViewCell *)cell APdidEndEditingWithValue:(NSString *)value;
@end

@interface ActivityPayTypeTableViewCell : PickerInputTableViewCell <UIPickerViewDataSource, UIPickerViewDelegate> {
	NSString *value;
}

@property (nonatomic, strong) NSString *value;
@property (nonatomic,retain) id <ActivityPayTypeTableViewCellDelegate> delegate;

@end
