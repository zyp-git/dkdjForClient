//
//  CacheItemDelegate.h
//  TSYP
//
//  Created by wulin on 13-6-4.
//
//

#import <Foundation/Foundation.h>
#import "CacheItem.h"

@protocol CacheItemDelegate <NSObject>
//下载成功执行该方法
- (void) cacheItemDelegateSucceeded:(CacheItem *)paramSender withRemoteURL:(NSURL *)paramRemoteURL
          withAboutToBeReleasedData:(NSData *)paramAboutToBeReleasedData  dataID:(NSString *)dataID;

//下载失败执行该方法
- (void) cacheItemDelegateFailed:(CacheItem *)paramSender
                       remoteURL:(NSURL *)paramRemoteURL
                       withError:(NSError *)paramError  dataID:(NSString *)dataID;
@end
