//
//  ChangePasswordViewController.h
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-2.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TwitterClient.h"
#import "MBProgressHUD.h"
#import "HJViewController.h"
#import "CachedDownloadManager.h"

#define RegeditViewNumberOfEditableRows        3

#define RegeditViewLabelTag  1024

@interface OrderDetailNewViewController : HJViewController<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate, MBProgressHUDDelegate>
{

    TwitterClient*      twitterClient;
    MBProgressHUD       *_progressHUD;
    UITapGestureRecognizer *backClick;
    NSMutableArray *foods;
    int startTag;
    int LineCount;
    CachedDownloadManager *imageDownload;
    int payStatus;//支付状态
    float payMoeny;//在线支付金额
    float foodMoeny;//
    float totalMoney;//订单总金额
    float cardPayMoney;//优惠券支付
    float countMoney;//促销优惠金额
    float sendMoney;//配送费
    float packetFee;//打包费
    BOOL isInitionView;
    UIScrollView *scrollView;

    int orderState;
    int sendState;
    int payMode;//支付方式
    UIButton *btnPay;
    
}
@property (nonatomic,assign) SEL result;//这里声明为属性方便在于外部传入。支付宝
@property (nonatomic, retain) UIButton  *btnPayOnLine;//支付按钮
@property (nonatomic, retain) NSString  *orderID;
@property (nonatomic, retain) NSString  *userName;
@property (nonatomic, retain) NSString  *userid;
@property (nonatomic, retain) NSString  *payId;
@property (nonatomic, retain) UIToolbar *keyboardToolbar;
@property (nonatomic, retain) NSDictionary *dic;


-(void)cancel:(id)sender;
-(void)save:(id)sender;
-(void)textFieldDone:(id)sender;
-(void)initView:(NSDictionary *)json;
- (id)initOrderID:(NSString *)orderid;
- (id)initWithGotoCommandDetailWith:(NSString *)orderid;

-(void)animateTextField:(UITextField *)textField up:(BOOL)up;

@end