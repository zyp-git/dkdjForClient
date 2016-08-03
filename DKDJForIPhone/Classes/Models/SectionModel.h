//
//  SectionModel.h
//  RenRenzx
//
//  Created by zhengjianfeng on 12-10-4.
//
//

#import <Foundation/Foundation.h>

@interface SectionModel : NSObject
{
    NSString*   ID;
	NSString*   Name;
    NSString*   CityId;
}

@property (nonatomic, retain) NSString* ID;
@property (nonatomic, retain) NSString* Name;
@property (nonatomic, retain) NSString* CityId;

- (SectionModel*)initWithJsonDictionary:(NSDictionary*)dic;
- (void)updateWithJSonDictionary:(NSDictionary*)dic;

@end