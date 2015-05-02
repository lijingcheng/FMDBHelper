//
//  NSObject+JCShorthandAdditionsORM.h
//  FMDBHelper
//
//  Created by 李京城 on 15/4/27.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

#ifdef JC_SHORTHAND_ORM

/**
 *  如果不喜欢在调用"NSObject+JCAdditionsORM.h"中的方法时加"jc_"前缀，需要在你的工程中加上"#define JC_SHORTHAND_ORM"
 */
@interface NSObject (JCShorthandAdditionsORM)

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, readonly) NSMutableDictionary *keyValues;

- (instancetype)initWithDictionary:(NSDictionary *)keyValues;
- (NSDictionary *)objectPropertys;
- (NSDictionary *)mapping;
+ (NSString *)tableName;

@end

@implementation NSObject (JCShorthandAdditionsORM)

- (instancetype)initWithDictionary:(NSDictionary *)keyValues {
    return [self jc_initWithDictionary:keyValues];
}

- (NSMutableDictionary *)keyValues {
    return [self jc_keyValues];
}

- (NSDictionary *)objectPropertys {
    return [self jc_objectPropertys];
}

- (NSDictionary *)mapping {
    return [self jc_mapping];
}

+ (NSString *)tableName {
    return [self jc_tableName];
}

- (NSString *)ID {
    return self.jc_ID;
}

- (void)setID:(NSString *)ID {
    self.jc_ID = ID;
}

@end

#endif
