//
//  MAXEntityModelReplace.m
//  ConvertTools
//
//  Created by maxfong on 14-9-14.
//
//

#import "MAXEntityModelReplace.h"

typedef NS_ENUM(NSUInteger, TCTReplicaModel)
{
    ___REQUESTHEADFILENAME___,
    ___REQUESTCOMPLIEFILENAME___,
    ___RESPONSEHEADFILENAME___,
    ___RESPONSECOMPLIEFILENAME___,
    ___PROJECTNAME___,
    ___DATE___,
    ___USERNAME___,
    ___COPYRIGHT___,
    ___IMPORTHEADER_ENTITYFILEREQUESTSUPERCLASS___,
    ___IMPORTHEADER_ENTITYFILERESPONSESUPERCLASS___,
    ___FILEREQUESTNAMEASIDENTIFIER___,
    ___FILERESPONSENAMEASIDENTIFIER___,
    ___VARIABLE_ENTITYFILEREQUESTSUPERCLASS___,
    ___VARIABLE_ENTITYFILERESPONSESUPERCLASS___,
    ___IMPORTHEADER_ENTITYFILEREFERENCE___,
    ___SUBIMPLEMENTATION___,
    ___REQUESTFILEBASENAME___,
    ___RESPONSEFILEBASENAME___,
    ___REQUESTINIT___,
    ___PROPERTYNAME___
};

#define replicaModelArray \
@[\
@"___REQUESTHEADFILENAME___",\
@"___REQUESTCOMPLIEFILENAME___",\
@"___RESPONSEHEADFILENAME___",\
@"___RESPONSECOMPLIEFILENAME___",\
@"___PROJECTNAME___",\
@"___DATE___",\
@"___USERNAME___",\
@"___COPYRIGHT___",\
@"___IMPORTHEADER_ENTITYFILEREQUESTSUPERCLASS___",\
@"___IMPORTHEADER_ENTITYFILERESPONSESUPERCLASS___",\
@"___FILEREQUESTNAMEASIDENTIFIER___",\
@"___FILERESPONSENAMEASIDENTIFIER___",\
@"___VARIABLE_ENTITYFILEREQUESTSUPERCLASS___",\
@"___VARIABLE_ENTITYFILERESPONSESUPERCLASS___",\
@"___IMPORTHEADER_ENTITYFILEREFERENCE___",\
@"___SUBIMPLEMENTATION___",\
@"___REQUESTFILEBASENAME___",\
@"___RESPONSEFILEBASENAME___",\
@"___REQUESTINIT___",\
@"___PROPERTYNAME___"\
];

NSString *const TCTModelFileServerNameKey = @"serverName";
NSString *const TCTModelFileInterfaceKey = @"interface";

@implementation MAXEntityModelReplace

+ (NSString *)replaceStringWithString:(NSString *)string object:(NSDictionary *)dictionary fileModel:(TCTFileEntityModel)fileModel options:(NSDictionary *)options
{
    __block NSString *originString = [string copy];
    NSArray *replaceModels = replicaModelArray;
    __block typeof(self) weakSelf = self;
    [replaceModels enumerateObjectsUsingBlock:^(NSString *value, NSUInteger idx, BOOL *stop)
     {
         NSString *replaceString = [weakSelf replaceStringWithKey:value object:dictionary fileModel:fileModel options:options];
         originString = [originString stringByReplacingOccurrencesOfString:value withString:replaceString];
     }];
    return originString;
}

+ (NSString *)replaceStringWithKey:(NSString *)key object:(NSDictionary *)dictionary fileModel:(TCTFileEntityModel)fileModel options:(NSDictionary *)options
{
    NSArray *replaceModels = replicaModelArray;
    return [self replaceStringWithModel:[replaceModels indexOfObject:key] object:dictionary fileModel:fileModel options:options];
}

+ (NSString *)replaceStringWithModel:(TCTReplicaModel)model object:(NSDictionary *)dictionary fileModel:(TCTFileEntityModel)fileModel options:(NSDictionary *)options
{
    switch (model)
    {
        case ___REQUESTHEADFILENAME___:
        {
            return [NSString stringWithFormat:@"Request%@.h", options[TCTModelFileServerNameKey] ?: @"<#serverName#>"];
        }
            break;
        case ___REQUESTCOMPLIEFILENAME___:
        {
            return [NSString stringWithFormat:@"Request%@.m", options[TCTModelFileServerNameKey] ?: @"<#serverName#>"];
        }
            break;
        case ___RESPONSEHEADFILENAME___:
        {
            return [NSString stringWithFormat:@"Response%@.h", options[TCTModelFileServerNameKey] ?: @"<#serverName#>"];
        }
            break;
        case ___RESPONSECOMPLIEFILENAME___:
        {
            return [NSString stringWithFormat:@"Response%@.m", options[TCTModelFileServerNameKey] ?: @"<#serverName#>"];
        }
            break;
        case ___PROJECTNAME___:
        {
            NSDictionary *dicAppInfo = [[NSBundle mainBundle] infoDictionary];
            return [dicAppInfo valueForKey:@"CFBundleExecutable"] ?: @"";
        }
            break;
        case ___DATE___:
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            return [dateFormatter stringFromDate:[NSDate date]];
        }
            break;
        case ___USERNAME___:
        {
            return NSUserName();
        }
            break;
        case ___COPYRIGHT___:
        {
            return @"";
        }
            break;
        case ___IMPORTHEADER_ENTITYFILEREQUESTSUPERCLASS___:
        {
            return @"#import \"RequestSuperObj.h\"";
        }
            break;
        case ___IMPORTHEADER_ENTITYFILERESPONSESUPERCLASS___:
        {
            return @"#import <Foundation/Foundation.h>";
        }
            break;
        case ___FILEREQUESTNAMEASIDENTIFIER___:
        {
            return [NSString stringWithFormat:@"Request%@", options[TCTModelFileServerNameKey] ?: @"<#serverName#>"];
        }
            break;
        case ___FILERESPONSENAMEASIDENTIFIER___:
        {
            return [NSString stringWithFormat:@"Response%@", options[TCTModelFileServerNameKey] ?: @"<#serverName#>"];
        }
            break;
        case ___VARIABLE_ENTITYFILEREQUESTSUPERCLASS___:
        {
            return @"RequestSuperObj";
        }
            break;
        case ___VARIABLE_ENTITYFILERESPONSESUPERCLASS___:
        {
            return @"NSObject";
        }
            break;
        case ___REQUESTFILEBASENAME___:
        {
            return [NSString stringWithFormat:@"Request%@", options[TCTModelFileServerNameKey] ?: @"<#serverName#>"];
        }
            break;
        case ___RESPONSEFILEBASENAME___:
        {
            return [NSString stringWithFormat:@"Response%@", options[TCTModelFileServerNameKey] ?: @"<#serverName#>"];
        }
            break;
        case ___REQUESTINIT___:
        {
            NSString *serverName = ([options[TCTModelFileServerNameKey] length] > 0) ? options[TCTModelFileServerNameKey] : nil;
            NSString *interface = ([options[TCTModelFileInterfaceKey] length] > 0) ? [options[TCTModelFileInterfaceKey] lowercaseString] : nil;
            return [NSString stringWithFormat:@"- (id)init\n\
{\n\
    if (self = [super init])\n\
    {\n\
        [self setInterfaceURL:@\"/%@\" Type:outer_4_Domain];\n\
        self.serviceName = @\"%@\";\n\
    }\n\
    return self;\n}", interface ?:@"<#interface#>", serverName ?: @"<#serverName#>"];
        }
            break;
        case ___IMPORTHEADER_ENTITYFILEREFERENCE___:
        case ___SUBIMPLEMENTATION___:
        {
            return [self refereceStringWithDictionary:dictionary fileModel:fileModel];
        }
            break;
        case ___PROPERTYNAME___:
        {
            return [self propertyStringsWithDictionary:dictionary];
        }
            break;
        default: return @"unknow";
    }
}

+ (NSString *)propertyStringsWithDictionary:(NSDictionary *)dictionary
{
    NSMutableString *propertyStrings = [NSMutableString string];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
     {
         NSString *propertyString = nil;
         if ([obj isKindOfClass:[NSArray class]])
         {
             propertyString = [self propertyStringWithArrayName:key];
         }
         else if ([obj isKindOfClass:[NSDictionary class]])
         {propertyString = [self propertyStringWithStringName:key];
             propertyString = [self propertyStringWithDictionaryName:key];
         }
         else
         {
             propertyString = [self propertyStringWithStringName:key];
         }
         [propertyStrings appendString:propertyString];
     }];
    return propertyStrings;
}

+ (NSString *)propertyStringWithStringName:(NSString *)propertyName
{
    return [NSString stringWithFormat:@"@property (nonatomic, retain) NSString *%@;\n", propertyName];
}
+ (NSString *)propertyStringWithArrayName:(NSString *)propertyName
{
    return [NSString stringWithFormat:@"@property (nonatomic, retain) NSMutableArray *%@;\n", propertyName];
}
+ (NSString *)propertyStringWithDictionaryName:(NSString *)propertyName
{
    return [NSString stringWithFormat:@"@property (nonatomic, retain) %@ *%@;\n", propertyName, propertyName];
}

+ (NSString *)objectStringWithDictionary:(NSDictionary *)dictionary className:(NSString *)className fileModel:(TCTFileEntityModel)fileModel
{
    __block NSMutableString *objectString = [NSMutableString string];
    if ([dictionary isKindOfClass:[NSDictionary class]])
    {
        switch (fileModel)
        {
            case TCTRequestHeadEntity:
            case TCTResponseHeadEntity:
            {
                [objectString appendString:[NSString stringWithFormat:@"\n\n@interface %@ : NSObject\n\n", className]];
                
                NSString *propertyString = [self propertyStringsWithDictionary:dictionary];
                [objectString appendString:propertyString];
                
                [objectString appendString:@"\n@end"];
            }
                break;
            case TCTRequestComplieEntity:
            case TCTResponseComplieEntity:
            {
                [objectString appendString:[NSString stringWithFormat:@"\n\n@implementation %@\n\n", className]];
                [objectString appendString:@"\n@end"];
            }
            default:
                break;
        }
    }
    return objectString;
}

+ (NSString *)subObjectStringWithDictionary:(NSDictionary *)dictionary className:(NSString *)className fileModel:(TCTFileEntityModel)fileModel
{
    __block NSMutableString *objectString = [[self objectStringWithDictionary:dictionary className:className fileModel:fileModel] mutableCopy];
    
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
    {
        if ([obj isKindOfClass:[NSArray class]])
        {
            [objectString appendString:[self subObjectStringWithDictionary:obj[0] className:key fileModel:fileModel]];
        }
        else if ([obj isKindOfClass:[NSDictionary class]])
        {
            [objectString appendString:[self subObjectStringWithDictionary:obj className:key fileModel:fileModel]];
        }
        else
        {
        }
    }];
    return objectString;
}

+ (NSString *)objectComplieStringWithDictionary:(NSDictionary *)dictionary className:(NSString *)className
{
    __block NSMutableString *objectString = [NSMutableString string];
    if ([dictionary isKindOfClass:[NSDictionary class]])
    {
        [objectString appendString:[NSString stringWithFormat:@"\n@implementation  %@\n", className]];
        [objectString appendString:@"\n@end"];
    }
    return objectString;
}
+ (NSString *)subObjectComplieStringWithDictionary:(NSDictionary *)dictionary className:(NSString *)className
{
    __block NSMutableString *objectString = [[self objectComplieStringWithDictionary:dictionary className:className] mutableCopy];
    
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
     {
         if ([obj isKindOfClass:[NSArray class]])
         {
             [objectString appendString:[self subObjectComplieStringWithDictionary:obj[0] className:key]];
         }
         else if ([obj isKindOfClass:[NSDictionary class]])
         {
             [objectString appendString:[self subObjectComplieStringWithDictionary:obj className:key]];
         }
         else
         {
         }
     }];
    return objectString;
}

+ (NSString *)refereceStringWithDictionary:(NSDictionary *)dictionary fileModel:(TCTFileEntityModel)fileModel
{
    __block NSMutableString *objectString = [NSMutableString string];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
    {
        if ([obj isKindOfClass:[NSArray class]])
        {
            if ([obj[0] isKindOfClass:[NSDictionary class]])
            {
                [objectString appendString:[self subObjectStringWithDictionary:obj[0] className:key fileModel:fileModel]];
            }
        }
        else if ([obj isKindOfClass:[NSDictionary class]])
        {
            [objectString appendString:[self subObjectStringWithDictionary:obj className:key fileModel:fileModel]];
        }
        else
        {
        }
    }];
    
    return objectString;
}

@end
