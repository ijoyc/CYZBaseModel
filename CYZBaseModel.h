//
//  CYZBaseModel.h
//  HappyRead
//
//  Created by YiZhuo Chen on 14-8-8.
//  Copyright (c) 2014年 陈一卓. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYZBaseModel : NSObject

/**
 *初始化方法，将传入字典的key对应的value赋值给Model对象中相应地属性。
 *@param aDict a Dictionary 该字典的key与attributeMapDictionary方法返回的字典的value同名，该字典的value为欲为属性赋的值
 *@return 返回实例变量
 */
- (id)initWithDict:(NSDictionary *)aDict;

/**
 *  初始化方法，传入json字符串，根据json字符串中的键值关系为对象相应属性赋值
 *  其映射关系可以在attributeMapDictionary中修改
 *
 *  @param json json字符串
 *
 *  @return 实例变量
 */
- (id)initWithJsonString:(NSString *)json;

/**
 *子类需要重写的方法，用以创建映射字典。
 *在该方法中将属性名称作为key值，与初始化时传入字典的key同名的字符串作为value。
 *若不重写，则返回nil,此时默认映射字典的key=value=初始化时传入字典的key同名的字符串。
 *@return 返回一个映射字典,或者nil(如果子类不重写)
 */
- (NSDictionary *)attributeMapDictionary;

/**
 *为实例变量赋以新的属性映射字典。
 *@param aDict a Dictionary 新的属性映射字典
 */
- (void)setAttributesDictionary:(NSDictionary *)aDict;

/**
 *  将自定义的对象转换成字典对象，属性名为键，属性值为值。
 */
- (NSDictionary *)dictionaryRepresentation;

@end
