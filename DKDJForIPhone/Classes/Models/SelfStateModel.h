//
//  FoodModel.h
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-28.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SelfStateModel : NSObject
{
    
	
}
@property (nonatomic, retain) NSString* stateName;
@property (nonatomic, retain) NSString* stateID;
- (SelfStateModel*)init;
- (SelfStateModel*)initWithJsonDictionary:(NSDictionary*)dic;
- (void)updateWithJSonDictionary:(NSDictionary*)dic;
-(void)setImg:(NSString *)imagePath Default:(NSString *)name;
@end