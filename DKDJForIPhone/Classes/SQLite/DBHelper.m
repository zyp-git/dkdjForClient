//
//  DBHelper.m
//  zz4iPhone
//
//  Created by Wu on 9/1/12.
//
//

#import "DBHelper.h"

@implementation DBHelper

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (NSString *) documentsDirectoryWithTrailingSlash:(BOOL)paramWithTrailingSlash{
    
    NSString *result = nil;
    NSArray *documents =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([documents count] > 0){
        result = [documents objectAtIndex:0];
        if (paramWithTrailingSlash == YES){
            result = [result stringByAppendingString:@"/"];
        }
    }
    return(result);
    
}
-(id)initOpenDataBase
{
    self = [super init];
    if(self)
    {
        //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *Path = [self documentsDirectoryWithTrailingSlash:YES];
        //Path = [paths objectAtIndex:0];
       // NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *dabaName = [NSString stringWithFormat:@"%@db.plist", Path ];//[NSString stringWithFormat:@"%@.plist", [infoDictionary objectForKey:@"CFBundleDisplayName"] ];
        
        if(sqlite3_open([dabaName UTF8String], &database) != SQLITE_OK)
        {
            sqlite3_close(database);
            self = nil;
        }
        /*[paths release];
        [Path release];*/
    }
    return self;
}

-(NSInteger)CreateTable
{
    char *sql = "create table if not exists MyFriends(id integer primary key autoincrement, friendID integeer, name text, icon text, phone varchar(15))";
    char *sql1 = "create table if not exists MyPhoneAddressBook(id integer primary key autoincrement, name text, phone varchar(15), type integet)";
    char *err;
    if(sqlite3_exec(database, sql, NULL, NULL, &err) != SQLITE_OK)
    {
        return 0;
    }
    if(sqlite3_exec(database, sql1, NULL, NULL, &err) != SQLITE_OK)
    {
        return 0;
    }
    return 1;
}





-(sqlite3_stmt *)exesql:(const char *)sql
{
    //
    sqlite3_stmt *stmt;
    if(SQLITE_OK == sqlite3_prepare_v2(database, sql, -1, &stmt, nil))
    {
        return stmt;
    }
    return nil;
}

-(BOOL)Exit:(const char *)sql
{
    sqlite3_stmt *stmt;
    BOOL result = NO;
    if(SQLITE_OK == sqlite3_prepare_v2(database, sql, -1, &stmt, nil))
    {
        while(sqlite3_step(stmt) == SQLITE_ROW)
        {
            result = YES;
        }
        sqlite3_finalize(stmt);
        
    }
    return result;
}

-(NSMutableArray *) getFriends:(NSString *)addr
{
    //
    addr = [addr stringByReplacingOccurrencesOfString:@"'" withString:@""];
    NSMutableArray *ary = [[NSMutableArray alloc] init];
    NSString *sql = [[[[@"select * from MyFriends where name like '%" stringByAppendingString:addr] stringByAppendingString:@"%' or phone like '%"] stringByAppendingString:addr]  stringByAppendingString:@"%'"];
    sqlite3_stmt *stmt = [self exesql:[sql UTF8String]];
    if(stmt)
    {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            int dataid = sqlite3_column_int(stmt, 0);
            int friendid = sqlite3_column_int(stmt, 1);
            
            char *name = (char *)sqlite3_column_text(stmt, 2);
            char *icon = (char *)sqlite3_column_text(stmt, 3);
            char *phone = (char *)sqlite3_column_text(stmt, 4);
            MyFriends *addr = [[MyFriends alloc] initWitchId:dataid frinedId:friendid name:[[NSString alloc] initWithUTF8String:name] phone:[[NSString alloc] initWithUTF8String:phone] icon:[[NSString alloc] initWithUTF8String:icon]];
            [ary addObject:addr];
            [addr release];
        }
        sqlite3_finalize(stmt);
    }
    return ary;
    
}

-(BOOL)checkFrined:(MyFriends *)myFriend
{
    NSString *sql = [@"select * from MyFriends where friendID=" stringByAppendingFormat:@"%d", myFriend.friendID];
    sqlite3_stmt *stmt = [self exesql:[sql UTF8String]];
    if(stmt)
    {
        if (sqlite3_data_count(stmt) > 0) {
            sqlite3_finalize(stmt);
            return YES;
        }
    }
    sqlite3_finalize(stmt);
    return NO;
}

-(BOOL)UpdateFriend:(MyFriends *)myFriend
{
    NSString *sql = [[[[[[[@"update MyFriends set name='" stringByAppendingString:myFriend.friendName] stringByAppendingString:@"',icon='"] stringByAppendingString:myFriend.friendICON] stringByAppendingString:@"',phone="] stringByAppendingString:myFriend.friendPhone] stringByAppendingString:@"' where friendID="] stringByAppendingFormat:@"%d", myFriend.friendID];
    sqlite3_stmt *stmt = [self exesql:[sql UTF8String]];
    if(stmt)
    {
        if (sqlite3_step(stmt) == SQLITE_DONE) {
            sqlite3_finalize(stmt);
            return YES;
        }
    }
    sqlite3_finalize(stmt);
    return NO;
}

-(BOOL)updateFriend:(MyFriends *)myFriend
{
    if ([self checkFrined:myFriend]) {
        //更新
        [self UpdateFriend:myFriend];
    }else{
        return [self insertFriend:myFriend];
    }
    return NO;
}

-(BOOL)insertFriend:(MyFriends *)myFriend
{
    NSString *sql = [[[[[[[[@"insert into MyFriends (friendID,name,icon,phone) values(" stringByAppendingFormat:@"%d", myFriend.friendID]stringByAppendingString:@",'"] stringByAppendingString:myFriend.friendName] stringByAppendingString:@"','"] stringByAppendingString:myFriend.friendICON] stringByAppendingString:@"','"] stringByAppendingString:myFriend.friendPhone] stringByAppendingString:@"')"];
    
    sqlite3_stmt *stmt = [self exesql:[sql UTF8String]];
    if(stmt)
    {
        if (sqlite3_step(stmt) == SQLITE_DONE) {
            sqlite3_finalize(stmt);
            return YES;
        }
    }
    sqlite3_finalize(stmt);
    return NO;
}

-(BOOL)cleanTable{
    NSString *sql = @"delete from MyFriends";
    sqlite3_stmt *stmt = [self exesql:[sql UTF8String]];
    if(stmt)
    {
        if (sqlite3_step(stmt) == SQLITE_DONE) {
            sqlite3_finalize(stmt);
            sql = @"update sqlite_sequence set seq=0 where name='MyFriends'";
            sqlite3_stmt *stmt = [self exesql:[sql UTF8String]];//自增字段从1开始
            if(stmt)
            {
                if (sqlite3_step(stmt) == SQLITE_DONE) {
                    sqlite3_finalize(stmt);
                }
            }
            return YES;
        }
    }
    sqlite3_finalize(stmt);
    return NO;
}

-(BOOL)delFriend:(MyFriends *)myFriend{
    NSString *sql = [@"delete from MyFriends where friendID=" stringByAppendingFormat:@"%d", myFriend.friendID];
    sqlite3_stmt *stmt = [self exesql:[sql UTF8String]];
    if(stmt)
    {
        if (sqlite3_step(stmt) == SQLITE_DONE) {
            sqlite3_finalize(stmt);
            
            return YES;
        }
    }
    sqlite3_finalize(stmt);
    return NO;
}






-(NSMutableArray *)getAllFriends
{
    //
    NSMutableArray *ary = [[NSMutableArray alloc] init];
    //HaveAddressModel *addr = nil;
    sqlite3_stmt *stmt = [self exesql:"select * from MyFriends order by id desc"];
    if(stmt)
    {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            int dataid = sqlite3_column_int(stmt, 0);
            int friendid = sqlite3_column_int(stmt, 1);
            
            char *name = (char *)sqlite3_column_text(stmt, 2);
            char *icon = (char *)sqlite3_column_text(stmt, 3);
            char *phone = (char *)sqlite3_column_text(stmt, 4);
            MyFriends *addr = [[MyFriends alloc] initWitchId:dataid frinedId:friendid name:[[NSString alloc] initWithUTF8String:name] phone:[[NSString alloc] initWithUTF8String:phone] icon:[[NSString alloc] initWithUTF8String:icon]];
            [ary addObject:addr];
            [addr release];
            //break;
        }
        sqlite3_finalize(stmt);
    }
    return ary;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)dealloc
{
    //sqlite3_close(database);
    [super dealloc];
}

@end
