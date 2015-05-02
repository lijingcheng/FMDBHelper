//
//  FMDBHelperSpec.m
//  FMDBHelper
//
//  Created by 李京城 on 15/3/23.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

SPEC_BEGIN(FMDBHelperSpec)

//Table structure:CREATE TABLE user (id text PRIMARY KEY,username text,age integer,birthday text,dept text)
//Table structure:CREATE TABLE dept (id text PRIMARY KEY,name text,manager text)

describe(@"FMDBHelper", ^{
    [FMDBHelper setDataBaseName:@"demo.db"];
    
    NSString *tableName = @"user";
    
    context(@"insert", ^{
        __block NSDictionary *keyValues = nil;
        beforeEach(^{
            keyValues = @{@"id": @"id2", @"username": @"zhangsan", @"age": @20, @"birthday": @"1995-03-22"};
        });
        
        afterEach(^{
            keyValues = nil;
        });
        
        it(@"insert:", ^{
            NSString *sql = @"INSERT OR REPLACE INTO user (id,username,age,birthday) VALUES ('id1','zhangsan',20,'1995-03-22')";
            BOOL result = [FMDBHelper insert:sql];
            
            [[theValue(result) should] beYes];
        });
        
        it(@"insert:keyValues:", ^{
            BOOL result = [FMDBHelper insert:tableName keyValues:keyValues];
            
            [[theValue(result) should] beYes];
        });
        
        it(@"insert:keyValues:replace:", ^{
            BOOL result = [FMDBHelper insert:tableName keyValues:keyValues replace:NO];
            
            [[theValue(result) should] beNo];
        });
    });
    
    context(@"update", ^{
        it(@"update:", ^{
            NSString *sql = @"update user set username='lisi' where id='id1'";
            BOOL result = [FMDBHelper update:sql];
            
            [[theValue(result) should] beYes];
        });
        
        it(@"update:keyValues:", ^{
            NSDictionary *keyValues = @{@"id": @"id2", @"username": @"zhangsan", @"age": @21, @"birthday": @"1994-03-21"};
            BOOL result = [FMDBHelper update:tableName keyValues:keyValues];
            
            [[theValue(result) should] beYes];
        });
        
        it(@"update:keyValues:where:", ^{
            BOOL result = [FMDBHelper update:tableName keyValues:@{@"username": @"wangwu"} where:@"username='haha'"];
            
            [[theValue(result) should] beYes];
        });
    });
    
    context(@"delete", ^{
        it(@"removeById:from:", ^{
            BOOL result = [FMDBHelper removeById:@"id2" from:tableName];

            [[theValue(result) should] beYes];
        });
        
        it(@"remove:where", ^{
            BOOL result = [FMDBHelper remove:tableName where:@"username='zhaoliu'"];
            
            [[theValue(result) should] beYes];
        });
        
        it(@"remove:", ^{
            BOOL result = [FMDBHelper remove:tableName];
            
            [[theValue(result) should] beYes];
        });
    });
    
    context(@"batch", ^{
        NSString *sql1 = @"INSERT OR REPLACE INTO user (id,username,age,birthday) VALUES ('id1','zhangsan',20,'1995-03-22')";
        NSString *sql2 = @"INSERT OR REPLACE INTO user (id,username,age,birthday) VALUES ('id2','lisii',21,'1994-03-22')";
        NSString *sql3 = @"INSERT OR REPLACE INTO user (id,username,age,birthday) VALUES ('id3','wangwu',22,'1993-03-22')";
        NSString *sql4 = @"INSERT INTO user (id,username,age,birthday) VALUES ('id3','wangwu',22,'1993-03-22')";
        NSString *sql5 = @"update user set username='lisi' where id='id2'";
        NSString *sql6 = @"remove from user where id='id3'";
        
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
            
            [[result should] haveCountOf:3];
        });
        
        it(@"query:where:", ^{
            NSArray *result = [FMDBHelper query:tableName where:@"age>?", @20, nil];

            [[result should] haveCountOf:2];
        });
        
        it(@"queryById:from:", ^{
            NSDictionary *result = [FMDBHelper queryById:@"id1" from:tableName];
            
            [[result shouldNot] beNil];
        });
        
        it(@"totalRowOfTable:", ^{
            NSInteger totalRow = [FMDBHelper totalRowOfTable:tableName];
            
            [[theValue(totalRow) should] equal:theValue(3)];
        });
        
        it(@"totalRowOfTable:where:", ^{
            NSInteger totalRow = [FMDBHelper totalRowOfTable:tableName where:@"age>21"];
            
            [[theValue(totalRow) should] equal:theValue(1)];
        });
    });
});

SPEC_END