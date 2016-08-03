//
//  PayByCardsViewController.h
//  RenRenzx
//
//  Created by zhengjianfeng on 13-3-7.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "GradientButton.h"
#import "MBProgressHUD.h"
#import "ASIHttpHeaders.h"
#import "CJSONDeserializer.h"
#import "MyAddressLabel.h"
#import "PayByCardViewController.h"
#import "PayByShopCardViewController.h"
#import "HJViewController.h"

#define kNumberOfEditableRows        2
#define LoginUserName                0
#define LoginPassword                1

#define kLabelTag                    4096
 
@protocol PayByCardsViewControllerDelegate <NSObject>

- (void) PayByCardsViewControllerValueChanged:(NSString*)paypassword shopcardids:(NSString*)shopcardids cardids:(NSString*)cardids;

@end

@interface PayByCardsViewController : HJViewController <MBProgressHUDDelegate,UIScrollViewDelegate,SelectCardViewControllerDelegate,SelectShopCardViewControllerDelegate>
{
    NSString            *_userName;
    NSString            *_password;
    
    NSString            *code;
    NSString            *cmoney;
    
    NSString            *shopcardcode;
    NSString            *shopcardcmoney;
    
    NSString            *cardid;
    NSString            *shopcardid;
    
    NSString            *paypassword;
    
    UIToolbar *keyboardToolbar_;
    //http 请求
    ASIHTTPRequest      *asiRequest;
    MBProgressHUD       *_progressHUD;
}

@property(nonatomic, retain) UIToolbar *keyboardToolbar;
@property(nonatomic, retain) UIToolbar *keyboardToolbarfix;

@property (nonatomic, retain) NSString              *_userName;
@property (nonatomic, retain) NSString              *_password;

@property (nonatomic, retain) NSString              *code;
@property (nonatomic, retain) NSString              *cmoney;
@property (nonatomic, retain) NSString              *paypassword;

@property (nonatomic, retain) NSString              *shopcardcode;
@property (nonatomic, retain) NSString              *shopcardcmoney;
@property (nonatomic, retain) NSString              *cardid;
@property (nonatomic, retain) NSString              *shopcardid;

@property(nonatomic,retain) ASIHTTPRequest *asiRequest;
@property (nonatomic, retain) MyAddressLabel *addressText;

@property (nonatomic, retain) id<PayByCardsViewControllerDelegate> delegate;

- (void)cancel:(id)sender;
//- (void)save:(id)sender;
//- (void)goregister:(id)sender;


- (void)resignKeyboard:(id)sender;
- (void)previousField:(id)sender;
//- (void)nextField:(id)sender;
//- (id)getFirstResponder;
- (void)animateView:(NSUInteger)tag;
- (void)checkBarButton:(NSUInteger)tag;
- (void)checkSpecialFields:(NSUInteger)tag;

//-(void) GetErr:(ASIHTTPRequest *)request;
//-(void) GetResult:(ASIHTTPRequest *)request;

@end
