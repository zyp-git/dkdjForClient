//
//  DBHelper.h
//  zz4iPhone
//
//  Created by Wu on 9/1/12.
//
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "MyFriends.h"

@interface DBHelper : UIView
{
    sqlite3 *database;
}
-(id)initOpenDataBase;
-(NSInteger)CreateTable;

-(BOOL)insertFriend:(MyFriends *)myFriend;
-(NSMutableArray *)getAllFriends;
-(NSMutableArray *) getFriends:(NSString *)addr;
-(BOOL)cleanTable;//清空表数据
-(BOOL)updateFriend:(MyFriends *)myFriend;
-(BOOL)delFriend:(MyFriends *)myFriend;

@end
