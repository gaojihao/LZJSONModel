//
//  JSONModelKeyMapper.m
//  xingyujiaoyu
//
//  Created by lizhi54 on 2017/12/22.
//  Copyright © 2017年 com.lizhi1026. All rights reserved.
//

#import "JSONModelKeyMapper.h"

@interface JSONModelKeyMapper()

@property(strong,nonatomic) NSMutableDictionary *jsonToModelMap;
@property(strong,nonatomic) NSMutableDictionary *modelToJsonMap;

@end

@implementation JSONModelKeyMapper

- (id)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self != nil) {
        self.jsonToModelMap = [[NSMutableDictionary alloc] initWithDictionary:dict];
        self.modelToJsonMap = [[NSMutableDictionary alloc] initWithCapacity:[dict count]];
        for (NSString *key in dict) {
            self.modelToJsonMap[dict[key]] = key;
        }
    }
    return self;
}


- (NSString *)modelKeyMappedFromJsonKey:(NSString *)jsonKey{
    NSString *mapped =  [self.jsonToModelMap objectForKey:jsonKey];
    return mapped ? mapped : jsonKey;
}

- (NSString *)jsonKeyMappedFromModelKey:(NSString *)modelKey{
    NSString *mapped = [self.modelToJsonMap objectForKey:modelKey];
    return mapped ? mapped : modelKey;
}

@end
