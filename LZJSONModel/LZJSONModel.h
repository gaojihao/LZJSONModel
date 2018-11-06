//
//  LZJSONModel.h
//  xingyujiaoyu
//
//  Created by lizhi54 on 2017/12/22.
//  Copyright © 2017年 com.lizhi1026. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JSONModelKeyMapper;
@class JSONModelError;

NS_ASSUME_NONNULL_BEGIN

@interface LZJSONModel : NSObject

+ (id)modelWithJSONDictionary:(NSDictionary *)dict;
+ (id)modelWithJSONDictionary:(NSDictionary *)dict error:(NSError **)error;

- (id)initWithJSONDictionary:(NSDictionary *)dict;
- (id)initWithJSONDictionary:(NSDictionary *)dict error:(NSError **)error;

- (NSDictionary *)toJSONDictionary;

- (void)setTreatBoolAsStringWhenModelToJSON:(BOOL)treatBoolAsStringWhenModelToJSON;

+ (JSONModelKeyMapper *)modelKeyMapper;

//此Dictionary的key为json对应的字段名，value为Model对应的属性名
+ (NSDictionary *)jsonToModelKeyMapDictionary;

@end

NS_ASSUME_NONNULL_END
