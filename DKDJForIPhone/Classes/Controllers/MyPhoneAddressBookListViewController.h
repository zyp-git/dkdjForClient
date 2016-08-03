//
//  MyPhoneAddressBook.h
//  HMBL
//
//  Created by ihangjing on 13-12-19.
//
//

#import "HJTableViewController.h"
#import "DBHelper.h"
#import "TwitterClient.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
@interface MyPhoneAddressBookListViewController : HJTableViewController<MBProgressHUDDelegate>
{
    UITapGestureRecognizer *backClick;
    NSString *userID;
    DBHelper *db;
    TwitterClient       *twitterClient;
    MBProgressHUD       *_progressHUD;
    int pageCount;
    //BOOL requst;
    //ABAddressBookRef addressBook;
    
    __block dispatch_group_t group;
    
    NSString *checkValue;
    BOOL runThread;
    int pageIndex;
    NSInteger prevCount;
    NSConditionLock *theLock;
}
@property (nonatomic, retain) NSMutableArray *MyPhoneBookList;
//@property (nonatomic, retain) NSConditionLock *theLock;
//@property (nonatomic, retain) NSConditionLock *taskLock;
-(MyPhoneAddressBookListViewController *)initWithUserid:(NSString *)userid;
@end
