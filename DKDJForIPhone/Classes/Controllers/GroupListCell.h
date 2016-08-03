//
//  GroupListCell.h
//  RenRenzx
//
//  Created by zhengjianfeng on 12-10-10.
//
//

#import <UIKit/UIKit.h>

@interface GroupListCell : UITableViewCell{
    
    UILabel *titleLabel;
    UILabel *priceLabel;
	UILabel *timeLabel;
	UILabel *shopLabel;
}

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *priceLabel;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) UILabel *shopLabel;

@end