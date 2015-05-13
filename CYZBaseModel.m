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

- (id)initWithJsonString:(NSString *)json {
    self = [super init];
    if (self) {
        //解析json字符串
        NSError *error = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
        
        if (error) {
            NSLog(@"Error occured when init object with json string: %@, error: %@", json, error.localizedDescription);
            return nil;
        }
        
        self = [self initWithDict:dict];
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
    //获得完整的映射字典
    NSDictionary *mapDictionary = [self keyValuesForMapDictionary:aDict];
    
    //遍历映射字典
    NSEnumerator *keyEnumerator = [mapDictionary keyEnumerator];
    id attributeName = nil;
    while ((attributeName = [keyEnumerator nextObject])) {
        //获得属性的setter
        SEL setter = [self setterWithAttributeName:attributeName];
        if ([self respondsToSelector:setter]) {
            //获得映射字典的值，也就是传入字典的键
            NSString *aDictKey = [mapDictionary objectForKey:attributeName];
            //获得传入字典的键对应的值，也就是要赋给属性的值
            id aDictValue = [aDict objectForKey:aDictKey];
            
            //获取该属性的类型名，便于接下来分别处理。
            objc_property_t property = class_getProperty([self class], [attributeName cStringUsingEncoding:NSUTF8StringEncoding]);
            NSString *type = [self propertyTypeForProperty:property];
            
            if ([aDictValue isKindOfClass:[NSDictionary class]]) {
                //如果传入的字典中还包括自定义对象，则找出它的类为它赋值。
                
                if ([type isEqualToString:@"NSDictionary"] == NO && [type isEqualToString:@"NSMutableDictionary"] == NO) {
                    //如果该类型不是字典类型，说明是自定义对象。
                    
                    Class newClass = objc_getClass([type cStringUsingEncoding:NSUTF8StringEncoding]);
                    //如果是该类的子类，说明能响应initWithDict:方法并且能建立映射字典。
                    if ([newClass isSubclassOfClass:[CYZBaseModel class]]) {
                        id instance = [[newClass alloc] initWithDict:aDictValue];
                        [self performSelectorOnMainThread:setter withObject:instance waitUntilDone:[NSThread isMainThread]];
                    }
                    
                } else {
                    //要赋值的属性也是字典类型，则直接赋值。
                    [self performSelectorOnMainThread:setter withObject:aDictValue waitUntilDone:[NSThread isMainThread]];
                }
            } else if ([aDictValue isKindOfClass:[NSArray class]]) {
                //如果
            } else if ([aDictValue isKindOfClass:[NSNumber class]]) {
                //数字类型需要分类讨论
                
                if ([type isEqualToString:@"NSNumber"]) {
                    //如果属性也是NSNumber类型，则直接赋值。
                    [self performSelectorOnMainThread:setter withObject:aDictValue waitUntilDone:[NSThread isMainThread]];
                } else {
                    //如果属性不是NSNumber，说明是基本类型。
                    
                    //获得最大的数据类型，保证值不丢失。
                    long long basicValue = [aDictValue longLongValue];
                    //调用method，传递基本类型的方法：使用NSInvocation。
                    NSMethodSignature *signature = [self methodSignatureForSelector:setter];
                    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
                    invocation.selector = setter;
                    invocation.target = self;
                    //第0和第1个参数分别是self和_cmd，由NSInvocation自动设置。
                    [invocation setArgument:&basicValue atIndex:2];
                    [invocation invoke];
                }
                
            } else {
                //如果该值是其他普通的类型，则为属性赋值
                [self performSelectorOnMainThread:setter withObject:aDictValue waitUntilDone:[NSThread isMainThread]];
            }
            
            
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
//        NSLog(@"key = %@, value = %@, value class = %@, changed Key = %@", key, value, NSStringFromClass([value class]), [keyValueMap objectForKey:key]);
        
        //如果用户在映射字典中提供了映射关系，则修改最终生成字典中相应的键。
        if ([keyValueMap.allKeys containsObject:key]) {
            key = [keyValueMap objectForKey:key];
        }
        
        //only add it to dictionary if it is not nil
        if (key && value) {
            [dict setObject:value forKey:key];
        } else if (key && value == nil) {
            //如果当前对象该值为空，设为nil。在字典中直接加nil会抛异常，需要加NSNull对象。
            [dict setObject:[NSNull null] forKey:key];
        }
    }
    
    free(properties);
    return dict;
}

#pragma mark - Private Methods

- (NSDictionary *)keyValuesForMapDictionary:(NSDictionary *)aDict {
    //获得映射字典
    NSMutableDictionary *mapDictionary = [[self attributeMapDictionary] mutableCopy];
    
    //如果子类没有重写attributeMapDictionary方法，则使用默认映射字典
    if (mapDictionary == nil) {
        mapDictionary = [NSMutableDictionary dictionaryWithCapacity:aDict.count];
    }
    
    //对传入字典遍历，为映射字典赋值
    for (NSString *key in aDict) {
        //如果当期的映射字典中含有该键值，说明子类已经为该属性建立了映射关系了。
        if ([mapDictionary.allKeys containsObject:key]) {
            continue;
        }
        //将子类没有建立映射的键映射为自身
        [mapDictionary setObject:key forKey:key];
    }
    
    return mapDictionary;
}

- (SEL)setterWithAttributeName:(NSString *)attributeName
{
    NSString *firstAlpha = [[attributeName substringToIndex:1] uppercaseString];
    NSString *otherAlpha = [attributeName substringFromIndex:1];
    NSString *setterMethodName = [NSString stringWithFormat:@"set%@%@:", firstAlpha, otherAlpha];
    return NSSelectorFromString(setterMethodName);
}

- (NSString *)propertyTypeForProperty:(objc_property_t)property {
    const char *attrs = property_getAttributes(property);

    //ie. T@"NSString",....... or Ti,...
    if (attrs == NULL) {
        return nil;
    }
    
    NSString *type = [NSString stringWithCString:attrs encoding:NSUTF8StringEncoding];
    
    type = [type componentsSeparatedByString:@","].firstObject;  //ie.T@"NSString" or Ti
    
    //如果包含@说明是对象类型(id 为@)
    if ([type containsString:@"@"]) {
        type = [self propertyTypeForObject:type];
    } else {
        type = [self propertyTypeForBasicDataType:type];
    }
    
    return type;
}

- (NSString *)propertyTypeForObject:(NSString *)type {
    
    type = [type substringFromIndex:3]; //ie. NSString"
    type = [type substringToIndex:[type rangeOfString:@"\""].location]; //ie. NSString
    
    return type;
}

- (NSString *)propertyTypeForBasicDataType:(NSString *)type {
    
    //不考虑结构体、共用体、枚举以及函数指针、块等（实际开发中不可能出现）
    //每个基本型的类型代号都为一个字符（long long为Tq）
    type = [type substringToIndex:1];   //ie. i
    
    return type;
}


@end
