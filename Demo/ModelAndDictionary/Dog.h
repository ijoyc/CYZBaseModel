//
//  Dog.h
//  ModelAndDictionary
//
//  Created by Chen Yizhuo on 15/5/12.
//  Copyright (c) 2015年 Chen Yizhuo. All rights reserved.
//

#import "CYZBaseModel.h"

@interface Dog : CYZBaseModel

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *favour;
@property (assign, nonatomic) long long test;

@end
