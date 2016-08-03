//
//  CachedDownloadManagerDelegate.h
//  TSYP
//
//  Created by wulin on 13-6-4.
//
//

#import <Foundation/Foundation.h>
#import "CachedDownloadManager.h"

@protocol CachedDownloadManagerDelegate <NSObject>
//缓存项的委托方法
-(void) cachedDownloadManagerSucceeded:(CachedDownloadManager *)paramSender remoteURL:(NSURL *)remoteURL localURL:(NSURL *)localURL aboutToBeReleasedData:(NSData *)aboutToBeReleasedData isCachedData:(BOOL)isCachedData;
//缓存项失败失败的委托方法
- (void) cachedDownloadManagerFailed:(CachedDownloadManager *)paramSender remoteURL:(NSURL *)remoteURL localURL:(NSURL *)localURL withError:(NSError *)paramError;
//所有任务完成
- (void) cachedDownloadFinish:(NSMutableArray *)arry start:(int)index dowType:(int)type;

-(void)updataUI:(int)type;
@end
