//
//  OrderListCell.h
//  DKDJForIPhone
//
//  Created by 张允鹏 on 16/6/6.
//
//
#import "Order4ListModel.h"
#import <UIKit/UIKit.h>
@class OrderListCell;
@protocol OrderListCellDelegate <NSObject>

-(void)OrderListCell:(OrderListCell *)cell gotoComment:(NSInteger )BtnTag;

@end

@interface OrderListCell : UITableViewCell


@property (nonatomic,strong)  Order4ListModel *orderModel;
@property (weak,nonatomic) id<OrderListCellDelegate> delegate;
+(OrderListCell  *)cellProcessWithTableView:(UITableView *)tableView;
+(OrderListCell  *)cellFinishWithTableView:(UITableView *)tableView;
@end
