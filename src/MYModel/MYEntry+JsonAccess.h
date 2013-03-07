//
//  MYEntry+JsonAccess.h
//  MYFrameworkDemo
//
//  Created by Whirlwind on 13-1-22.
//  Copyright (c) 2013年 BOOHEE. All rights reserved.
//

#import "MYEntry.h"
#import "MYJsonAccess.h"

@interface MYEntry (JsonAccess)

+ (NSString *)modelName;
+ (NSString *)modelNameWithPlural;

/**  使用json字典初始化
 */
- (id)initWithJsonDictionary:(NSDictionary *)dic;

/** 从json字典中更新当前对象的属性
 */
- (void)updatePropertyWithJsonDictionary:(NSDictionary *)dic;

/** 从json数组中构造模型数组
 *  
 *  通过遍历调用[MYEntry initWithJsonDictionary:]初始化
 *
 *  @return 返回模型数组
 */
+ (NSArray *)parseModelArrayFromHashArray:(NSArray *)list;

/** 通过json key，设置property值
 *  @warning 只能设置NSObject类型的属性
 */
- (void)setPropertyWithJsonKey:(NSString *)key toValue:(NSObject *)obj;

#pragma mark - override

/** 转换json字段为对应的property字段
 *
 *  @param name json字段名称
 *  @return 返回属性名称
 */
+ (NSString *)convertJsonKeyNameToPropertyName:(NSString *)name;

/** 转换属性名为对应的json字段
 *
 *  @param name 属性名称
 *  @return 返回json字段
 */
+ (NSString *)convertPropertyNameToJsonKeyName:(NSString *)name;

- (NSMutableDictionary *)changesDictionarySerializeForJsonAccess;
@end
