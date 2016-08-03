//
//  CacheItem.h
//  TSYP
//
//  Created by wulin on 13-6-4.
//
//

#import <Foundation/Foundation.h>
@interface CacheItem : NSObject{
    
@public
   // id delegate;
    //web地址
    NSURL              *remoteURL;
@private
    //是否正在下载
    BOOL                  isDownloading;
    //NSMutableURLRequest对象
    NSMutableURLRequest         *connectionData;
    //NSURLConnection对象
    NSURLConnection       *connection;
    NSInteger httpStatus;//状态
}
/* -------------------------- */

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) NSURL  *remoteURL;
@property (nonatomic, assign) BOOL      isDownloading;
@property (nonatomic, retain) NSMutableURLRequest *connectionData;
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSString *ID;
@property (nonatomic, retain) NSMutableData *cacheData;
@property (nonatomic,) BOOL isCancel;//是否取消了下载

/* ----------开始下载方法----------- */

- (BOOL) startDownloadingURLAsyn:(NSString *)paramRemoteURL delegate:(id)delegat dataID:(NSString *)dataID;//异步

- (BOOL) startDownloadingURL:(NSString *)paramRemoteURL delegate:(id)delegat dataID:(NSString *)dataID;//同步



@end


