//
//  JSONModelError.m
//  xingyujiaoyu
//
//  Created by lizhi54 on 2017/12/24.
//  Copyright © 2017年 com.lizhi1026. All rights reserved.
//

#import "JSONModelError.h"

NSString * const LZ_JSONModelErrorDomain = @"LZ_JSONModelErrorDomain";

@implementation JSONModelError

+ (JSONModelError *)errorNilInput{
    return [JSONModelError errorWithDomain:LZ_JSONModelErrorDomain code:LZJSONModelErrorCodeNilInput userInfo:@{NSLocalizedDescriptionKey: @"用于创建TBJSONModel的参数为nil"}];
}

+ (JSONModelError *)errorDataInvalidWithDescription:(NSString *)description{
    return [JSONModelError errorWithDomain:LZ_JSONModelErrorDomain code:LZJSONModelErrorCodeDataInvalid userInfo:@{NSLocalizedDescriptionKey: description}];
}

@end
