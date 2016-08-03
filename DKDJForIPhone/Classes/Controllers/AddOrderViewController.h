//
//  AddOrderViewController.h
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-5-18.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterClient.h"
#import "MBProgressHUD.h"
#import "tooles.h"
#import "PayByCardsViewController.h"
#import "HJViewController.h"
#import "UserAddressDetail.h"


#define RegeditViewNumberOfEditableRows        9
#define UserName                0
#define Password                1
#define Email                   2
#define PayInCusterAccount      2//账户余额扣款
#define CusterPicup             1//用户自取
#define UserCoupon              1//使用优惠券
#define RegeditViewLabelTag                    1024

//, UIPickerViewDelegate, UIPickerViewDataSource
@interface AddOrderViewController : HJViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,MBProgressHUDDelegate,UIAlertViewDelegate,UIPickerViewDelegate, UIPickerViewDataSource, NSXMLParserDelegate, PayByCardsViewControllerDelegate, UITextFieldDelegate>
//@interface AddOrderViewController : UITableViewController<UITextFieldDelegate,MBProgressHUDDelegate> 
{
    //President *president;
    NSMutableArray *fieldLabels;
    NSMutableDictionary *tempValues;
    NSMutableArray *stateList;//自取站点列表
    UITextField *textFieldBeingEdited;  
    
    NSString*           shopid;
    TwitterClient*      twitterClient;
    //NSMutableArray      *shopcartDict;//foodid FoodInOrderModel
    UILabel             *shopcartLabel;
    UITableView         *orderTableViewSC;
    
    UIPickerView        *pickerDistribution;//配送方式
    UIPickerView        *pickerPayType;//支付方式
    UIPickerView        *pickerOffline;//线下支付方式
    UIPickerView        *pickerOnline; //线上支付方式
    UIPickerView        *pickerCoupon;//是否使用优惠券
    
    NSArray*     distributionArray;
    NSArray*     payTypeArray;
    NSArray*     offlineArray;
    //NSArray*     onlineArray;
    
    NSString  *distribution;
    NSString  *paytype1;
    NSString  *paytype2;
    
    NSString  *distribution_num;
    NSString  *paytype1_num;
    NSString  *paytype2_num;
    NSString *addrID;
    int nSelectStateIndex;//所选站点
    MBProgressHUD       *_progressHUD;
    
    float sumPriceSC;
    float sentmoney;
    int sumCountSC;
    
    UIToolbar *keyboardToolbar_;
    UIDatePicker *ordertimeDatePicker_;
    NSDate *ordertime_;
    
    NSString            *uduserid;
    
    NSString *ordermodel;
    NSString *orderId;
    
    UIActivityIndicatorView *indicator;
    UIAlertView* unionpayalertView;
    
    UIAlertView* mAlert;
    NSMutableData* mData;
    NSMutableArray *address;//地址簿
    //UITextField *sendTime;//配送时间输入框
    
    NSString*           cardid;
    NSString*           shopcardid;
    NSString *ousername;
    NSString *otel;
    NSString *oaddresse;
    //UITableView *tableView;
    int orderType;//订单类型，0 外卖 1现场点菜
    int isCoupon;//是否使用优惠券 0不使用 1使用
    int payType;//支付方式 0货到付款，1支付宝 2账户余额
    int eatType;//现场点菜类型 0现吃 1预定
    BOOL isShowDatePick;
    BOOL isShowAddressList;//是否显示过地址相关的界面，，列表
    BOOL isShowNewAddress;//包括新增
    int viewHeight;//屏幕的逻辑高度
    int orderTimePickY;//时间选择器y点高度
    int LineCount;
    UITapGestureRecognizer *backClick;
    
    NSMutableArray *couponKeyList;//优惠券编号列表
    NSMutableArray *couponList;//优惠券列表
    int rowStartCoupon;//从哪一行开始输入优惠券
    BOOL isShowSelectCoupon;//是否进入过选择优惠券界面
    LoadCell            *loadCell;
    int COUPON_TAG;//优惠券起始编号tag
    
    int payPasswordTag;
    int remarkTag;
    
    

}
@property (nonatomic, retain) NSString *cardid;
@property (nonatomic, retain) NSString *shopcardid;
@property (nonatomic, retain)NSString *sendTime;//送货时间
@property (nonatomic, retain)NSString *payPassword;//支付密码
@property (nonatomic, retain)NSString *nsRemark;//备注
@property (nonatomic, retain)NSString *couponJSON;//优惠券json格式
- (void)showAlertWait;
- (void)showAlertMessage:(NSString*)msg;
- (void)hideAlert;

- (NSString*)currentUID;

//@property (nonatomic, retain) UIPickerView *pickerAddress;
//@property (nonatomic, retain) NSArray *addressArray;
@property(nonatomic, retain) UIAlertView* unionpayalertView;
@property(nonatomic, retain)UITableView *tableView;
@property (nonatomic, retain) NSString *ordermodel;
@property (nonatomic, retain) NSString *orderId;
@property (nonatomic, retain) NSMutableArray *fieldLabels;
@property (nonatomic, retain) NSMutableDictionary *tempValues;
@property (nonatomic, retain) UITextField *textFieldBeingEdited;
@property (nonatomic, retain) NSString *shopid;
//@property (nonatomic, retain) NSMutableArray *shopcartDict;//购物车
@property (nonatomic, retain) UILabel *shopcartLabel;
@property (nonatomic, retain) UITableView *orderTableView;

@property (nonatomic, retain) UIDatePicker *ordertimeDatePicker;
@property(nonatomic, retain) NSDate *ordertime;
@property(nonatomic, retain) UIToolbar *keyboardToolbar;

@property (nonatomic, retain) NSString              *uduserid;

@property (nonatomic, retain) UIPickerView *pickerDistribution;
@property (nonatomic, retain) UIPickerView *pickerPayType;
@property (nonatomic, retain) UIPickerView *pickerOffline;
@property (nonatomic, retain) UIPickerView *pickerOnline;
@property (nonatomic, retain) UIPickerView *pickerCoupon;//地址簿
@property (nonatomic, retain) NSMutableArray *address;//地址簿

@property (nonatomic, retain) NSArray *distributionArray;
@property (nonatomic, retain) NSArray *payTypeArray;
@property (nonatomic, retain) NSArray *offlineArray;
@property (nonatomic, retain) NSArray *couponArray;//是否使用优惠券

@property (nonatomic, retain) NSString  *distribution;
@property (nonatomic, retain) NSString  *paytype1;
@property (nonatomic, retain) NSString  *paytype2;

@property (nonatomic, retain) NSString  *distribution_num;
@property (nonatomic, retain) NSString  *paytype1_num;
@property (nonatomic, retain) NSString  *paytype2_num;
@property(nonatomic, retain)NSString *ousername;
@property(nonatomic, retain)NSString *otel;
@property(nonatomic, retain)NSString *oaddresse;

-(void)cancel:(id)sender;
-(void)save:(id)sender;
-(void)textFieldDone:(id)sender;

-(id)initWithShopId:(NSString*)ShopId;
-(void) UpdateShopCart;
- (void)setOrderTime;
//-(void) showPickerView;
//-(void) hidePickerView;
- (void)resignKeyboard:(id)sender;
- (void)previousField:(id)sender;
- (void)nextField:(id)sender;
- (id)getFirstResponder;
- (void)animateView:(NSUInteger)tag;
- (void)checkBarButton:(NSUInteger)tag;
- (void)checkSpecialFields:(NSUInteger)tag;

-(void)animateTextField:(UITextField *)textField up:(BOOL)up;
-(void)addorderDidReceive:(TwitterClient*)client obj:(NSObject*)obj;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

- (BOOL)IsLogin;
- (void)refreshFields;
@end