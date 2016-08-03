//
//  BuildingModel.h
//  RenRenzx
//
//  Created by zhengjianfeng on 12-10-4.
//
//

#import <Foundation/Foundation.h>

@interface BuildingModel : NSObject
{
    NSString*   ID;
	NSString*   Name;
}

@property (nonatomic, retain) NSString* ID;
@property (nonatomic, retain) NSString* Name;

- (BuildingModel*)initWithJsonDictionary:(NSDictionary*)dic;
- (void)updateWithJSonDictionary:(NSDictionary*)dic;

@end