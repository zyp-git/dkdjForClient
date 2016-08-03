//
//  SeckillListCell.m
//  RenRenzx
//
//  Created by zhengjianfeng on 12-10-10.
//
//

#import "SeckillListCell.h"

@implementation SeckillListCell

@synthesize titleLabel;
@synthesize priceLabel;
@synthesize timeLabel;
@synthesize shopLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //1.
        CGRect nameLabelRect = CGRectMake(5, 5, 260, 15);
        titleLabel = [[UILabel alloc] initWithFrame:nameLabelRect];
        
        titleLabel.textAlignment = NSTextAlignmentLeft;
        
        //nameLabel.text = shopmodel.shopname;
        titleLabel.font = [UIFont boldSystemFontOfSize:14];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.tag = 1;
        
        [self addSubview: titleLabel];
        [titleLabel release];
        
        //2.
        CGRect telLabelRect = CGRectMake(5,25, 260, 12);
        priceLabel = [[UILabel alloc] initWithFrame:
                      telLabelRect];
        
        priceLabel.textAlignment = NSTextAlignmentLeft;
        //telLabel.text = shopmodel.tel;
        priceLabel.font = [UIFont boldSystemFontOfSize:12];
        priceLabel.textColor = [UIColor grayColor];
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.tag = 2;
        
        [self addSubview: priceLabel];
        [priceLabel release];
        
        //3.
        CGRect timeValueRect = CGRectMake(5, 40, 260, 12);
        timeLabel = [[UILabel alloc] initWithFrame:
                     timeValueRect];
        
        timeLabel.textAlignment = NSTextAlignmentLeft;
        //timeValue.text = shopmodel.OrderTime;
        timeLabel.font = [UIFont boldSystemFontOfSize:12];
        timeLabel.textColor = [UIColor grayColor];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.tag = 3;
        
        [self addSubview:timeLabel];
        [timeLabel release];
        
        //4.
        CGRect addressValueRect = CGRectMake(5, 55, 260, 12);
        shopLabel = [[UILabel alloc] initWithFrame:
                     addressValueRect];
        
        shopLabel.textAlignment = NSTextAlignmentLeft;
        //addressValue.text = shopmodel.address;
        shopLabel.font = [UIFont boldSystemFontOfSize:12];
        shopLabel.textColor = [UIColor grayColor];
        shopLabel.backgroundColor = [UIColor clearColor];
        shopLabel.tag = 4;
        
        [self addSubview:shopLabel];
        [shopLabel release];
        
    }
    return self;
}

-(void) dealloc
{
    /*
     [titleLabel release];
     [priceLabel release];
     [timeLabel release];
     [shopLabel release];
     */
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
