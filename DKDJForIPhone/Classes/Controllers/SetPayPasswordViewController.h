//
//  SetPayPasswordViewController.h
//  RenRenzx
//
//  Created by zhengjianfeng on 13-3-13.
//
//

#import <UIKit/UIKit.h>

#import "TwitterClient.h"
#import "MBProgressHUD.h"
#import "HJViewController.h"

#define RegeditViewNumberOfEditableRows        3

#define RegeditViewLabelTag  1024

@interface SetPayPasswordViewController : HJViewController<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate, MBProgressHUDDelegate>
{
    NSArray *fieldLabels;
    NSMutableDictionary *tempValues;
    UITextField *textFieldBeingEdited;
    
    NSString*           userid;
    TwitterClient*      twitterClient;
    
    UITableView         *orderTableViewSC;
    
    MBProgressHUD       *_progressHUD;
    
    NSDictionary        *dic;
}

@property (nonatomic, retain) NSString              *userid;
@property (nonatomic, retain) NSDictionary          *dic;
@property (nonatomic, retain) NSArray               *fieldLabels;
@property (nonatomic, retain) NSMutableDictionary   *tempValues;
@property (nonatomic, retain) UITextField           *textFieldBeingEdited;
@property (nonatomic, retain) UITableView           *orderTableView;

-(void)cancel:(id)sender;
-(void)save:(id)sender;
-(void)textFieldDone:(id)sender;

-(id)initUserInfo;

-(void)animateTextField:(UITextField *)textField up:(BOOL)up;

@end