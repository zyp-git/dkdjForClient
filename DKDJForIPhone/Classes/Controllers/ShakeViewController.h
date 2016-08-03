//
//  ShakeViewController.h
//  IBogu
//
//  Created by ihangjing on 13-10-18.
//
//

#import "HJViewController.h"
#import "ShakeItemViewController.h"
#import "TwitterClient.h"

@interface ShakeViewController : HJViewController<UIAccelerometerDelegate, MBProgressHUDDelegate, UIGestureRecognizerDelegate>
{
    ShakeItemViewController * start;
    UILabel *lable;
    TwitterClient       *twitterClient;
    MBProgressHUD       *_progressHUD;
    NSInteger shakeCount;
    
    NSDate *shakeStart;
    
    NSString *shopID;
    BOOL isShow;
    UIAccelerometer *accelerometer;
    
}
@property (nonatomic, retain)NSString *shopID;

@end
