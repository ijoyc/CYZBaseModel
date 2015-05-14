//
//  User.m
//  ModelAndDictionary
//
//  Created by Chen Yizhuo on 15/5/12.
//  Copyright (c) 2015年 Chen Yizhuo. All rights reserved.
//

#import "User.h"

@implementation User

- (NSString *)description
{
    return [NSString stringWithFormat:@"name = %@, userid = %@, address = %@, type = %d, dogs = %@", self.name, self.userID, self.address, self.type, self.dogs];
}

- (NSDictionary *)objectClassesInArray {
    return @{@"dogs": @"Dog"};
}

@end
