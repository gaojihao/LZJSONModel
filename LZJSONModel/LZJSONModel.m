//
//  LZJSONModel.m
//  xingyujiaoyu
//
//  Created by lizhi54 on 2017/12/22.
//  Copyright © 2017年 com.lizhi1026. All rights reserved.
//

#import "LZJSONModel.h"
#import "NSArray+LZJSONModel.h"
#import "NSDictionary+LZJSONModel.h"
#import "JSONModelProperty.h"
#import "JSONModelKeyMapper.h"
#import "JSONModelError.h"
#import <objc/runtime.h>

NSString * const JSONModelBoolStringTrue = @"true";
NSString * const JSONModelBoolStringFalse = @"false";

static const char * kAssociatedMapperKey;
static const char * kAssociatedPropertiesKey;

@interface LZJSONModel (){
    BOOL _treatBoolAsStringWhenModelToJSON;
}

@end

@implementation LZJSONModel

- (void)_setupKeyMapper{
    
    if (objc_getAssociatedObject(self.class, &kAssociatedMapperKey) == nil) {
        
        JSONModelKeyMapper *keyMapper = [self.class modelKeyMapper];
        
        if (keyMapper != nil) {
            objc_setAssociatedObject(self.class, &kAssociatedMapperKey, keyMapper, OBJC_ASSOCIATION_RETAIN);
        }
    }
}

- (void)_setupPropertyMap{
    
    if (objc_getAssociatedObject(self.class, &kAssociatedPropertiesKey) == nil) {
        
        NSMutableDictionary *propertyMap = [NSMutableDictionary dictionary];
        
        Class class = [self class];
        
        while (class != [LZJSONModel class]) {
            unsigned int propertyCount;
            objc_property_t *properties = class_copyPropertyList(class, &propertyCount);
            for (unsigned int i = 0; i < propertyCount; i++) {
                
                objc_property_t property = properties[i];
                const char *propertyName = property_getName(property);
                NSString *name = [NSString stringWithUTF8String:propertyName];
                //属性的相关属性都在propertyAttrs中，包括其类型，protocol，存取修饰符等信息
                const char *propertyAttrs = property_getAttributes(property);
                NSString *typeString = [NSString stringWithUTF8String:propertyAttrs];
                JSONModelProperty *modelProperty = [[JSONModelProperty alloc] initWithName:name typeString:typeString];
                if (!modelProperty.isReadonly) {
                    [propertyMap setValue:modelProperty forKey:modelProperty.name];
                }
            }
            free(properties);
            
            class = [class superclass];
        }
        objc_setAssociatedObject(self.class, &kAssociatedPropertiesKey, propertyMap, OBJC_ASSOCIATION_RETAIN);
    }
}

//根据对应的属性类型，将value进行转换成合适的值
- (id)valueForProperty:(JSONModelProperty *)property
         withJSONValue:(id)value{
    
    id resultValue = value;
    if (value == nil || [value isKindOfClass:[NSNull class]]) {
        resultValue = nil;
    }else{
        if (property.valueType != LZClassPropertyTypeObject) {
            /*当属性为原始数据类型而对应的json dict中的value的类型为字符串对象的时候
             则对字符串进行相应的转换*/
            if ([value isKindOfClass:[NSString class]]) {
                if (property.valueType == LZClassPropertyTypeInt ||
                    property.valueType == LZClassPropertyTypeUnsignedInt||
                    property.valueType == LZClassPropertyTypeShort||
                    property.valueType == LZClassPropertyTypeUnsignedShort) {
                    resultValue = [NSNumber numberWithInt:[(NSString *)value intValue]];
                }
                if (property.valueType == LZClassPropertyTypeLong ||
                    property.valueType == LZClassPropertyTypeUnsignedLong ||
                    property.valueType == LZClassPropertyTypeLongLong ||
                    property.valueType == LZClassPropertyTypeUnsignedLongLong){
                    resultValue = [NSNumber numberWithLongLong:[(NSString *)value longLongValue]];
                }
                if (property.valueType == LZClassPropertyTypeFloat) {
                    resultValue = [NSNumber numberWithFloat:[(NSString *)value floatValue]];
                }
                if (property.valueType == LZClassPropertyTypeDouble) {
                    resultValue = [NSNumber numberWithDouble:[(NSString *)value doubleValue]];
                }
                if (property.valueType == LZClassPropertyTypeChar) {
                    //对于BOOL而言，@encode(BOOL) 为 c 也就是signed char
                    resultValue = [NSNumber numberWithBool:[(NSString *)value boolValue]];
                }
            }
        }else{
            Class valueClass = property.objectClass;
            //当当前属性为LZJSONModel类型
            if ([valueClass isSubclassOfClass:[LZJSONModel class]] &&
                [value isKindOfClass:[NSDictionary class]]) {
                resultValue = [[valueClass alloc] initWithJSONDictionary:value];
            }
            
            //当当前属性为NSString类型，而对应的json的value为非NSString对象，自动进行转换
            if ([valueClass isSubclassOfClass:[NSString class]] &&
                ![value isKindOfClass:[NSString class]]) {
                resultValue = [NSString stringWithFormat:@"%@",value];
            }
            
            //当当前属性为NSNumber类型，而对应的json的value为NSString的时候
            if ([valueClass isSubclassOfClass:[NSNumber class]] &&
                [value isKindOfClass:[NSString class]]) {
                NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
                resultValue = [numberFormatter numberFromString:value];
            }
            
            NSString *valueProtocol = [property.objectProtocols lastObject];
            if ([valueProtocol isKindOfClass:[NSString class]]) {
                Class valueProtocolClass = NSClassFromString(valueProtocol);
                if (valueProtocolClass != nil) {
                    if ([valueProtocolClass isSubclassOfClass:[LZJSONModel class]]) {
                        //array of models
                        if ([value isKindOfClass:[NSArray class]]) {
                            resultValue = [(NSArray *)value modelArrayWithClass:valueProtocolClass];
                        }
                        //dictionary of models
                        if ([value isKindOfClass:[NSDictionary class]]) {
                            resultValue = [(NSDictionary *)value modelDictionaryWithClass:valueProtocolClass];
                        }
                    }
                }
            }
        }
    }
    return resultValue;
}

+ (id)modelWithJSONDictionary:(NSDictionary *)dict{
    
    return [self modelWithJSONDictionary:dict error:NULL];
}

+ (id)modelWithJSONDictionary:(NSDictionary *)dict
                        error:(NSError *__autoreleasing *)error{
    
    return [[self alloc] initWithJSONDictionary:dict error:error];
}

- (id)init{
    self = [super init];
    if (self != nil) {
        [self _setupKeyMapper];
        [self _setupPropertyMap];
    }
    return self;
}

- (id)initWithJSONDictionary:(NSDictionary *)dict{
    
    return [self initWithJSONDictionary:dict error:NULL];
}

- (id)initWithJSONDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)error{
    
    if (!dict) {
        if (error) {
            *error = [JSONModelError errorNilInput];
        }
        return nil;
    }
    
    if (![dict isKindOfClass:[NSDictionary class]]) {
        if (error) {
            *error = [JSONModelError errorDataInvalidWithDescription:@"输入参数类型数错，应该为NSDictionary"];
        }
        return nil;
    }
    
    self = [self init];
    if (self != nil) {
        NSDictionary *propertyMap = objc_getAssociatedObject(self.class, &kAssociatedPropertiesKey);
        JSONModelKeyMapper *keyMapper = objc_getAssociatedObject(self.class, &kAssociatedMapperKey);
        
        //对JSON所有字段进行遍历，到 keyMapper 中查看是否有映射的属性名，然后再对属性进行设置
        [dict enumerateKeysAndObjectsUsingBlock:^(NSString *jsonKey, id jsonValue, BOOL *stop) {
            NSString *propertyKey = keyMapper ? [keyMapper modelKeyMappedFromJsonKey:jsonKey] : jsonKey;
            JSONModelProperty *modelProperty = [propertyMap valueForKey:propertyKey];
            if (modelProperty) {
                id propertyValue = [self valueForProperty:modelProperty withJSONValue:jsonValue];
                if (propertyValue != nil) {
                    [self setValue:propertyValue forKey:modelProperty.name];
                }
            }
        }];
    }
    return self;
}

- (NSDictionary *)toJSONDictionary{
    
    NSDictionary *propertyMap = objc_getAssociatedObject(self.class, &kAssociatedPropertiesKey);
    
    if (propertyMap!= nil && [propertyMap count] > 0) {
        NSMutableDictionary *jsonDictionary = [NSMutableDictionary dictionaryWithCapacity:[propertyMap count]];
        JSONModelKeyMapper *keyMapper = objc_getAssociatedObject(self.class, &kAssociatedMapperKey);
        
        for (JSONModelProperty *property in [propertyMap allValues]) {
            NSString *dictKey = property.name;
            id val = [self valueForKeyPath:dictKey];
            
            if ([val isKindOfClass:[LZJSONModel class]]) {
                val = [(LZJSONModel *)val toJSONDictionary];
            }else if([val isKindOfClass:[NSArray class]]){
                val = [(NSArray *)val toJSONArray];
            }else if([val isKindOfClass:[NSDictionary class]]){
                val = [(NSDictionary *)val toJSONDictionary];
            }
            
            if (keyMapper != nil) {
                NSString *mappedKey = [keyMapper jsonKeyMappedFromModelKey:dictKey];
                if (mappedKey != nil) {
                    dictKey = mappedKey;
                }
            }
            
            if (val != nil && dictKey != nil) {
                if (property.valueType == LZClassPropertyTypeChar) {
                    if (_treatBoolAsStringWhenModelToJSON &&
                        [val isKindOfClass:[NSNumber class]]) {
                        NSString *booleanString = nil;
                        if ([val boolValue]) {
                            booleanString = JSONModelBoolStringTrue;
                        }else{
                            booleanString = JSONModelBoolStringFalse;
                        }
                        [jsonDictionary setObject:booleanString forKey:dictKey];
                    }else{
                        [jsonDictionary setObject:val forKey:dictKey];
                    }
                }else{
                    [jsonDictionary setObject:val forKey:dictKey];
                }
            }
        }
        return jsonDictionary;
    }
    return nil;
}

- (void)setTreatBoolAsStringWhenModelToJSON:(BOOL)treatBoolAsStringWhenModelToJSON{
    
    _treatBoolAsStringWhenModelToJSON = treatBoolAsStringWhenModelToJSON;
}

- (id)copyWithZone:(NSZone *)zone {
    
    return [[self.class allocWithZone:zone] initWithJSONDictionary:[self toJSONDictionary] error:NULL];
}

- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

- (NSString *)description{
    
    return [NSString stringWithFormat:@"%@",[self toJSONDictionary]];
}

+ (JSONModelKeyMapper *)modelKeyMapper{
    
    NSDictionary *modelKeyMap = [self jsonToModelKeyMapDictionary];
    if (modelKeyMap) {
        return [[JSONModelKeyMapper alloc] initWithDictionary:modelKeyMap];
    } else {
        return nil;
    }
}

+ (NSDictionary *)jsonToModelKeyMapDictionary{
    
    return nil;
}

@end
