//
//  BFAppInfoManager.h
//  OCProject
//
//  Created by 王祥伟 on 2023/12/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BFAppInfoManager : NSObject

//app信息
+ (NSString *)bundleName;
+ (NSString *)appName;
+ (NSString *)appBundle;
+ (NSString *)appVersion;
+ (NSString *)appMinSystemVersion;

//设备信息
+ (NSString *)deviceName;
+ (NSString *)deviceModel;
+ (NSString *)deviceSize;
+ (NSString *)deviceScale;
+ (NSString *)systemVersion;
+ (NSString *)systemLanguage;

@end

NS_ASSUME_NONNULL_END
