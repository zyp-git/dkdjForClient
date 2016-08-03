//
//  ImageDowloadTask.m
//  TSYP
//
//  Created by wulin on 13-6-5.
//
//

#import "ImageDowloadTask.h"

@implementation ImageDowloadTask
@synthesize URL;
@synthesize showImg;
@synthesize locURL;
@synthesize dowload;
@synthesize ID;
@synthesize defaultPath;
@synthesize index;//在原数组中的索引
@synthesize groupType;//所在组标识

-(id)initWhichURLAndUI:(NSString *)url showImg:(UIImage *)showIm dataID:(NSString *)dataID  defaultImg:(NSString *)path indexInGroup:(int)indexInGroup group:(int)group{
    [super init];
    /*if (url.length == 0) {
        self.URL = @"";
    }else{
        
    }*/
    
    
    self.URL = url;
    self.showImg = showIm;
    self.dowload = NO;
    self.ID = dataID;
    self.defaultPath = path;
    self.groupType = group;
    
    self.index = indexInGroup;
    return self;
}

-(void)dealloc{
    if (self.URL != nil) {
        [self.URL release];
        self.URL = nil;
    }
    if(self.showImg != nil){
        [self.showImg release];
        self.showImg = nil;
    }
    if(self.ID != nil){
        [self.ID release];
        self.ID = nil;
    }
    if(self.locURL != nil){
        [self.locURL release];
        self.locURL = nil;
    }
    if (self.defaultPath != nil) {
        [self.defaultPath release];
        self.defaultPath = nil;
    }
    [super dealloc];
    
}
@end
