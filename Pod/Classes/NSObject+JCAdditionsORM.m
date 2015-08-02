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

- (instancetype)initWithDictionary:(NSDictionary *)keyValues
{
    NSAssert(keyValues, @"keyValues cannot be nil!");
    NSAssert([keyValues isKindOfClass:[NSDictionary class]], @"keyValues must be kind of NSDictionary!");
    
    NSDictionary *objectPropertys = [self objectPropertys];
    NSDictionary *mapping = [self mapping];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:keyValues.count];
    [keyValues enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        if ([obj jc_isValid]) {
            if ([key isEqualToString:identifier]) {
                [dict setObject:obj forKey:NSStringFromSelector(@selector(ID))];
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
                
                if ([obj isKindOfClass:[NSNumber class]]) {
                    objc_property_t property = class_getProperty(self.class, key.UTF8String);
                    
                    if (property != NULL) {
                        NSString *propertyType = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
                        
                        if ([propertyType containsString:@"String"]) {
                            obj = [obj stringValue];
                        }
                    }
                }
                
                if ([obj isKindOfClass:[NSDictionary class]] && objectPropertys[useKey]) {
                    [dict setObject:[[objectPropertys[useKey] alloc] initWithDictionary:obj] forKey:useKey];
                }
                else {
                    [dict setObject:obj forKey:useKey];
                }
            }
        }
    }];
    
    [self setValuesForKeysWithDictionary:dict];
    
    [self jc_settingsDefaultValueForHasNilValuePropertys];
    
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //    NSLog(@"%@, %@", key, value);
}

- (NSString *)ID
{
    return objc_getAssociatedObject(self, &IDKey);
}

- (void)setID:(NSString *)ID
{
    NSAssert(ID, @"ID cannot be nil!");
    
    objc_setAssociatedObject(self, &IDKey, ID, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSMutableDictionary *)keyValues
{
    NSDictionary *objectPropertys = [self objectPropertys];
    
    [self jc_settingsDefaultValueForHasNilValuePropertys];
    
    NSDictionary *keyValues = [self dictionaryWithValuesForKeys:self.jc_propertys];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:keyValues.count];
    
    [keyValues enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj jc_isValid]) {
            if ([key isEqualToString:NSStringFromSelector(@selector(ID))]) {
                [dict setObject:obj forKey:identifier];
            }
            else {
                if (objectPropertys[key]) {
                    obj = [obj keyValues];
                }
                
                if ([obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSDictionary class]]) {
                    NSError *error = nil;
                    NSData *json = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
                    if (!error) {
                        obj = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
                    }
                }
                
                [dict setObject:obj forKey:key];
            }
        }
    }];
    
    return dict;
}

- (NSDictionary *)objectPropertys
{
    return @{};
}

- (NSDictionary *)mapping
{
    return @{};
}

+ (NSString *)tableName
{
    return NSStringFromClass([self class]);
}

#pragma mark -

- (NSMutableArray *)jc_propertys
{
    NSMutableArray *allKeys = [[NSMutableArray alloc] initWithCapacity:10];
    [allKeys addObject:NSStringFromSelector(@selector(ID))];
    
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for(int i = 0 ; i < count ; i++){
        [allKeys addObject:[NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding]];
    }
    
    free(properties);
    
    return allKeys;
}

- (void)jc_settingsDefaultValueForHasNilValuePropertys
{
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for(int i = 0 ; i < count ; i++){
        NSString *propertyName = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];
        
        if ([self valueForKey:propertyName] == nil) {
            NSString *propertyType = [NSString stringWithCString:property_getAttributes(properties[i]) encoding:NSUTF8StringEncoding];
            
            if (([propertyType hasPrefix:@"T@\"NSString\""] || [propertyType hasPrefix:@"T@\"NSMutableString\""])) {
                [self setValue:@"" forKey:propertyName];
            }
            else if ([propertyType hasPrefix:@"T@\"NSNumber\""]) {
                [self setValue:[NSNumber numberWithInt:0] forKey:propertyName];
            }
        }
    }
    
    free(properties);
}

- (BOOL)jc_isValid
{
    return !(self == nil || [self isKindOfClass:[NSNull class]]);
}

@end