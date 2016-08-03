//
//  FoodModel.m
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-28.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "ShopTypeModel.h"

@implementation ShopTypeModel

@synthesize typeID;
@synthesize typeName;
@synthesize typeEnName;//英文名称
@synthesize attr;
@synthesize ico;
@synthesize picPath;
@synthesize notice;//菜品提示
@synthesize imageView;
@synthesize image;
- (void)updateWithFloorJsonDictionary:(NSDictionary*)dic
{
    self.typeEnName = [dic objectForKey:@"SortPic"];
    self.typeID = [[dic objectForKey:@"SortID"] intValue];
    self.typeName = [dic objectForKey:@"SortName"];
    self.notice = [dic objectForKey:@"note"];
}
- (void)updateWithChildJsonDictionary:(NSDictionary*)dic
{
    self.ico = [dic objectForKey:@"SortPic"];
    self.typeID = [[dic objectForKey:@"SortID"] intValue];
    self.typeName = [dic objectForKey:@"SortName"];
   // self.notice = [dic objectForKey:@"note"];
}
- (void)updateWithJSonDictionary:(NSDictionary*)dic imageDow:(CachedDownloadManager *)imageDow GoupId:(int)goup
{
  
    [self updateWithChildJsonDictionary:dic];
    NSArray *arry = [dic objectForKey:@"sublist"];
    int index = (int)[self.attr count];
    for (int i = 0; i < [arry count]; i++) {
        NSDictionary *dic1 = (NSDictionary*)[arry objectAtIndex:i];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        ShopTypeModel *model = [[ShopTypeModel alloc] initWithChildJsonDictionary:dic1];
        model.picPath = [imageDow addTask:[NSString stringWithFormat:@"%d", model.typeID] url:model.ico showImage:nil defaultImg:@"" indexInGroup:index++ Goup:goup];
        [model setImg:model.picPath Default:@"暂无图片"];
        [self.attr addObject:model];
        
    }
    
}

- (ShopTypeModel*)init
{
    [super init];
    self.attr = [[NSMutableArray alloc] init];
    return self;
}

- (ShopTypeModel*)initWithJsonDictionary:(NSDictionary*)dic imageDow:(CachedDownloadManager *)imageDow GoupId:(int)goup
{
	[self init];
    
    [self updateWithJSonDictionary:dic imageDow:imageDow GoupId:goup];
	
	return self;
}
- (ShopTypeModel*)initWithChildJsonDictionary:(NSDictionary*)dic
{
    [self init];
    
    [self updateWithChildJsonDictionary:dic];
    
    return self;

}
- (ShopTypeModel*)initWithFloorJsonDictionary:(NSDictionary*)dic
{
    [self init];
    
    [self updateWithFloorJsonDictionary:dic];
    
    return self;
}

-(void)setImg:(NSString *)imagePath Default:(NSString *)name imgView:(UIImageView *)imgView{
    if (imgView == nil) {
        return;
    }
    self.imageView = imgView;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:imagePath] == YES) {
        self.imageView.image = [[UIImage alloc] init];
        [self.imageView.image initWithContentsOfFile:imagePath];
    }else{
        self.imageView.image = [UIImage imageNamed:name];
    }
    [fileManager release];
    
}

-(void)setImgView:(NSString *)imagePath Default:(NSString *)name
{
    if (self.imageView == nil) {
        return;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:imagePath] == YES) {
        self.imageView.image = nil;
        //UIImage
        [self.imageView.image initWithContentsOfFile:imagePath];
    }else{
        self.imageView.image = [UIImage imageNamed:name];
    }
    [fileManager release];
}

-(void)setImg:(NSString *)imagePath Default:(NSString *)name{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:imagePath] == YES) {
        self.image = [UIImage imageWithContentsOfFile:imagePath];
    }else{
        self.image = [UIImage imageNamed:name];
    }
    [fileManager release];
    
}

- (void)dealloc
{
    
    [self.typeName release];
    [self.notice release];
    [self.picPath release];
    [self.image release];
    [self.imageView release];
    [self.attr release];
    [self.typeEnName release];
   	[super dealloc];
}


@end
