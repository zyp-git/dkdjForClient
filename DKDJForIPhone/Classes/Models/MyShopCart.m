//
//  MyShopCart.m
//  GZGJ
//
//  Created by ihangjing on 14-9-19.
//
//

#import "MyShopCart.h"

@implementation MyShopCart
@synthesize shopCartArry;//ShopCardModel 列表

@synthesize custName;//收货人
@synthesize phone;//收货电话
@synthesize Address;//收货地址
@synthesize email;//邮箱
@synthesize sendTime;//配送时间
@synthesize userID;//会员编号
@synthesize areaID;//区域编号
@synthesize userName;//会员名称
@synthesize people;//就餐人数
@synthesize payPassword;//在线支付余额支付的支付密码
@synthesize note;//订单备注
@synthesize uLat;//用户纬度
@synthesize uLng;//用户经度

@synthesize activityID;//参加活动编号
@synthesize activityName;//参加活动名称
@synthesize addTime;//提交时间
@synthesize canJoinPeople;//能参加活动的人数限制

@synthesize canBuyType;//能支持0 普通订单 1预约订单

@synthesize buyType;////0 普通订单 1预约订单 2 参与线下活动 3参与线上活动 4购买或兑换优惠券 5礼品兑换
@synthesize senType;//配送方式 1送货上门;2上门自提;3到店消费
@synthesize payType;//支付方法:0线上支付,1线下支付
@synthesize payMode;//支付方式：1,支付宝支付;2,礼品卡支付;4,货到付款;5,微信;
@synthesize foodCount;//菜品总数
@synthesize foodAttrLine;//菜品规格总数（不包含规格里面的个数）

@synthesize sendMoney;//配送费
@synthesize packageFee;//打包费
@synthesize allPrice;//总价
@synthesize togoPrice;//不包含水吧饮品的价格

@synthesize cFoodCount;//购物车选中菜品总数
@synthesize cFoodAttrLine;//购物车选中菜品规格总数（不包含规格里面的个数）

@synthesize cSendMoney;//购物车选中配送费
@synthesize cPackageFee;//购物车选中打包费
@synthesize cAllPrice;//购物车选中总价
@synthesize cTogoPrice;//购物车选中不包含水吧饮品的价格

-(id)init{
    [super init];
    if (self != nil) {
        shopCartArry = [[NSMutableArray alloc] init];
    }
    return self;
}
-(NSString *)FloatToStr:(float)v
{
    return [NSString stringWithFormat:@"%f", v];
}
-(float)add:(float)v1 value:(float)v2{//加
    NSDecimalNumber *a = [NSDecimalNumber decimalNumberWithString:[self FloatToStr:v1]];
    NSDecimalNumber *b = [NSDecimalNumber decimalNumberWithString:[self FloatToStr:v2]];
    NSDecimalNumber *c = [a decimalNumberByAdding:b];
    return [c floatValue];
}
-(float)subtract:(float)v1 value:(float)v2{//减
    NSDecimalNumber *a = [NSDecimalNumber decimalNumberWithString:[self FloatToStr:v1]];
    NSDecimalNumber *b = [NSDecimalNumber decimalNumberWithString:[self FloatToStr:v2]];
    NSDecimalNumber *c = [a decimalNumberBySubtracting:b];
    return [c floatValue];
}
-(float)multiply:(float)v1 value:(float)v2{//剩
    NSDecimalNumber *a = [NSDecimalNumber decimalNumberWithString:[self FloatToStr:v1]];
    NSDecimalNumber *b = [NSDecimalNumber decimalNumberWithString:[self FloatToStr:v2]];
    NSDecimalNumber *c = [a decimalNumberByMultiplyingBy:b];
    return [c floatValue];
}
-(float)divide:(float)v1 value:(float)v2{//除
    NSDecimalNumber *a = [NSDecimalNumber decimalNumberWithString:[self FloatToStr:v1]];
    NSDecimalNumber *b = [NSDecimalNumber decimalNumberWithString:[self FloatToStr:v2]];
    NSDecimalNumber *c = [a decimalNumberByDividingBy:b];
    return [c floatValue];
}



-(int) addFoodAttr:(FShop4ListModel *)mShop food:(FoodModel *)food attrIndex:(int)attrIndex
{
    
    
    int length =(int) [self.shopCartArry count];
    foodCount++;
    //allPrice += ((FoodAttrModel *)[[food attr] objectAtIndex:attrIndex]).price;
    allPrice = [self add:allPrice value:((FoodAttrModel *)[[food attr] objectAtIndex:attrIndex]).price];
    ShopCardModel *model;
    if (length > 0) {
        for (int i = 0; i < length; i++) {
            model = [self.shopCartArry objectAtIndex:i];
            if (mShop.shopid == model.shopID) {
                food.tName = model.shopName;
                foodAttrLine -= model.foodAttrLine;//矫正属性数字
                cAllPrice = [self subtract:cAllPrice value:model.cAllPrice];
                cTogoPrice = [self subtract:cTogoPrice value:model.cTogoPrice];
                cPackageFee = [self subtract:cPackageFee value:model.cPackageFee];
                cFoodCount -= model.cFoodCount;
                cSendMoney = [self subtract:cSendMoney value:model.sendFee];
                attrIndex = [model addFoodAttr:food index:attrIndex];
                cAllPrice = [self add:cAllPrice value:model.cAllPrice];
                cTogoPrice = [self add:cTogoPrice value:model.cTogoPrice];
                cPackageFee = [self add:cPackageFee value:model.cPackageFee];
                cFoodCount += model.cFoodCount;
                foodAttrLine += model.foodAttrLine;////矫正属性数字
                [model CalculationSendFee];
                cSendMoney = [self add:cSendMoney value:model.sendFee];
                return attrIndex;
                
            }
        }
    }
    model = [[ShopCardModel alloc] init];
    model.shopID = mShop.shopid;
    model.shopName = mShop.shopname;
    model.sendMoney = mShop.Sendmoney;
    model.fullFreeMoney = mShop.fullFreeMoney;
    model.startMoney = mShop.startMoney;
    model.Lat = mShop.Lat;
    model.Lng = mShop.Lng;
    model.distance = mShop.distance;
    food.tName = mShop.shopname;
    food.tid = mShop.shopid;
    
    //cAllPrice -= model.cAllPrice;
    //cTogoPrice -= model.cTogoPrice;
    //cPackageFee -= model.cPackageFee;
    cAllPrice = [self subtract:cAllPrice value:model.cAllPrice];
    cTogoPrice = [self subtract:cTogoPrice value:model.cTogoPrice];
    cPackageFee = [self subtract:cPackageFee value:model.cPackageFee];
    cFoodCount -= model.cFoodCount;
    
    [model addFoodAttr:food index:attrIndex];
    
    //cAllPrice += model.cAllPrice;
    //cTogoPrice += model.cTogoPrice;
    //cPackageFee += model.cPackageFee;
    cAllPrice = [self add:cAllPrice value:model.cAllPrice];
    cTogoPrice = [self add:cTogoPrice value:model.cTogoPrice];
    cPackageFee = [self add:cPackageFee value:model.cPackageFee];
    cFoodCount += model.cFoodCount;
    
    model.maxKM = mShop.maxKM;
    model.minKM = mShop.minKM;
    model.SendFeeAffKM = mShop.SendFeeAffKM;
    model.SendFeeOfKM = mShop.SendFeeOfKM;
    model.startSendFee = mShop.startSendFee;
    
    [model CalculationSendFee];
    //cSendMoney += model.sendFee;
    cSendMoney = [self add:cSendMoney value:model.sendFee];
    
    [self.shopCartArry addObject:model];
    foodAttrLine++;
    return 1;
}

-(int) delFoodAttr:(FShop4ListModel *)mShop food:(FoodModel *)food attrIndex:(int)attrIndex{
    // TODO Auto-generated method stub
    int length = (int)[self.shopCartArry count];
    ShopCardModel *model;
    if (length > 0) {
        for (int i = 0; i < length; i++) {
            model = [self.shopCartArry objectAtIndex:i];
            if (mShop.shopid == model.shopID) {
                foodAttrLine -= model.foodAttrLine;//矫正属性数字
               // allPrice -= model.allPrice;
                allPrice = [self subtract:allPrice value:model.allPrice];
                foodCount -= model.foodCount;
                
                //cAllPrice -= model.cAllPrice;
                //cTogoPrice -= model.cTogoPrice;
                //cPackageFee -= model.cPackageFee;
                cFoodCount -= model.cFoodCount;
                //cSendMoney -= model.sendFee;
                cAllPrice = [self subtract:cAllPrice value:model.cAllPrice];
                cTogoPrice = [self subtract:cTogoPrice value:model.cTogoPrice];
                cPackageFee = [self subtract:cPackageFee value:model.cPackageFee];
                cSendMoney = [self subtract:cSendMoney value:model.sendFee];
                attrIndex = [model delFoodAttr:food index:attrIndex];
                foodAttrLine += model.foodAttrLine;//矫正属性数字
                //allPrice += model.allPrice;
                allPrice = [self add:allPrice value:model.allPrice];
                foodCount += model.foodCount;
                
                //cAllPrice += model.cAllPrice;
                //cTogoPrice += model.cTogoPrice;
                //cPackageFee += model.cPackageFee;
                cFoodCount += model.cFoodCount;
                [model CalculationSendFee];
                //cSendMoney += model.sendFee;
                cAllPrice = [self add:cAllPrice value:model.cAllPrice];
                cTogoPrice = [self add:cTogoPrice value:model.cTogoPrice];
                cPackageFee = [self add:cPackageFee value:model.cPackageFee];
                cSendMoney = [self add:cSendMoney value:model.sendFee];
                if (attrIndex == 0 && model.foodCount == 0) {
                    [self.shopCartArry removeObjectAtIndex:i];
                }
                return attrIndex;
            }
        }
    }
    return 0;
}


-(float) getFoodPrice:(FoodModel *)food {
    // TODO Auto-generated method stub
    int length = (int)[self.shopCartArry count];
    if (length > 0) {
        ShopCardModel *model;
        for (int i = 0; i < length; i++) {
            model = [self.shopCartArry objectAtIndex:i];
            if (food.tid == model.shopID) {
                return [model getFoodPrice:food.foodid];
            }
        }
    }
    return 0.0f;
}

-(float) getFoodPriceWithShop:(FShop4ListModel *)mShop foodID:(int)foodId {
    // TODO Auto-generated method stub
    int length = (int)[self.shopCartArry count];
    if (length > 0) {
        ShopCardModel *model;
        for (int i = 0; i < length; i++) {
            model = [self.shopCartArry objectAtIndex:i];
            if (mShop.shopid == model.shopID) {
                return [model getFoodPrice:foodId];
            }
        }
    }
    return 0.0f;
}

- (int)getFoodCountInAttr:(FShop4ListModel *)mShop foodID:(int)foodId
               attrId:(int)cId {
    // TODO Auto-generated method stub
    int length = (int)[self.shopCartArry count];
    if (length > 0) {
        ShopCardModel *model;
        for (int i = 0; i < length; i++) {
            model = [self.shopCartArry objectAtIndex:i];
            if (mShop.shopid == model.shopID) {
                
                return [model getFoodCountInAttr:foodId attId:cId];
            }
        }
    }
    return 0;
}

-(int)getFoodCountInAttrWitchShopID:(int)shopID foodID:(int)foodId attrId:(int)cId {
    // TODO Auto-generated method stub
    int length = [self.shopCartArry count];
    if (length > 0) {
        ShopCardModel *model;
        for (int i = 0; i < length; i++) {
            model = [self.shopCartArry objectAtIndex:i];
            if (shopID == model.shopID) {
                return [model getFoodCountInAttr:foodId attId:cId];
            }
        }
    }
    return 0;
}

-(ShopCardModel*) getShopCardInOrderModel:(int)index{//根据index返回shopCart
    // TODO Auto-generated method stub
    int count = 0;
    int length = (int)[self.shopCartArry count];
    for (int i = 0; i < length; i++) {
        count += [[self.shopCartArry objectAtIndex:i] foodAttrLine];
        if (index < count) {//如果在该所以呢里面
            return [self.shopCartArry objectAtIndex:i];
        }else{
            count = 0;
            index -= [[self.shopCartArry objectAtIndex:i] foodAttrLine];
        }
    }
    return nil;
}

-(FoodModel*) getFoodInOrderModel:(int *)index{//根据index返回食品
    // TODO Auto-generated method stub
    int count = 0;
    NSInteger length = [self.shopCartArry count];
    for (int i = 0; i < length; i++) {
        count += [[self.shopCartArry objectAtIndex:i] foodAttrLine];
        if ((*index) < count) {//如果在该所以呢里面
            return [[self.shopCartArry objectAtIndex:i] getFoodInOrderModel:index];
        }else{
            count = 0;
            (*index) -= [[self.shopCartArry objectAtIndex:i] foodAttrLine];
        }
    }
    return nil;
}

-(int) addFoodAttr:(FoodModel *)food attrIndex:(int)attrIndex {
    // TODO Auto-generated method stub
    NSInteger length = [self.shopCartArry count];
    
    ShopCardModel *model;
    if (length > 0) {
        for (int i = 0; i < length; i++) {
            model = [self.shopCartArry objectAtIndex:i];
            if (food.tid == model.shopID) {
                foodAttrLine -= model.foodAttrLine;//矫正属性数字
                //allPrice -= model.allPrice;
                foodCount -= model.foodCount;
                
                //cAllPrice -= model.cAllPrice;
                //cTogoPrice -= model.cTogoPrice;
                //cPackageFee -= model.cPackageFee;
                cFoodCount -= model.cFoodCount;
                //cSendMoney -= model.sendFee;
                allPrice = [self subtract:allPrice value:model.allPrice];
                cAllPrice = [self subtract:cAllPrice value:model.cAllPrice];
                cTogoPrice = [self subtract:cTogoPrice value:model.cTogoPrice];
                cPackageFee = [self subtract:cPackageFee value:model.cPackageFee];
                cSendMoney = [self subtract:cSendMoney value:model.sendFee];
                attrIndex = [model addFoodAttrFoodId:food.foodid index:attrIndex];
                foodAttrLine += model.foodAttrLine;//矫正属性数字
                //allPrice += model.allPrice;
                foodCount += model.foodCount;
                
                //cAllPrice += model.cAllPrice;
                //cTogoPrice += model.cTogoPrice;
                //cPackageFee += model.cPackageFee;
                cFoodCount += model.cFoodCount;
                [model CalculationSendFee];
                //cSendMoney += model.sendFee;
                allPrice = [self add:allPrice value:model.allPrice];
                cAllPrice = [self add:cAllPrice value:model.cAllPrice];
                cTogoPrice = [self add:cTogoPrice value:model.cTogoPrice];
                cPackageFee = [self add:cPackageFee value:model.cPackageFee];
                cSendMoney = [self add:cSendMoney value:model.sendFee];
                return attrIndex;
                
            }
        }
    }
    
    return 0;
}

-(int) delFoodAttr:(FoodModel *)food attrIndex:(int)attrIndex{
    // TODO Auto-generated method stub
    NSInteger length = [self.shopCartArry count];
    ShopCardModel *model;
    if (length > 0) {
        for (int i = 0; i < length; i++) {
            model = [self.shopCartArry objectAtIndex:i];
            if (food.tid == model.shopID) {
                foodAttrLine -= model.foodAttrLine;//矫正属性数字
                //allPrice -= model.allPrice;
                foodCount -= model.foodCount;
                
                //cAllPrice -= model.cAllPrice;
                //cTogoPrice -= model.cTogoPrice;
                //cPackageFee -= model.cPackageFee;
                cFoodCount -= model.cFoodCount;
                //cSendMoney -= model.sendFee;
                allPrice = [self subtract:allPrice value:model.allPrice];
                cAllPrice = [self subtract:cAllPrice value:model.cAllPrice];
                cTogoPrice = [self subtract:cTogoPrice value:model.cTogoPrice];
                cPackageFee = [self subtract:cPackageFee value:model.cPackageFee];
                cSendMoney = [self subtract:cSendMoney value:model.sendFee];
                attrIndex = [model delFoodAttrFoodId:food.foodid index:attrIndex];//.delFoodAttr(food.getId(), pt);
                foodAttrLine += model.foodAttrLine;//矫正属性数字
                //allPrice += model.allPrice;
                foodCount += model.foodCount;
                
                //cAllPrice += model.cAllPrice;
                //cTogoPrice += model.cTogoPrice;
                //cPackageFee += model.cPackageFee;
                cFoodCount += model.cFoodCount;
                [model CalculationSendFee];
                //cSendMoney += model.sendFee;
                allPrice = [self add:allPrice value:model.allPrice];
                cAllPrice = [self add:cAllPrice value:model.cAllPrice];
                cTogoPrice = [self add:cTogoPrice value:model.cTogoPrice];
                cPackageFee = [self add:cPackageFee value:model.cPackageFee];
                cSendMoney = [self add:cSendMoney value:model.sendFee];
                if (attrIndex == 0 && model.foodCount == 0) {
                    [self.shopCartArry removeObjectAtIndex:i];
                }
                return attrIndex;
            }
        }
    }
    return 0;
}

-(void) removeFood:(FoodModel *)food attrIndex:(int)attrIndex{
    // TODO Auto-generated method stub
    int length =(int) [self.shopCartArry count];
    ShopCardModel *model;
    if (length > 0) {
        for (int i = 0; i < length; i++) {
            model = [self.shopCartArry objectAtIndex:i];
            if (food.tid == model.shopID) {
                length = model.foodCount;
                if (attrIndex < length) {
                    foodAttrLine -= model.foodAttrLine;//矫正属性数字
                    //allPrice -= model.allPrice;
                    foodCount -= model.foodCount;
                    
                    //cAllPrice -= model.cAllPrice;
                    //cTogoPrice -= model.cTogoPrice;
                    //cPackageFee -= model.cPackageFee;
                    cFoodCount -= model.cFoodCount;
                    //cSendMoney -= model.sendFee;
                    allPrice = [self subtract:allPrice value:model.allPrice];
                    cAllPrice = [self subtract:cAllPrice value:model.cAllPrice];
                    cTogoPrice = [self subtract:cTogoPrice value:model.cTogoPrice];
                    cPackageFee = [self subtract:cPackageFee value:model.cPackageFee];
                    cSendMoney = [self subtract:cSendMoney value:model.sendFee];
                    
                    [model removeFood:food.foodid index:attrIndex];//.removeFood(food.getId(), attrIndex);
                    foodAttrLine += model.foodAttrLine;//矫正属性数字
                    //allPrice += model.allPrice;
                    foodCount += model.foodCount;
                    
                    //cAllPrice += model.cAllPrice;
                    //cTogoPrice += model.cTogoPrice;
                    //cPackageFee += model.cPackageFee;
                    cFoodCount += model.cFoodCount;
                    [model CalculationSendFee];
                    //cSendMoney += model.sendFee;
                    allPrice = [self add:allPrice value:model.allPrice];
                    cAllPrice = [self add:cAllPrice value:model.cAllPrice];
                    cTogoPrice = [self add:cTogoPrice value:model.cTogoPrice];
                    cPackageFee = [self add:cPackageFee value:model.cPackageFee];
                    cSendMoney = [self add:cSendMoney value:model.sendFee];
                    if (model.foodCount == 0) {
                        [self.shopCartArry removeObjectAtIndex:i];
                    }
                    return;
                    
                }
                
            }
        }
    }
}

-(int) setFoodAttr:(FoodModel *)food attrIndex:(int)attrIndex foodCount:(int)ncount shop:(FShop4ListModel *)mShop{
    // TODO Auto-generated method stub
    int length;// = [self.shopCartArry count];
    ShopCardModel *model;
    while (1) {
        length =(int) [self.shopCartArry count];
        if (length > 0) {
            for (int i = 0; i < length; i++) {
                model = [self.shopCartArry objectAtIndex:i];
                if (food.tid == model.shopID) {
                    length = model.foodCount;
                    if (attrIndex < length) {
                        foodAttrLine -= model.foodAttrLine;//矫正属性数字
                        //allPrice -= model.allPrice;
                        foodCount -= model.foodCount;
                        
                        //cAllPrice -= model.cAllPrice;
                        //cTogoPrice -= model.cTogoPrice;
                        //cPackageFee -= model.cPackageFee;
                        cFoodCount -= model.cFoodCount;
                        //cSendMoney -= model.sendFee;
                        allPrice = [self subtract:allPrice value:model.allPrice];
                        cAllPrice = [self subtract:cAllPrice value:model.cAllPrice];
                        cTogoPrice = [self subtract:cTogoPrice value:model.cTogoPrice];
                        cPackageFee = [self subtract:cPackageFee value:model.cPackageFee];
                        cSendMoney = [self subtract:cSendMoney value:model.sendFee];
                        ncount = [model setFoodAttr:food index:attrIndex Count:ncount];// model.setFoodAttr(food.getId(), attrIndex, ncount);
                        foodAttrLine += model.foodAttrLine;//矫正属性数字
                        //allPrice += model.allPrice;
                        foodCount += model.foodCount;
                        
                        //cAllPrice += model.cAllPrice;
                        //cTogoPrice += model.cTogoPrice;
                        //cPackageFee += model.cPackageFee;
                        cFoodCount += model.cFoodCount;
                        [model CalculationSendFee];
                        //cSendMoney += model.sendFee;
                        allPrice = [self add:allPrice value:model.allPrice];
                        cAllPrice = [self add:cAllPrice value:model.cAllPrice];
                        cTogoPrice = [self add:cTogoPrice value:model.cTogoPrice];
                        cPackageFee = [self add:cPackageFee value:model.cPackageFee];
                        cSendMoney = [self add:cSendMoney value:model.sendFee];
                        if (model.foodCount == 0) {
                            [self.shopCartArry removeObjectAtIndex:i];
                        }
                        return ncount;
                    }
                    [self addFoodAttr:mShop food:food attrIndex:attrIndex];//不存在，加进去
                    //ncount--;
                    //return 0;
                    
                }
            }
        }
        [self addFoodAttr:mShop food:food attrIndex:attrIndex];//不存在，加进去
        //ncount--;
        //return 0;
    }
    
}

-(void)checkAll:(BOOL)check{
    NSInteger length = [self.shopCartArry count];
    ShopCardModel *model;
    for (int i = 0; i < length; i++) {
        model = [self.shopCartArry objectAtIndex:i];
        //cAllPrice -= shopCart.cAllPrice;
        //cTogoPrice -= shopCart.cTogoPrice;
        //cPackageFee -= shopCart.cPackageFee;
        cFoodCount -= model.cFoodCount;
        //cSendMoney -= shopCart.sendFee;
        cAllPrice = [self subtract:cAllPrice value:model.cAllPrice];
        cTogoPrice = [self subtract:cTogoPrice value:model.cTogoPrice];
        cPackageFee = [self subtract:cPackageFee value:model.cPackageFee];
        cSendMoney = [self subtract:cSendMoney value:model.sendFee];
        [model checkAll:check];
        //cAllPrice += shopCart.cAllPrice;
        //cTogoPrice += shopCart.cTogoPrice;
        //cPackageFee += shopCart.cPackageFee;
        cFoodCount += model.cFoodCount;
        [model CalculationSendFee];
        //cSendMoney += shopCart.sendFee;
        cAllPrice = [self add:cAllPrice value:model.cAllPrice];
        cTogoPrice = [self add:cTogoPrice value:model.cTogoPrice];
        cPackageFee = [self add:cPackageFee value:model.cPackageFee];
        cSendMoney = [self add:cSendMoney value:model.sendFee];
        
    }
}
-(void)checkFood:(FoodModel *)food attrIndex:(int)attrIndex check:(BOOL)isCheck
{
    NSInteger length = [self.shopCartArry count];
    ShopCardModel *model;
    for (int i = 0; i < length; i++) {
        model = [self.shopCartArry objectAtIndex:i];
        if (food.tid == model.shopID) {
            //cAllPrice -= shopCart.cAllPrice;
            //cTogoPrice -= shopCart.cTogoPrice;
            //cPackageFee -= shopCart.cPackageFee;
            cFoodCount -= model.cFoodCount;
            //cSendMoney -= shopCart.sendFee;
            cAllPrice = [self subtract:cAllPrice value:model.cAllPrice];
            cTogoPrice = [self subtract:cTogoPrice value:model.cTogoPrice];
            cPackageFee = [self subtract:cPackageFee value:model.cPackageFee];
            cSendMoney = [self subtract:cSendMoney value:model.sendFee];
            [model checkFoodId:food.foodid attrIndex:attrIndex check:isCheck];
            //cAllPrice += shopCart.cAllPrice;
            //cTogoPrice += shopCart.cTogoPrice;
            //cPackageFee += shopCart.cPackageFee;
            cFoodCount += model.cFoodCount;
            [model CalculationSendFee];
            //cSendMoney += shopCart.sendFee;
            cAllPrice = [self add:cAllPrice value:model.cAllPrice];
            cTogoPrice = [self add:cTogoPrice value:model.cTogoPrice];
            cPackageFee = [self add:cPackageFee value:model.cPackageFee];
            cSendMoney = [self add:cSendMoney value:model.sendFee];
            break;

        }
    }
}

-(void)dealloc{
    [self.shopCartArry removeAllObjects];
    [self.shopCartArry release];//ShopCardModel 列表
    [self.uLat release];
    [self.uLng release];
    [self.custName release];//收货人
    [self.phone release];//收货电话
    [self.Address release];//收货地址
    [self.sendTime release];//配送时间
    [self.userID release];//会员编号
    [self.userName release];//会员名称
    [self.people release];//就餐人数
    [self.payPassword release];//在线支付余额支付的支付密码
    [self.note release];//订单备注
    [self.email release];
    [self.activityID release];
    [self.activityName release];
    [self.addTime release];
    [self.areaID release];
    [super dealloc];
}

-(void)checkShopCard:(NSArray *)ary
{
    for (int i = 0; i < [ary count] && [self.shopCartArry count]; ++i) {
        NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
        ShopCardModel *shop = [self.shopCartArry objectAtIndex:i];
        [shop checkCardList:dic];
    }
}

-(NSString *)addKeyString:(NSString *)name value:(NSString *)value toStr:(NSString *)strJSON
{
    if (name == nil && name.length < 1) {
        return strJSON;
    }
    if (strJSON == nil) {
        strJSON = @"";
    }
    if (value == nil) {
        value = @"";
    }
    if (strJSON.length > 0) {
        strJSON = [NSString stringWithFormat:@"%@,\"%@\":\"%@\"", strJSON, name, value];
    }else{
        strJSON = [NSString stringWithFormat:@"{\"%@\":\"%@\"", name, value];
    }
    return strJSON;
    
}

-(NSString *)addKeyInt:(NSString *)name value:(int)value toStr:(NSString *)strJSON
{
    if (name == nil && name.length < 1) {
        return strJSON;
    }
    if (strJSON == nil) {
        strJSON = @"";
    }
    if (strJSON.length > 0) {
        strJSON = [NSString stringWithFormat:@"%@,\"%@\":\"%d\"", strJSON, name, value];
    }else{
        strJSON = [NSString stringWithFormat:@"{\"%@\":\"%d\"", name, value];
    }
    return strJSON;
}

-(NSString *)addKeyFloat:(NSString *)name value:(float)value toStr:(NSString *)strJSON
{
    if (name == nil && name.length < 1) {
        return strJSON;
    }
    if (strJSON == nil) {
        strJSON = @"";
    }
    if (strJSON.length > 0) {
        strJSON = [NSString stringWithFormat:@"%@,\"%@\":\"%.2f\"", strJSON, name, value];
    }else{
        strJSON = [NSString stringWithFormat:@"{\"%@\":\"%.2f\"", name, value];
    }
    return strJSON;
}

-(NSString *)addKeyStartArry:(NSString *)name value:(NSString *)value toStr:(NSString *)strJSON
{
    if (name == nil && name.length < 1) {
        return strJSON;
    }
    if (value == nil) {
        value = @"";
    }
    if (strJSON == nil) {
        strJSON = @"";
    }
    if (strJSON.length > 0) {
        strJSON = [NSString stringWithFormat:@"%@,\"%@\":[%@", strJSON, name, value];
    }else{
        strJSON = [NSString stringWithFormat:@"{\"%@\":[%@", name, value];
    }
    return strJSON;
}

-(NSString *)addKeyArry:(NSString *)value toStr:(NSString *)strJSON
{
    if (value == nil || value.length < 3) {
        return strJSON;
    }
    if (strJSON == nil || strJSON.length < 3) {
        return nil;
    }
    
    strJSON = [NSString stringWithFormat:@"%@,%@", strJSON, value];
    
    return strJSON;
}
-(NSString *)addKeyArryEnd:(NSString *)strJSON
{
    if (strJSON == nil || strJSON.length < 3) {
        return nil;
    }
    
    strJSON = [NSString stringWithFormat:@"%@]", strJSON];
    
    return strJSON;
}

-(NSString *)addEnd:(NSString *)strJSON
{
    if (strJSON == nil || strJSON.length < 3) {
        return nil;
    }
    strJSON = [NSString stringWithFormat:@"%@}", strJSON];
    return strJSON;
}

-(NSString *)JSONEnd:(NSString *)strJSON
{
    if (strJSON == nil || strJSON.length < 3) {
        return nil;
    }
    strJSON = [NSString stringWithFormat:@"[%@]", strJSON];
    return strJSON;
}

-(NSString *)getJSONString
{
    //NSString *value = [NSString stringWithFormat:@""];
    NSString *foodlist = @"";
    ShopCardModel *shopCard;
    for (int i = 0; i < [self.shopCartArry count]; i++) {
        shopCard = [self.shopCartArry objectAtIndex:i];
        if (i != 0) {
            foodlist = [NSString stringWithFormat:@"%@,%@", foodlist, [shopCard getJSONString]];
        }else
        {
            foodlist = [NSString stringWithFormat:@"%@",[shopCard getJSONString]];
        }
        
    }
    NSString *strJSON = @"";
    strJSON = [self addKeyString:@"Phone" value:self.phone toStr:strJSON];

    strJSON = [self addKeyString:@"Mobilephone" value:self.phone toStr:strJSON];
    strJSON = [self addKeyString:@"UserID" value:self.userID toStr:strJSON];
    strJSON = [self addKeyString:@"Receiver" value:self.custName toStr:strJSON];
    strJSON = [self addKeyString:@"CustomerName" value:self.userName toStr:strJSON];
    strJSON = [self addKeyString:@"Address" value:self.Address toStr:strJSON];
    //strJSON = [self addKeyInt:@"sendtype" value:1 toStr:strJSON];
    strJSON = [self addKeyString:@"PayPassword" value:self.payPassword toStr:strJSON];
    strJSON = [self addKeyString:@"GainTime" value:self.sendTime toStr:strJSON];
    strJSON = [self addKeyString:@"ulng" value:self.uLng toStr:strJSON];
    strJSON = [self addKeyString:@"ulat" value:self.uLat toStr:strJSON];
    strJSON = [self addKeyString:@"state" value:@"6" toStr:strJSON];
    strJSON = [self addKeyString:@"bid" value:self.areaID toStr:strJSON];
    //strJSON = [self addKeyInt:@"OrderType" value:0 toStr:strJSON];
    strJSON = [self addKeyInt:@"TogoId" value:((ShopCardModel *)[self.shopCartArry objectAtIndex:0]).shopID toStr:strJSON];
    strJSON = [self addKeyString:@"Remark" value:self.note toStr:strJSON];
    strJSON = [self addKeyInt:@"PayMode" value:self.payMode toStr:strJSON];
    strJSON = [self addKeyString:@"Ordersource" value:@"3" toStr:strJSON];
    if (buyType == 1) {
        strJSON = [self addKeyString:@"Oorderid" value:self.people toStr:strJSON];
    }
    
    strJSON = [self addKeyStartArry:@"ShopList" value:foodlist toStr:strJSON];
    strJSON = [self addKeyArryEnd:strJSON];
    strJSON = [self addEnd:strJSON];
    strJSON = [self JSONEnd:strJSON];
    /*NSString *value = [NSString stringWithFormat:@"[{\"ShopCardIDs\": \"\",\"Phone\": \"%@\",\"UserID\": \"%@\",\"UserName\": \"%@\",\"sendfree\": \"0.0\",\"sendtype\": \"1\",\"Oorderid\": \"0\",\"PayPassword\": \"\",\"tempCode\": \"\",\"SentTime\": \"%@\",\"OrderType\": \"0\",\"Address\": \"%@\",\"TogoId\": \"%d\",\"payType\": \"%d\",\"Remark\": \"%@\",\"bid\": \"\",\"PostCode\": \"\",\"DeliveType\": \"%d\",\"paymode\": \"%d\",\"Tel\": \"%@\",\"ShopCardList\": [],\"ShopList\": [%@]}]", self.phone, self.userID,self.custName,self.sendTime, self.Address,shopCard.shopID,self.payType,self.note,self.senType,self.payType,self.phone, foodlist];*/
    return strJSON;
}
//获取商家id json
-(NSString *)getTogoIDJSONString
{
    //NSString *value = [NSString stringWithFormat:@""];
    NSString *foodlist = @"";
    ShopCardModel *shopCard;
    for (int i = 0; i < [self.shopCartArry count]; i++) {
        shopCard = [self.shopCartArry objectAtIndex:i];
        if (i != 0) {
            foodlist = [NSString stringWithFormat:@"%@,{\"TogoId\":\"%d\"}", foodlist, shopCard.shopID];
        }else
        {
            foodlist = [NSString stringWithFormat:@"{\"TogoId\":\"%d\"}",shopCard.shopID];
        }
        
    }
    NSString *strJSON = @"";
    strJSON = [self addKeyString:@"UserID" value:self.userID toStr:strJSON];
    
    strJSON = [self addKeyStartArry:@"Shoplist" value:foodlist toStr:strJSON];
    strJSON = [self addKeyArryEnd:strJSON];
    strJSON = [self addEnd:strJSON];
    strJSON = [self JSONEnd:strJSON];
    
    return strJSON;
}
-(NSString *)getGiftJSONString
{
    NSString *strJSON = @"";
    strJSON = [self addKeyString:@"Phone" value:self.phone toStr:strJSON];
    strJSON = [self addKeyString:@"CustId" value:self.userID toStr:strJSON];
    strJSON = [self addKeyString:@"Person" value:self.custName toStr:strJSON];
    strJSON = [self addKeyString:@"UserName" value:self.userName toStr:strJSON];
    strJSON = [self addKeyString:@"Address" value:@"" toStr:strJSON];
    strJSON = [self addKeyString:@"Cdate" value:self.addTime toStr:strJSON];
    strJSON = [self addKeyString:@"Date" value:@"" toStr:strJSON];
    strJSON = [self addKeyString:@"DetailId" value:@"0" toStr:strJSON];
    strJSON = [self addKeyInt:@"State" value:0 toStr:strJSON];
    strJSON = [self addKeyString:@"GiftsId" value:self.activityID toStr:strJSON];
    strJSON = [self addKeyString:@"Remark" value:self.note toStr:strJSON];
    strJSON = [self addKeyInt:@"PayIntegral" value:self.cAllPrice toStr:strJSON];
    strJSON = [self addKeyString:@"GiftName" value:self.activityName toStr:strJSON];
    strJSON = [self addEnd:strJSON];
    strJSON = [self JSONEnd:strJSON];
    
    return strJSON;
}
-(void)Clean
{
    [self.shopCartArry removeAllObjects];
    self.senType = 1;//配送方式 1送货上门;2上门自提;3到店消费
    self.payType = 1;//支付方法:0线上支付,1线下支付
    self.payMode = 1;//支付方式：1,支付宝支付;2,礼品卡支付;3,货到付款;4,到店自提;5,到店消费;
    
    self.foodCount = 0;//菜品总数
    self.foodAttrLine = 0;//菜品规格总数（不包含规格里面的个数）
    
    self.sendMoney = 0.0;//配送费
    self.packageFee = 0.0;//打包费
    self.allPrice = 0.0;//总价
    self.togoPrice = 0.0;//不包含水吧饮品的价格
    
    self.cFoodCount = 0;//购物车选中菜品总数
    self.cFoodAttrLine = 0;//购物车选中菜品规格总数（不包含规格里面的个数）
    
    self.cSendMoney = 0.0;//购物车选中配送费
    self.cPackageFee = 0.0;//购物车选中打包费
    self.cAllPrice = 0.0;//购物车选中总价
    self.cTogoPrice = 0.0;//购物车选中不包含水吧饮品的价格
}
@end
