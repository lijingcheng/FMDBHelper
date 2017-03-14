//
//  FMDBHelper.h
//  FMDBHelper
//
//  Created by 李京城 on 15/3/10.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+JCAdditionsORM.h"

@interface FMDBHelper : NSObject

/**
 *  Setting up the database file
 */
+ (void)setDataBaseName:(NSString *)name;

/**
 *  Use @sql create
 */
+ (BOOL)createTable:(NSString *)sql;

/**
 *  Drop table use tableName
 */
+ (BOOL)dropTable:(NSString *)tableName;

/**
 *  Use @sql insert
 */
+ (BOOL)insert:(NSString *)sql;

/**
 *  Use @obj insert
 */
+ (BOOL)insertObject:(NSObject *)obj;

/**
 *  Insert or replace @keyValues into @table
 */
+ (BOOL)insert:(NSString *)table keyValues:(NSDictionary *)keyValues;

/**
 *  Insert @keyValues into @table
 *
 *  @param replace    if have is the same record, whether you need to replace
 */
+ (BOOL)insert:(NSString *)table keyValues:(NSDictionary *)keyValues replace:(BOOL)replace;

/**
 *  Use @sql Update
 */
+ (BOOL)update:(NSString *)sql;

/**
 *  Use @obj Update
 */
+ (BOOL)updateObject:(NSObject *)obj;

/**
 *  Use @keyValues updated @table
 *
 *  @warning the default where is "id=?", so @keyValues must include "id"
 */
+ (BOOL)update:(NSString *)table keyValues:(NSDictionary *)keyValues;

/**
 *  If the @where are met, use @keyValues updated @table
 */
+ (BOOL)update:(NSString *)table keyValues:(NSDictionary *)keyValues where:(NSString *)where;

/**
 *  Delete from @table
 */
+ (BOOL)remove:(NSString *)table;

/**
 *  Use @obj delete
 */
+ (BOOL)removeObject:(NSObject *)obj;

/**
 *  Delete from @table where id=@id_
 */
+ (BOOL)removeById:(NSString *)id_ from:(NSString *)table;

/**
 *  Delete from @table @where
 */
+ (BOOL)remove:(NSString *)table where:(NSString *)where;

/**
 *  Select * from @table
 */
+ (NSMutableArray *)query:(NSString *)table;

/**
 *  Select * from @table where id=@id_
 */
+ (NSDictionary *)queryById:(NSString *)id_ from:(NSString *)table;

/**
 *  Select * from @table @where
 */
+ (NSMutableArray *)query:(NSString *)table where:(NSString *)where, ... NS_REQUIRES_NIL_TERMINATION;

/**
 *  Select count(id) from @table
 */
+ (NSInteger)totalRowOfTable:(NSString *)table;

/**
 *  Select count(id) from @table @where
 */
+ (NSInteger)totalRowOfTable:(NSString *)table where:(NSString *)where;

/**
 *  batch execute @sqls
 *
 *  @param useTransaction    whether to use transaction
 */
+ (BOOL)executeBatch:(NSArray *)sqls useTransaction:(BOOL)useTransaction;

@end
