//
//  CYZBaseModel.m
//  HappyRead
//
//  Created by YiZhuo Chen on 14-8-8.
//  Copyright (c) 2014年 陈一卓. All rights reserved.
//

#import "CYZBaseModel.h"
#import <objc/runtime.h>

@interface CYZBaseModel ()

- (SEL)_getSetterWithAttributeName:(NSString *)attributeName;

@end

@implementation CYZBaseModel

- (id)initWithDict:(NSDictionary *)aDict
{
    self = [super init];
    
    if (self) {
        //建立映射关系
        [self setAttributesDictionary:aDict];
    }
    
    return self;
}

- (NSDictionary *)attributeMapDictionary
{
    //子类需要重写的方法
    //NSAssert(NO, "You should override this method in Your Custom Class");
    return nil;
}

- (void)setAttributesDictionary:(NSDictionary *)aDict
{
    //获得映射字典
    NSDictionary *mapDictionary = [self attributeMapDictionary];
    
    //如果子类没有重写attributeMapDictionary方法，则使用默认映射字典
    if (mapDictionary == nil) {
        NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithCapacity:aDict.count];
        for (NSString *key in aDict) {
            [tempDict setObject:key forKey:key];
        }
        mapDictionary = tempDict;
    }
    
    //遍历映射字典
    NSEnumerator *keyEnumerator = [mapDictionary keyEnumerator];
    id attributeName = nil;
    while ((attributeName = [keyEnumerator nextObject])) {
        //获得属性的setter
        SEL setter = [self _getSetterWithAttributeName:attributeName];
        if ([self respondsToSelector:setter]) {
            //获得映射字典的值，也就是传入字典的键
            NSString *aDictKey = [mapDictionary objectForKey:attributeName];
            //获得传入字典的键对应的值，也就是要赋给属性的值
            id aDictValue = [aDict objectForKey:aDictKey];
            
            //为属性赋值
            [self performSelectorOnMainThread:setter withObject:aDictValue waitUntilDone:[NSThread isMainThread]];
        }
    }
}

- (NSDictionary *)dictionaryRepresentation {
    unsigned int count = 0;
    //get a list of all properties of this class
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:count];
    
    NSDictionary *keyValueMap = [self attributeMapDictionary];
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        id value = [self valueForKey:key];
        NSLog(@"key = %@, value = %@, value class = %@, changed Key = %@", key, value, NSStringFromClass([value class]), [keyValueMap objectForKey:key]);
        key = [keyValueMap objectForKey:key];
        //only add it to dictionary if it is not nil
        if (key && value) {
            [dict setObject:value forKey:key];
        }
    }
    
    free(properties);
    return dict;
}

#pragma mark - Private Methods

- (SEL)_getSetterWithAttributeName:(NSString *)attributeName
{
    NSString *firstAlpha = [[attributeName substringToIndex:1] uppercaseString];
    NSString *otherAlpha = [attributeName substringFromIndex:1];
    NSString *setterMethodName = [NSString stringWithFormat:@"set%@%@:", firstAlpha, otherAlpha];
    return NSSelectorFromString(setterMethodName);
}

@end
