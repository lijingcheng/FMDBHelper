//
//  User.h
//  FMDBHelper
//
//  Created by 李京城 on 15/5/2.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Dog;
@class Dept;
@interface User : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, strong) Dept *dept;
@property (nonatomic, copy) NSArray<Dog *> *dogs;

@end
