//
//  BFNetworkModel.h
//  OCProject
//
//  Created by 王祥伟 on 2023/12/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BFNetworkModel : NSObject

@property (nonatomic, copy) NSString *host;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *pathString;
@property (nonatomic, copy) NSData *httpBody;
@property (nonatomic, copy) NSString *httpMethod;
@property (nonatomic, copy) NSString *mimeType;

@property (nonatomic, copy) NSString *requestParams;
@property (nonatomic, assign) NSInteger statusCode;
@property (nonatomic, strong) NSString *data;

@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;

@property (nonatomic, assign) double totalDuration;

@property (nonatomic, copy) NSString *suggestedFilename;
@property (nonatomic, assign) long long expectedContentLength;

@property (nonatomic, copy) NSDictionary *resquestHeaderFields;
@property (nonatomic, copy) NSDictionary *responseHeaderFields;
@end

NS_ASSUME_NONNULL_END
