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
#import "HJTextView.h"
#define RegeditViewNumberOfEditableRows        3

#define RegeditViewLabelTag  1024

@interface AddOrderToServerNewViewController : HJViewController<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate, MBProgressHUDDelegate, UITextViewDelegate>
{
    
    
    
   
    TwitterClient*      twitterClient;
    
   
    
    MBProgressHUD       *_progressHUD;
    
    
    BOOL isPayPassword;//是否为支付密码
    
    UITapGestureRecognizer *backClick;
    int startTag;
    int LineCount;
    
    int addrType;//1 地图地址 2地址库
    int sendType;//1 配送 2自取
    int sendTimeType;
    int payType;//4货到付款 1支付寶 3账户余额
    
    UIDatePicker *ordertimeDatePicker;//时间选择器
    NSMutableArray *address;
    
    BOOL isShowAddressList;//是否进入过选地址界面
    BOOL isShowNewAddress;//是否新增过地址
    UIScrollView *scrollView;
    BOOL addOrderSucess;
    UIButton *btnAddNewAddr;
    //NSString *payPassword;
    BOOL isGotoPay;
}
@property (nonatomic,assign) SEL result;//这里声明为属性方便在于外部传入。支付宝
@property (nonatomic, retain) NSString              *userid;
@property (nonatomic, retain) NSString              *userName;
@property (nonatomic, retain) NSString              *orderId;
@property (nonatomic, retain) NSString              *payId;//支付编号
@property(nonatomic, retain) UIToolbar *keyboardToolbar;
@property (nonatomic, copy)NSString *payPassword;

@property(nonatomic, retain) UIButton *btnPayMoeny;//货到付款
@property(nonatomic, retain) UIButton *btnPayAccount;//账户余额
@property(nonatomic, retain) UIButton *btnPayAlipay;//支付宝
@property(nonatomic, retain) UIButton *btnPayWXpay;//微信支付
@property (nonatomic, retain) UIImageView *bgView;
@property (nonatomic, retain) HJTextView *tfAddress;
@property (nonatomic, retain) HJTextView *tfGPSAddress;
@property (nonatomic, retain) HJTextView *tfReciver;
@property (nonatomic, retain) HJTextView *tfPhone;
@property (nonatomic, retain) HJTextView *tfPayPassword;
@property (nonatomic, retain) HJTextView *tfTime;
@property (nonatomic, retain) HJTextView *tfRemark;
@property (nonatomic, retain) HJTextView *tfPeople;//预约人数
@property (nonatomic, assign)float payMoney;//在线支付金额



-(void)cancel:(id)sender;
-(void)save:(id)sender;
-(void)textFieldDone:(id)sender;

-(id)initUserInfo:(BOOL)isPay;

-(void)animateTextField:(UITextView *)textField up:(BOOL)up;

@end