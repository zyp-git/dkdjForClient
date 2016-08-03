//
//  MyCouponModel.h
//  HMBL
//
//  Created by ihangjing on 13-12-28.
//
//

#import <Foundation/Foundation.h>

@interface MyCouponModel : NSObject

@property (nonatomic, retain) NSString* CKey;//券号
@property (nonatomic,) int CType;//券类型，1 现金券， 2折扣
@property (nonatomic, retain) NSString *CValue;//券值
@property (nonatomic, retain) NSString *GeivePerson;//赠送人
@property (nonatomic, assign)int CTimeLimity;//是否时间限制 0 有时间限制，1无时间限制
@property (nonatomic, retain) NSString *StartTime;//时间限制的开始时间;
@property (nonatomic, retain) NSString *EndTime;//时间限制的结束时间
@property (nonatomic,)int CMoneyLine;//金额限制 0有金额限制，1无金额限制
@property (nonatomic,)float MoneyLine;//金额限制量
@property (nonatomic,)float CMoney;//剩余金额;
@property (nonatomic,)int CActivity;//是否激活 0没有激活，1激活
@property (nonatomic,)int dataID;//编号
@property (nonatomic,)int isUser;//是否使用 0未用，1使用过
@property (nonatomic,)int isSelect;//是否选中，0未选中，1选择中
@property (nonatomic,)int indexSelect;//选中队列中的位置

-(MyCouponModel *)initWitchDic:(NSDictionary *)dic;
@end
