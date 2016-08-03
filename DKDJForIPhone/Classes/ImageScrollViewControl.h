//
//  ImageScrollViewControl.h
//  TSYP
//
//  Created by wulin on 13-6-3.
//
//

#import <UIKit/UIKit.h>
#import "CachedDownloadManager.h"
#import "ImageScrollViewControlDelegate.h"
#import "TwitterClient.h"
#import "HJScrollView.h"
#import "DDProgressView.h"
#import "MBProgressHUD.h"
//弃用类
@interface ImageScrollViewControl : UIView<UIScrollViewDelegate, MBProgressHUDDelegate> {
    UIImageView *backgroundImage3;
    UIImageView *backgroundImage1;
    UIImageView *backgroundImage2;
    
    UIView *backGroud;//背景色
    UIView *backGroud3;
    UIView *backGroud1;
    UIView *backGroud2;
    
    UIImageView *b3Img1;
    UIImageView *b3Img2;
    UIImageView *b3Img3;
    UIImageView *b3Img4;
    UIImageView *b3Img5;
    UIImageView *b3Img6;
    
    UIImageView *b1Img1;
    UIImageView *b1Img2;
    UIImageView *b1Img3;
    UIImageView *b1Img4;
    UIImageView *b1Img5;
    UIImageView *b1Img6;
    
    UIImageView *b2Img1;
    UIImageView *b2Img2;
    UIImageView *b2Img3;
    UIImageView *b2Img4;
    UIImageView *b2Img5;
    UIImageView *b2Img6;
    
    HJScrollView *scrollView;
    UIPageControl *pageControl;
    NSMutableArray *viewList;
    
    NSTimer *timer;
    
    int pageCount;
    int currentPhotoNum;
    int advType;//0普通广告，1推荐食品
    int rollType;//0隐现方式切换，1 滚动方式切换
    int showIndex;//切换现实效果时，当前现实的是第几个，开始为1
    BOOL leftOrRight;//向左或右
    
    UITapGestureRecognizer *imgClick;
    UITapGestureRecognizer *bgClick;
    
    UILabel *name3;
    UILabel *price3;
    UILabel *name1;
    UILabel *name2;
    UILabel *price1;
    UILabel *price2;
    
    
    
    MBProgressHUD * _progressHUD;
    id delegate;
    
    BOOL isStartTick;//是否开始播放
   // UIButton *Btn1;
   // UIButton *Btn2;
    NSString *DataID;
    
}

@property (nonatomic, retain) NSMutableArray *pages;
@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, retain) CachedDownloadManager *imageDowload;
@property (nonatomic, retain) TwitterClient *twitterClient;
@property (nonatomic, retain)DDProgressView *progressView;//进度条
@property (nonatomic)CGFloat startP;//进度条步长
@property (nonatomic)CGFloat nowP;//当前进度


//scoType 图片切换模式
-(void)getDataFormeNet;
- (id)initWithFrame:(CGRect)frame type:(int)Type  Delegate:(id)Delegate data:(NSMutableArray *)arry scoType:(int)scoType dataID:(NSString *)dataid;
-(void)startPlay;
@end
