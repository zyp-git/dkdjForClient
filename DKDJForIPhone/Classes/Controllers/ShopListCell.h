//
//  ShopListCell.h
//  EasyEat4iPhone
//
//  Created by dev on 12-1-5.
//  Copyright 2012 ihangjing.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopListCell : UITableViewCell{
    UILabel *nameLabel;
    UILabel *timeLabel;
	UILabel *telLabel;
	UILabel *addressLabel;
	UIImage *iconImage;
}
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *timeLabel;
@property (nonatomic, retain) IBOutlet UILabel *telLabel;
@property (nonatomic, retain) IBOutlet UILabel *addressLabel;
@property (nonatomic, retain) IBOutlet UIImage *iconImagel;


@end
