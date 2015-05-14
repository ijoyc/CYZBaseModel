//
//  Bag.m
//  ModelAndDictionary
//
//  Created by Chen Yizhuo on 15/5/13.
//  Copyright (c) 2015年 Chen Yizhuo. All rights reserved.
//

#import "Bag.h"

@implementation Bag

- (void)setPrice:(CGFloat)price {
    _price = price;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"name = %@, price = %f, t = %@", self.name, self.price, self.t];
}

@end

@implementation Test

- (NSString *)description
{
    return [NSString stringWithFormat:@"name = %@", self.name];
}

@end
