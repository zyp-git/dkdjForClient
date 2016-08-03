//
//  AlertTableViewController.h
//  TSYP
//
//  Created by wulin on 13-6-13.
//
//

#import <UIKit/UIKit.h>

@interface AlertTableViewController : UIViewController <UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource> {
    UITableView *myTableView;
    NSArray *array;
    NSIndexPath *lastIndexPath;
}
@property (nonatomic, retain) NSIndexPath *lastIndexPath;

- (IBAction)btnClick:sender;
@end
