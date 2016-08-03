//
//  FoodListCell.h
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-28.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//  暂未使用

#import <Foundation/Foundation.h>

@interface FoodListCell : UITableViewCell{
    UILabel *nameLabel;
    UILabel *priceLabel;
	UILabel *numLabel;
    UIButton *plusButton;
    UIButton *minusButton;
    
}
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *priceLabel;
@property (nonatomic, retain) IBOutlet UILabel *numLabel;

@end