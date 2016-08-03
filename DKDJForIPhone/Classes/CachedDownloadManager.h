//
//  CachedDownloadManager.h
//  TSYP
//
//  Created by wulin on 13-6-4.
//
//

#import <Foundation/Foundation.h>
#import "CacheItem.h"
#import "CacheItemDelegate.h"
#import "ImageDowloadTask.h"

#define CachedKeyExpiryDate @"ExpiryDate"
#define CachedKeyDownloadEndDate @"DownloadEndDate"
#define CachedKeyDownloadStartDate @"DownloadStartDate"
#define CachedKeyLocalURL @"LocalURL"
#define CachedKeyExpiresInSeconds @"ExpiresInSeconds"
#define CachedKeyWebURL @"WEBURL"
#define MAX_TASK 5

/****
 字典类型：
 {
    id =     {
    DownloadEndDate = "2011-08-02 07:51:57 +0100";
    DownloadStartDate = "2011-08-02 07:51:55 +0100";
    ExpiresInSeconds = 20;
    ExpiryDate = "2011-08-02 07:52:17 +0100";
    LocalURL = "/var/mobile/Applications/ApplicationID/Documents/
    httpwww.cnn.com.cache";
    };
 }
 ****/

@interface CachedDownloadManager : NSObject <CacheItemDelegate>{
    
@public
    //id  delegate;
    __block int taskCount;
    __block int indexTask;//记录最后处理的任务
    __block int countTask;//任务总数
    __block int startTask;//记录开始处理的任务
    __block dispatch_group_t group;
    __block dispatch_group_t mGroup;//主线程保持，用来后续增加任务时可以继续执行下载任务
    //__block NSConditionLock *theLock = [[NSConditionLock alloc] init];
    __block int maxThread;
@private
    //记录缓存数据的字典
    NSMutableDictionary *cacheDictionary;
    //缓存的路径
    NSString *cacheDictionaryPath;
    BOOL stop;//停止运行
    BOOL pass;//停止更新UI
    int dowloadType;
    
    
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) NSConditionLock *theLock;
@property (nonatomic, retain) NSConditionLock *taskLock;

@property (nonatomic, retain) NSMutableArray * taskArry;
@property (nonatomic, retain) NSMutableArray * cacheItemArry;

@property (nonatomic, copy) NSMutableDictionary *cacheDictionary;
@property (nonatomic, retain) NSMutableDictionary *taskDictionary;

@property (nonatomic, retain) NSString *cacheDictionaryPath;


-(NSString *) addTask:(NSString *)strID url:(NSString *)url showImage:(UIImage *)showImage defaultImg:(NSString *)path  indexInGroup:(int)indexInGroup Goup:(int)group;
-(id)initWitchReadShopAdvDic:(NSString *)dataid Delegate:(id) deleg;
-(id)initWitchReadDic:(int)type Delegate:(id) deleg;
-(void)changeDowloadType:(int)type;
-(void)cleanAllTask;
-(BOOL)getIsStop;
-(void)startTask;
-(void)stopTask;
-(void)doTask;

/* 保持缓存字典 */

- (BOOL) saveCacheDictionary;

/* 公有方法：下载 */

//- (BOOL) download:(ImageDowloadTask *)imageTask updateExpiryDateIfInCache:(BOOL)paramUpdateExpiryDateIfInCache isAsny:(BOOL)isAsny  cacheItem:(CacheItem *)cacheItem;

/* -------------------------- */




@end
