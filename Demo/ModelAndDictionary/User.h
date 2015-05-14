//
//  User.h
//  ModelAndDictionary
//
//  Created by Chen Yizhuo on 15/5/12.
//  Copyright (c) 2015年 Chen Yizhuo. All rights reserved.
//

#import "CYZBaseModel.h"
#import "Dog.h"

typedef enum {
    kUserTypeNormal,
    kUserTypeVIP
} UserType;

@interface User : CYZBaseModel

@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSString *userID;

@property (assign, nonatomic) BOOL followedMe;

@property (strong, nonatomic) NSString *address;

@property (strong, nonatomic) NSArray *dogs;

@property (assign, nonatomic) UserType type;

@end
