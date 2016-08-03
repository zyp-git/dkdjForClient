//
//  GroupListModel.h
//  RenRenzx
//
//  Created by zhengjianfeng on 12-10-10.
//
//

#import <Foundation/Foundation.h>
//{"gId":"10","Title":"团购测试项目","nowdis":"5.0","Inve3":"0天-21时-23分-56秒","price":"100.0","Discount":"50.0","InUser":"5","togoname":"山东人家","Inve4":"测试一下而已木有地址"}
@interface GroupListModel : NSObject
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

- (GroupListModel*)initWithJsonDictionary:(NSDictionary*)dic;
- (void)updateWithJSonDictionary:(NSDictionary*)dic;

@end