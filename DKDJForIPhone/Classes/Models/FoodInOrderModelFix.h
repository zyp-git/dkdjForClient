//
//  FoodInOrderModelFix.h
//  Faneat4iPhone
//
//  Created by OS Mac on 12-7-7.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodInOrderModelFix : NSObject
{
    NSString*   foodid;
	NSString*   foodname;
    float       price;
    float       package;
    int         foodCount; 
}

@property (nonatomic, retain) NSString* foodid;
@property (nonatomic, retain) NSString* foodname;
@property (nonatomic, retain) NSString* picPath;
@property (nonatomic, assign) float     price;
@property (nonatomic, assign) float     package;
@property (nonatomic, assign) int       foodCount;
@property (nonatomic,) int isComment;//0没有评论，1评论了
@property (nonatomic, retain) UIImage *image;


- (FoodInOrderModelFix*)initWithDictionary:(NSDictionary*)dic;
- (void)updateWithDictionary:(NSDictionary*)dic;

- (FoodInOrderModelFix*)initWithDictionaryFix:(NSDictionary*)dic;
- (void)updateWithDictionaryFix:(NSDictionary*)dic;
-(void)setImg:(NSString *)imagePath Default:(NSString *)name;
@end