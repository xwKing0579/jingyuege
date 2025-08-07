//
//  DBCommonConfig.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/28.
//

#import <Foundation/Foundation.h>
#import "DBCommonString.h"
#import "DBBookModel.h"
#import "DBAppConfigModel.h"
#import "DBUserModel.h"
#import "DBContryCodeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBCommonConfig : NSObject

+ (void)toLogin;
+ (BOOL)isLogin;
+ (NSString *)userId;
+ (NSString *)userToken;

//是否新手
+ (BOOL)isNewbie;

//导流
+ (void)migrateUserInReading:(BOOL)reading;
+ (void)announcementNotice;

+ (void)jumpCustomerService;

+ (NSString *)contryTel;
+ (DBContryCodeModel *)contyCodeModel;

+ (DBUserModel *)userDataInfo;
+ (void)updateUserInfo:(DBUserModel *)user;
+ (DBUserInfoModel *)userCurrentInfo; //区别这里有广告配置信息

+ (DBAppConfigModel *)appConfig;
+ (void)updateAppConfig:(DBAppConfigModel *)appConfig;

// 审核通过关闭 默认开启
+ (BOOL)switchAudit;
+ (BOOL)allFunctionSwitchAudit;
+ (BOOL)isUserVip;

+ (void)cutUserSide;
+  (void)bindInvitationLink:(NSString *)link completion:(void (^ __nullable)(BOOL open))completion;

//性别字段
+ (NSString *)bookGenderType:(DBBookType)type;

// 1 已完结  2 连载中
+ (NSString *)bookStausDesc:(NSInteger)status;

//读到 未开始阅读
+ (NSString *)bookReadingProgress:(NSString *)chapterName;

// 字数 格式
+ (NSString *)bookWordsDesc:(NSInteger)works;

// 描述
+ (NSString *)bookDesc:(DBBookModel *)model;
+ (NSString *)bookContainAuthorDesc:(DBBookModel *)model;

//官方地址
+ (NSString *)addressOfficialWithPath:(NSString *)path;

///屏蔽
+ (NSString *)shieldFreeString;


///下载链接
+ (NSString *)downLinkString;
+ (void)showShareView;

+ (void)getPushAuthorizationCompletion:(void (^ __nullable)(BOOL open))completion;

+ (void)openAppSetting;

//评分
+ (void)fiveStarPraise;
+ (void)toStoreReview;

//更新
+ (void)getAppStoreCompletion:(void(^)(BOOL needUpdate))completion;

@end

NS_ASSUME_NONNULL_END
