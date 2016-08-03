//
//  CommendDetailViewController.h
//  HMBL
//
//  Created by ihangjing on 13-11-26.
//
//

#import "HJViewController.h"
#import "DYRateView.h"
#import "TwitterClient.h"
#import "FoodInOrderModelFix.h"
@interface CommendDetailViewController : HJViewController<MBProgressHUDDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

{
    UITapGestureRecognizer *backClick;
    DYRateView * star;
    
    UITextField *commentValue;
    TwitterClient       *twitterClient;
    MBProgressHUD       *_progressHUD;
    
    FoodInOrderModelFix *foodModel;
    NSString *orderID;
    int sg;
    int fg;
    int og;
    UIButton *btnComment;//记录传过来的button，评论成功那么修改
    UIImageView *userICON;//图片
    UITapGestureRecognizer *imgClick;
    UIImagePickerController *imagePicker;
}
@property (nonatomic, retain) NSString *myICONet;//我的图片网络地址
@property (nonatomic, retain) NSString *imgExt;//图片扩展名
@property (nonatomic, retain) NSString *commandID;//评论编号
@property (nonatomic, retain) NSString *myICOPath;//我的图片本地地址
@property (nonatomic, retain) UIImage *myICO;//我的图片
-(CommendDetailViewController *)initWithFood:(FoodInOrderModelFix *)food orderID:(NSString *)orderid;
@end
