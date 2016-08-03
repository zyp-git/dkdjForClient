//
//  SectionModel.h
//  RenRenzx
//
//  Created by zhengjianfeng on 12-10-4.
//
//

#import <Foundation/Foundation.h>

@interface GiftInfoModel : NSObject
{
    NSString *gID;
	NSString * gName;
    NSString * price;//礼品价格
    NSString * pic;
    NSString * hasMoney;//当type = 1时，代表多少金额
    NSString * pkAddress;//礼品自取地址
    NSString * locaPath;
    
	int needPoint;//需要的最少积分
	
	int stocks;//库存
	
	int type;//类型，0普通礼品，1现金券
	
	int lotterPoint;//抽奖所需积分
	
}

@property (nonatomic, retain)NSString *gID;
@property (nonatomic, retain)NSString * gName;
@property(nonatomic)int needPoint;//需要的最少积分
@property (nonatomic, retain)NSString * price;//礼品价格
@property(nonatomic)int stocks;//库存
@property (nonatomic, retain)NSString * pic;
@property(nonatomic)int type;//类型，0普通礼品，1现金券
@property (nonatomic, retain)NSString * hasMoney;//当type = 1时，代表多少金额
@property(nonatomic)int lotterPoint;//抽奖所需积分
@property (nonatomic, retain)NSString * pkAddress;//礼品自取地址
@property(nonatomic, retain)NSString *locaPath;

- (GiftInfoModel*)initWithJsonDictionary:(NSDictionary*)dic;
-(GiftInfoModel*)initWithJsonDictionaryOfDetail:(NSDictionary*)dic;
- (void)updateWithJSonDictionary:(NSDictionary*)dic;

@end