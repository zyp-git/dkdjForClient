//
//  CityModel.h
//  RenRenzx
//
//  Created by zhengjianfeng on 12-10-4.
//
//

#import <Foundation/Foundation.h>

@interface CityModel : NSObject
{
    NSString*   ID;
	NSString*   Name;
}

@property (nonatomic, retain) NSString* ID;
@property (nonatomic, retain) NSString* Name;

- (CityModel*)initWithJsonDictionary:(NSDictionary*)dic;
- (void)updateWithJSonDictionary:(NSDictionary*)dic;

@end