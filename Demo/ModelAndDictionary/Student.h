//
//  Student.h
//  ModelAndDictionary
//
//  Created by Chen Yizhuo on 15/5/13.
//  Copyright (c) 2015年 Chen Yizhuo. All rights reserved.
//

#import "CYZBaseModel.h"
#import "Bag.h"

@interface Student : CYZBaseModel

@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *desc;
@property (copy, nonatomic) NSString *nowName;
@property (copy, nonatomic) NSString *oldName;
@property (copy, nonatomic) NSString *nameChangedTime;
@property (strong, nonatomic) Bag *bag;

@end
