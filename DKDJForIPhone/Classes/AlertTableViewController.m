//
//  AlertTableViewController.m
//  TSYP
//
//  Created by wulin on 13-6-13.
//
//

#import "AlertTableViewController.h"
#import "UIAlertTableView.h"

@implementation AlertTableViewController
@synthesize lastIndexPath;

- (void)viewDidLoad {
    array = [[NSArray alloc] initWithObjects:@"test1", @"test2", @"test3", @"test4", nil];
    [super viewDidLoad];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    NSUInteger row = [indexPath row];
    NSUInteger oldRow = [lastIndexPath row];
    cell.textLabel.text = [array objectAtIndex:row];
    cell.accessoryType = (row == oldRow && lastIndexPath != nil) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger newRow = [indexPath row];
    NSInteger oldRow = [lastIndexPath row];
    if ((newRow == 0 && oldRow == 0) || (newRow != oldRow)){
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath: lastIndexPath];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        lastIndexPath = [indexPath retain];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)btnClick:sender
{
    UIAlertTableView *alert = [[UIAlertTableView alloc] initWithTitle:@"Select Option"
                                                              message:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                                    otherButtonTitles:@"Do", nil];
    alert.tableDelegate = self;
    alert.dataSource = self;
    alert.tableHeight = 120;
    [alert show];
    [alert release];
}

- (void)dealloc {
    [lastIndexPath release];
    [array release];
    [super dealloc];
}
@end
