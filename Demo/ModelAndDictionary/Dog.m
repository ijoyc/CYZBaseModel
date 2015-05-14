//
//  Dog.m
//  ModelAndDictionary
//
//  Created by Chen Yizhuo on 15/5/12.
//  Copyright (c) 2015年 Chen Yizhuo. All rights reserved.
//

#import "Dog.h"

@implementation Dog

- (NSString *)description
{
    return [NSString stringWithFormat:@"name = %@, favour = %@", self.name, self.favour];
}

@end
