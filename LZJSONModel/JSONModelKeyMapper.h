//
//  JSONModelKeyMapper.h
//  xingyujiaoyu
//
//  Created by lizhi54 on 2017/12/22.
//  Copyright © 2017年 com.lizhi1026. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSONModelKeyMapper : NSObject

//映射字典自身的key为json的字段名，value为model的属性名
- (id)initWithDictionary:(NSDictionary *)dict;

- (NSString *)modelKeyMappedFromJsonKey:(NSString *)jsonKey;
- (NSString *)jsonKeyMappedFromModelKey:(NSString *)modelKey;

@end

NS_ASSUME_NONNULL_END
