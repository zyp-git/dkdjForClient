//
//  Order4ListModel.h
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-5-21.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartOrder4ListModel : NSObject
{
    
}

@property (nonatomic, retain) NSString*   OrderId;//兑换编号
@property (nonatomic, retain) NSString*   GiftName;//礼品名字
@property (nonatomic, retain) NSString*   PayIntegral;//所需积分
@property (nonatomic) int   State;//状态 0 为审核 1 审核通过 2 审核未通过
@property (nonatomic, retain) NSString*   sendtype;//配送方式 1 自提 2 送货
@property (nonatomic, retain) NSString*   OrderTime; //兑换时间
@property (nonatomic, retain) NSString*   ReveInt1;//礼品类型 0普通礼品 1 现金券
@property (nonatomic, retain) NSString* validcode;//验证码

- (CartOrder4ListModel*)initWithJsonDictionary:(NSDictionary*)dic;
- (void)updateWithJSonDictionary:(NSDictionary*)dic;

@end