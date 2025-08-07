//
//  UIDevice+DBKit.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (DBKit)

+ (NSString *)currentDeviceName;
+ (NSString *)currentDeviceModel;
+ (NSString *)deviceSize;
+ (NSString *)deviceScale;
+ (NSString *)systemVersion;
+ (NSString *)systemLanguage;

+ (NSString *)deviceuuidString;

+ (double)firstInstallationTime;
+ (void)saveFirstInstallationTime;

+ (BOOL)isVPNConnected;
+ (BOOL)isUSBConnected;
@end

NS_ASSUME_NONNULL_END
