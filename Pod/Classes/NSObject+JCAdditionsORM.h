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
 *  如果Model类的属性类型不是来自Foundation框架，而是自定义的另一Model类，则需要在此方法中设置对应关系
 *  例: @{@"Model类的属性名称": [该属性对应的类名 class]};
 */
- (NSDictionary *)objectPropertys;

/**
 *  不管数据来自数据库还是JSON，只要字段与Model类中的属性名字不一致，则需要重写此方法。
 *  例: @{@"数据字段名称": @"Model类的属性名称"};
 */
- (NSDictionary *)mapping;

/**
 *  if the model class name and the table name is different, you need to overwrite this method.
 *
 *  @return default returns the class name.
 */
+ (NSString *)tableName;

@end
