//
//  FoodModel.h
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-28.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CachedDownloadManager.h"
@interface ShopTypeModel : NSObject
{
    
	
}

@property (nonatomic, assign) int typeID;
@property (nonatomic, retain) NSString* typeName;
@property (nonatomic, retain) NSString* typeEnName;//英文名称
@property (nonatomic, retain) NSMutableArray *attr;//菜品规格
@property (nonatomic, retain) NSString *ico;
@property (nonatomic, retain) NSString *picPath;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) NSString *notice;//菜品提示

- (ShopTypeModel*)init;
- (ShopTypeModel*)initWithJsonDictionary:(NSDictionary*)dic imageDow:(CachedDownloadManager *)imageDow GoupId:(int)goup;//父类
- (ShopTypeModel*)initWithChildJsonDictionary:(NSDictionary*)dic;//子类
- (ShopTypeModel*)initWithFloorJsonDictionary:(NSDictionary*)dic;//楼层
- (void)updateWithChildJsonDictionary:(NSDictionary*)dic;
- (void)updateWithFloorJsonDictionary:(NSDictionary*)dic;
- (void)updateWithJSonDictionary:(NSDictionary*)dic  imageDow:(CachedDownloadManager *)imageDow GoupId:(int)goup;
-(void)setImg:(NSString *)imagePath Default:(NSString *)name imgView:(UIImageView *)imgView;
-(void)setImgView:(NSString *)imagePath Default:(NSString *)name;
-(void)setImg:(NSString *)imagePath Default:(NSString *)name;
@end