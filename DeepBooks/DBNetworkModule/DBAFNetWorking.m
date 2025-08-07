//
//  DBAFNetWorking.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/27.
//

#import "DBAFNetWorking.h"
#import "DBNetResultModel.h"
#import "DBDecryptManager.h"
#import <Reachability/Reachability.h>
@implementation DBAFNetWorking

+ (void)getServiceRequest:(NSString *)path parameInterface:(NSDictionary * _Nullable)parameInterface serviceData:(DBAFNetResult)result{
    [self getServiceRequest:path parameInterface:parameInterface modelClass:nil serviceData:result];
}

+ (void)getServiceRequest:(NSString *)path parameInterface:(NSDictionary * _Nullable)parameInterface modelClass:(Class _Nullable)modelClass serviceData:(DBAFNetResult)result{
    [DBBaseAlamofire getWithPath:path parameInterface:parameInterface responseBlock:^(BOOL successfulRequest, NSData *data, NSError * _Nullable error) {
        [self jsonDataParsing:path parameInterface:parameInterface success:successfulRequest data:data modelClass:modelClass error:error serviceData:result];
    }];
}

+ (void)getServiceRequestType:(DBLinkType)type combine:(id _Nullable)combine parameInterface:(NSDictionary * _Nullable)parameInterface serviceData:(DBAFNetResult)result{
    [self getServiceRequestType:type combine:combine parameInterface:parameInterface modelClass:nil serviceData:result];
}

+ (void)getServiceRequestType:(DBLinkType)type combine:(id _Nullable)combine parameInterface:(NSDictionary * _Nullable)parameInterface modelClass:(Class _Nullable)modelClass serviceData:(DBAFNetResult)result{
    NSString *url = [DBLinkManager combineLinkWithType:type combine:combine];
    [self getServiceRequest:url parameInterface:parameInterface modelClass:modelClass serviceData:result];
}

+ (void)postServiceRequest:(NSString *)path parameInterface:(NSDictionary * _Nullable)parameInterface serviceData:(DBAFNetResult)result{
    [self postServiceRequest:path parameInterface:parameInterface modelClass:nil serviceData:result];
}

+ (void)postServiceRequest:(NSString *)path parameInterface:(NSDictionary * _Nullable)parameInterface modelClass:(Class _Nullable)modelClass serviceData:(DBAFNetResult)result{
    [DBBaseAlamofire postWithPath:path parameInterface:parameInterface responseBlock:^(BOOL successfulRequest, NSData *data, NSError * _Nullable error) {
        [self jsonDataParsing:path parameInterface:parameInterface success:successfulRequest data:data modelClass:modelClass error:error serviceData:result];
    }];
}

+ (void)postServiceRequestType:(DBLinkType)type combine:(id _Nullable)combine parameInterface:(NSDictionary * _Nullable)parameInterface serviceData:(DBAFNetResult)result{
    [self postServiceRequestType:type combine:combine parameInterface:parameInterface modelClass:nil serviceData:result];
}

+ (void)postServiceRequestType:(DBLinkType)type combine:(id _Nullable)combine parameInterface:(NSDictionary * _Nullable)parameInterface modelClass:(Class _Nullable)modelClass serviceData:(DBAFNetResult)result{
    NSString *url = [DBLinkManager combineLinkWithType:type combine:combine];
    [self postServiceRequest:url parameInterface:parameInterface modelClass:modelClass serviceData:result];
}

+ (void)uploadServiceRequest:(NSString *)path parameInterface:(NSDictionary * _Nullable)parameInterface fileData:(NSData * _Nullable)fileData serviceData:(DBAFNetResult)result{
    [self uploadServiceRequest:path parameInterface:parameInterface fileData:fileData modelClass:nil serviceData:result];
}

+ (void)uploadServiceRequest:(NSString *)path parameInterface:(NSDictionary * _Nullable)parameInterface fileData:(NSData * _Nullable)fileData modelClass:(Class _Nullable)modelClass serviceData:(DBAFNetResult)result{
    [DBBaseAlamofire uploadImageWithPath:path parameInterface:parameInterface fileData:fileData responseBlock:^(BOOL successfulRequest, NSData *data, NSError * _Nullable error) {
        [self jsonDataParsing:path parameInterface:parameInterface success:successfulRequest data:data modelClass:modelClass error:error serviceData:result];
    }];
}

+ (void)uploadServiceRequestType:(DBLinkType)type combine:(id _Nullable)combine parameInterface:(NSDictionary * _Nullable)parameInterface fileData:(NSData * _Nullable)fileData serviceData:(DBAFNetResult)result{
    [self uploadServiceRequestType:type combine:combine parameInterface:parameInterface fileData:fileData modelClass:nil serviceData:result];
}

+ (void)uploadServiceRequestType:(DBLinkType)type combine:(id _Nullable)combine parameInterface:(NSDictionary * _Nullable)parameInterface fileData:(NSData * _Nullable)fileData modelClass:(Class _Nullable)modelClass serviceData:(DBAFNetResult)result{
    NSString *url = [DBLinkManager combineLinkWithType:type combine:combine];
    [self uploadServiceRequest:url parameInterface:parameInterface fileData:fileData modelClass:modelClass serviceData:result];
}

+ (void)downloadServiceRequest:(NSString *)path fileName:(NSString *)fileName serviceData:(DBAFNetResult)result{
    [self downloadServiceRequest:path fileName:fileName modelClass:nil serviceData:result];
}

+ (void)downloadServiceRequest:(NSString *)path fileName:(NSString *)fileName modelClass:(Class _Nullable)modelClass serviceData:(DBAFNetResult)result{
    [DBBaseAlamofire downloadWithPath:path fileName:fileName responseBlock:^(BOOL successfulRequest, NSData *data, NSError * _Nullable error) {
        [self jsonDataParsing:path parameInterface:nil success:successfulRequest data:data modelClass:modelClass error:error serviceData:result];
    }];
}

+ (void)jsonDataParsing:(NSString *)url parameInterface:parameInterface success:(BOOL)success data:(NSData *)data modelClass:(Class _Nullable)modelClass error:(NSError *)error serviceData:(DBAFNetResult)result{
    if (!result) return;
    
    NSLog(@"url = %@\n parameInterface == %@",url,parameInterface);
    if (success && data){
        id jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:NULL];
        if ([jsonData isKindOfClass:[NSDictionary class]] && [(NSDictionary *)jsonData valueForKey:@"code"]) {
            DBNetResultModel *model = [DBNetResultModel yy_modelWithDictionary:jsonData];
            NSString *msg = model.msg;
            if (model.code != 1) {
                result(NO, jsonData, msg);
                return;
            }
            
            if (!model.data){
                result(YES, jsonData, msg);
                return;
            }
            jsonData = model.data;
            if ([jsonData isKindOfClass:[NSDictionary class]] && [jsonData valueForKey:@"ver"]){
                DBDataResultModel *dataModel = [DBDataResultModel yy_modelWithDictionary:model.data];
                NSString *dataString = [DBDecryptManager decryptText:dataModel.content ver:dataModel.ver];
                NSData *dataData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
                if (dataData) jsonData = [NSJSONSerialization JSONObjectWithData:dataData options:kNilOptions error:NULL];
                
                if ([jsonData isKindOfClass:[NSDictionary class]] && [jsonData valueForKey:@"lists"]){
                    id lists = jsonData[@"lists"];
                    if ([lists isKindOfClass:NSDictionary.class] && [lists valueForKey:@"ver"]){
                        DBDataResultModel *moreModel = [DBDataResultModel yy_modelWithDictionary:lists];
                        NSString *moreDataString = [DBDecryptManager decryptText:moreModel.content ver:moreModel.ver];
                        NSData *moreData = [moreDataString dataUsingEncoding:NSUTF8StringEncoding];
                        if (moreData) jsonData = [NSJSONSerialization JSONObjectWithData:moreData options:kNilOptions error:NULL];
                    }
                }
            }
            NSLog(@"jsonData == %@",jsonData);
            
            if (modelClass){
                if ([jsonData isKindOfClass:[NSDictionary class]]){
                    result(YES, [modelClass yy_modelWithDictionary:jsonData], msg);
                    return;
                }else if ([jsonData isKindOfClass:[NSArray class]]){
                    result(YES, [NSArray yy_modelArrayWithClass:modelClass json:jsonData], msg);
                    return;
                }
            }
        }else if (modelClass){
            if ([jsonData isKindOfClass:[NSDictionary class]]){
                result(YES, [modelClass yy_modelWithDictionary:jsonData], @"");
                return;
            }else if ([jsonData isKindOfClass:[NSArray class]]){
                result(YES, [NSArray yy_modelArrayWithClass:modelClass json:jsonData], @"");
                return;
            }
        }
       
        result(YES, jsonData, nil);
    }else{
        Reachability *reachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus status = [reachability currentReachabilityStatus];
        if (status == NotReachable){
            result(NO, nil, @"网络请求失败，请检查您的网络设置");
        }else{
            result(NO, nil, nil);
        }
    }
}

@end
