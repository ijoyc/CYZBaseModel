//
//  main.m
//  ModelAndDictionary
//
//  Created by Chen Yizhuo on 15/5/12.
//  Copyright (c) 2015年 Chen Yizhuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Weibo.h"
#import "User.h"
#import "Student.h"
#import "Bag.h"

void dictionaryToModel_normal() {
    NSDictionary *dictionary = @{@"name": @"xiaowang",
                                 @"userID": @"45",
                                 @"followedMe": @YES,
                                 @"address": @"china",
                                 @"type": @(kUserTypeVIP)};
    User *userModel = [[User alloc] initWithDict:dictionary];
    NSLog(@"%@", userModel);
}

void jsonStringToModel() {
    NSString *jsonString = @"{\"name\":\"xiaoli\", \"userID\":\"14\", \"address\":\"china\", \"type\":1}";
    User *userModel = [[User alloc] initWithJsonString:jsonString];
    NSLog(@"%@", userModel);
}

void dictionaryToModel_contains() {
    NSDictionary *dict = @{@"name": @"lv",
                           @"price": @100.4,
                           @"t": @{@"name": @"testName"}};
    Bag *b = [[Bag alloc] initWithDict:dict];
    NSLog(@"%@", b);
}

void dictionaryToModel_containsArray() {
    NSDictionary *dict = @{@"nm": @"shangsi",
                           @"address": @"binhai",
                           @"userID": @"43",
                           @"dogs": @[@{@"name": @"xiaobai",
                                        @"favour": @"chi",},
                                      @{@"name": @"xiaohei",
                                        @"favour": @"he",},
                                      @{@"name": @"xiaohuang",
                                        @"favour": @"wan",}]
                           };
    User *user = [[User alloc] initWithDict:dict];
    NSLog(@"%@", user);
}

void dictionaryToModel_mapping() {
    NSDictionary *testMappingDictionary = @{
                                            @"id" : @"20",
                                            @"desciption" : @"kids",
                                            @"name" : @{
                                                    @"newName" : @"lufy",
                                                    @"oldName" : @"kitty",
                                                    @"info" : @{
                                                            @"nameChangedTime" : @"2013-08"
                                                            }
                                                    },
                                            @"other" : @{
                                                    @"bag" : @{
                                                            @"name" : @"a red bag",
                                                            @"price" : @100.7
                                                            }
                                                    }
                                            };
    Student *s = [[Student alloc] initWithDict:testMappingDictionary];
    NSLog(@"s = %@", s);
}

void DictionaryToModel_Example() {
    // dict -> model
    NSDictionary *dict = @{@"nm": @"zhangsan",
                           @"weiboID": @123,
                           @"numberWeiboID": @123,
                           @"time": @"today",
                           @"user": @{@"nm": @"shangsi",
                                      @"address": @"binhai",
                                      @"userID": @"43",
                                      @"dogs": @[@{@"name": @"xiaobai",
                                                   @"favour": @"chi",},
                                                 @{@"name": @"xiaohei",
                                                   @"favour": @"he",},
                                                 @{@"name": @"xiaohuang",
                                                   @"favour": @"wan",}]
                                      },
                           @"userDictionary": @{@"testKey1": @"testValue1",
                                                @"testKey2": @"testValue2"}};
    Weibo *w = [[Weibo alloc] initWithDict:dict];
    NSLog(@"%@", w);
}


void jsonArrayToModels() {
    NSArray *dictArray = @[@{@"name": @"lv", @"price": @14.4}, @{@"name": @"shuihuo", @"price": @1}];
    NSArray *bags = [Bag objectArrayWithJsonArray:dictArray];
    NSLog(@"bags = %@", bags);
}

void modelToDictionary() {
    // model -> dict
    Weibo *weibo = [[Weibo alloc] init];
    weibo.name = @"n";
    weibo.weiboID = 12;
    weibo.numberWeiboID = @1;
    NSDictionary *wd = [weibo dictionaryRepresentation];
    NSLog(@"%@", wd);
}

void modelToDictionary_complex() {
    Student *stu = [[Student alloc] init];
    stu.nowName = @"chen";
    stu.oldName = @"yi";
    stu.nameChangedTime = @"1";
    
    Bag *b = [[Bag alloc] init];
    b.name = @"fake lv";
    b.price = 1.1;
    
    Test *t = [[Test alloc] init];
    t.name = @"test";
    
    b.t = t;
    stu.bag = b;
    
    NSDictionary *studict = [stu dictionaryRepresentation];
    NSLog(@"studict = %@", studict);
}

void modelArrayToJsonStringAndJsonArray() {
    Bag *b1 = [[Bag alloc] init];
    b1.name = @"bag1";
    b1.price = 2.2;
    
    Bag *b2 = [[Bag alloc] init];
    b2.name = @"bag2";
    b2.price = 3.3;
    
    NSArray *bagArray = @[b1, b2];
    NSArray *jsonArray = [Bag jsonArrayWithObjectArray:bagArray];
    NSLog(@"%@", jsonArray);
    
    NSString *bagJsonString = [Bag jsonStringWithObjectArray:bagArray];
    NSLog(@"%@", bagJsonString);
}

void encodeAndDecode() {
    Bag *b2 = [[Bag alloc] init];
    b2.name = @"bag2";
    b2.price = 3.3;
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"test.plist"];
    NSLog(@"path = %@", path);
    [NSKeyedArchiver archiveRootObject:b2 toFile:path];
    
    Bag *unarchivedBag = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    NSLog(@"%@", unarchivedBag);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        dictionaryToModel_normal();
        
    }
    
    return 0;
}

