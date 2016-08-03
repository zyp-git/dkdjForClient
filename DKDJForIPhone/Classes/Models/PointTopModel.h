//
//  PointTopModel.h
//  HMBL
//
//  Created by ihangjing on 13-12-31.
//
//

#import <Foundation/Foundation.h>

@interface PointTopModel : NSObject
@property (nonatomic, retain)NSString *userID;//用户编号
@property(nonatomic, retain)NSString *userName;//用户名称
@property(nonatomic, retain)NSString *historyPoint;//历史积分
@property(nonatomic, retain)NSString *publicPoint;//公益积分;
@property (nonatomic, retain)NSString* friendICON;//好友头像网络
@property (nonatomic, retain)NSString* frImageLocalPath;//好友头像本地缓存
@property (nonatomic, retain) UIImage *frImage;//好友头像

-(PointTopModel *)initWitchDic:(NSDictionary *)dic;
-(void)setFrImg:(NSString *)imagePath Default:(NSString *)name;
@end
