//
//  DowImageMode.m
//  TSYP
//
//  Created by wulin on 13-6-4.
//
//

#import "DowImageMode.h"

@implementation DowImageMode
@synthesize URL;
@synthesize data;

-(void) dealloc{
    if(self.URL != nil){
        [self.URL invalidate];
        self.URL = nil;
    }
    if(self.data != nil){
        [self.data invalidate];
        self.data = nil;
    }
    [super dealloc];
}
@end
