//
//  FoodModel.m
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-28.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "FoodModel.h"

@implementation FoodModel


- (void)updateWithJSonDictionary:(NSDictionary*)dic
{
    self.FoodType=[dic objectForKey:@"FoodType"];
    self.ico = [dic objectForKey:@"icon"];
    self.foodid = [[dic objectForKey:@"FoodID"] intValue];
    self.foodname = [dic objectForKey:@"Name"];
    self.price = [[dic objectForKey:@"Price"] floatValue];
    self.tid = [[dic objectForKey:@"togoid"] intValue];
    self.Disc=[dic objectForKey:@"intro"];
    
    self.sale = [[dic objectForKey:@"sale"] intValue];

    self.canBuy = 0;//[[dic objectForKey:@"canbuy"] intValue];//是否能购买 0表示可以购买，1表示只可浏览(只对活动商品列表有效)
    self.packagefree = [[dic objectForKey:@"PackageFree"] floatValue];
    NSArray *arry = [dic objectForKey:@"Stylelist"];
    if([arry count] > 0){
        for (int i = 0; i < 1; i++) {
            NSDictionary *dic1 = (NSDictionary*)[arry objectAtIndex:i];
            if (![dic isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            FoodAttrModel *model = [[FoodAttrModel alloc] initWithJsonDictionary:dic1];
            //这里的打包费等于商品的打包费
            model.pactFee = self.packagefree;
            model.cid = self.foodid;
            
            [self.attr addObject:model];
            
        }
    }else{
        FoodAttrModel *model = [[FoodAttrModel alloc] init];
        //这里的打包费等于商品的打包费
        model.pactFee = self.packagefree;
        model.cid = self.foodid;
        model.name = self.foodname;
        model.price = self.price;
        [self.attr addObject:model];
    }

}

- (FoodModel*)init
{
    [super init];
    self.attr = [[NSMutableArray alloc] init];
    return self;
}

- (FoodModel*)initWithJsonDictionary:(NSDictionary*)dic
{
	[self init];
    
    [self updateWithJSonDictionary:dic];
	
	return self;
}

-(void)setImg:(NSString *)imagePath Default:(NSString *)name{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:imagePath] == YES) {
        self.image = [[UIImage alloc] init];
        self.image = [UIImage imageWithContentsOfFile:imagePath];
    }else{
        self.image = [UIImage imageNamed:name];
    }
    [fileManager release];
    
}

- (void)dealloc
{
    
    [self.foodname release];
    [self.Disc release];
    [self.notice release];
    [self.picPath release];
    [self.tName release];
    [self.image release];
    [self.publicPoint release];
    [self.attr release];
   	[super dealloc];
}


@end
