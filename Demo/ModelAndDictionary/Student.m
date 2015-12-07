//
//  Student.m
//  ModelAndDictionary
//
//  Created by Chen Yizhuo on 15/5/13.
//  Copyright (c) 2015年 Chen Yizhuo. All rights reserved.
//

#import "Student.h"

@implementation Student

- (NSDictionary *)attributeMapDictionary {
    return @{
             @"ID" : @"id",
             @"desc" : @"desciption",
             @"oldName" : @"name.oldName",
             @"nowName" : @"name.newName",
             @"nameChangedTime" : @"name.info.nameChangedTime",
             @"bag" : @"other.bag"
             };
}


@end
