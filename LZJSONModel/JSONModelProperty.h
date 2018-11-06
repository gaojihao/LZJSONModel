//
//  JSONModelProperty.h
//  xingyujiaoyu
//
//  Created by lizhi54 on 2017/12/22.
//  Copyright © 2017年 com.lizhi1026. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LZJSONModelPropertyValueType) {
    LZClassPropertyValueTypeNone = 0,
    LZClassPropertyTypeChar,
    LZClassPropertyTypeInt,
    LZClassPropertyTypeShort,
    LZClassPropertyTypeLong,
    LZClassPropertyTypeLongLong,
    LZClassPropertyTypeUnsignedChar,
    LZClassPropertyTypeUnsignedInt,
    LZClassPropertyTypeUnsignedShort,
    LZClassPropertyTypeUnsignedLong,
    LZClassPropertyTypeUnsignedLongLong,
    LZClassPropertyTypeFloat,
    LZClassPropertyTypeDouble,
    LZClassPropertyTypeBool,
    LZClassPropertyTypeVoid,
    LZClassPropertyTypeCharString,
    LZClassPropertyTypeObject,
    LZClassPropertyTypeClassObject,
    LZClassPropertyTypeSelector,
    LZClassPropertyTypeArray,
    LZClassPropertyTypeStruct,
    LZClassPropertyTypeUnion,
    LZClassPropertyTypeBitField,
    LZClassPropertyTypePointer,
    LZClassPropertyTypeUnknow
};

NS_ASSUME_NONNULL_BEGIN

@interface JSONModelProperty : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) LZJSONModelPropertyValueType valueType;

@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, assign) Class objectClass;
@property (nonatomic, retain) NSArray *objectProtocols;
@property (nonatomic, assign) BOOL isReadonly;

- (id)initWithName:(NSString *)name typeString:(NSString *)typeString;

@end

NS_ASSUME_NONNULL_END
