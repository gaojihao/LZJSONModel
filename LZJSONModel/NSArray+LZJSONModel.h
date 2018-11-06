//
//  NSArray+LZJSONModel.h
//  xingyujiaoyu
//
//  Created by lizhi54 on 2017/12/23.
//  Copyright © 2017年 com.lizhi1026. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (LZJSONModel)

- (NSArray *)modelArrayWithClass:(Class)modelClass;

- (NSArray *)toJSONArray;

@end

NS_ASSUME_NONNULL_END
