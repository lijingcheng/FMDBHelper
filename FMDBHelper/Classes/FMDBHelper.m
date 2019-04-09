//
//  FMDBHelper.m
//  FMDBHelper
//
//  Created by 李京城 on 15/3/10.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

#import "FMDBHelper.h"
#import "FMDB.h"
#import "NSObject+JCAdditionsORM.h"

@implementation FMDBHelper

static NSString *dbName = @"";
static NSString *dbPath = @"";

+ (void)setDataBaseName:(NSString *)name {
    NSAssert(name, @"name cannot be nil!");
    
    dbName = name;
}

+ (void)setDataBasePath:(NSString *)path {
    NSAssert(path, @"path cannot be nil!");
    
    dbPath = path;
}

+ (BOOL)createTable:(NSString *)sql {
    return [self executeUpdate:sql args:nil];
}

+ (BOOL)dropTable:(NSString *)tableName {
    NSString *sql = [NSString stringWithFormat:@"DROP TABLE IF EXISTS %@", tableName];
    
    return [self executeUpdate:sql args:nil];
}

#pragma mark - insert

+ (BOOL)insert:(NSString *)sql {
    NSAssert(sql, @"sql cannot be nil!");
    
    return [self executeUpdate:sql args:nil];
}

+ (BOOL)insertObject:(NSObject *)obj {
    NSAssert(obj, @"obj cannot be nil!");
    
    return [self insert:[[obj class] tableName] keyValues:[obj keyValues]];
}

+ (BOOL)insertObject:(NSObject *)obj usingAutoIncrementColumn:(NSString * _Nonnull)column {
    NSAssert(obj && column, @"obj or column cannot be nil!");
    
    return [self insert:[[obj class] tableName] keyValues:[obj keyValues] replace:NO usingAutoIncrementColumn:column];
}

+ (BOOL)insert:(NSString *)table keyValues:(NSDictionary *)keyValues {
    NSAssert(table && keyValues, @"table or keyValues cannot be nil!");
    
    return [self insert:table keyValues:keyValues replace:YES];
}

+ (BOOL)insert:(NSString *)table keyValues:(NSDictionary *)keyValues replace:(BOOL)replace {
    NSAssert(table && keyValues, @"table or keyValues cannot be nil!");
    
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
    
    NSString *sql = [[NSString alloc] initWithFormat:@"INSERT%@ INTO %@ (%@) VALUES (%@)", replace ? @" OR REPLACE" : @"", table, [columns componentsJoinedByString:@","], [placeholder componentsJoinedByString:@","]];
    
    return [self executeUpdate:sql args:values];
}

+ (BOOL)insert:(NSString *)table keyValues:(NSDictionary *)keyValues replace:(BOOL)replace usingAutoIncrementColumn:(NSString * _Nonnull)column {
    NSAssert(table && keyValues, @"table or keyValues cannot be nil!");
    NSAssert(column, @"column cannot be nil when using auto increment key!");

    NSMutableArray *columns = [NSMutableArray array];
    NSMutableArray *values = [NSMutableArray array];
    NSMutableArray *placeholder = [NSMutableArray array];
    
    [keyValues enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (obj && ![obj isEqual:[NSNull null]]) {
            if ([key isEqualToString:column]) {
                return;
            }
            [columns addObject:key];
            [values addObject:obj];
            [placeholder addObject:@"?"];
        }
    }];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"INSERT%@ INTO %@ (%@) VALUES (%@)", replace ? @" OR REPLACE" : @"", table, [columns componentsJoinedByString:@","], [placeholder componentsJoinedByString:@","]];
    
    return [self executeUpdate:sql args:values];
}

#pragma mark - update

+ (BOOL)update:(NSString *)sql {
    NSAssert(sql, @"sql cannot be nil!");
    
    return [self executeUpdate:sql args:nil];
}

+ (BOOL)updateObject:(NSObject *)obj {
    NSAssert(obj, @"obj cannot be nil!");
    
    return [self update:[[obj class] tableName] keyValues:[obj keyValues]];
}

+ (BOOL)update:(NSString *)table keyValues:(NSDictionary *)keyValues {
    NSAssert(table && keyValues, @"table or keyValues cannot be nil!");
    NSAssert(keyValues[identifier], @"keyValues[@\"%@\"] cannot be nil!", identifier);
    
    return [self update:table keyValues:keyValues where:[NSString stringWithFormat:@"%@='%@'", identifier, keyValues[identifier]]];
}

+ (BOOL)update:(NSString *)table keyValues:(NSDictionary *)keyValues where:(NSString *)where {
    NSAssert(table && keyValues && where, @"table,keyValues,where can't be nil!");
    
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

+ (BOOL)remove:(NSString *)table {
    NSAssert(table, @"table cannot be nil!");
    
    return [self remove:table where:@"1=1"];
}

+ (BOOL)removeObject:(NSObject *)obj {
    NSAssert(obj, @"obj cannot be nil!");
    
    return [self removeById:obj.ID from:[[obj class] tableName]];
}

+ (BOOL)removeById:(NSString *)id_ from:(NSString *)table {
    NSAssert(id_ && table, @"id_ or table cannot be nil!");
    
    return [self remove:table where:[NSString stringWithFormat:@"%@='%@'", identifier, id_]];
}

+ (BOOL)remove:(NSString *)table where:(NSString *)where {
    NSAssert(table && where, @"table or where cannot be nil!");
    
    NSString *sql = [[NSString alloc] initWithFormat:@"DELETE FROM %@ WHERE %@", table, where];
    
    return [self executeUpdate:sql args:nil];
}

#pragma mark - query

+ (NSMutableArray *)query:(NSString *)table {
    NSAssert(table, @"table cannot be nil!");
    
    return [self query:table where:@"1=1", nil];
}

+ (NSDictionary *)queryById:(NSString *)id_ from:(NSString *)table {
    NSAssert(id_ && table, @"id_ or table cannot be nil!");
    
    NSMutableArray *result = [self query:table where:[NSString stringWithFormat:@"%@=?", identifier], id_, nil];
    
    return (result.count > 0) ? result.firstObject : nil;
}

+ (NSMutableArray *)query:(NSString *)table where:(NSString *)where, ... {
    NSAssert(table && where, @"table or where cannot be nil!");
    
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:10];
    
    va_list args;
    va_start(args, where);
    
    FMDatabase *db = [FMDatabase databaseWithPath:[self dbPath]];
    
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@", table, where] withVAList:args];
        while ([rs next]) {
            [result addObject:[rs resultDictionary]];
        }
        
        [db close];
    }
    
    db = nil;
    
    va_end(args);
    
    return result;
}

+ (NSInteger)totalRowOfTable:(NSString *)table {
    NSAssert(table, @"table cannot be nil!");
    
    return [self totalRowOfTable:table where:@"1=1"];
}

+ (NSInteger)totalRowOfTable:(NSString *)table where:(NSString *)where {
    NSAssert(table && where, @"table or where cannot be nil!");
    
    NSInteger totalRow = 0;
    
    FMDatabase *db = [FMDatabase databaseWithPath:[self dbPath]];
    
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT COUNT(%@) totalRow FROM %@ WHERE %@", identifier, table, where]];
        if ([rs next]) {
            totalRow = [[rs resultDictionary][@"totalRow"] integerValue];
        }
    
        [db close];
    }
    
    db = nil;
    
    return totalRow;
}

#pragma mark - batch

+ (BOOL)executeBatch:(NSArray *)sqls useTransaction:(BOOL)useTransaction {
    NSAssert(sqls, @"sqls cannot be nil!");
    
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
    } else {
        [queue inDatabase:^(FMDatabase *db) {
            for (NSString *sql in sqls) {
                [db executeUpdate:sql];
            }
        }];
    }
    
    return success;
}

#pragma mark - private method

+ (BOOL)executeUpdate:(NSString *)sql args:(NSArray *)args {
    BOOL success = NO;
    
    FMDatabase *db = [FMDatabase databaseWithPath:[self dbPath]];
    
    if ([db open]) {
        success = [db executeUpdate:sql withArgumentsInArray:args];
        
        [db close];
    }
    
    db = nil;
    
    return success;
}

+ (NSString *)dbPath {
    if (dbPath && ![dbPath isEqualToString:@""]) {
        return dbPath;
    } else {
        NSAssert(dbName, @"dbName cannot be nil!");
        
        return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:dbName];
    }
}

@end
