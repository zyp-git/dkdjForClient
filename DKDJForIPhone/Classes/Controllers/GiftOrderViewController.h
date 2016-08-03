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

#define RegeditViewNumberOfEditableRows        9
#define UserName                0
#define Password                1
#define Email                   2

#define RegeditViewLabelTag                    1024

//, UIPickerViewDelegate, UIPickerViewDataSource
@interface GiftOrderViewController : HJViewController<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,MBProgressHUDDelegate,UIAlertViewDelegate,UIPickerViewDelegate, UIPickerViewDataSource, NSXMLParserDelegate, PayByCardsViewControllerDelegate>
//@interface AddOrderViewController : UITableViewController<UITextFieldDelegate,MBProgressHUDDelegate> 
{
    //President *president;
    NSMutableArray *fieldLabels;
    NSMutableDictionary *tempValues;
    UITextField *textFieldBeingEdited;  
    
    NSString*           lotterID;
    TwitterClient*      twitterClient;
    
    UITableView         *orderTableViewSC;
    
    UIPickerView        *pickerDistribution;//配送方式(送货，自取)
    UIPickerView        *pickerSTime;//去送货时间（不限，周一-周五，周末）
    
    
    NSArray*     distributionArray;
    NSArray*     payTypeArray;
    //NSArray*     onlineArray;
    
 
    
    MBProgressHUD       *_progressHUD;
    
    float sumPriceSC;
    int sentmoney;
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
    

    NSString *ousername;
    NSString *otel;
    NSString *oaddresse;
    UITableView *tableView;
    int orderType;//订单类型，0 兑换 1 抽奖
    int sendType;//支付方式 2送货 1自取
    int sentTime;//取送货时间 0不限 1周一-周五 2周末
    int gType;//礼品的类型
    BOOL isSubmit;
    UITapGestureRecognizer *backClick;
}

@property (nonatomic, retain) UITableView *tableView;

- (void)showAlertWait;
- (void)showAlertMessage:(NSString*)msg;
- (void)hideAlert;

- (NSString*)currentUID;

//@property (nonatomic, retain) UIPickerView *pickerAddress;
//@property (nonatomic, retain) NSArray *addressArray;
@property(nonatomic, retain) UIAlertView* unionpayalertView;

@property (nonatomic, retain) NSString *ordermodel;
@property (nonatomic, retain) NSString *orderId;
@property (nonatomic, retain) NSMutableArray *fieldLabels;
@property (nonatomic, retain) NSMutableDictionary *tempValues;
@property (nonatomic, retain) UITextField *textFieldBeingEdited;
@property (nonatomic, retain) NSString *lotterID;
@property (nonatomic, retain) UITableView *orderTableView;

@property (nonatomic, retain) UIDatePicker *ordertimeDatePicker;
@property(nonatomic, retain) NSDate *ordertime;
@property(nonatomic, retain) UIToolbar *keyboardToolbar;

@property (nonatomic, retain) NSString              *uduserid;

@property (nonatomic, retain) UIPickerView *pickerDistribution;
@property (nonatomic, retain) UIPickerView *pickerSTime;

@property (nonatomic, retain) NSArray *distributionArray;
@property (nonatomic, retain) NSArray *payTypeArray;
//@property (nonatomic, retain) NSArray *onlineArray;

@property(nonatomic, retain)NSString *ousername;
@property(nonatomic, retain)NSString *otel;
@property(nonatomic, retain)NSString *oaddresse;
@property(nonatomic, retain)NSString *GName;
@property(nonatomic, retain)NSString *GPoint;

-(void)cancel:(id)sender;
-(void)save:(id)sender;
-(void)textFieldDone:(id)sender;

- (id)initWithLotterID:(NSString*)rid gName:(NSString *)name gPoint:(NSString *)point;
- (id)initWithCart:(NSString *)gID GName:(NSString *)name gPoint:(NSString *)point GType:(int)type;
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