//
//  Order4ListModel.h
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-5-21.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LotterOrderDetailModel : NSObject
{
	NSString*   Pname;
    NSString*   ReveInt;
	NSString*   addtime;
    int  ReveVar;
    int   state;
    NSString *Rcver;//收件人
    NSString *tel;//电话
    NSString *Address;//地址
    NSString *Remark;//备注
}

@property (nonatomic, retain) NSString*   Pname;
@property (nonatomic, retain) NSString*   ReveInt;
@property (nonatomic, retain) NSString*   addtime;
@property (nonatomic) int   ReveVar;
@property (nonatomic) int   state;
@property (nonatomic, retain) NSString *Rcver;//收件人
@property (nonatomic, retain) NSString *tel;//电话
@property (nonatomic, retain) NSString *Address;//地址
@property (nonatomic, retain) NSString *Remark;//备注

- (LotterOrderDetailModel*)initWithJsonDictionary:(NSDictionary*)dic;
- (void)updateWithJSonDictionary:(NSDictionary*)dic;

@end