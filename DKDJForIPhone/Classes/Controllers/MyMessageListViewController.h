//
//  MyMessageListViewController.h
//  HMBL
//
//  Created by ihangjing on 14-1-9.
//
//

#import "HJViewController.h"
#import "MBProgressHUD.h"
#import "TwitterClient.h"
#import "CachedDownloadManager.h"
#import "NSAttributedString+Attributes.h"
#import "MarkupParser.h"
#import "OHAttributedLabel.h"
#import "CustomMethod.h"
#import "LoadCell.h"
@interface MyMessageListViewController : HJViewController<UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate, UITextFieldDelegate, OHAttributedLabelDelegate, UITextViewDelegate>
{
    TwitterClient       *twitterClient;
    MBProgressHUD       *_progressHUD;
    CachedDownloadManager *frImageDowload;
    CachedDownloadManager *msgImageDowload;
    int viewHeight;
    int pageIndex;
    int currentIndexRow;
    OHAttributedLabel *currentLabel;
    int page;
    int total;
    BOOL lastHiden;//记录上次loadcell是否隐藏
    UITapGestureRecognizer *backClick;
}
@property(nonatomic, retain)UITableView *tableView;
@property(nonatomic, retain)UITextView *tfSendMessage;//发送消息输入框
@property(nonatomic, retain)UIButton *btnSend;//发送消息按钮
@property(nonatomic, retain)NSMutableArray *messageArry;//消息队列
@property (nonatomic, strong) NSMutableArray *m_rowHeights;//高度
@property (nonatomic, strong) NSMutableArray *m_labelArray;//lbale队列
@property (nonatomic, strong) NSDictionary *m_emojiDic;
@property(nonatomic, retain)NSString *userID;
@property (nonatomic, retain)LoadCell            *msgLoadCell;

-(MyMessageListViewController *)initWithcUserID:(NSString *)userid;
@end
