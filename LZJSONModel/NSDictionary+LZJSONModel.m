//
//  NSDictionary+LZJSONModel.m
//  xingyujiaoyu
//
//  Created by lizhi54 on 2017/12/23.
//  Copyright © 2017年 com.lizhi1026. All rights reserved.
//

#import "NSDictionary+LZJSONModel.h"
#import "LZJSONModel.h"
#import "NSArray+LZJSONModel.h"

@implementation NSDictionary (LZJSONModel)

- (NSDictionary *)modelDictionaryWithClass:(Class)modelClass{
    
    NSMutableDictionary *modelDictionary = [NSMutableDictionary dictionary];
    
    for (NSString *key in self) {
        
        id object = [self objectForKey:key];
        
        if ([object isKindOfClass:[NSDictionary class]]) {
            [modelDictionary setObject:[[modelClass alloc] initWithJSONDictionary:object] forKey:key];
        }else if ([object isKindOfClass:[NSArray class]]){
            [modelDictionary setObject:[object modelArrayWithClass:modelClass] forKey:key];
        }else{
            [modelDictionary setObject:object forKey:key];
        }
    }
    return modelDictionary;
}

- (NSDictionary *)toJSONDictionary{
    
    NSMutableDictionary *jsonDictionary = [NSMutableDictionary dictionary];
    
    for (NSString *key in self) {
        
        id object = [self objectForKey:key];
        if ([object isKindOfClass:[LZJSONModel class]]) {
            [jsonDictionary setObject:[(LZJSONModel *)object toJSONDictionary] forKey:key];
            
        }else if ([object isKindOfClass:[NSArray class]]){
            
            [jsonDictionary setObject:[(NSArray *)object toJSONArray] forKey:key];
            
        }else{
            
            [jsonDictionary setObject:object forKey:key];
        }
    }
    return jsonDictionary;
}


@end
