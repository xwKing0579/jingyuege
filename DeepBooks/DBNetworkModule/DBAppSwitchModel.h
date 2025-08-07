//
//  DBAppSwitchModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBAppSwitchModel : NSObject

+ (void)getDomainLinkTest:(BOOL)test completion:(void (^ __nullable)(BOOL success))completion;

+ (void)getApiStateCompletion:(void (^ __nullable)(BOOL enable))completion;

+ (void)getAppSwitchCompletion:(void (^ __nullable)(BOOL success))completion;

+ (void)getAppSwitchWithInvitationCode:(NSString *)code;

+ (void)getAppSwitchWithPassword:(NSString *)password;

+ (void)getNetSafetyProvidePlan:(void (^ __nullable)(BOOL success))completion;
@end

NS_ASSUME_NONNULL_END
