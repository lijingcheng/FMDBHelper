//
//  FMDBHelper.h
//  FMDBHelper
//
//  Created by 李京城 on 15/3/10.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+JCAdditionsORM.h"
#import "NSObject+JCShorthandAdditionsORM.h"

@interface FMDBHelper : NSObject

/**
 *  设置app使用的数据库
 *
 *  @param name         数据库文件的名字
 *
 *  @warning 如果要使用"FMDBHelper"，那么这个方法是必须要正确设置的
 */
+ (void)setDataBaseName:(NSString *)name;

/**
 *  插入数据
 *
 *  @param sql          SQL语句
 *
 *  @return YES: 执行成功, NO: 执行失败
 */
+ (BOOL)insert:(NSString *)sql;

/**
 *  将传入对象插入到对应的数据库表中
 *
 *  @param obj          要插入的对象
 *
 *  @return YES: 执行成功, NO: 执行失败
 */
+ (BOOL)insertObject:(NSObject *)obj;

/**
 *  插入数据(如果表中存在相同记录，默认替换原数据)
 *
 *  @param table         要插入的表
 *  @param keyValues     要插入的字段名和值
 *
 *  @return YES: 执行成功, NO: 执行失败
 */
+ (BOOL)insert:(NSString *)table keyValues:(NSDictionary *)keyValues;

/**
 *  插入数据
 *
 *  @param table        要插入的表
 *  @param keyValues    要插入的字段名和值
 *  @param replace      如果表中存在相同记录，是否需要替换
 *
 *  @return YES: 执行成功, NO: 执行失败
 */
+ (BOOL)insert:(NSString *)table keyValues:(NSDictionary *)keyValues replace:(BOOL)replace;

/**
 *  更新数据
 *
 *  @param sql          SQL语句
 *
 *  @return YES: 执行成功, NO: 执行失败
 */
+ (BOOL)update:(NSString *)sql;

/**
 *  根据传入对象更新对应的数据库记录
 *
 *  @param obj         要更新的对象
 *
 *  @return YES: 执行成功, NO: 执行失败
 */
+ (BOOL)updateObject:(NSObject *)obj;

/**
 *  更新数据
 *
 *  @param table         要更新的表
 *  @param keyValues     要更新的字段名和值
 *
 *  @return YES: 执行成功, NO: 执行失败
 *
 *  @warning 默认的where条件是id=?，所以keyValues参数要包括id
 */
+ (BOOL)update:(NSString *)table keyValues:(NSDictionary *)keyValues;

/**
 *  根据条件更新数据
 *
 *  @param table         要更新的表
 *  @param keyValues     要更新的字段名和值
 *  @param where         更新条件
 *
 *  @return YES: 执行成功, NO: 执行失败
 */
+ (BOOL)update:(NSString *)table keyValues:(NSDictionary *)keyValues where:(NSString *)where;

/**
 *  删除表中的所有数据
 *
 *  @param table         要删除的表
 *
 *  @return YES: 执行成功, NO: 执行失败
 */
+ (BOOL)remove:(NSString *)table;

/**
 *  删除传入对象对应的数据库记录
 *
 *  @param obj          要删除的对象
 *
 *  @return YES: 执行成功, NO: 执行失败
 */
+ (BOOL)removeObject:(NSObject *)obj;

/**
 *  根据id删除数据
 *
 *  @param id_           要删除的数据id
 *  @param table         要删除的表
 *
 *  @return YES: 执行成功, NO: 执行失败
 */
+ (BOOL)removeById:(NSString *)id_ from:(NSString *)table;

/**
 *  根据条件删除数据
 *
 *  @param table         要删除的表
 *  @param where         删除条件
 *
 *  @return YES: 执行成功, NO: 执行失败
 */
+ (BOOL)remove:(NSString *)table where:(NSString *)where;

/**
 *  查找表中的所有数据
 *
 *  @param table        要查找的表
 *
 *  @return 如果查不到则返回空数组
 */
+ (NSMutableArray *)query:(NSString *)table;

/**
 *  根据id查找数据
 *
 *  @param id_          要查找的数据id
 *  @param table        要查找的表
 *
 *  @return 如果查不到则返回nil
 */
+ (NSDictionary *)queryById:(NSString *)id_ from:(NSString *)table;

/**
 *  根据条件查找数据
 *
 *  @param table         要查找的表
 *  @param where         查找条件
 *
 *  @return 如果查不到则返回空数组
 */
+ (NSMutableArray *)query:(NSString *)table where:(NSString *)where, ... NS_REQUIRES_NIL_TERMINATION;

/**
 *  查找表中有多少条数据
 *
 *  @param table         要查找的表
 *
 *  @return 查找到的数据条数
 */
+ (NSInteger)totalRowOfTable:(NSString *)table;

/**
 *  根据条件查找表中有多少条数据
 *
 *  @param table         要查找的表
 *  @param where         查找条件
 *
 *  @return 查找到的数据条数
 */
+ (NSInteger)totalRowOfTable:(NSString *)table where:(NSString *)where;

/**
 *  批量更新数据
 *
 *  @param sqls              要执行的sql语句(insert/update/delete)
 *  @param useTransaction    是否使用事务
 *
 *  @return YES: 执行成功, NO: 执行失败
 */
+ (BOOL)executeBatch:(NSArray *)sqls useTransaction:(BOOL)useTransaction;

@end
