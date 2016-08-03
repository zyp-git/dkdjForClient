//
//  SeckillListModel.h
//  RenRenzx
//
//  Created by zhengjianfeng on 12-10-10.
//
//

#import <Foundation/Foundation.h>

//{"fID":"21","foodname":"素三样","statestr":"立即秒杀","openstate":"1","timestr":"正在秒杀中...","togoname":"山东人家","oldprice":"8.0","newprice":"5.0","sqid":"2","cnum":"4"}
@interface SeckillListModel : NSObject
{
    NSString*   dataid;
	NSString*   togoname;
    NSString*   title;
	NSString*   nowdis;
    NSString*   inve3;
    NSString*   price;
    NSString*   discount;
    NSString*   inuser;
    NSString*   inve4;
    NSString*   shopid;
    NSString*   sentmoney;
    NSString*   status;//1 正常 0 关闭
    NSString*   desc;
}

@property (nonatomic, retain) NSString* dataid;
@property (nonatomic, retain) NSString* togoname;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* nowdis;
@property (nonatomic, retain) NSString* inve3;
@property (nonatomic, retain) NSString* price;
@property (nonatomic, retain) NSString* discount;
@property (nonatomic, retain) NSString* inuser;
@property (nonatomic, retain) NSString* inve4;
@property (nonatomic, retain) NSString* shopid;
@property (nonatomic, retain) NSString* sentmoney;
@property (nonatomic, retain) NSString* status;
@property (nonatomic, retain) NSString* desc;

- (SeckillListModel*)initWithJsonDictionary:(NSDictionary*)dic;
- (void)updateWithJSonDictionary:(NSDictionary*)dic;

@end