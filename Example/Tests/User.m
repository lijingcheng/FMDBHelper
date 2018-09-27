//
//  User.m
//  FMDBHelper
//
//  Created by 李京城 on 15/5/2.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

#import "User.h"
#import "Dept.h"
#import "Dog.h"

@implementation User

- (NSDictionary *)mapping {
    return @{@"username": @"name"};
}

- (NSDictionary *)objectPropertys {
    return @{@"dept": [Dept class]};
}

- (NSDictionary *)genericForArray {
    return @{@"dogs": [Dog class]};
}

+ (NSString *)tableName {
    return @"sys_user";
}

@end
