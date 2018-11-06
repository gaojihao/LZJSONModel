//
//  NSArray+LZJSONModel.m
//  xingyujiaoyu
//
//  Created by lizhi54 on 2017/12/23.
//  Copyright © 2017年 com.lizhi1026. All rights reserved.
//

#import "NSArray+LZJSONModel.h"
#import "LZJSONModel.h"

@implementation NSArray (LZJSONModel)

- (NSArray *)modelArrayWithClass:(Class)modelClass{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (id object in self) {
        if ([object isKindOfClass:[NSArray class]]) {
            [modelArray addObject:[object modelArrayWithClass:modelClass]];
        }else if ([object isKindOfClass:[NSDictionary class]]){
            [modelArray addObject:[[modelClass alloc] initWithJSONDictionary:object]];
        }else{
            [modelArray addObject:object];
        }
    }
    return modelArray;
}


- (NSArray *)toJSONArray{
    NSMutableArray *jsonArray = [NSMutableArray array];
    
    for (id object in self) {
        if ([object isKindOfClass:[LZJSONModel class]]) {
            NSDictionary *objectDict = [(LZJSONModel *)object toJSONDictionary];
            [jsonArray addObject:objectDict];
        }else if ([object isKindOfClass:[NSArray class]]){
            [jsonArray addObject:[object toJSONArray]];
        }else{
            [jsonArray addObject:object];
        }
    }
    
    return jsonArray;
}

@end
