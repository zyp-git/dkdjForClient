//
//  FoodAttrModel.h
//  TSYP
//
//  Created by wulin on 13-6-12.
//
//

#import <Foundation/Foundation.h>
#import "CouponModel.h"
@interface FoodAttrModel : NSObject{

}
@property(nonatomic) int cid;
@property(nonatomic) int foodId;
@property (nonatomic, retain)NSString *name;
@property (nonatomic, retain)CouponModel *card;//代金券
@property (nonatomic)float price;
@property (nonatomic)int count;
@property(nonatomic)float pactFee;
@property(nonatomic)float oldPrice;//原价
@property(nonatomic)BOOL isSelect;//是否在购物车中选中结算，选中了才会最总提交；
@property (nonatomic)int cardIndex;//代金券所在位置
- (FoodAttrModel*)initWithJsonDictionary:(NSDictionary*)dic;
@end
