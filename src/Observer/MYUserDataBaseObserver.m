//
//  MYUserDataBaseObserver.m
//  MYFrameworkDemo
//
//  Created by Whirlwind on 13-2-16.
//  Copyright (c) 2013年 BOOHEE. All rights reserved.
//

#import "MYUserDataBaseObserver.h"
#import "MYDbManager.h"

@implementation MYUserDataBaseObserver

- (void)migrateUserDataBase:(NSNotification *)ntf {
    MYDbManager *accessor = [ntf.userInfo valueForKey:@"sqlAccess"];
    [accessor migratePlugin:@"MYUserEntryLog" toVersion:1 update:^(NSInteger oldVersion, MYDbManager *accessor) {
        NSMutableArray *sqls = [[NSMutableArray alloc] initWithCapacity:0];
        if (oldVersion == 0) {
            // my_user_entry_logs
            [sqls addObject:@"CREATE TABLE my_user_entry_logs (id integer PRIMARY KEY AUTOINCREMENT, user_key varchar(36) NOT NULL, model_name varchar(50), local_id int, remote_id int, field_name varchar(50), field_value varchar(1000), exec_type varchar(1), updated_at datetime);"];
            [sqls addObject:@"CREATE INDEX index_local_id_and_model_name_on_my_user_entry_logs on my_user_entry_logs (local_id, model_name);"];
            [sqls addObject:@"CREATE INDEX index_user_key_and_id_on_my_user_entry_logs on my_user_entry_logs (user_key, id);"];
        }
        [accessor.dbQueue inDatabase:^(FMDatabase *db) {
            for (NSString *sql in sqls) {
                if (![db executeUpdate:sql]) {
                    LogError(@"ERROR! %@", db.lastErrorMessage);
                }
            }
        }];
        [sqls release];
    }];
}
@end
