//
//  UserAddressDetailViewController.h
//  TSYP
//
//  Created by wulin on 13-9-9.
//
//

#import <UIKit/UIKit.h>
#import "HJTableViewController.h"
#import "TwitterClient.h"
#import "SearchOnMapViewController.h"
#import "UserAddressMode.h"

@interface UserAddressDetailViewController : HJViewController<UITextInputDelegate, MBProgressHUDDelegate, UIAlertViewDelegate,SearchOnMapViewControllerDelegate>
{
    NSArray *array;

    NSString *btnTitle;

    NSString *uduserid;
    
    TwitterClient*      twitterClient;
    MBProgressHUD       *_progressHUD;
    int Type;
    NSString *userName;
    NSString *userPhone;
    NSString *userAddr;
    NSString *userArea;
    
    BOOL bShowMap;
    NSString *shopID;
    UITapGestureRecognizer *backClick;
    
}
@property (nonatomic,strong) UserAddressMode * model;
@property (nonatomic,assign) int editType;
-(id)initWithEdit;
-(id)initDefault;
-(id)initWithShopID:(NSString *)sid;
@end
