//
//  ShopListCell.m
//  EasyEat4iPhone
//
//  Created by zjf@ihangjing.com on 12-1-5.
//  Copyright 2012 ihangjing.com. All rights reserved.
//	

// 商家列表中视图单元 
// 包含：icon 名称 营业时间 电话 地址
#import "ShopListCell.h"

@implementation ShopListCell

@synthesize nameLabel;
@synthesize timeLabel;
@synthesize telLabel;
@synthesize addressLabel;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [nameLabel release];
    [timeLabel release];
	[telLabel release];
	[addressLabel release];
    [super dealloc];
}
@end
