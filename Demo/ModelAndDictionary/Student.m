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

- (NSString *)description
{
    return [NSString stringWithFormat:@"id = %@, desc = %@, oldname = %@, nowname = %@, namechangedtime = %@, bag = %@", self.ID, self.desc, self.oldName, self.nowName, self.nameChangedTime, self.bag];
}

@end
