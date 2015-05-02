# FMDBHelper
[![CI Status](http://img.shields.io/travis/lijingcheng/FMDBHelper.svg?style=flat)](https://travis-ci.org/lijingcheng/FMDBHelper)
[![Version](https://img.shields.io/cocoapods/v/FMDBHelper.svg?style=flat)](http://cocoadocs.org/docsets/FMDBHelper)
[![License](https://img.shields.io/cocoapods/l/FMDBHelper.svg?style=flat)](http://cocoadocs.org/docsets/FMDBHelper)
[![Platform](https://img.shields.io/cocoapods/p/FMDBHelper.svg?style=flat)](http://cocoadocs.org/docsets/FMDBHelper)

Easier to use FMDB and support the ORM.
(PS: Support JSON into Model)

## Installation

pod "FMDBHelper"

## Usage

- Add #import "FMDBHelper.h" to your prefix.pch
- If you want to use FMDBHelper without all those pesky 'jc_' prefixes. Add #define JC_SHORTHAND_ORM to your prefix.pch before importing FMDBHelper.
- 
//
- [FMDBHelper setDataBaseName:@"demo.db"];demo.db不会自动创建，需要用户自己将建好的数据库文件入在mainBundle，

强调下，obj对应的数据库表如果与类名不一致，则需要重写tablename方法。。。表的主键id默认必须叫"id"

Table structure:CREATE TABLE user (id text PRIMARY KEY,username text,age integer,birthday text,dept text)
or
{
  "id": "a1b2c3d4e5",
  "username": "李京城",
  "age": 31,
  "birthday": "1984/3/28",
  "dept":{
    "id": "f6g7h8i9j0",
    "name": "",
    "manager": ""
  },
}

## Author

[李京城](http://lijingcheng.github.io)

## License

MIT

