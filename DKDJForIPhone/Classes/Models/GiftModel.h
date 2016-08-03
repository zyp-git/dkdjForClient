//
//  FShop4ListMode.h
//  Faneat4iPhone
//
//  Created by OS Mac on 12-7-4.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import <Foundation/Foundation.h>

//{"DataID":"140", "TogoName":"老娘舅", "Grade":"1","sortname":"商务简餐","address":"提供主城区各餐厅外卖服务[除下沙/萧山]","Time1Start":"10:00","Time1End":"21:00","Time2Start":"10:00","Time2End":"21:00","distance":"0","Star":"1","lng":"120.176888","lat":"30.303508","sendmoney":"0"}
@interface GiftModel : NSObject
{
       //NSString*   picPath;
}
@property (nonatomic,) NSInteger giftID;//编号，编号
@property (nonatomic, retain) NSString *giftName;//活动名称，物品名称
@property (nonatomic,) CGFloat oPrice;//原价
@property (nonatomic,) NSInteger cNum;//剩余数量，库存
@property (nonatomic, retain) NSString* icon;
@property (nonatomic, assign) NSInteger NeedIntegral;//需要积分
@property (nonatomic, retain) NSString* des;//描述，间接；



@property (nonatomic, retain) NSString* picPath;

@property (nonatomic, retain) UIImage* image;

@property (nonatomic, assign) int GiftsPrice;//销量

-(GiftModel *)init;
- (GiftModel*)initWithJsonDictionary:(NSDictionary*)dic;
-(void)setImg:(NSString *)imagePath Default:(NSString *)iname;
- (void)updateWithJSonDictionary:(NSDictionary*)dic;

@end