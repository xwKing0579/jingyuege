//
//  DBAFNetWorking.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/27.
//

#import <Foundation/Foundation.h>
#import "DBLinkManager.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^DBAFNetResult)(BOOL successfulRequest, id _Nullable result, NSString * _Nullable message);
@interface DBAFNetWorking : NSObject

+ (void)getServiceRequest:(NSString *)path parameInterface:(NSDictionary * _Nullable)parameInterface serviceData:(DBAFNetResult)result;
+ (void)getServiceRequest:(NSString *)path parameInterface:(NSDictionary * _Nullable)parameInterface modelClass:(Class _Nullable)modelClass serviceData:(DBAFNetResult)result;

+ (void)getServiceRequestType:(DBLinkType)type combine:(id _Nullable)combine parameInterface:(NSDictionary * _Nullable)parameInterface serviceData:(DBAFNetResult)result;
+ (void)getServiceRequestType:(DBLinkType)type combine:(id _Nullable)combine parameInterface:(NSDictionary * _Nullable)parameInterface modelClass:(Class _Nullable)modelClass serviceData:(DBAFNetResult)result;

+ (void)postServiceRequest:(NSString *)path parameInterface:(NSDictionary * _Nullable)parameInterface serviceData:(DBAFNetResult)result;
+ (void)postServiceRequest:(NSString *)path parameInterface:(NSDictionary * _Nullable)parameInterface modelClass:(Class _Nullable)modelClass serviceData:(DBAFNetResult)result;

+ (void)postServiceRequestType:(DBLinkType)type combine:(id _Nullable)combine parameInterface:(NSDictionary * _Nullable)parameInterface serviceData:(DBAFNetResult)result;
+ (void)postServiceRequestType:(DBLinkType)type combine:(id _Nullable)combine parameInterface:(NSDictionary * _Nullable)parameInterface modelClass:(Class _Nullable)modelClass serviceData:(DBAFNetResult)result;

+ (void)uploadServiceRequest:(NSString *)path parameInterface:(NSDictionary * _Nullable)parameInterface fileData:(NSData * _Nullable)fileData serviceData:(DBAFNetResult)result;
+ (void)uploadServiceRequest:(NSString *)path parameInterface:(NSDictionary * _Nullable)parameInterface fileData:(NSData * _Nullable)fileData modelClass:(Class _Nullable)modelClass serviceData:(DBAFNetResult)result;

+ (void)uploadServiceRequestType:(DBLinkType)type combine:(id _Nullable)combine parameInterface:(NSDictionary * _Nullable)parameInterface fileData:(NSData * _Nullable)fileData serviceData:(DBAFNetResult)result;
+ (void)uploadServiceRequestType:(DBLinkType)type combine:(id _Nullable)combine parameInterface:(NSDictionary * _Nullable)parameInterface fileData:(NSData * _Nullable)fileData modelClass:(Class _Nullable)modelClass serviceData:(DBAFNetResult)result;

+ (void)downloadServiceRequest:(NSString *)path fileName:(NSString *)fileName serviceData:(DBAFNetResult)result;
+ (void)downloadServiceRequest:(NSString *)path fileName:(NSString *)fileName modelClass:(Class _Nullable)modelClass serviceData:(DBAFNetResult)result;
@end

NS_ASSUME_NONNULL_END
