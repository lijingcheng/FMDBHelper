//
//  XFMDBHelper.m
//  FMDBHelper
//
//  Created by 李京城 on 15/3/10.
//  Copyright (c) 2015年 lijingcheng. All rights reserved.
//

#import "XFMDBHelper.h"
#import "FMDB.h"

static NSString * const kDBName = @"demo.db";
static NSString * const kId = @"id";

@implementation XFMDBHelper

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(![[NSFileManager defaultManager] fileExistsAtPath:[self dbPath]]) {
            NSString *bundlePath = [[NSBundle mainBundle] pathForResource:kDBName ofType:nil];
            [[NSFileManager defaultManager] copyItemAtPath:bundlePath toPath:[self dbPath] error:nil];
        }
    });
}

#pragma mark - insert

+ (BOOL)insert:(NSString *)sql
{
    return [self executeUpdate:sql args:nil];
}

+ (BOOL)insert:(NSString *)table keyValues:(NSDictionary *)keyValues
{
    return [self insert:table keyValues:keyValues replace:YES];
}

+ (BOOL)insert:(NSString *)table keyValues:(NSDictionary *)keyValues replace:(BOOL)replace
{
    NSMutableArray *columns = [NSMutableArray array];
    NSMutableArray *values = [NSMutableArray array];
    NSMutableArray *placeholder = [NSMutableArray array];
    
    [keyValues enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (obj && ![obj isEqual:[NSNull null]]) {
            [columns addObject:key];
            [values addObject:obj];
            [placeholder addObject:@"?"];
        }
    }];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"INSERT%@ INTO %@ (%@) VALUES (%@)", replace?@" OR REPLACE":@"", table, [columns componentsJoinedByString:@","], [placeholder componentsJoinedByString:@","]];
    
    return [self executeUpdate:sql args:values];
}

#pragma mark - update

+ (BOOL)update:(NSString *)sql
{
    return [self executeUpdate:sql args:nil];
}

+ (BOOL)update:(NSString *)table keyValues:(NSDictionary *)keyValues
{
    return [self update:table keyValues:keyValues where:[NSString stringWithFormat:@"%@=%@", kId, keyValues[kId]]];
}

+ (BOOL)update:(NSString *)table keyValues:(NSDictionary *)keyValues where:(NSString *)where
{
    NSMutableArray *settings = [NSMutableArray array];
    NSMutableArray *values = [NSMutableArray array];
    
    [keyValues enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (obj && ![obj isEqual:[NSNull null]]) {
            [settings addObject:[NSString stringWithFormat:@"%@=?", key]];
            [values addObject:obj];
        }
    }];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"UPDATE %@ SET %@ WHERE %@", table, [settings componentsJoinedByString:@","], where];
    
    return [self executeUpdate:sql args:values];
}

#pragma mark - remove

+ (BOOL)remove:(NSString *)table
{
    return [self remove:table where:@"1=1"];
}

+ (BOOL)removeById:(NSString *)id_ from:(NSString *)table
{
    return [self remove:table where:[NSString stringWithFormat:@"%@=%@", kId, id_]];
}

+ (BOOL)remove:(NSString *)table where:(NSString *)where
{
    NSString *sql = [[NSString alloc] initWithFormat:@"DELETE FROM %@ WHERE %@", table, where];
    
    return [self executeUpdate:sql args:nil];
}


#pragma mark - query

+ (NSMutableArray *)query:(NSString *)table
{
    return [self query:table where:@"1=1", nil];
}

+ (NSDictionary *)queryById:(NSString *)id_ from:(NSString *)table
{
    NSMutableArray *result = [self query:table where:[NSString stringWithFormat:@"%@=?", kId], id_, nil];
    
    if ([result count] > 0) {
        return [result firstObject];
    }
    else {
        return nil;
    }
}

+ (NSMutableArray *)query:(NSString *)table where:(NSString *)where, ...
{
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:10];
    
    va_list args;
    va_start(args, where);
    
    FMDatabase *db = [FMDatabase databaseWithPath:[self dbPath]];
    
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@", table, where] withVAList:args];
        while ([rs next]) {
            [result addObject:[rs resultDictionary]];
        }
    }
    
    [db close];
    va_end(args);
    
    return result;
}

+ (NSInteger)totalRowOfTable:(NSString *)table
{
    return [self totalRowOfTable:table where:@"1=1"];
}

+ (NSInteger)totalRowOfTable:(NSString *)table where:(NSString *)where
{
    NSInteger totalRow = 0;
    
    FMDatabase *db = [FMDatabase databaseWithPath:[self dbPath]];
    
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT COUNT(%@) totalRow FROM %@ WHERE %@", kId, table, where]];
        if ([rs next]) {
            totalRow = [[rs resultDictionary][@"totalRow"] integerValue];
        }
    }
    
    [db close];
    
    return totalRow;
}

#pragma mark - batch

+ (BOOL)executeBatch:(NSArray *)sqls useTransaction:(BOOL)useTransaction
{
    __block BOOL success = YES;
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[self dbPath]];
    
    if (useTransaction) {
        [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            for (NSString *sql in sqls) {
                if (![db executeUpdate:sql]) {
                    *rollback = YES;
                    success = NO;
                    break;
                }
            }
        }];
    }
    else {
        [queue inDatabase:^(FMDatabase *db) {
            for (NSString *sql in sqls) {
                [db executeUpdate:sql];
            }
        }];
    }
    
    return success;
}

#pragma mark - private method

+ (BOOL)executeUpdate:(NSString *)sql args:(NSArray *)args
{
    BOOL success = NO;
    
    FMDatabase *db = [FMDatabase databaseWithPath:[self dbPath]];
    
    if ([db open]) {
        success = [db executeUpdate:sql withArgumentsInArray:args];
    }
    
    [db close];
    
    return success;
}

+ (NSString *)dbPath
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:kDBName];
}

@end
