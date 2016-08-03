//
//  CacheItem.m
//  TSYP
//
//  Created by wulin on 13-6-4.
//
//

#import "CacheItem.h"
#import "CacheItemDelegate.h"


@implementation CacheItem

@synthesize delegate;
@synthesize remoteURL;
@synthesize connectionData;
@synthesize connection;
@synthesize isDownloading;
@synthesize ID;
@synthesize cacheData;
@synthesize isCancel;//是否取消了下载

- (BOOL) startDownloadingURLAsyn:(NSString *)paramRemoteURL delegate:(id)delegat dataID:(NSString *)dataID{
    self.remoteURL = [NSURL URLWithString:paramRemoteURL];
    
    self.ID = dataID;
    if(self.remoteURL == nil){
        
        return NO;
    }
    self.delegate = delegat;
    self.cacheData = [[NSMutableData alloc] init];
    //创建一个请求
    self.connectionData = [NSMutableURLRequest requestWithURL:self.remoteURL cachePolicy:NSURLRequestUseProtocolCachePolicy
                                              timeoutInterval:60.0f];
    
    self.connection = [[NSURLConnection alloc] initWithRequest:self.connectionData delegate:self
                                              startImmediately:YES];//这里是异步的
    isDownloading = YES;
    if(self.connection == nil){
        
        [self.cacheData release];
        return NO;
    }
    return YES;
}

- (BOOL) startDownloadingURL:(NSString *)paramRemoteURL delegate:(id)delegat dataID:(NSString *)dataID{//同步下载
    
    
    self.remoteURL = [NSURL URLWithString:paramRemoteURL];
    if(self.remoteURL == nil){
        
        return NO;
    }
    self.delegate = delegat;
    self.ID = dataID;
    NSLog(@"StartDowload:%@", ID);
    
    NSURLCache *urlCache = [NSURLCache sharedURLCache];
    /* 设置缓存的大小为1M*/
    [urlCache setMemoryCapacity:1*1024*1024];
    //创建一个请求
    self.connectionData = [NSMutableURLRequest requestWithURL:self.remoteURL cachePolicy:urlCache timeoutInterval:60];
    
    isDownloading = YES;
        
    NSError *downloadError = nil;
    
    
    NSData *imageData = [NSURLConnection sendSynchronousRequest:self.connectionData returningResponse:nil error:&downloadError];//同步
    NSLog(@"DowladFinish:%@", ID);
    if (!isCancel) {
        if(downloadError == nil && imageData != nil){
            //image = [UIImage imageWithData:imageData];
            
            [self.delegate cacheItemDelegateSucceeded:self withRemoteURL:remoteURL withAboutToBeReleasedData:imageData dataID:self.ID];
            [self.connectionData release];
            [self.remoteURL release];
            [self.ID release];
            isDownloading = NO;
            
            return YES;
        }
        else if(downloadError != nil){
            // NSLog(＠"Error happened = ％＠"， downloadError);
            isDownloading = NO;
            [self.delegate cacheItemDelegateFailed:self remoteURL:remoteURL withError:downloadError dataID:self.ID];
        }
        else
        {
            
            // NSLog(＠"No data could get downloaded  the URL.");
            isDownloading = NO;
            [self.delegate cacheItemDelegateFailed:self remoteURL:remoteURL withError:downloadError dataID:self.ID];
            
        }
    }
    
    [self.connectionData release];
    [self.remoteURL release];
    [self.ID release];
    return NO;
}

- (void)  connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
   //NSString *mime = [connection h];
    NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
    //NSDictionary *heat = [httpResponse allHeaderFields];
    httpStatus = [httpResponse statusCode];
    //NSLog(@"将接收输出");
    
}
- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request
            redirectResponse:(NSURLResponse *)redirectResponse{
    //NSLog(@"即将发送请求");
    return(request);
}
- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data{
    //NSLog(@"接受数据");
    //NSLog(@"数据长度为 = %lu", (unsigned long)[data length]);
    //Byte *testByte = (Byte *)[data bytes];
    [cacheData appendData:data];
    //connection.
    //[delegate cacheItemDelegateSucceeded:self withRemoteURL:remoteURL withAboutToBeReleasedData:data dataID:self.ID];
    
}

//数据请求完毕，这个时候，用法是多线程的时候，通过这个通知，关子线程  
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    //NSLog(@"请求完成");
    if (!isCancel) {
        if (httpStatus == 200) {
            [self.delegate cacheItemDelegateSucceeded:self withRemoteURL:remoteURL withAboutToBeReleasedData:[[NSData alloc] initWithBytes:[cacheData bytes] length:[cacheData length]] dataID:self.ID];
        }else{
            [self.delegate cacheItemDelegateFailed:self remoteURL:remoteURL withError:nil dataID:self.ID];
        }
    }
    
    
    isDownloading = NO;
}
//通知关闭子线程
- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error{
    //NSLog(@"请求失败");
    isDownloading = NO;
    if (!isCancel) {
        [self.delegate cacheItemDelegateFailed:self remoteURL:remoteURL withError:error dataID:self.ID];
    }
    
}

-(void)dealloc{
    /*if (delegate != nil) {
        [delegate release];
    }*/
    self.delegate = nil;
    if (remoteURL != nil) {
        [remoteURL release];
    }
    if (connectionData != nil) {
        [connectionData release];
    }
    if (connection != nil) {
        [connection release];
    }
    if (ID != nil) {
        [ID release];
    }
    [self.cacheData release];
    [super dealloc];
}

@end
