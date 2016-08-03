//
//  UIAlertTableView.h
//  TSYP
//
//  Created by wulin on 13-6-13.
//
//

#import <UIKit/UIKit.h>
#import "FoodModel.h"
#import "FoodInOrderModel.h"

@interface UIAlertTableView : UIAlertView <UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource>{
    UIAlertView *alertView;
    UITableView *inTableView;
    //NSMutableDictionary *shopCart;
    int tableHeight;
    int tableExtHeight;
    id <UITableViewDataSource> dataSource;
    id <UITableViewDelegate> tableDelegate;
    id updateDelegate;
    FoodModel *food;
    FoodInOrderModel *foodInOrder;
    NSIndexPath *lastIndexPath;
}
@property (nonatomic, assign) id dataSource;
@property (nonatomic, assign) id tableDelegate;
@property (nonatomic, retain) id updateDelegate;

@property (nonatomic, readonly) UITableView *inTableView;
@property (nonatomic, assign) int tableHeight;
@property (nonatomic, retain) NSIndexPath *lastIndexPath;
//@property (nonatomic, retain)FoodModel *food;
//@property (nonatomic, retain)NSMutableArray *shopCart;
- (void)prepare;
- (id)initWitchData:(FoodModel **)data updateTableView:(id)update;
- (id)initWitchDataOfInOrderModel:(FoodInOrderModel **)data updateTableView:(id)update;
@end
