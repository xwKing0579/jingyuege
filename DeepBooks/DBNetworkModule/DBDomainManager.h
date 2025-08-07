//
//  DBDomainManager.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBDomainManager : NSObject

//获取域名
+ (void)setAppConfig;
+ (void)getAppDomain;
+ (void)carryOutBusinessTest:(BOOL)test completion:(void (^ __nullable)(BOOL success))completion;

//加载webp格式的图片
+ (void)supportWebpImage;

@end



NS_ASSUME_NONNULL_END
