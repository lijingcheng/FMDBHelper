//
//  FMDBHelperSpec.m
//  FMDBHelper
//
//  Created by 李京城 on 15/3/23.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

#import "FMDBHelper.h"
#import "User.h"
#import "Dept.h"
#import "Dog.h"

SPEC_BEGIN(FMDBHelperSpec)

describe(@"FMDBHelper", ^{
    
    [FMDBHelper setDataBaseName:@"demo.db"];
    
    NSString *tableName = @"sys_user";
    
    context(@"insert", ^{
        __block NSDictionary *keyValues = nil;
        beforeEach(^{
            NSString *path = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"json"];
            keyValues = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingMutableLeaves error:nil];
        });
        
        afterEach(^{
            keyValues = nil;
        });
        
        it(@"insert:", ^{
            NSString *sql = @"INSERT OR REPLACE INTO sys_user (id,name,age,birthday,dept,dogs,nums) VALUES ('id1','zhangsan',15,'2000/03/22','','','')";
            BOOL result = [FMDBHelper insert:sql];
            
            [[theValue(result) should] beYes];
        });
        
        it(@"insertObject:", ^{
            User *user = [[User alloc] initWithDictionary:keyValues];
            
            BOOL result = [FMDBHelper insertObject:user];
            
            [[theValue(result) should] beYes];
        });
        
        it(@"insert:keyValues:", ^{
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:keyValues];
            dict[@"id"] = @"id2";
            dict[@"name"] = @"lijingcheng";
            [dict removeObjectForKey:@"username"];
            
            BOOL result = [FMDBHelper insert:tableName keyValues:dict];
            
            [[theValue(result) should] beYes];
        });
        
        it(@"insert:keyValues:replace:", ^{
            BOOL result = [FMDBHelper insert:tableName keyValues:keyValues replace:NO];
            
            [[theValue(result) should] beNo];
        });
    });
    
    context(@"update", ^{
        it(@"update:", ^{
            NSString *sql = @"update sys_user set name='lisi' where id='id1'";
            BOOL result = [FMDBHelper update:sql];
            
            [[theValue(result) should] beYes];
        });
        
        it(@"updateObject:", ^{
            NSDictionary *dict = @{@"id": @"a1b2c3d4e5", @"name": @"><((*>", @"age": @18};
            User *user = [[User alloc] initWithDictionary:dict];

            BOOL result = [FMDBHelper updateObject:user];
            
            [[theValue(result) should] beYes];
        });
        
        it(@"update:keyValues:", ^{
            BOOL result = [FMDBHelper update:tableName keyValues:@{@"id": @"id2", @"name": @"victor", @"age": @18}];
            
            [[theValue(result) should] beYes];
        });
        
        it(@"update:keyValues:where:", ^{
            BOOL result = [FMDBHelper update:tableName keyValues:@{@"name": @"wangwu"} where:@"name='victor'"];
            
            [[theValue(result) should] beYes];
        });
    });

    context(@"delete", ^{
        it(@"removeById:from:", ^{
            BOOL result = [FMDBHelper removeById:@"id2" from:tableName];

            [[theValue(result) should] beYes];
        });
        
        it(@"removeObject:", ^{
            NSDictionary *dict = @{@"id": @"a1b2c3d4e5", @"name": @"><((*>", @"age": @18};
            User *user = [[User alloc] initWithDictionary:dict];
            
            BOOL result = [FMDBHelper removeObject:user];
            
            [[theValue(result) should] beYes];
        });
        
        it(@"remove:where", ^{
            BOOL result = [FMDBHelper remove:tableName where:@"name='lisi'"];
            
            [[theValue(result) should] beYes];
        });
        
        it(@"remove:", ^{
            BOOL result = [FMDBHelper remove:tableName];
            
            [[theValue(result) should] beYes];
        });
    });

    context(@"batch", ^{
        NSString *sql1 = @"INSERT OR REPLACE INTO sys_user (id,name,age,birthday,dept) VALUES ('id1','lijingcheng',31,'1984/3/28','{\n  \"id\" : \"f6g7h8i9j0\",\n  \"name\" : \"dev\",\n  \"manager\" : \"X\"\n}')";
        NSString *sql2 = @"INSERT OR REPLACE INTO sys_user (id,name,age,birthday,dept) VALUES ('id2','zhangsan',21,'1994/3/22','')";
        NSString *sql3 = @"INSERT OR REPLACE INTO sys_user (id,name,age,birthday,dept) VALUES ('id3','wangwu',22,'1993/3/21','')";
        NSString *sql4 = @"INSERT INTO sys_user (id,name,age,birthday) VALUES ('id3','wangwu',22,'1993-03-22')";
        NSString *sql5 = @"update sys_user set name='lisi' where id='id2'";
        NSString *sql6 = @"delete from sys_user where id='id3'";
        
        it(@"executeBatch:useTransaction:(YES)", ^{
            BOOL result = [FMDBHelper executeBatch:@[sql1, sql2, sql3, sql4, sql5, sql6] useTransaction:YES];
            
            [[theValue(result) should] beNo];
        });
        
        it(@"executeBatch:useTransaction:(NO)", ^{
            BOOL result = [FMDBHelper executeBatch:@[sql1, sql2, sql3, sql4, sql5, sql6] useTransaction:NO];
            
            [[theValue(result) should] beYes];
        });
    });

    context(@"query", ^{
        it(@"query:", ^{
            NSArray *result = [FMDBHelper query:tableName];
            
            [[result should] haveCountOf:2];
        });
        
        it(@"query:where:", ^{
            NSArray *result = [FMDBHelper query:tableName where:@"age>?", @20, nil];

            [[result should] haveCountOf:2];
        });
        
        it(@"queryById:from:", ^{
            NSDictionary *result = [FMDBHelper queryById:@"id1" from:tableName];
            
            [[result shouldNot] beNil];
            
            User *user = [[User alloc] initWithDictionary:result];
            NSLog(@"%@, %@, %ld, %@, %@", user.ID, user.name, (long)user.age, user.birthday, user.dept.keyValues);
            
            Dept *dept = [[Dept alloc] initWithDictionary:user.dept.keyValues];
            
            NSLog(@"%@, %@, %@", dept.ID, dept.name, dept.manager);
        });
        
        it(@"totalRowOfTable:", ^{
            NSInteger totalRow = [FMDBHelper totalRowOfTable:tableName];
            
            [[theValue(totalRow) should] equal:theValue(2)];
        });
        
        it(@"totalRowOfTable:where:", ^{
            NSInteger totalRow = [FMDBHelper totalRowOfTable:tableName where:@"age>24"];
            
            [[theValue(totalRow) should] equal:theValue(1)];
        });
    });
});

SPEC_END
