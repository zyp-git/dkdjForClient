//
//  HJEditShopCartNumberPopView.h
//  GZGJ
//
//  Created by ihangjing on 14-10-13.
//
//

#import "HJPopViewBase.h"
#import "FoodModel.h"
#import "FShop4ListModel.h"
#import "MyShopCart.h"
#import "ShopCardModel.h"
#define startNumberTag 1000//数字显示界面起始tag
#define startPlushTag 2000//增加按钮起始tag
#define startMinTag 3000//减少按钮起始tag

@interface HJEditShopCartNumberPopView : HJPopViewBase<UIActionSheetDelegate>
{
    UIImage *viewroundImage;
    MyShopCart *myShopCart;
    FShop4ListModel *shopModel;
    FoodModel *foodModel;
    UILabel *numValue;
    UILabel *cardValue;
    int shopIndex;
    ShopCardModel *shopcard;
}

-(HJEditShopCartNumberPopView *)initWithView:(UIView *)view FoodModel:(FoodModel *)food FShop4ListModel:(FShop4ListModel *)shop MyShopCart:(MyShopCart *)shopCart childViewPosition:(CGPoint)point index:(int)index;

@end
