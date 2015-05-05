# FMDBHelper
[![CI Status](http://img.shields.io/travis/lijingcheng/FMDBHelper.svg?style=flat)](https://travis-ci.org/lijingcheng/FMDBHelper)
[![Version](https://img.shields.io/cocoapods/v/FMDBHelper.svg?style=flat)](http://cocoadocs.org/docsets/FMDBHelper)
[![License](https://img.shields.io/cocoapods/l/FMDBHelper.svg?style=flat)](http://cocoadocs.org/docsets/FMDBHelper)
[![Platform](https://img.shields.io/cocoapods/p/FMDBHelper.svg?style=flat)](http://cocoadocs.org/docsets/FMDBHelper)

Easier to use FMDB, support the ORM and JSON into Model.

## Installation

pod "FMDBHelper"

## Usage

- Add #import "FMDBHelper.h" to your prefix.pch
-  Setting up the database file and the file must exist.
``` objc
[FMDBHelper setDataBaseName:@"demo.db"];
```
- Example
if you have a table like this:
``` js
user (
  id text PRIMARY KEY,
  username text,
  age integer,
  birthday text,
  dept text
)
```
or have a JSON like this:
``` js
{
  "id": "a1b2c3d4e5",
  "username": "李京城",
  "age": 31,
  "birthday": "1984/3/28",
  "dept":{
    "id": "f6g7h8i9j0",
    "name": "dev",
    "manager": "X"
  }
}
```

Create a model class and declare properties with the name of the JSON keys.

``` objc
//User.h
@interface User : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, strong) Dept *dept;

@end

//User.m
@implementation User

- (NSDictionary *)mapping
{
    return @{@"username": @"name"};
}

- (NSDictionary *)objectPropertys
{
    return @{@"dept": [Dept class]};
}

+ (NSString *)tableName
{
    return @"sys_user";
}

@end
```

``` objc
//insert
NSString *path = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"json"];
NSDictionary *keyValues = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingMutableLeaves error:nil];

User *user = [[User alloc] initWithDictionary:keyValues];

[FMDBHelper insertObject:user];

//query
NSDictionary *result = [FMDBHelper queryById:@"a1b2c3d4e5" from:[User tableName]];

User *user = [[User alloc] initWithDictionary:result];
NSLog(@"%@, %@, %ld, %@, %@", user.ID, user.name, (long)user.age, user.birthday, user.dept.keyValues);

Dept *dept = [[Dept alloc] initWithDictionary:user.dept.keyValues];

NSLog(@"%@, %@, %@", dept.ID, dept.name, dept.manager);

```

如果model类的名字与表名不一致，则需要重写tablename方法
If the model class name and the table name are not, you need to overwrite tableName method
``` objc
+ (NSString *)tableName
{
    return @"sys_user";
}
```

表的主键字段默认为"id"   不管数据来自数据库还是JSON，只要字段与Model类中的属性名字不一致，则需要重写mapping方法
``` objc
- (NSDictionary *)mapping
{
    return @{@"数据字段名称": @"Model类的属性名称"};
}

```
- 如果Model类的属性类型不是来自Foundation框架，而是自定义的另一Model类，则需要重写objectPropertys方法
``` objc
- (NSDictionary *)objectPropertys
{
    return @{@"dept": [Dept class]};@{@"Model类的属性名称": [该属性对应的类名 class]};
}
```

## Attention

Does not support Model collections, such as NSArray<User>* users;

## Author

[李京城](http://lijingcheng.github.io)

## License

MIT

