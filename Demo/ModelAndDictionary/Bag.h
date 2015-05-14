//
//  Bag.h
//  ModelAndDictionary
//
//  Created by Chen Yizhuo on 15/5/13.
//  Copyright (c) 2015年 Chen Yizhuo. All rights reserved.
//

#import "CYZBaseModel.h"

@class Test;

@interface Bag : CYZBaseModel

@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) CGFloat price;
@property (strong, nonatomic) Test *t;

@end

@interface Test : CYZBaseModel
@property (strong, nonatomic) NSString *name;
@end