//
//  Weibo.m
//  ModelAndDictionary
//
//  Created by Chen Yizhuo on 15/5/12.
//  Copyright (c) 2015年 Chen Yizhuo. All rights reserved.
//

#import "Weibo.h"

@implementation Weibo

- (NSDictionary *)attributeMapDictionary {
    NSDictionary *dict = @{@"name": @"nm"};
    return dict;
}

- (void)setWeiboID:(int)weiboID {
    _weiboID = weiboID;
}

- (void)setNumberWeiboID:(NSNumber *)numberWeiboID {
    _numberWeiboID = numberWeiboID;
}


@end
