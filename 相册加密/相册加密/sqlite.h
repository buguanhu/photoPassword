//
//  sqlite.h
//  相册加密
//
//  Created by siluo on 2017/7/17.
//  Copyright © 2017年 TH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface sqlite : NSObject
@property (nonatomic) sqlite3 *db;
@end
