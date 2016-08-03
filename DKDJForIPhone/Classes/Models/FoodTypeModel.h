//
//  FoodTypeModel.h
//  Faneat4iPhone
//
//  Created by OS Mac on 12-7-17.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodTypeModel : NSObject

@property (nonatomic, strong) NSString* SortID;
@property (nonatomic, strong) NSString* SortName;
@property (nonatomic, strong) NSString* JOrder;
@property (nonatomic, strong) NSString* icon;
@property (nonatomic, strong) NSString* picPath;
@property (nonatomic, strong) UIImage* image;

- (FoodTypeModel*)initWithJsonDictionary:(NSDictionary*)dic;
- (void)updateWithJSonDictionary:(NSDictionary*)dic;
-(void)setImg:(NSString *)imagePath Default:(NSString *)name;

@end