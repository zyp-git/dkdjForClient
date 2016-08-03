//
//  FoodAttrModel.h
//  TSYP
//
//  Created by wulin on 13-6-12.
//
//

#import <Foundation/Foundation.h>

@interface KTVModel : NSObject{

}
@property(nonatomic) int dataID;
@property (nonatomic, retain)NSString *weekstart;//星期段
@property (nonatomic, retain)NSString *TimeEnd;
@property (nonatomic)int Sort;//优惠类型  0价格，1 活动，2优惠券
@property(nonatomic, retain)NSString *TimeStart;
@property(nonatomic, retain)NSString *Sortname;//包间
@property (nonatomic, assign)float Price;//价格

- (KTVModel*)initWithJsonDictionary:(NSDictionary*)dic;
-(void)setImg:(NSString *)imagePath Default:(NSString *)name;
@end
