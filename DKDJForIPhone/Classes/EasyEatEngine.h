//
//  EasyEatEngine.h
//  EasyEat4iPhone
//
//  Created by dev on 12-1-4.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EasyEatEngine : NSObject {

}

+ (EasyEatEngine *)easyEatEngineWithDelegate:(NSObject *)delegate;
- (EasyEatEngine *)initWithDelegate:(NSObject *)delegate;


+ (NSString *)version;
+ (NSString *)username;
+ (NSString *)password;
//+ (void)setUsername:(NSString *)newUsername password:(NSString *)newPassword remember:(BOOL)storePassword;

+ (void)forgetPassword;
+ (void)remindPassword;

@end
