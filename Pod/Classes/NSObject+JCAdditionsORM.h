//
//  NSObject+JCAdditionsORM.h
//  FMDBHelper
//
//  Created by 李京城 on 15/4/27.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

#import <Foundation/Foundation.h>

//用于对应数据库表中的主键id或者是json数据的id字段
extern NSString * const identifier;

@interface NSObject (JCAdditionsORM)

/**
 *  为每个对象增加一个"id"属性，用于对应数据库表中的主键id
 */
@property (nonatomic, copy) NSString *ID;

/**
 *  对象包含的属性及对应的值
 */
@property (nonatomic, readonly) NSMutableDictionary *keyValues;

/**
 *  keyValues中的key要与Model类中的属性名称相对应，如不一致@see jc_mapping
 */
- (instancetype)initWithDictionary:(NSDictionary *)keyValues;

/**
 *  if the property type is a custom class, you need to overwrite this method.
 *
 *  @return key is property name, value is model class, default return @{};
 */
- (NSDictionary *)objectPropertys;

/**
 *  if the property name and the data source is not the same key, you need to overwrite this method.
 *
 *  @return key is datasource's key, value is property name, default return @{}.
 */
- (NSDictionary *)mapping;

/**
 *  if the model class name and the table name is different, you need to overwrite this method.
 *
 *  @return default return the class name.
 */
+ (NSString *)tableName;

@end
