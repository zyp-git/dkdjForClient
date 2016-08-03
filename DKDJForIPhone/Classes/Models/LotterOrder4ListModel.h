//
//  Order4ListModel.h
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-5-21.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LotterOrder4ListModel : NSObject
{
    NSString*   RID;
	NSString*   Pname;
    NSString*   ReveInt;
	NSString*   addtime;
    int  ReveVar;
    int   state;
}

@property (nonatomic, retain) NSString*   RID;
@property (nonatomic, retain) NSString*   Pname;
@property (nonatomic, retain) NSString*   ReveInt;
@property (nonatomic, retain) NSString*   addtime;
@property (nonatomic) int   ReveVar;
@property (nonatomic) int   state;

- (LotterOrder4ListModel*)initWithJsonDictionary:(NSDictionary*)dic;
- (void)updateWithJSonDictionary:(NSDictionary*)dic;

@end