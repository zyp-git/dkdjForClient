//
//  FileController.h
//  Faneat4iPhone
//
//  Created by OS Mac on 12-7-5.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//
#define kOrderListFile @"ShopCart.plist"
#import <Foundation/Foundation.h>

@interface FileController : NSObject {
    
}

+(NSString *)documentsPath;
+(NSString *)fullpathOfFilename:(NSString *)filename;
+(void)saveOrderList:(NSDictionary *)list;
+(NSDictionary *)loadOrderList;
+(NSUInteger)addOneToRow:(NSUInteger)row;
+(NSUInteger)deleteOneFomRow:(NSUInteger)row;
+(NSDictionary *)readRow:(NSUInteger)row;

+(void)saveShopCart:(NSMutableDictionary *)shopcartDict;
+(NSMutableDictionary *)loadShopCart;

@end
