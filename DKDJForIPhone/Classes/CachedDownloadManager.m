//
//  CachedDownloadManager.m
//  TSYP
//
//  Created by wulin on 13-6-4.
//
//

#import "CachedDownloadManager.h"
#import "CachedDownloadManagerDelegate.h"

@implementation CachedDownloadManager

@synthesize delegate;
@synthesize cacheDictionary;
@synthesize cacheDictionaryPath;
@synthesize taskDictionary;
@synthesize theLock;
@synthesize taskLock;
@synthesize cacheItemArry;//下载缓存的item 下载完的都会移除改arry

-(void)initDic:(int)type name:(NSString *)dicName
{
    NSString *documentsDirectory = [self documentsDirectoryWithTrailingSlash:YES];
    //zyp生产缓存字典的路径
    switch (type) {
        case 0:
            self.cacheDictionaryPath = [[documentsDirectory stringByAppendingString:@"AdvCachedDownloads.dic"] retain];//广告缓存字典
            break;
        case 1:
            self.cacheDictionaryPath = [[documentsDirectory stringByAppendingString:@"ShopCachedDownloads.dic"] retain];//商家缓存字典
            break;
        case 2:
            self.cacheDictionaryPath = [[documentsDirectory stringByAppendingString:@"FoodCachedDownloads.dic"] retain];//食品缓存字典
            break;
        case 3:
            self.cacheDictionaryPath = [[documentsDirectory stringByAppendingString:@"GiftCachedDownloads.dic"] retain];//礼品
            break;
        case 4:
            self.cacheDictionaryPath = [[documentsDirectory stringByAppendingString:@"PopAdvCachedDownloads.dic"] retain];//弹出广告
        case 5:
            self.cacheDictionaryPath = [[documentsDirectory stringByAppendingString:@"FoodTypeCachedDownloads.dic"] retain];//食品分类
            break;
        case 6:
            self.cacheDictionaryPath = [[documentsDirectory stringByAppendingString:@"MyFriendsCachedDownloads.dic"] retain];//好友
            break;
        case 7:
            self.cacheDictionaryPath = [[documentsDirectory stringByAppendingString:@"MessageCachedDownloads.dic"] retain];//消息图片下载
            break;
        case 9:
            self.cacheDictionaryPath = [[documentsDirectory stringByAppendingString:@"ShopCachedDownloadsLogo.dic"] retain];//商家详情背景
            break;
        case 10:
            self.cacheDictionaryPath = [[documentsDirectory stringByAppendingString:@"ShopLogoInOrder.dic"] retain];//商家详情背景
            break;
        case 11:
            self.cacheDictionaryPath = [[documentsDirectory stringByAppendingString:@"ShopCachedDownloadsCoupon.dic"] retain];//商家优惠券
            break;
        case 12:
            self.cacheDictionaryPath = [[documentsDirectory stringByAppendingString:@"ShopTypeCachedDownloads.dic"] retain];//商家分类
            break;
        case 13:
            self.cacheDictionaryPath = [[documentsDirectory stringByAppendingString:dicName] retain];//食品分类
        case 14:
            self.cacheDictionaryPath = [[documentsDirectory stringByAppendingString:@"UserCommandCacheDowloads.dic"] retain];//用户评论相关图片
            break;
        case 15:
            self.cacheDictionaryPath = [[documentsDirectory stringByAppendingString:@"ShopTagCacheDowloads.dic"] retain];//商户图标标签
            break;
            
    }
    
    //创建一个NSFileManager实例
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    //判断是否存在缓存字典的数据
    if ([fileManager fileExistsAtPath:self.cacheDictionaryPath] == YES){
        //NSLog(self.cacheDictionaryPath);
        //加载缓存字典中的数据
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:self.cacheDictionaryPath];
        
        cacheDictionary = [dictionary mutableCopy];
        
        [dictionary release];
        
        //移除没有下载完成的缓存数据
        [self removeCorruptedCachedItems];
        
    } else {
        //创建一个新的缓存字典
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        cacheDictionary = [dictionary mutableCopy];
        [dictionary release];
    }
    [fileManager release];
    
    self.taskArry = [[NSMutableArray alloc] init];
    taskCount = 0;//启动5个任务。
    indexTask = 0;
    countTask = 0;
    
    theLock = [[NSConditionLock alloc] init];
    
    taskLock =[[NSConditionLock alloc] init];
    self.cacheItemArry = [[NSMutableArray alloc] init];
    
    
    self.taskDictionary = [[NSMutableDictionary alloc] init];
    mGroup = dispatch_group_create();
    group = dispatch_group_create();
    
    [self mainThreadKeep];
}

-(id)initWitchReadShopAdvDic:(NSString *)dataid Delegate:(id) deleg{//注意必须在ui线程中调用
    [super init];
    self.delegate = deleg;
    stop = NO;
    pass = NO;
    dowloadType = 13;
    if(self != nil){
        [self initDic:13 name:[NSString stringWithFormat:@"ShopAdvCacheDownloads%@.dic", dataid]];
    }
    return self;
}

-(id)initWitchReadDic:(int)type Delegate:(id) deleg{//注意必须在ui线程中调用
    [super init];
    self.delegate = deleg;
    stop = NO;
    pass = NO;
    dowloadType = type;
    if(self != nil){
        [self initDic:type name:nil];
    }
    
    return self;
}

-(void)changeDowloadType:(int)type
{
    NSString *documentsDirectory = [self documentsDirectoryWithTrailingSlash:YES];
    // dowloadType 生产缓存字典的路径
    dowloadType = type;
    switch (type) {
        case 0:
            self.cacheDictionaryPath = [[documentsDirectory stringByAppendingString:@"AdvCachedDownloads.dic"] retain];//广告缓存字典
            break;
        case 1:
            self.cacheDictionaryPath = [[documentsDirectory stringByAppendingString:@"ShopCachedDownloads.dic"] retain];//商家缓存字典
            break;
        case 2:
            self.cacheDictionaryPath = [[documentsDirectory stringByAppendingString:@"FoodCachedDownloads.dic"] retain];//食品缓存字典
            break;
        case 3:
            self.cacheDictionaryPath = [[documentsDirectory stringByAppendingString:@"GiftCachedDownloads.dic"] retain];//礼品
            break;
        case 4:
            self.cacheDictionaryPath = [[documentsDirectory stringByAppendingString:@"PopAdvCachedDownloads.dic"] retain];//弹出广告
        case 5:
            self.cacheDictionaryPath = [[documentsDirectory stringByAppendingString:@"FoodTypeCachedDownloads.dic"] retain];//食品分类
            break;
        case 6:
            self.cacheDictionaryPath = [[documentsDirectory stringByAppendingString:@"MyFriendsCachedDownloads.dic"] retain];//好友
            break;
        case 7:
            self.cacheDictionaryPath = [[documentsDirectory stringByAppendingString:@"MessageCachedDownloads.dic"] retain];//消息图片下载
            break;
        case 9:
            self.cacheDictionaryPath = [[documentsDirectory stringByAppendingString:@"ShopCachedDownloadsLogo.dic"] retain];//商家详情背景
        case 10:
            self.cacheDictionaryPath = [[documentsDirectory stringByAppendingString:@"ShopLogoInOrder.dic"] retain];//商家详情背景
            break;
    }
    
    //创建一个NSFileManager实例
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    //判断是否存在缓存字典的数据
    if ([fileManager fileExistsAtPath:self.cacheDictionaryPath] == YES){
        //NSLog(self.cacheDictionaryPath);
        //加载缓存字典中的数据
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:self.cacheDictionaryPath];
        
        cacheDictionary = [dictionary mutableCopy];
        
        [dictionary release];
        
        //移除没有下载完成的缓存数据
        [self removeCorruptedCachedItems];
        
    } else {
        //创建一个新的缓存字典
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        cacheDictionary = [dictionary mutableCopy];
        [dictionary release];
    }
    [fileManager release];
}

-(NSString *) addTask:(NSString *)strID url:(NSString *)url showImage:(UIImage *)showImage defaultImg:(NSString *)path indexInGroup:(int)indexInGroup  Goup:(int)groupT{
    //NSString *strID = [NSString stringWithFormat:@"%lld", ID];
    //ImageDowloadTask *t = [self.taskArry ;
    ImageDowloadTask *task;// = [self.taskDictionary objectForKey:strID];
    //if (task == nil) {//没有任务，那么加入
    countTask++;
    task = [[ImageDowloadTask alloc] initWhichURLAndUI:url showImg:showImage dataID:strID defaultImg:path indexInGroup:indexInGroup group:groupT];
    if ([self.taskDictionary objectForKey:strID] == nil) {//保证字典只加入一次
        [self.taskDictionary setObject:@"task" forKey:strID];
    }
    
    [self.taskArry addObject:task];
    [task release];
        
    //}
    
    NSMutableDictionary *dic = [self.cacheDictionary objectForKey:strID];
    if (dic != nil) {
        return [dic objectForKey:@"LocalURL"];
    }
    return nil;
}

-(void)cleanAllTask{
    [self pastTask];
    taskCount = 0;
    countTask = 0;
    startTask = 0;
    indexTask = 0;
    [self.taskDictionary removeAllObjects];
    [self.taskArry removeAllObjects];
}

-(BOOL)getIsStop
{
    return stop;
}


-(void)mainThreadKeep{
    [theLock lock];
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        
        // something
        [theLock lockWhenCondition:1];
        
        [theLock unlockWithCondition:1];
    });
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
        //耗时操作
        //NSLog(@"Start dowload");
        dispatch_async(dispatch_get_main_queue(), ^{//回到ui线程，更新ui
            //更新ui
            [self doTask];
        });
        ///[group release];
    });
}

-(void)startTask{
    pass = NO;
    startTask = indexTask;
    [theLock unlockWithCondition:1];
}

-(void)stopTask{
    stop = YES;
    [taskLock unlockWithCondition:0];
    [theLock unlockWithCondition:1];
    for(int i = 0; i < [self.cacheItemArry count]; i++){
        CacheItem *cache = [self.cacheItemArry objectAtIndex:i];
        cache.isCancel = YES;
    }
    [self.cacheItemArry removeAllObjects];
    
}

-(void)pastTask{
    pass = YES;
    [taskLock unlockWithCondition:0];
    [theLock unlockWithCondition:1];
    
}
/*
-(void)cancelTask{
    [self startTask];
    for(int i = 0; i < [self.cacheItemArry count]; i++){
        CacheItem *cache = [self.cacheItemArry objectAtIndex:i];
        cache.isCancel = YES;
    }
    [self.cacheItemArry removeAllObjects];
}
*/
-(void)doTask{
    if (!stop) {
        if(indexTask < countTask){
            //该程序块在组中所有程序块即将执行完时执行
            //maxThread = MAX_TASK - taskCount;//最大还可以创建多少个线程
            //[theLock lockWhenCondition:1];
            taskCount = countTask - indexTask;//还有多少个任务
            //[theLock unlockWithCondition:1];
            if (taskCount > MAX_TASK) {//剩余任务大于最大允许创建的任务数
                taskCount = MAX_TASK;
            }
            maxThread = taskCount;
            [taskLock lock];
            dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{//并行执行的线程
                [taskLock lockWhenCondition:0];
                [taskLock unlockWithCondition:0];
            });
            dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{//汇总结果
                //耗时操作
                if (self.delegate != nil && !stop && !pass) {
                    [self.delegate cachedDownloadFinish:self.taskArry start:startTask dowType:dowloadType];
                }
                
                NSLog(@"A thread finish Taskcount:%d indexTask:%d", maxThread - taskCount, taskCount);
                dispatch_async(dispatch_get_main_queue(), ^{//回到ui线程，更新ui
                    //更新ui
                    if (self.delegate != nil && !stop && !pass) {
                        [self.delegate updataUI:dowloadType];
                    }
                    [self doTask];//必须主线程中下载创建下载线程
                });
            });
            while(taskCount  > 0){
                ImageDowloadTask *task = [self.taskArry objectAtIndex:indexTask];
                
                [self download:task updateExpiryDateIfInCache:YES isAsny:YES];
                //[task release];
                indexTask++;
                taskCount--;
            }
            
        }else{
            [self mainThreadKeep];
        }
    }
}
//去掉无效的字典
- (void) removeCorruptedCachedItems{
    NSMutableArray *keysToRemove = [NSMutableArray array];
    for (NSMutableDictionary *itemKey in self.cacheDictionary){
        NSMutableDictionary *itemDictionary =
        [self.cacheDictionary objectForKey:itemKey];        
        if ([itemDictionary objectForKey:CachedKeyDownloadEndDate] == nil){
            NSLog(@"This file didn't get downloaded fully. Removing.");
            [keysToRemove addObject:itemKey];
        }
    }    
    [self.cacheDictionary removeObjectsForKeys:keysToRemove];
    
}
//保存字典
-(BOOL) saveCacheDictionary{
    
    BOOL result = NO;
    if ([self.cacheDictionaryPath length] == 0 ||
        self.cacheDictionary == nil){
        return(NO); 
    }
    result = [self.cacheDictionary writeToFile:self.cacheDictionaryPath atomically:YES];    
    return(result);    
}
//获取程序文档路径
- (NSString *) documentsDirectoryWithTrailingSlash:(BOOL)paramWithTrailingSlash{
    
    NSString *result = nil;
    NSArray *documents =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([documents count] > 0){
        result = [documents objectAtIndex:0];
        if (paramWithTrailingSlash == YES){
            result = [result stringByAppendingString:@"/"];
        }
    }
    return(result);
    
}

- (BOOL) download:(ImageDowloadTask *)imageTask updateExpiryDateIfInCache:(BOOL)paramUpdateExpiryDateIfInCache isAsny:(BOOL)isAsny{
    
    BOOL result = NO;
    
    if (self.cacheDictionary == nil /*||
        [paramURLAsString length] == 0*/){
        return(NO);
    }
    
    NSString *paramURLAsString = imageTask.URL;
    //根据url，从字典中获取缓存项的相关数据
    NSMutableDictionary *itemDictionary = [self.cacheDictionary objectForKey:imageTask.ID];
    
    
    BOOL    fileHasBeenCached = NO;//文件是否已经被缓存
    
    BOOL    cachedFileHasExpired = NO;//缓存是否过期
    
    BOOL    cachedFileExists = NO;//缓存文件是否存在
    
    BOOL    cachedFileDataCanBeLoaded = NO;//缓存文件能否被加载
    
    NSData  *cachedFileData = nil;//缓存文件数据
    
    BOOL    cachedFileIsFullyDownloaded = NO;//缓存文件是否完全下载
    
    BOOL    cachedFileIsBeingDownloaded = NO;//缓存文件是否已经下载
    
    NSDate    *expiryDate = nil;//过期时间
    
    NSDate    *downloadEndDate = nil;//下载结束时间
    
    NSDate    *downloadStartDate = nil;//下载开始时间
    
    NSString  *localURL = nil;//本地缓存路径
    NSString *WebURL =nil;//网络地址
    
    NSNumber  *expiresInSeconds = nil;//有效时间
    NSDate    *now = [NSDate date];
    
    if (itemDictionary != nil){
        fileHasBeenCached = YES;
    }
    //如果文件已经被缓存，则从缓存项相关数据中获取相关的值
    if (fileHasBeenCached == YES){
        expiryDate = [itemDictionary objectForKey:CachedKeyExpiryDate];
        downloadEndDate = [itemDictionary objectForKey:CachedKeyDownloadEndDate];
        downloadStartDate = [itemDictionary objectForKey:CachedKeyDownloadStartDate];
        localURL = [itemDictionary objectForKey:CachedKeyLocalURL];
        WebURL = [itemDictionary objectForKey:CachedKeyWebURL];
        expiresInSeconds = [itemDictionary objectForKey:CachedKeyExpiresInSeconds];
        //如果下载开始和结束时间不为空，表示文件全部被下载
        if (downloadEndDate != nil &&
            downloadStartDate != nil){
            cachedFileIsFullyDownloaded = YES;
        }
        
        /* 如果expiresInSeconds不为空，downloadEndDate为空，表示文件已经正在下载 */
        if (expiresInSeconds != nil &&
            downloadEndDate == nil){
            cachedFileIsBeingDownloaded = YES;
        }
        
        /* 判断缓存是否过期 */
        /*if (expiryDate != nil && [now timeIntervalSinceDate:expiryDate] > 0.0){
            cachedFileHasExpired = YES;
        }*/
        //下载连接地址更换，那么图片更换
        if((WebURL == nil && paramURLAsString.length > 0) || [WebURL compare:paramURLAsString] != NSOrderedSame){
            cachedFileHasExpired = YES;
        }
        //下载地址唯空，但是本地已经有缓存
        if(localURL.length > 0 && paramURLAsString.length == 0){
            cachedFileHasExpired = NO;
        }
        if (cachedFileHasExpired == NO){
            /* 如果缓存文件没有过期，加载缓存文件，并且更新过期时间 */
            NSFileManager *fileManager = [[NSFileManager alloc] init];
            
            if ([fileManager fileExistsAtPath:localURL] == YES){//判断文件是否存在
                cachedFileExists = YES;
                cachedFileData = [NSData dataWithContentsOfFile:localURL];
                if (cachedFileData != nil){
                    cachedFileDataCanBeLoaded = YES;
                } /* if (cachedFileData != nil){ */
            } /* if ([fileManager fileExistsAtPath:localURL] == YES){ */
            
            [fileManager release];
            
            /* 更新缓存时间 */
            
            if (paramUpdateExpiryDateIfInCache == YES){
                
                NSDate *newExpiryDate = [NSDate dateWithTimeIntervalSinceNow:20000];
                
                NSLog(@"Updating the expiry date from %@ to %@.", expiryDate, newExpiryDate);
                
                [itemDictionary setObject:newExpiryDate forKey:CachedKeyExpiryDate];
                
                NSNumber *expires = [NSNumber numberWithFloat:20000];
                
                [itemDictionary setObject:expires forKey:CachedKeyExpiresInSeconds];
            }
            //maxThread--;
            
        } /* if (cachedFileHasExpired == NO){ */
        
    }
    
    if (cachedFileIsBeingDownloaded == YES){
        NSLog(@"这个文件已经正在下载...");
        imageTask.locURL = localURL;
        maxThread--;
        if (maxThread == 0) {
            [taskLock unlockWithCondition:0];
        }
        return(YES);
    }
    
    if (fileHasBeenCached == YES){
        
        if (cachedFileHasExpired == NO &&
            cachedFileExists == YES &&
            cachedFileDataCanBeLoaded == YES &&
            [cachedFileData length] > 0 &&
            cachedFileIsFullyDownloaded == YES){
            /* 如果文件有缓存而且没有过期 */
//            NSLog(@"文件有缓存而且没有过期.");
            /*[self.delegate cachedDownloadManagerSucceeded:self remoteURL:[NSURL URLWithString:paramURLAsString]
                                                 localURL:[NSURL URLWithString:localURL]
                                    aboutToBeReleasedData:cachedFileData
                                             isCachedData:YES];*/
            imageTask.locURL = localURL;
            maxThread--;
            if (maxThread == 0) {
                [taskLock unlockWithCondition:0];
            }
            return(YES);
        } else {
            /* 如果文件没有被缓存，获取缓存失败 */
            NSLog(@"文件没有缓存.");
            [self.cacheDictionary removeObjectForKey:paramURLAsString];
            [self saveCacheDictionary];
        } /* if (cachedFileHasExpired == NO && */
        
    } /* if (fileHasBeenCached == YES){ */
    if ([imageTask.URL length] == 0) {
        imageTask.locURL = @"";//
        maxThread--;
        if (maxThread == 0) {
            [taskLock unlockWithCondition:0];
        }
        return NO;
    }
    /* 去下载文件 */
    NSNumber *expires = [NSNumber numberWithFloat:20000];
    NSMutableDictionary *newDictionary = [[[NSMutableDictionary alloc] init] autorelease];
    [newDictionary setObject:expires forKey:CachedKeyExpiresInSeconds];//嵌套字典
    localURL = [paramURLAsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    localURL = [localURL stringByReplacingOccurrencesOfString:@"://" withString:@""];
    localURL = [localURL stringByReplacingOccurrencesOfString:@"/" withString:@"$"];
    localURL = [localURL stringByReplacingOccurrencesOfString:@":" withString:@"$"];
    localURL = [localURL stringByAppendingPathExtension:@"cache"];
    NSString *documentsDirectory = [self documentsDirectoryWithTrailingSlash:NO];
    localURL = [documentsDirectory stringByAppendingPathComponent:localURL];
    [newDictionary setObject:localURL forKey:CachedKeyLocalURL];
    [newDictionary setObject:now forKey:CachedKeyDownloadStartDate];
    [newDictionary setObject:paramURLAsString forKey:CachedKeyWebURL];
    [self.cacheDictionary setObject:newDictionary forKey:imageTask.ID];
    [self saveCacheDictionary];
    imageTask.locURL = localURL;
    
    CacheItem *cacheItem = [[CacheItem alloc] init];
    if(isAsny){
        result = [cacheItem startDownloadingURLAsyn:paramURLAsString delegate:self dataID:imageTask.ID];
        
    }else{
        result = [cacheItem startDownloadingURL:paramURLAsString delegate:self dataID:imageTask.ID];
    }
    [self.cacheItemArry addObject:cacheItem];
    [cacheItem release];
    return result;
}


//缓存项的委托方法
- (void) cacheItemDelegateSucceeded:(CacheItem *)paramSender withRemoteURL:(NSURL *)paramRemoteURL
          withAboutToBeReleasedData:(NSData *)paramAboutToBeReleasedData  dataID:(NSString *)dataID{
    NSLog(@"dowload success:%@", dataID);
    //从缓存字典中获取该缓存项的相关数据
    NSMutableDictionary *dictionary = [self.cacheDictionary objectForKey:dataID];
    //取当前时间
    NSDate *now = [NSDate date];
    //获取有效时间
    NSNumber *expiresInSeconds = [dictionary objectForKey:CachedKeyExpiresInSeconds];
    //转换成NSTimeInterval
    NSTimeInterval expirySeconds = [expiresInSeconds floatValue];
    //修改字典中缓存项的下载结束时间
    [dictionary setObject:[NSDate date] forKey:CachedKeyDownloadEndDate];
    //修改字典中缓存项的缓存过期时间
    [dictionary setObject:[now dateByAddingTimeInterval:expirySeconds] forKey:CachedKeyExpiryDate];
    
    //保存缓存字典
    [self saveCacheDictionary];
    
    NSString *localURL = [dictionary objectForKey:CachedKeyLocalURL];
    
    /* 将下载的数据保存到磁盘 */
    if ([paramAboutToBeReleasedData writeToFile:localURL atomically:YES] == YES){
        NSLog(@"缓存文件到磁盘成功.");
    } else{
        NSLog(@"缓存文件到磁盘失败.");
    }
    maxThread--;
    if (maxThread == 0) {
        [taskLock unlockWithCondition:0];
    }
    //执行缓存管理的委托方法
    /*[self.delegate cachedDownloadManagerSucceeded:self remoteURL:paramRemoteURL
                                         localURL:[NSURL URLWithString:localURL]
                            aboutToBeReleasedData:paramAboutToBeReleasedData
                                     isCachedData:NO];*/
    
    
}

//缓存项失败失败的委托方法
- (void) cacheItemDelegateFailed:(CacheItem *)paramSender remoteURL:(NSURL *)paramRemoteURL
                       withError:(NSError *)paramError  dataID:(NSString *)dataID{
    
    /* 从缓存字典中移除缓存项，并发送一个委托 */
    NSLog(@"文件下载失败.");
    if (self.delegate != nil){
        
//        NSMutableDictionary *dictionary = [self.cacheDictionary objectForKey:[paramRemoteURL absoluteString]];
        
//        NSString *localURL = [dictionary objectForKey:CachedKeyLocalURL];
        
        /*[self.delegate cachedDownloadManagerFailed:self remoteURL:paramRemoteURL
                                          localURL:[NSURL URLWithString:localURL]
                                         withError:paramError];*/
    }
    for (int i = startTask; i < [self.taskArry count]; i++) {
        ImageDowloadTask *task = (ImageDowloadTask *)[self.taskArry objectAtIndex:i];
        if ([task.ID compare:dataID] == NSOrderedSame) {
            task.locURL = nil;
            break;
        }
    }
    [self.cacheDictionary removeObjectForKey:dataID];
    maxThread--;
    if (maxThread == 0) {
        [taskLock unlockWithCondition:0];
    }
    [self.cacheItemArry removeObject:paramSender];
    
}
- (void) dealloc {
    if (cacheDictionary != nil){
        [self saveCacheDictionary];
    }
    [self.cacheItemArry release];
    self.delegate = nil;
    [cacheDictionary release];
    [cacheDictionaryPath release];
    [taskDictionary release];
    [theLock release];
    [taskLock release];
    [self.taskArry release];
    [cacheDictionaryPath release];
    
    [super dealloc];
}
@end
