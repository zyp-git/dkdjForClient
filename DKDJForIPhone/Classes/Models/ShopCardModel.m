//
//  ShopCardModel.m
//  RenRenzx
//
//  Created by zhengjianfeng on 13-3-4.
//
//

#import "ShopCardModel.h"
#import "FoodModel.h"
#import "CouponModel.h"

@implementation ShopCardModel

@synthesize cardnum;
@synthesize point;
@synthesize ckey;
@synthesize cmoney;
@synthesize CID;
@synthesize reveint;
@synthesize timelimity;
@synthesize moneylimity;
@synthesize moneyline;
@synthesize starttime;
@synthesize endtime;
@synthesize Lat;
@synthesize Lng;
@synthesize checked = m_checked;
@synthesize foodArry;//菜品
@synthesize shopID;//商家编号
@synthesize shopName;//商家名称
@synthesize allPrice;//总价
@synthesize foodCount;//菜品总数
@synthesize foodAttrLine;//菜品规格总数（不包含规格里面的个数）

@synthesize senType;//配送方式 1送货上门;2上门自提;3到店消费
@synthesize payType;//支付方法:0线上支付,1线下支付
@synthesize payMode;//支付方式：1,支付宝支付;2,礼品卡支付;3,货到付款;4,到店自提;5,到店消费;

@synthesize sendMoney;//配送费
@synthesize sendFee;//配送费 （网站固定的）
@synthesize packageFee;//打包费
@synthesize startMoney;//起送金额

@synthesize fullFreeMoney;// 满多少免配送费 0.0表示不眠

// 下面计算配送费相关
@synthesize startSendFee;// 起步价
@synthesize SendFeeOfKM;// 每公里加价
@synthesize minKM;// 超过多少公里开始加价
@synthesize maxKM;// 超过多少公里采用第二价格
@synthesize SendFeeAffKM;// 超过多少公里第二价格
@synthesize distance;//距离最后地址确定计算

@synthesize cAllPrice;//购物车选中总价
@synthesize cTogoPrice;//购物车选中不包含水吧饮品的价格
@synthesize cFoodCount;//购物车选中菜品总数
@synthesize cFoodAttrLine;//购物车选中菜品规格总数（不包含规格里面的个数)
@synthesize cPackageFee;//购物车选中打包费
@synthesize activity;//优惠券列表
@synthesize userActivity;//使用优惠券

- (void)updateWithJSonDictionary:(NSDictionary*)dic
{
    
    self.cardnum = [dic objectForKey:@"cardnum"];
    self.ckey = [dic objectForKey:@"ckey"];
    self.point = [dic objectForKey:@"point"];
    self.cmoney = [dic objectForKey:@"cmoney"];
    self.CID = [dic objectForKey:@"CID"];
    
    self.reveint = [dic objectForKey:@"ReveInt"];
    self.timelimity = [dic objectForKey:@"timelimity"];
    self.moneylimity = [dic objectForKey:@"moneylimity"];
    self.moneyline = [dic objectForKey:@"moneyline"];
    self.starttime = [dic objectForKey:@"starttime"];
    self.endtime = [dic objectForKey:@"endtime"];
    
    self.checked = NO;
    
    NSLog(@"ckey: %@", ckey);
    
    
}



-(void)Clean{
    [self.foodArry removeAllObjects];
    [self.activity removeAllObjects];
    [self.userActivity removeAllObjects];
    self.foodAttrLine = 0;
    self.allPrice = 0.0f;
    self.foodCount = 0;
}

-(ShopCardModel*)init
{
    self = [super init];
    self.foodArry = [[NSMutableArray alloc] init];
    self.activity = [[NSMutableArray alloc] init];
    self.userActivity = [[NSMutableArray alloc] init];
    
    return self;
}

-(ShopCardModel*)initWithJsonDictionary:(NSDictionary*)dic
{
	self = [super init];
    
    [self updateWithJSonDictionary:dic];
	
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

-(BOOL) isFreeSend
{//是否面配送费
    if ((self.fullFreeMoney > 0.0f && self.cTogoPrice >= self.fullFreeMoney) || self.cTogoPrice == 0.0f) {//达到了面配送费金额剪掉配送费
        return YES;
    }
    return NO;
}

-(void) CalculationSendFee{//计算配送费
    if ([self isFreeSend]) {
        self.sendFee = 0.0f;
    }else{
        if(self.startSendFee == 0.0f)//未设置配送费计算方式，那么默认就用网站固定的配送费
        {
            self.sendFee = self.sendMoney;
            return;
            
        }
        self.sendFee = self.startSendFee;
        if (self.maxKM > self.minKM && self.distance > self.maxKM) {//maxKM必须大于minKM 否则没意义
            //self.sendFee += ((self.maxKM - self.minKM) * self.SendFeeOfKM + (self.distance - self.maxKM) * self.SendFeeAffKM);
            self.sendFee = [self add:self.sendFee value:[self add:[self multiply:[self subtract:self.maxKM value:self.minKM] value:self.SendFeeOfKM ] value:[self multiply:[self subtract:self.distance value:self.maxKM] value:self.SendFeeAffKM ]]];
        }else if(self.minKM > 0.0 && self.distance > self.minKM){//无最大公里限制
            //self.sendFee += (self.distance - self.minKM) * self.SendFeeOfKM;
            self.sendFee = [self add:self.sendFee value:[self multiply:[self subtract:self.distance value:self.minKM] value:self.self.SendFeeOfKM]];
        }else{//无起步价，就是每公里多少钱
            //self.sendFee += self.distance * self.SendFeeOfKM;
            self.sendFee = [self add:self.sendFee value:[self multiply:self.distance value:self.self.SendFeeOfKM]];
        }
    }
    
}

-(FoodModel*) getFoodInOrderModel:(int *)index {
    int count = 0;
    for (int i = 0; i < [self.foodArry count]; i++) {
        count += [[(FoodModel *)[self.foodArry objectAtIndex:i] attr] count];
        if ((*index) < count) {
            count -= [[(FoodModel *)[self.foodArry objectAtIndex:i] attr] count];
            (*index) -= count;
            return (FoodModel *)[self.foodArry objectAtIndex:i];
        }
    }
    return nil;
}

-(int)setFoodWithAttrLine:(int)index Count:(int)Count{
    int count = 0;
    for (int i = 0; i < [self.foodArry count]; i++) {
        count += [[(FoodModel *)[self.foodArry objectAtIndex:i] attr] count];
        if (index < count) {
            count -= [[(FoodModel *)[self.foodArry objectAtIndex:i] attr] count];
            index -= count;
            FoodModel * model = (FoodModel *)[self.foodArry objectAtIndex:i];
            FoodAttrModel *attr = (FoodAttrModel *)[model.attr objectAtIndex:index];
            Count -= attr.count;
            
            attr.count += Count;
            model.count += Count;
            //model.price += (attr.price * Count);
            model.price = [self add:model.price value:[self multiply:attr.price value:Count]];
            self.foodCount += Count;
            //self.allPrice += (attr.price * Count);
            self.allPrice = [self add:self.allPrice value:[self multiply:attr.price value:Count]];
            //self.packageFee += (attr.pactFee * Count);
            self.packageFee = [self add:self.packageFee value:[self multiply:attr.pactFee value:Count]];
            if (attr.isSelect) {
                //cAllPrice += (attr.price * Count);
                cAllPrice = [self add:cAllPrice value:[self multiply:attr.price value:Count]];
                //cTogoPrice += (attr.price * Count);
                cTogoPrice = [self add:cTogoPrice value:[self multiply:attr.price value:Count]];
                //cPackageFee += (attr.pactFee * Count);
                cPackageFee = [self add:cPackageFee value:[self multiply:attr.pactFee value:Count]];
                cFoodCount += Count;
            }
            count = attr.count;
            if (attr.count == 0) {
                [model.attr removeObjectAtIndex:index];
                self.foodAttrLine--;
            }
            if (model.count == 0) {
                [self.foodArry removeObjectAtIndex:i];
            }
            return Count;
        }
    }
    return 0;
}

-(int)addFoodWithAttrLine:(int)index{
    int count = 0;
    for (int i = 0; i < [self.foodArry count]; i++) {
        count += [[(FoodModel *)[self.foodArry objectAtIndex:i] attr] count];
        if (index < count) {
            count -= [[(FoodModel *)[self.foodArry objectAtIndex:i] attr] count];
            index -= count;
            FoodModel * model = (FoodModel *)[self.foodArry objectAtIndex:i];
            FoodAttrModel *attr = (FoodAttrModel *)[model.attr objectAtIndex:index];
            attr.count++;
            model.count++;
            //model.price += attr.price;
            model.price = [self add:model.price value:attr.price];
            self.foodCount++;
            //self.allPrice += attr.price;
            self.allPrice = [self add:self.allPrice value:attr.price];
            //self.packageFee += attr.pactFee;
            self.packageFee = [self add:self.packageFee value:attr.pactFee];
            if (attr.isSelect) {
                //cAllPrice += attr.price;
                cAllPrice = [self add:cAllPrice value:attr.price];
                //cTogoPrice += attr.price;
                cTogoPrice = [self add:cTogoPrice value:attr.price];
                //cPackageFee += attr.pactFee;
                cPackageFee = [self add:cPackageFee value:attr.pactFee];
                cFoodCount++;
            }
            return attr.count;
        }
    }
    return 0;
}

-(int)delFoodWithAttrLine:(int)index{
    int count = 0;
    for (int i = 0; i < [self.foodArry count]; i++) {
        count += [[(FoodModel *)[self.foodArry objectAtIndex:i] attr] count];
        if (index < count) {
            count -= [[(FoodModel *)[self.foodArry objectAtIndex:i] attr] count];
            index -= count;
            FoodModel * model = (FoodModel *)[self.foodArry objectAtIndex:i];
            FoodAttrModel *attr = (FoodAttrModel *)[model.attr objectAtIndex:index];
            attr.count--;
            model.count--;
            //model.price -= attr.price;
            model.price = [self subtract:model.price value:attr.price];
            self.foodCount--;
            //self.allPrice -= attr.price;
            self.allPrice = [self subtract:self.allPrice value:attr.price];
            //self.packageFee -= attr.pactFee;
            self.packageFee = [self subtract:self.packageFee value:attr.pactFee];
            if (attr.isSelect) {
                //cAllPrice -= attr.price;
                //cTogoPrice -= attr.price;
                //cPackageFee -= attr.pactFee;
                cAllPrice = [self subtract:cAllPrice value:attr.price];
                cTogoPrice = [self subtract:cTogoPrice value:attr.price];
                cPackageFee = [self subtract:cPackageFee value:attr.pactFee];
                cFoodCount--;
            }
            int length = attr.count;
            
            if (attr.count == 0) {
                [model.attr removeObjectAtIndex:index];
                self.foodAttrLine--;
            }
            if (model.count == 0) {
                [self.foodArry removeObjectAtIndex:i];
            }
            return length;
        }
    }
    return 0;
}

-(int)removeFoodWithAttrLine:(int)index{
    int count = 0;
    for (int i = 0; i < [self.foodArry count]; i++) {
        count += [[(FoodModel *)[self.foodArry objectAtIndex:i] attr] count];
        if (index < count) {
            count -= [[(FoodModel *)[self.foodArry objectAtIndex:i] attr] count];
            index -= count;
            FoodModel * model = (FoodModel *)[self.foodArry objectAtIndex:i];
            FoodAttrModel *attr = (FoodAttrModel *)[model.attr objectAtIndex:index];
            
            model.count -= attr.count;
            //model.price -= (attr.price * attr.count);
            model.price = [self subtract:model.price value:[self multiply:attr.price value:attr.count]];
            self.foodCount -= attr.count;
            //self.allPrice -= (attr.price * attr.count);
            self.allPrice = [self subtract:self.allPrice value:[self multiply:attr.price value:attr.count]];
            //self.packageFee -= (attr.pactFee * attr.count);
            self.packageFee = [self subtract:self.packageFee value:[self multiply:attr.pactFee value:attr.count]];
            if (attr.isSelect) {
                //cAllPrice -= (attr.price * attr.count);
                cAllPrice = [self subtract:cAllPrice value:[self multiply:attr.price value:attr.count]];
                //cTogoPrice -= (attr.price * attr.count);
                cTogoPrice = [self subtract:cTogoPrice value:[self multiply:attr.price value:attr.count]];
                //cPackageFee -= (attr.pactFee * attr.count);
                cPackageFee = [self subtract:cPackageFee value:[self multiply:attr.pactFee value:attr.count]];
                cFoodCount -= count;
            }
            [model.attr removeObjectAtIndex:index];
            self.foodAttrLine--;
            
            if (model.count == 0) {
                [self.foodArry removeObjectAtIndex:i];
            }
            return 0;
        }
    }
    return 0;
}

// 返回相应食品某一属性是否已经存在，并返回相应的个数
-(int) getFoodCountInAttr:(int)foodId attId:(int)attrId {
    int length = (int)[self.foodArry count];
    if (length > 0) {
        FoodModel *model;
        for (int i = 0; i < length; i++) {
            model = (FoodModel *)[self.foodArry objectAtIndex:i];
            if (foodId == model.foodid) {
                length = (int)[model.attr count];
                if (length > 0) {
                    FoodAttrModel *attr;
                    for (int j = 0; j < length; j++) {
                        attr = [model.attr objectAtIndex:j];
                        if (attrId == attr.cid) {
                            return attr.count;
                        }
                    }
                }
                return 0;
            }
        }
    }
    return 0;
}

-(float) getFoodPrice:(int)foodId {
    int length = (int)[self.foodArry count];
    if (length > 0) {
        FoodModel *model;
        for (int i = 0; i < length; i++) {
            model = [self.foodArry objectAtIndex:i];
            if (foodId == model.foodid) {
                
                return model.price;
            }
        }
    }
    return 0.00f;
}



//
-(int) addFoodAttrFoodId:(int)foodid index:(int)attrIndex {
    int length = (int)[self.foodArry count];
    
    FoodModel *model;
    if (length > 0) {
        for (int i = 0; i < length; i++) {
            model = [self.foodArry objectAtIndex:i];
            if (foodid == model.foodid) {
                length = (int)[model.attr count];
                if (attrIndex < length) {
                    FoodAttrModel *attr;
                    attr = [model.attr objectAtIndex:attrIndex];
                    attr.count++;
                    model.count++;
                    //model.price += attr.price;
                    model.price = [self add:model.price value:attr.price];
                    foodCount++;
                    //allPrice += attr.price;
                    allPrice = [self add:allPrice value:attr.price];
                    packageFee += attr.pactFee;
                    if (attr.isSelect) {
                        //cAllPrice += attr.price;
                        cAllPrice = [self add:cAllPrice value:attr.price];
                        //cTogoPrice += attr.price;
                        cTogoPrice = [self add:cTogoPrice value:attr.price];
                        //cPackageFee += attr.pactFee;
                        cPackageFee = [self add:cPackageFee value:attr.pactFee];
                        cFoodCount++;
                    }
                    return attr.count;
                    
                }
                return 0;
                
            }
        }
    }
    
    return 0;
}

-(int) setFoodAttr:(FoodModel *)food index:(int)attrIndex Count:(int)count{
    int length =(int) [self.foodArry count];
    //self.foodCount++;
    FoodAttrModel *attr1 = (FoodAttrModel *)[food.attr objectAtIndex:attrIndex];
    
    FoodModel *model;
    FoodAttrModel *attr;
    if (length > 0) {
        
        for (int i = 0; i < length; i++) {
            model = [self.foodArry objectAtIndex:i];
            if (food.foodid == model.foodid) {
                length =(int) [model.attr count];
                if (length > 0) {
                    
                    for (int j = 0; j < length; j++) {
                        attr = (FoodAttrModel *)[model.attr objectAtIndex:j];
                        if (attr1.cid == attr.cid) {//属性存在
                            
                            count -= attr.count;
                            attr.count += count;
                            model.count += count;
                            //model.price += (attr.price * count);
                            //self.allPrice += (attr.price * count);
                            self.foodCount += count;
                            //self.packageFee += (attr.pactFee * count);
                            model.price = [self add:model.price value:[self multiply:attr.price value:count]];
                            
                            self.allPrice = [self add:self.allPrice value:[self multiply:attr.price value:count]];
                            
                            self.packageFee = [self add:self.packageFee value:[self multiply:attr.pactFee value:count]];
                            if (attr.isSelect) {
                                //cAllPrice += (attr.price * count);
                                //cTogoPrice += (attr.price * count);
                                //cPackageFee += (attr.pactFee * count);
                                cAllPrice = [self add:cAllPrice value:[self multiply:attr.price value:count]];
                                
                                cTogoPrice = [self add:cTogoPrice value:[self multiply:attr.price value:count]];
                                
                                cPackageFee = [self add:cPackageFee value:[self multiply:attr.pactFee value:count]];
                                cFoodCount+= count;
                            }
                            count = attr.count;
                            if (attr.count == 0) {
                                [model.attr removeObjectAtIndex:j];
                                self.foodAttrLine--;
                            }
                            if (model.count == 0) {
                                [self.foodArry removeObjectAtIndex:i];
                            }
                            return count;
                        }
                    }
                }
                if (count > 0) {
                    self.foodAttrLine++;
                    attr = [[FoodAttrModel alloc] init];//[[FoodAttrModel alloc] copy:attr1];
                    attr.cid = attr1.cid;
                    attr.pactFee = attr1.pactFee;
                    attr.price = attr1.price;
                    attr.name = attr1.name;
                    attr.count = count;
                    
                    model.count += count;
                    //model.price += (attr.price * count);
                    //self.allPrice += (attr.price * count);
                    //self.packageFee += (attr.pactFee * count);
                    model.price = [self add:model.price value:[self multiply:attr.price value:count]];
                    
                    self.allPrice = [self add:self.allPrice value:[self multiply:attr.price value:count]];
                    
                    self.packageFee = [self add:self.packageFee value:[self multiply:attr.pactFee value:count]];
                    
                    [model.attr addObject:attr];
                    self.foodCount += count;
                }
                
                //model.setImageLocalPath(food.getImageLocalPath());
                //model.listSpec.add(food.listSpec.get(attrIndex));
                
                return count;
                
            }
        }
    }
    if (count > 0) {
        model = [[FoodModel alloc] init];
        model.foodid = food.foodid;
        model.foodname = food.foodname;
        model.ico = food.ico;
        model.picPath = food.picPath;
        model.packagefree = food.packagefree;
        model.Disc = food.Disc;
        model.notice = food.notice;
        model.tid = food.tid;
        model.image = food.image;
        
        attr = [[FoodAttrModel alloc] init];//[[FoodAttrModel alloc] copy:attr1];
        attr.cid = attr1.cid;
        attr.pactFee = attr1.pactFee;
        attr.price = attr1.price;
        attr.name = attr1.name;
        attr.count = count;
        attr.isSelect = attr1.isSelect;
        
        model.count = count;
        //model.price = attr.price * count;
        model.price = [self multiply:attr.price value:count];
        [model.attr addObject:attr];
        [self.foodArry addObject:model];
        self.foodAttrLine++;
        self.foodCount += count;
        //self.allPrice += (attr1.price * count);
        //self.packageFee += (attr1.pactFee * count);
        self.allPrice = [self add:self.allPrice value:[self multiply:attr.price value:count]];
        
        self.packageFee = [self add:self.packageFee value:[self multiply:attr.pactFee value:count]];
        
    }
    
    return count;
}
//添加代金券
-(void) addFoodAttr:(FoodModel *)food index:(int)attrIndex cardAry:(NSMutableArray *)cardAry cardIndex:(int)index{
    int length = (int)[self.foodArry count];
    FoodAttrModel *attr1 = (FoodAttrModel *)[food.attr objectAtIndex:attrIndex];
    FoodModel *model;
    FoodAttrModel *attr;
    if (length > 0) {
        
        for (int i = 0; i < length; i++) {
            model = [self.foodArry objectAtIndex:i];
            if (food.foodid == model.foodid) {
                length = (int)[model.attr count];
                if (length > 0) {
                    
                    for (int j = 0; j < length; j++) {
                        attr = (FoodAttrModel *)[model.attr objectAtIndex:j];
                        if (attr1.cid == attr.cid) {
                            if (attr1.card != nil) {
                                [cardAry insertObject:attr1.card atIndex:attr1.cardIndex];
                                attr1.card = nil;
                            }
                            attr1.card = [cardAry objectAtIndex:index];
                            attr1.cardIndex = index;
                            [cardAry removeObjectAtIndex:index];
                        }
                    }
                }
            }
        }
    }
}

//去除代金券
-(void) removeFoodAttr:(FoodModel *)food index:(int)attrIndex cardAry:(NSMutableArray *)cardAry{
    int length = (int)[self.foodArry count];
    FoodAttrModel *attr1 = (FoodAttrModel *)[food.attr objectAtIndex:attrIndex];
    FoodModel *model;
    FoodAttrModel *attr;
    if (length > 0) {
        
        for (int i = 0; i < length; i++) {
            model = [self.foodArry objectAtIndex:i];
            if (food.foodid == model.foodid) {
                length = (int)[model.attr count];
                if (length > 0) {
                    
                    for (int j = 0; j < length; j++) {
                        attr = (FoodAttrModel *)[model.attr objectAtIndex:j];
                        if (attr1.cid == attr.cid) {
                            if (attr1.card != nil) {
                                [cardAry insertObject:attr1.card atIndex:attr1.cardIndex];
                                attr1.card = nil;
                            }
                            //attr1.card = [cardAry objectAtIndex:index];
                            //attr1.cardIndex = index;
                            //[cardAry removeObjectAtIndex:index];
                        }
                    }
                }
            }
        }
    }
}

-(int) addFoodAttr:(FoodModel *)food index:(int)attrIndex {
    int length = (int)[self.foodArry count];
    self.foodCount++;
    FoodAttrModel *attr1 = (FoodAttrModel *)[food.attr objectAtIndex:attrIndex];
    //self.allPrice += attr1.price;
    self.allPrice = [self add:self.allPrice value:attr1.price];
    //self.packageFee += attr1.pactFee;
    self.packageFee = [self add:self.packageFee value:attr1.pactFee];
    
    FoodModel *model;
    FoodAttrModel *attr;
    if (length > 0) {
        
        for (int i = 0; i < length; i++) {
            model = [self.foodArry objectAtIndex:i];
            if (food.foodid == model.foodid) {
                length = (int)[model.attr count];
                if (length > 0) {
                    
                    for (int j = 0; j < length; j++) {
                        attr = (FoodAttrModel *)[model.attr objectAtIndex:j];
                        if (attr1.cid == attr.cid) {
                            attr.count++;
                            model.count++;
                            //model.price += attr.price;
                            model.price = [self add:model.price value:attr.price];
                            if (attr.isSelect) {
                                //cAllPrice += attr.price;
                                //cTogoPrice += attr.price;
                                //cPackageFee += attr.pactFee;
                                cAllPrice = [self add:cAllPrice value:attr.price];
                                cTogoPrice = [self add:cTogoPrice value:attr.price];
                                cPackageFee = [self add:cPackageFee value:attr.pactFee];
                                cFoodCount++;
                            }
                            return attr.count;
                        }
                    }
                }
                self.foodAttrLine++;
                attr = [[FoodAttrModel alloc] init];//[[FoodAttrModel alloc] copy:attr1];
                attr.cid = attr1.cid;
                attr.pactFee = attr1.pactFee;
                attr.price = attr1.price;
                attr.name = attr1.name;
                attr.count = 1;
                
                model.count++;
                //model.price += attr.price;
                model.price = [self add:model.price value:attr.price];
                [model.attr addObject:attr];
                //model.setImageLocalPath(food.getImageLocalPath());
                //model.listSpec.add(food.listSpec.get(attrIndex));
                
                return 1;
                
            }
        }
    }
    model = [[FoodModel alloc] init];
    
    model.foodid = food.foodid;
    model.foodname = food.foodname;
    model.ico = food.ico;
    model.picPath = food.picPath;
    model.packagefree = food.packagefree;
    model.Disc = food.Disc;
    model.notice = food.notice;
    model.tid = food.tid;
    model.tName = food.tName;
    model.image = food.image;
    
    attr = [[FoodAttrModel alloc] init];//[[FoodAttrModel alloc] copy:attr1];
    attr.cid = attr1.cid;
    attr.pactFee = attr1.pactFee;
    attr.price = attr1.price;
    attr.name = attr1.name;
    attr.count = 1;
    
    model.count = 1;
    model.price = attr.price;
    [model.attr addObject:attr];
    [self.foodArry addObject:model];
    self.foodAttrLine++;
    return 1;
}



-(void) removeFood:(int)foodid index:(int)attrIndex {
    int length = (int)[self.foodArry count];
    FoodModel *model;
    FoodAttrModel *attr;
    if (length > 0) {
        for (int i = 0; i < length; i++) {
            model = [self.foodArry objectAtIndex:i];
            if (foodid == model.foodid) {
                length = (int)[model.attr count];
                if (attrIndex < length) {
                    self.foodAttrLine--;
                    model.count--;
                    attr = [model.attr objectAtIndex:attrIndex];
                    //float price = attr.count * attr.price;
                    float price = [self multiply:attr.count value:attr.price];
                    //float pactFee = attr.count * attr.pactFee;
                    float pactFee = [self multiply:attr.count value:attr.pactFee];
                    //model.price -= price;
                    model.price = [self subtract:model.price value:price];
                    //self.allPrice-= price;
                    self.allPrice = [self subtract:self.allPrice value:price];
                    self.foodCount -= attr.count;
                    //self.packageFee -= pactFee;
                    self.packageFee = [self subtract:self.packageFee value:pactFee];
                    if (attr.isSelect) {
                        //cAllPrice -= price;
                        //cTogoPrice -= price;
                        //cPackageFee -= pactFee;
                        cAllPrice = [self subtract:cAllPrice value:price];
                        cTogoPrice = [self subtract:cTogoPrice value:price];
                        cPackageFee = [self subtract:cPackageFee value:pactFee];
                        cFoodCount -= attr.count;
                    }
                    [model.attr removeObjectAtIndex:attrIndex];
                    if (model.count == 0) {
                        [self.foodArry removeObjectAtIndex:i];
                    }
                    return;
                    
                }
                
            }
        }
    }
}

-(int) delFoodAttrFoodId:(int)foodid index:(int)attrIndex {
    int length = (int)[self.foodArry count];
    FoodModel *model;
    if (length > 0) {
        for (int i = 0; i < length; i++) {
            model = [self.foodArry objectAtIndex:i];
            if (foodid == model.foodid) {
                length = (int)[model.attr count];
                FoodAttrModel *attr;
                if (attrIndex < length) {
                    attr = [model.attr objectAtIndex:attrIndex];
                    attr.count--;
                    
                    //model.price -= attr.price;
                    model.price = [self subtract:model.price value:attr.price];
                    self.foodCount--;
                    //allPrice -= attr.price;
                    self.allPrice = [self subtract:self.allPrice value:attr.price];
                    //packageFee -= attr.pactFee;
                    self.packageFee = [self subtract:self.packageFee value:attr.pactFee];
                    if (attr.isSelect) {
                        //cAllPrice -= attr.price;
                        //cTogoPrice -= attr.price;
                        //cPackageFee -= attr.pactFee;
                        cAllPrice = [self subtract:cAllPrice value:attr.price];
                        cTogoPrice = [self subtract:cTogoPrice value:attr.price];
                        cPackageFee = [self subtract:cPackageFee value:attr.pactFee];
                        cFoodCount--;
                    }
                    length = attr.count;
                    if (attr.count == 0) {
                        [model.attr removeObjectAtIndex:attrIndex];
                        self.foodAttrLine--;
                        length = 0;
                    }
                    model.count--;
                    
                    
                    
                    if (model.count == 0) {
                        [self.foodArry removeObjectAtIndex:i];
                        
                        return 0;
                    }
                    return length;
                    
                }
                return 0;
            }
        }
    }
    return 0;
}



-(int) delFoodAttr:(FoodModel*)food index:(int)attrIndex {
    int length = (int)[self.foodArry count];
    FoodModel *model;
    FoodAttrModel *attr1 = [food.attr objectAtIndex:attrIndex];
    if (length > 0) {
        for (int i = 0; i < length; i++) {
            model = [self.foodArry objectAtIndex:i];
            if (food.foodid == model.foodid) {
                length = (int)[model.attr count];
                if (length > 0) {
                    FoodAttrModel *attr;
                    for (int j = 0; j < length; j++) {
                        attr = [model.attr objectAtIndex:j];
                        if (attr.cid == attr1.cid) {
                            attr.count--;
                            
                            //model.price -= attr.price;
                            model.price = [self subtract:model.price value:attr.price];
                            self.foodCount--;
                            //self.allPrice -= attr.price;
                            self.allPrice = [self subtract:self.allPrice value:attr.price];
                            //packageFee -= attr.pactFee;
                            self.packageFee = [self subtract:self.packageFee value:attr.pactFee];
                            if (attr.isSelect) {
                                //cAllPrice -= attr.price;
                                //cTogoPrice -= attr.price;
                                //cPackageFee -= attr.pactFee;
                                cAllPrice = [self subtract:cAllPrice value:attr.price];
                                cTogoPrice = [self subtract:cTogoPrice value:attr.price];
                                cPackageFee = [self subtract:cPackageFee value:attr.pactFee];
                                cFoodCount--;
                            }
                            
                            length = attr.count;
                            
                            if (attr.count == 0) {
                                [model.attr removeObjectAtIndex:j];
                                self.foodAttrLine--;
                            }
                            model.count--;
                            
                            if (model.count == 0) {
                                [self.foodArry removeObjectAtIndex:i];
                                
                                return 0;
                            }
                            return length;
                        }
                    }
                }
                return 0;
            }
        }
    }
    return 0;
}

-(void)checkAll:(BOOL)check
{
    int length = (int)[self.foodArry count];
    int attrLength;
    FoodModel *model;
    FoodAttrModel *foodAttr;
    for (int i = 0; i < length; i++) {
        model = [self.foodArry objectAtIndex:i];
        attrLength = (int)[[model attr] count];
        for (int j = 0; j < attrLength; j++) {
            foodAttr = [model.attr objectAtIndex:j];
            //foodAttr.isSelect = check;
            if (foodAttr.isSelect) {
                //cAllPrice -= (foodAttr.price * foodAttr.count);
                cAllPrice = [self subtract:cAllPrice value:[self multiply:foodAttr.price value:foodAttr.count]];
                //cTogoPrice -= (foodAttr.price * foodAttr.count);
                cTogoPrice = [self subtract:cTogoPrice value:[self multiply:foodAttr.price value:foodAttr.count]];
                //cPackageFee -= (foodAttr.pactFee * foodAttr.count);
                cPackageFee = [self subtract:cPackageFee value:[self multiply:foodAttr.pactFee value:foodAttr.count]];
                cFoodCount -= foodAttr.count;
            }
            foodAttr.isSelect = check;
            if (foodAttr.isSelect) {
                //cAllPrice += (foodAttr.price * foodAttr.count);
                cAllPrice = [self add:cAllPrice value:[self multiply:foodAttr.price value:foodAttr.count]];
                //cTogoPrice += (foodAttr.price * foodAttr.count);
                cTogoPrice = [self add:cTogoPrice value:[self multiply:foodAttr.price value:foodAttr.count]];
                //cPackageFee += (foodAttr.pactFee * foodAttr.count);
                cPackageFee = [self add:cPackageFee value:[self multiply:foodAttr.pactFee value:foodAttr.count]];
                cFoodCount += foodAttr.count;
            }
        }
    }
}
-(void)checkFoodId:(int)foodID attrIndex:(int)attrIndex check:(BOOL)isCheck
{
    int length = (int)[self.foodArry count];
    FoodModel *model;
    for (int i = 0; i < length; i++) {
        model = [self.foodArry objectAtIndex:i];
        if (foodID == model.foodid && attrIndex < [model.attr count]) {
            FoodAttrModel *foodAttr = [model.attr objectAtIndex:attrIndex];
            if (foodAttr.isSelect) {
                //cAllPrice -= (foodAttr.price * foodAttr.count);
                cAllPrice = [self subtract:cAllPrice value:[self multiply:foodAttr.price value:foodAttr.count]];
                //cTogoPrice -= (foodAttr.price * foodAttr.count);
                cTogoPrice = [self subtract:cTogoPrice value:[self multiply:foodAttr.price value:foodAttr.count]];
                //cPackageFee -= (foodAttr.pactFee * foodAttr.count);
                cPackageFee = [self subtract:cPackageFee value:[self multiply:foodAttr.pactFee value:foodAttr.count]];
                cFoodCount -= foodAttr.count;
            }
            foodAttr.isSelect = isCheck;
            if (foodAttr.isSelect) {
                //cAllPrice += (foodAttr.price * foodAttr.count);
                cAllPrice = [self add:cAllPrice value:[self multiply:foodAttr.price value:foodAttr.count]];
                //cTogoPrice += (foodAttr.price * foodAttr.count);
                cTogoPrice = [self add:cTogoPrice value:[self multiply:foodAttr.price value:foodAttr.count]];
                //cPackageFee += (foodAttr.pactFee * foodAttr.count);
                cPackageFee = [self add:cPackageFee value:[self multiply:foodAttr.pactFee value:foodAttr.count]];
                cFoodCount += foodAttr.count;
            }
        }
    }
}

-(void)dealloc
{
    [self.cardnum release];
    [self.point release];
    [self.ckey release];
    [self.cmoney release];
    [self.CID release];
    [self.reveint release];
    [self.timelimity release];
    [self.moneylimity release];
    [self.moneyline release];
    [self.starttime release];
    [self.endtime release];
    [self.Lat release];
    [self.Lng release];
    [self.activity release];
    [self.foodArry release];
    [self.userActivity release];
    
   	[super dealloc];
}

//获取对应商家的代金券
-(void)checkCardList:(NSDictionary *)dic1
{
    if (self.activity == nil) {
        self.activity = [[NSMutableArray alloc] init];
    }
    NSArray *ary = [dic1 objectForKey:@"Voucher"];
    for (int i = 0; i < [ary count]; ++i) {
        NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        CouponModel *model = [[CouponModel alloc] initWithJsonDictionaryOnShopCart:dic];
        
        
        [self.activity addObject:model];
        [model release];
    }
}

-(NSString *)addKeyStringListItem:(NSString *)name value:(NSString *)value toStr:(NSString *)strJSON
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
        strJSON = [NSString stringWithFormat:@"%@,{\"%@\":\"%@\"}", strJSON, name, value];
    }else{
        strJSON = [NSString stringWithFormat:@"{\"%@\":\"%@\"}", name, value];
    }
    return strJSON;
    
}

-(NSString *)addKeyIntListItem:(NSString *)name value:(int)value toStr:(NSString *)strJSON
{
    if (name == nil && name.length < 1) {
        return strJSON;
    }
    if (strJSON == nil) {
        strJSON = @"";
    }
    if (strJSON.length > 0) {
        strJSON = [NSString stringWithFormat:@"%@,{\"%@\":\"%d\"}", strJSON, name, value];
    }else{
        strJSON = [NSString stringWithFormat:@"{\"%@\":\"%d\"}", name, value];
    }
    return strJSON;
}

-(NSString *)addKeyFloatListItem:(NSString *)name value:(float)value toStr:(NSString *)strJSON
{
    if (name == nil && name.length < 1) {
        return strJSON;
    }
    if (strJSON == nil) {
        strJSON = @"";
    }
    if (strJSON.length > 0) {
        strJSON = [NSString stringWithFormat:@"%@,{\"%@\":\"%.2f\"}", strJSON, name, value];
    }else{
        strJSON = [NSString stringWithFormat:@"{\"%@\":\"%.2f\"}", name, value];
    }
    return strJSON;
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
    NSString *strJSON = @"";
    BOOL isAddAry = NO;
    strJSON = [self addKeyString:@"Lng" value:self.Lng toStr:strJSON];
    strJSON = [self addKeyString:@"Lat" value:self.Lat toStr:strJSON];
    strJSON = [self addKeyInt:@"TogoId" value:self.shopID toStr:strJSON];
    
    NSString *cardList = nil;
    for (int i = 0; i < [self.foodArry count]; i++) {
        FoodModel *model = [self.foodArry objectAtIndex:i];
        for (int j = 0; j < [model.attr count]; j++) {
            FoodAttrModel *attr = [model.attr objectAtIndex:j];
            if (attr.isSelect) {
                NSString *value = @"";
                value = [self addKeyString:@"PName" value:model.foodname toStr:value];
                value = [self addKeyString:@"ReveInt1" value:@"0" toStr:value];//商品活动所属编号
                value = [self addKeyString:@"ReveInt2" value:@"0" toStr:value];//商品活动类型：0普通 1.团购 2.秒杀 3.限量 4.买撘赠
                value = [self addKeyString:@"Material" value:@"0" toStr:value];
                value = [self addKeyInt:@"sid" value:attr.cid toStr:value];//规格
                value = [self addKeyString:@"sname" value:attr.name toStr:value];//规格名称
                value = [self addKeyFloat:@"addprice" value:0.0 toStr:value];//
                value = [self addKeyInt:@"PId" value:model.foodid toStr:value];
                value = [self addKeyInt:@"PNum" value:attr.count toStr:value];
                value = [self addKeyInt:@"TogoId" value:self.shopID toStr:value];
                value = [self addKeyFloat:@"owername" value:attr.pactFee toStr:value];
                value = [self addKeyFloat:@"PPrice" value:attr.price toStr:value];
                value = [self addKeyFloat:@"Currentprice" value:attr.price toStr:value];
                value = [self addEnd:value];
                if (attr.card != nil) {
                    cardList = [self addKeyIntListItem:@"id" value:attr.card.dataID toStr:cardList];
                    
                }
                if (i == 0 && j == 0) {
                    strJSON = [self addKeyStartArry:@"ItemList" value:value toStr:strJSON];
                    isAddAry = YES;
                }else{
                    strJSON = [self addKeyArry:value toStr:strJSON];
                }
                
                
            }
        }
    }
    if (isAddAry) {
        strJSON = [self addKeyArryEnd:strJSON];
    }
    isAddAry = NO;
    
    if (cardList != nil) {
        strJSON = [self addKeyStartArry:@"shopcardjson" value:cardList toStr:strJSON];
        strJSON = [self addKeyArryEnd:strJSON];
    }
    
    
    strJSON = [self addEnd:strJSON];
    return strJSON;
}

@end
