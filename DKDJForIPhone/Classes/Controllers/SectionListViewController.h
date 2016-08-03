//
//  SectionListViewController.h
//  RenRenzx
//
//  Created by zhengjianfeng on 12-10-4.
//
//

#import <UIKit/UIKit.h>

#import "LoadCell.h"
#import "MBProgressHUD.h"
#import "ASIHttpHeaders.h"
#import "CJSONDeserializer.h"
#import "CircleListViewController.h"
#import "CachedDownloadManager.h"
#import "HJTableViewController.h"

@interface SectionListViewController : HJTableViewController<MBProgressHUDDelegate>
{
    BOOL                hasMore;
    LoadCell            *loadCell;
    MBProgressHUD       *_progressHUD;
    
    NSMutableArray          *list;
    BOOL                    refreshing;
    NSInteger               pageindex;
    NSInteger               pagesize;
    NSInteger               pagecount;
    
    //http 请求
    ASIHTTPRequest          *asiRequest;
}

@property (nonatomic, retain) NSMutableArray *list;
@property (nonatomic,retain) ASIHTTPRequest *asiRequest;

@property (nonatomic) BOOL refreshing;
@property (assign,nonatomic) NSInteger pageindex;
@property (assign,nonatomic) NSInteger pagesize;
@property (assign,nonatomic) NSInteger pagecount;
@property (nonatomic, retain) NSString *defaultPath;
@property (nonatomic, retain) CachedDownloadManager*  imageDownload;

- (id)initWithGetDat;

@end