//
//  JSONModelError.h
//  xingyujiaoyu
//
//  Created by lizhi54 on 2017/12/24.
//  Copyright © 2017年 com.lizhi1026. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const LZ_JSONModelErrorDomain;

typedef NS_ENUM(int, LZJSONModelErrorCode) {
    LZJSONModelErrorCodeNilInput = 1,
    LZJSONModelErrorCodeDataInvalid = 2
};


NS_ASSUME_NONNULL_BEGIN

@interface JSONModelError : NSError

+ (id)errorNilInput;
+ (id)errorDataInvalidWithDescription:(NSString *)description;

@end

NS_ASSUME_NONNULL_END
