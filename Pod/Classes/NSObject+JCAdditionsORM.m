//
//  NSObject+JCAdditionsORM.m
//  FMDBHelper
//
//  Created by 李京城 on 15/4/27.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

#import "NSObject+JCAdditionsORM.h"
#import <objc/runtime.h>

NSString * const identifier = @"id";

@implementation NSObject (JCAdditionsORM)

static const void *IDKey;

- (instancetype)jc_initWithDictionary:(NSDictionary *)keyValues
{
    NSAssert(keyValues, @"keyValues cannot be nil!");
    NSAssert([keyValues isKindOfClass:[NSDictionary class]], @"keyValues must be kind of NSDictionary!");
    
    NSDictionary *objectPropertys = [self jc_objectPropertys];
    NSDictionary *mapping = [self jc_mapping];
    #ifdef JC_SHORTHAND_ORM
        objectPropertys = [self objectPropertys];
        mapping = [self mapping];
    #endif
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:keyValues.count];
    [keyValues enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj jc_isValid]) {
            if ([key isEqualToString:identifier]) {
                [dict setObject:obj forKey:NSStringFromSelector(@selector(jc_ID))];
            }
            else {
                NSString *useKey = mapping[key] ? : key;
                
                if ([obj isKindOfClass:[NSString class]]) {
                    NSError *error = nil;
                    id jsonObject = [NSJSONSerialization JSONObjectWithData:[obj dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
                    
                    if (!error) {
                        obj = jsonObject;
                    }
                }
                
                if ([obj isKindOfClass:[NSDictionary class]] && objectPropertys[useKey]) {
                    [dict setObject:[[objectPropertys[useKey] alloc] jc_initWithDictionary:obj] forKey:useKey];
                }
                else {
                    [dict setObject:obj forKey:useKey];
                }
            }
        }
    }];
    
    [self setValuesForKeysWithDictionary:dict];
    
    return self;
}

- (NSString *)jc_ID
{
    return objc_getAssociatedObject(self, &IDKey);
}

- (void)setJc_ID:(NSString *)jc_ID
{
    NSAssert(jc_ID, @"jc_ID cannot be nil!");
    
    objc_setAssociatedObject(self, &IDKey, jc_ID, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSMutableDictionary *)jc_keyValues
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[self dictionaryWithValuesForKeys:self.jc_propertys]];
    NSString *idKey = NSStringFromSelector(@selector(jc_ID));
    [dict setObject:dict[idKey] forKey:identifier];
    [dict removeObjectForKey:idKey];
    
    NSDictionary *objectPropertys = [self jc_objectPropertys];
    #ifdef JC_SHORTHAND_ORM
        objectPropertys = [self objectPropertys];
    #endif
    
    [objectPropertys enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if([dict[key] jc_isValid]) {
            [dict setObject:[dict[key] jc_keyValues] forKey:key];
        }
    }];
    
    return dict;
}

- (NSDictionary *)jc_objectPropertys
{
    return @{};
}

- (NSDictionary *)jc_mapping
{
    return @{};
}

+ (NSString *)jc_tableName
{
    return NSStringFromClass([self class]);
}

#pragma mark -

- (NSMutableArray *)jc_propertys
{
    NSMutableArray *allKeys = [[NSMutableArray alloc] initWithCapacity:10];
    [allKeys addObject:NSStringFromSelector(@selector(jc_ID))];
    
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for(int i = 0 ; i < count ; i++){
        [allKeys addObject:[NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding]];
    }
    
    free(properties);
    
    return allKeys;
}

- (BOOL)jc_isValid
{
    return !(self == nil || [self isKindOfClass:[NSNull class]]);
}

@end