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
- [FMDBHelper setDataBaseName:@"demo.db"];demo.db是已存在的数据库文件，FMDBHelper会将它复制到documents目录下


//Table structure:CREATE TABLE user (id text PRIMARY KEY,username text,age integer,birthday text,dept text)
if you have a JSON like this:
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
Create a new Objective-C class for your data model and declare properties in your header file with the name of the JSON keys:
``` objc
#import "Dept.h"

@interface User : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, strong) Dept *dept;

@end
```


- 如果model类的名字与它对应的数据库表名不一致，则需要重写tablename方法
``` objc
+ (NSString *)tableName
{
    return @"name";
}
```

- 表的主键字段默认为"id"   不管数据来自数据库还是JSON，只要字段与Model类中的属性名字不一致，则需要重写mapping方法
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



Table structure:CREATE TABLE user (id text PRIMARY KEY,username text,age integer,birthday text,dept text)
or



不支持Model collections，如@property (strong, nonatomic) NSArray<ProductModel>* products;

## Author

[李京城](http://lijingcheng.github.io)

## License

MIT

