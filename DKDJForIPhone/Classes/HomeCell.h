//
//  HomeCell.h
//  DKDJForIPhone
//
//  Created by 张允鹏 on 16/5/28.
//
//

#import <UIKit/UIKit.h>
#import "FShop4ListModel.h"

@class  HomeCell;
@protocol HomeCellDelegate <NSObject>

-(void) HomeCell:(HomeCell *)cell withBtnOpenState:(BOOL)isOpen;

@end

@interface HomeCell : UITableViewCell

@property (nonatomic,strong) NSMutableArray <FShop4ListModel*> * viewArr;
@property (weak,nonatomic) UIView * lineView;
@property (assign,nonatomic) NSIndexPath *  indexPath;
@property (nonatomic,strong) FShop4ListModel * FShop4ListModel;
@property (weak,nonatomic)  id<HomeCellDelegate> delegate;


+(HomeCell *)HomeCellWithTableView:(UITableView *)tableView;



@end
