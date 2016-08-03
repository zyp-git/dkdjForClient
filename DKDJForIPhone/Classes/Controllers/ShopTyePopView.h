//
//  ShopTyePopView.h
//  GZGJ
//
//  Created by ihangjing on 14/11/6.
//
//

#import "HJPopViewBase.h"
#import "ShopTypeModel.h"

@interface ShopTyePopView : HJPopViewBase<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *dataArry;
    UITableView *dataTable;
}
-(ShopTyePopView *) initinitWithView:(UIView *)view WithArry:(NSMutableArray *)ary;
@end
