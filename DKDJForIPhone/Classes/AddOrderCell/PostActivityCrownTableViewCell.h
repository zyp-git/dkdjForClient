//
//  PostActivityCrownTableViewCell.h
//  AlongWithUs4iPhone
//
//  Created by zhengjianfeng on 12-9-16.
//
//

#import <UIKit/UIKit.h>

#import "PickerInputTableViewCell.h"

@class PostActivityCrownTableViewCell;

@protocol PostActivityCrownTableViewCellDelegate <NSObject>
@optional//@optional可选择实现 @required 表示必须实现
- (void)tableViewCell:(PostActivityCrownTableViewCell *)cell didEndEditingWithValue:(NSString *)value;
@end

@interface PostActivityCrownTableViewCell : PickerInputTableViewCell <UIPickerViewDataSource, UIPickerViewDelegate> {
	NSString *value;
    NSString *valuefix;
}

@property (nonatomic,strong) NSString *value;
@property (nonatomic,strong) NSString *valuefix;
@property (nonatomic,retain) id <PostActivityCrownTableViewCellDelegate> delegate;

@end
