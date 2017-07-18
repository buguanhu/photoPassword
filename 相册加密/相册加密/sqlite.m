//
//  sqlite.m
//  相册加密
//
//  Created by siluo on 2017/7/17.
//  Copyright © 2017年 TH. All rights reserved.
//

#import "sqlite.h"

@implementation sqlite

- (sqlite3 *)creatSqlite:(NSString *)sqlite{

    sqlite3 *db = NULL;
    
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *lastString = [NSString stringWithFormat:@"%@.sqlite",sqlite];
    
    NSString *fileName = [doc stringByAppendingPathComponent:lastString];
    NSLog(@"fileName:%@",fileName);
    const char *cfileName = fileName.UTF8String;
    
    int result = sqlite3_open(cfileName, &db);

    self.db = db;
    
    return self.db;
    
}

- (sqlite3 *)openList:(NSString *)str{

        const char *sql = "CREATE TABLE IF NOT EXISTS 'str' (id integer PRIMARY KEY AUTOINCREMENT,name text NOT NULL,age integer NOT NULL);";
        char *errmsg = NULL;
       int  result = sqlite3_exec(self.db, sql, NULL, NULL, &errmsg);
        
        if (result == SQLITE_OK) {
            NSLog(@"创表成功");
        }else{
            NSLog(@"创表失败:%s",errmsg);
        }
        
        
    
    
    return self.db;

}

- (void)add:(NSString *)tableName{

    NSString *name = [NSString stringWithFormat:@"哈哈%d",arc4random_uniform(100)];
    
    int age = arc4random_uniform(20) + 10;
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (name,age) VALUES('%@','%d');",tableName, name,age];
    
    char *errmsg = NULL;
    sqlite3_exec(self.db, sql.UTF8String, NULL, NULL, &errmsg);
    if (errmsg) {
        NSLog(@"插入数据失败-- %s",errmsg);
    }else{
        
        NSLog(@"成功！！！");
        
    }

    
}

@end
