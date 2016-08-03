//
//  HJListViewPop.h
//  JYBE
//
//  Created by ihangjing on 15/4/2.
//
//

#import "HJPopViewBase.h"

@interface HJListViewPop : HJPopViewBase<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *dataTable;
    NSMutableArray *dataAry;
    UITableView *dataTable1;
    NSMutableArray *dataAry1;
    
    
}
-(HJListViewPop *)initWithView:(UIView *)view childViewPosition:(CGPoint)point aryValue:(NSMutableArray *)ary showType:(int)Type popType:(int)pType;
-(void)setDataArry2:(NSMutableArray *)ary;
@end
