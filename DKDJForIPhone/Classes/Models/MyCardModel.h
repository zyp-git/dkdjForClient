//
//  MyCardModel.h
//  RenRenzx
//
//  Created by zhengjianfeng on 12-10-6.
//
//

#import <Foundation/Foundation.h>
//{"cardnum":"111128","point":"100","ckey":"1111-1111-1111-1128","cmoney":"100.0","CID":"18"}
@interface MyCardModel : NSObject
{
    NSString*   cardnum;
	NSString*   point;
    NSString*   ckey;
    NSString*   cmoney;
    NSString*   CID;
    BOOL			m_checked;
}

@property (nonatomic, retain) NSString* cardnum;
@property (nonatomic, retain) NSString* point;
@property (nonatomic, retain) NSString* ckey;
@property (nonatomic, retain) NSString* cmoney;
@property (nonatomic, retain) NSString* CID;
@property(nonatomic, assign) BOOL checked;

- (MyCardModel*)initWithJsonDictionary:(NSDictionary*)dic;
- (void)updateWithJSonDictionary:(NSDictionary*)dic;

@end