//
//  IntroModel.m
//  TSYP
//
//  Created by wulin on 13-6-3.
//
//

#import "AdvModel.h"

@implementation AdvModel
@synthesize titleText;
@synthesize descriptionText;
@synthesize image;
@synthesize advType;//广告类型 0商品 ，1·公告
@synthesize dataID;
@synthesize imageLocalPath;
@synthesize imageNetPath;

- (id) initWithTitle:(NSString*)title description:(NSString*)desc image:(NSString*)imageText {
    self = [super init];
    if(self != nil) {
        
        
        self.titleText = title;
        self.descriptionText = desc;
        
//        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:imageText] == YES) {
            self.image = [[UIImage alloc] init];
            [self.image initWithContentsOfFile:imageText];
        }else{
            self.image = [UIImage imageNamed:imageText];
        }
//        [fileManager release];
        
        
    }
    return self;
}

-(id)initWithShopAdvDic:(NSDictionary *)dic{
    self = [super init];
    if (self != nil) {
        self.dataID = [[dic objectForKey:@ "dataid"] intValue];
        self.advType = 4;
        
        self.imageNetPath = [dic objectForKey:@"icon"];
        self.titleText = @"";
        
    }
    return self;
}

-(id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self != nil) {
        //self.dataID = [[dic objectForKey:@ "SortID"] intValue];
        self.advType = [[dic objectForKey:@ "priority"] intValue];
        
        self.imageNetPath = [dic objectForKey:@"SortName"];
        self.titleText = [dic objectForKey:@"SortID"];
        if (self.titleText.length >= 18) {
            if ([self.titleText rangeOfString:@"shopreview.aspx"].length == 15) {
                self.advType = 2;
            }else if ([self.titleText rangeOfString:@"shop.aspx"].length == 9) {
                self.advType = 3;
            }
            NSRange index = [self.titleText rangeOfString:@"id="];
            if (index.length > 0) {
                NSRange postoin = [self.titleText rangeOfString:@"&"];
                NSRange sub;
                if (postoin.length > 0) {
                    if (postoin.location < index.location) {
                        sub.location = index.location;
                        sub.length = self.titleText.length - index.location;
                        self.titleText = [self.titleText substringWithRange:sub];
                        postoin = [self.titleText rangeOfString:@"&"];
                        if (postoin.length > 0) {
                            sub.location = 0;
                            sub.length = postoin.location;
                            self.titleText = [self.titleText substringWithRange:sub];
                        }
                    }else{//id=是第一个参数
                        sub.location = index.location;
                        sub.length = postoin.location - index.location;
                        self.titleText = [self.titleText substringWithRange:sub];
                    }
                }else{//只有id=这个参数
                    sub.location = index.location;
                    sub.length = self.titleText.length - index.location;
                    self.titleText = [self.titleText substringWithRange:sub];
                }
                NSArray *arry = [self.titleText componentsSeparatedByString:@"="];
                self.dataID =[arry[1] intValue];
            }
        }
        
    }
    return self;
}

-(void)setImg:(NSString *)imagePath Default:(NSString*)name{
    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath] == YES) {
        self.image = [[UIImage alloc] init];
        self.image = [UIImage imageWithContentsOfFile:imagePath];
    }else{
        self.image = [UIImage imageNamed:name];
    }
    [[NSFileManager defaultManager] release];
    
}

-(void)dealloc{
    [self.titleText release];
    [self.descriptionText release];
    [self.image release];
    //[cachedFileData release];
    [self.imageLocalPath release];
    [self.imageNetPath release];
    [super dealloc];
}
@end
