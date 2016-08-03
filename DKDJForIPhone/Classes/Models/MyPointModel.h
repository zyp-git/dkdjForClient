//
//  MyPointModel.h
//  HMBL
//
//  Created by ihangjing on 13-12-31.
//
//

#import <Foundation/Foundation.h>

@interface MyPointModel : NSObject

@property (nonatomic, retain)NSString *comment;//说明
@property (nonatomic, retain)NSString *point;//积分值
@property (nonatomic, retain)NSString *dataTime;//时间
@property (nonatomic) int type;//类型

-(MyPointModel *)initWitchDic:(NSDictionary *)dic;
@end
