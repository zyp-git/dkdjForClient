//
//  UserTimelineCell.m
//  TwitterFon
//
//  Created by kaz on 8/20/08.
//  Copyright 2008 naan studio. All rights reserved.
//

#import "LoadCell.h"
#import "ColorUtils.h"

static NSString *sLabels[] = {
    @"加载更多商家...",
    @"加载更多礼品...",
    @"加载更多数据...",
    @"加载更多餐品...",
    @"加载中...",
	@"提交中...",
    @"加载更多区域...",
    @"   ",
    @"网络搜索更多,加为好友",
};

@implementation LoadCell

@synthesize spinner;
@synthesize type;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier];
    
    // name label
    self.backgroundColor = [UIColor clearColor];
    label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor cellLabelColor];
    label.highlightedTextColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.numberOfLines = 1;
    label.textAlignment = NSTextAlignmentCenter;    
    label.frame = CGRectMake(0, 0, 320, 47);
    [self.contentView addSubview:label];
    self.contentView.backgroundColor = [UIColor clearColor];
    spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
    [self.contentView addSubview:spinner];
   
	return self;
}

- (void)setType:(loadCellType)aType
{
    type = aType;
    label.text = sLabels[type];
    [spinner stopAnimating];
}

-(loadCellType)getType
{
    return type;
}

//You should override this method only if the autoresizing behaviors of the subviews do not offer the behavior you want.
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect bounds = [label textRectForBounds:CGRectMake(0, 0, 320, 48) limitedToNumberOfLines:1];
    spinner.frame = CGRectMake(bounds.origin.x + bounds.size.width + 4, (self.frame.size.height / 2) - 8, 16, 16);
    label.frame = CGRectMake(0, 0, 320, self.frame.size.height - 1);
}

- (void)dealloc {
	[super dealloc];
}


@end
