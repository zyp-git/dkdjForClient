//
//  Order4ListModel.h
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-5-21.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FoodInOrderModelFix.h"
@interface Order4ListModel : NSObject{
    
}
@property (nonatomic,strong)  NSMutableArray  <FoodInOrderModelFix *>* foodsArr;
@property (nonatomic, retain) NSString* OrderId;
@property (nonatomic, retain) NSString* ShopName;
@property (nonatomic, retain) NSString* TotalMoney;
@property (nonatomic, assign) int State;
@property (nonatomic, assign) int Sendtate;
@property (nonatomic, assign) int ShopState;
@property (nonatomic, retain) NSString* Address;
@property (nonatomic, retain) NSString* OrderTime;
@property (nonatomic, retain) NSString* SentMoney;
@property (nonatomic, retain) NSString* Packagefree;
@property (nonatomic, retain) UIImage* image;
@property (nonatomic, retain) NSString* TogoPic;
@property (nonatomic, retain) NSString* picPath;
@property (nonatomic, assign) NSInteger* isShopSet;
@property (nonatomic, assign) NSInteger* payState;

- (Order4ListModel*)initWithJsonDictionary:(NSDictionary*)dic;
- (void)updateWithJSonDictionary:(NSDictionary*)dic;
-(void)setImg:(NSString *)imagePath Default:(NSString *)iname;

@end