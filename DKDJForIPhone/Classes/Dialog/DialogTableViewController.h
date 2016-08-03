//
//  DialogTableViewController.h
//  TSYP
//
//  Created by wulin on 13-6-12.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface DialogTableViewController : UIAlertView<UITableViewDataSource,UITableViewDelegate>
- (id)initWithData:(NSMutableArray *)data Title:(NSString *)title;
@end
