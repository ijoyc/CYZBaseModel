//
//  Weibo.h
//  ModelAndDictionary
//
//  Created by Chen Yizhuo on 15/5/12.
//  Copyright (c) 2015年 Chen Yizhuo. All rights reserved.
//

#import "CYZBaseModel.h"
#import "User.h"

@interface Weibo : CYZBaseModel

@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) int weiboID;
@property (assign, nonatomic) NSNumber *numberWeiboID;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) NSDictionary *userDictionary;

@end
