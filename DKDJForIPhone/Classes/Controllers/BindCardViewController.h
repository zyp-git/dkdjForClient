//
//  BindCardViewController.h
//  RenRenzx
//
//  Created by zhengjianfeng on 12-10-6.
//
//

#import <UIKit/UIKit.h>

#import "GradientButton.h"
#import "MBProgressHUD.h"
#import "ASIHttpHeaders.h"
#import "CJSONDeserializer.h"
#import "MyAddressLabel.h"
#import "HJViewController.h"

#define kNumberOfEditableRows        2
#define LoginUserName                0
#define LoginPassword                1

#define kLabelTag                    4096

@interface BindCardViewController : HJViewController <MBProgressHUDDelegate,UIScrollViewDelegate>
{
    NSString            *_userName;
    NSString            *_password;
    
    MyAddressLabel *addressText;
    UIToolbar *keyboardToolbar_;
    //http 请求
    ASIHTTPRequest      *asiRequest;
    MBProgressHUD       *_progressHUD;
}

@property(nonatomic, retain) UIToolbar *keyboardToolbar;

@property (nonatomic, retain) NSString              *_userName;
@property (nonatomic, retain) NSString              *_password;
@property(nonatomic,retain) ASIHTTPRequest *asiRequest;
@property (nonatomic, retain) MyAddressLabel *addressText;

- (void)cancel:(id)sender;
- (void)save:(id)sender;
- (void)goregister:(id)sender;


- (void)resignKeyboard:(id)sender;
- (void)previousField:(id)sender;
- (void)nextField:(id)sender;
- (id)getFirstResponder;
- (void)animateView:(NSUInteger)tag;
- (void)checkBarButton:(NSUInteger)tag;
- (void)checkSpecialFields:(NSUInteger)tag;

-(void) GetErr:(ASIHTTPRequest *)request;
-(void) GetResult:(ASIHTTPRequest *)request;

@end

