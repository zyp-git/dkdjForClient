//
//  MyAddressLabel.h
//  Faneat4iPhone
//
//  Created by OS Mac on 12-7-3.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyAddressLabel;
@protocol MyLabelDelegate <NSObject>
@required
- (void)myLabel:(MyAddressLabel *)myLabel touchesWtihTag:(NSInteger)tag;
@end

@interface MyAddressLabel : UILabel {
    id <MyLabelDelegate> delegate;
}

@property (nonatomic, assign) id <MyLabelDelegate> delegate;
- (id)initWithFrame:(CGRect)frame;
@end