//
//  MAXEntityModelReplace.m
//  ConvertTools
//
//  Created by maxfong on 14-9-14.
//
//

#import "MAXEntityModelReplace.h"
#import "MAXEntityModelCreate.h"

#define k_VARIABLE_ENTITYFILESUPERCLASS      @"NSObject"
#define k_IMPORTHEADER_ENTITYFILESUPERCLASS  @"#import <Foundation/Foundation.h>"

typedef NS_ENUM(NSUInteger, MAXReplicaModel)
{
    ___HEADFILENAME___,
    ___COMPLIEFILENAME___,
    ___PROJECTNAME___,
    ___DATE___,
    ___USERNAME___,
    ___COPYRIGHT___,
    ___IMPORTHEADER_ENTITYFILESUPERCLASS___,
    ___FILENAMEASIDENTIFIER___,
    ___VARIABLE_ENTITYFILESUPERCLASS___,
    ___IMPORTHEADER_ENTITYFILEREFERENCE___,
    ___FILEBASENAME___,
    ___INIT___,
    ___PROPERTYNAME___
};

#define replicaModelArray \
@[\
@"___HEADFILENAME___",\
@"___COMPLIEFILENAME___",\
@"___PROJECTNAME___",\
@"___DATE___",\
@"___USERNAME___",\
@"___COPYRIGHT___",\
@"___IMPORTHEADER_ENTITYFILESUPERCLASS___",\
@"___FILENAMEASIDENTIFIER___",\
@"___VARIABLE_ENTITYFILESUPERCLASS___",\
@"___IMPORTHEADER_ENTITYFILEREFERENCE___",\
@"___FILEBASENAME___",\
@"___INIT___",\
@"___PROPERTYNAME___"\
];

NSString *const MAXModelFileServerNameKey = @"MAXServerName";
NSString *const MAXModelFileInterfaceKey = @"MAXInterface";
NSString *const MAXModelFilePrefixKey = @"MAXPrefix";
NSString *const MAXModelFileSuperClassKey = @"MAXSuperClass";
NSString *const MAXModelFileImportKey = @"MAXImport";
NSString *const MAXModelFileInitKey = @"MAXInit";

@implementation MAXEntityModelReplace

+ (NSString *)replaceStringWithString:(NSString *)string object:(NSDictionary *)dictionary fileModel:(MAXFileEntityModel)fileModel options:(NSDictionary *)options
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

+ (NSString *)replaceStringWithKey:(NSString *)key object:(NSDictionary *)dictionary fileModel:(MAXFileEntityModel)fileModel options:(NSDictionary *)options
{
    NSArray *replaceModels = replicaModelArray;
    return [self replaceStringWithModel:[replaceModels indexOfObject:key] object:dictionary fileModel:fileModel options:options];
}

+ (NSString *)replaceStringWithModel:(MAXReplicaModel)model object:(NSDictionary *)dictionary fileModel:(MAXFileEntityModel)fileModel options:(NSDictionary *)options
{
    switch (model)
    {
        case ___HEADFILENAME___:
        {
            return [NSString stringWithFormat:@"%@%@.h", [options[MAXModelFilePrefixKey] capitalizedString] ?: @"", [options[MAXModelFileServerNameKey] capitalizedString] ?: @"<#serverName#>"];
        }
            break;
        case ___COMPLIEFILENAME___:
        {
            return [NSString stringWithFormat:@"%@%@.m", [options[MAXModelFilePrefixKey] capitalizedString] ?: @"", [options[MAXModelFileServerNameKey] capitalizedString] ?: @"<#serverName#>"];
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
        case ___IMPORTHEADER_ENTITYFILESUPERCLASS___:
        {
            return options[MAXModelFileImportKey] ?: options[MAXModelFileSuperClassKey] ? [NSString stringWithFormat:@"#import \"%@.h\"", options[MAXModelFileSuperClassKey]] : k_IMPORTHEADER_ENTITYFILESUPERCLASS;
        }
            break;
        case ___FILENAMEASIDENTIFIER___:
        {
            return [NSString stringWithFormat:@"%@%@", options[MAXModelFilePrefixKey] ?: @"", options[MAXModelFileServerNameKey] ?: @"<#serverName#>"];
        }
            break;
        case ___VARIABLE_ENTITYFILESUPERCLASS___:
        {
            return options[MAXModelFileSuperClassKey] ?: k_VARIABLE_ENTITYFILESUPERCLASS;
        }
            break;
        case ___FILEBASENAME___:
        {
            return [NSString stringWithFormat:@"%@%@", options[MAXModelFilePrefixKey] ?: @"", options[MAXModelFileServerNameKey] ?: @"<#serverName#>"];
        }
            break;
        case ___INIT___:
        {
            NSString *serverName = ([options[MAXModelFileServerNameKey] length] > 0) ? options[MAXModelFileServerNameKey] : nil;
            NSString *interface = ([options[MAXModelFileInterfaceKey] length] > 0) ? [options[MAXModelFileInterfaceKey] lowercaseString] : nil;
            //FIXME!!! Logic Maybe Change
            return options[MAXModelFileInitKey] ?: [NSString stringWithFormat:@"- (id)init\n{\n\
    if (self = [super init])\n\
    {\n\
        [self setInterfaceURL:@\"/%@\" Type:outer_4_Domain];\n\
        self.serviceName = @\"%@\";\n\
    }\n\
    return self;\n}\n", interface ?:@"<#interface#>", serverName ?: @"<#serverName#>"];
        }
            break;
        case ___IMPORTHEADER_ENTITYFILEREFERENCE___:
        {
            return [self importWithDictionary:dictionary fileModel:fileModel options:options];
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
         {
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

+ (NSString *)importStringsWithDictionary:(NSDictionary *)dictionary className:(NSString *)className fileModel:(MAXFileEntityModel)fileModel options:(NSDictionary *)options
{
    __block NSMutableString *objectString = [[NSString stringWithFormat:@"\n#import \"%@.h\"", [className capitalizedString]] mutableCopy];
    {
        NSDictionary *subClassOptions = @{MAXModelFileServerNameKey : className,
                                          MAXModelFileInitKey : @""};
        NSData *contentData = [MAXEntityModelCreate contentWithModel:fileModel originalData:dictionary options:subClassOptions];
        NSString *filePath = [MAXEntityModelCreate filePathWithModel:fileModel options:subClassOptions];
        
        [MAXEntityModelCreate createFileAtPath:filePath contentData:contentData attributes:nil];
    }
    
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
     {
         if ([obj isKindOfClass:[NSArray class]] && [obj count] > 0)
         {
             [objectString appendString:[self importStringsWithDictionary:obj[0] className:key fileModel:fileModel options:options]];
         }
         else if ([obj isKindOfClass:[NSDictionary class]])
         {
             [objectString appendString:[self importStringsWithDictionary:obj className:key fileModel:fileModel options:options]];
         }
     }];
    return objectString;
}

+ (NSString *)importWithDictionary:(NSDictionary *)dictionary fileModel:(MAXFileEntityModel)fileModel options:(NSDictionary *)options
{
    __block NSMutableString *objectString = [NSMutableString string];
    
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
     {
         if ([obj isKindOfClass:[NSArray class]] && [obj count] > 0)
         {
             if ([obj[0] isKindOfClass:[NSDictionary class]])
             {
                 [objectString appendString:[self importStringsWithDictionary:obj[0] className:key fileModel:fileModel options:options]];
             }
         }
         else if ([obj isKindOfClass:[NSDictionary class]])
         {
             [objectString appendString:[self importStringsWithDictionary:obj className:key fileModel:fileModel options:options]];
         }
     }];
    return objectString;
}

@end
