//
//  DBAppSetting.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class DBAppStarModel;

@interface DBAppSetting : NSObject

@property (nonatomic, copy) NSString *domain;
@property (nonatomic, copy) NSString *keyword;
@property (nonatomic, copy) NSString *inviteLink;
@property (nonatomic, copy) NSString *deviceCheck;

@property (nonatomic, assign) NSInteger launchCount; //启动次数
@property (nonatomic, assign) NSInteger launchTimeStamp; //第一次启动时间
@property (nonatomic, assign) NSInteger lastLaunchTimeStamp; //上一次启动时间
@property (nonatomic, assign) NSInteger currentLaunchTimeStamp;

@property (nonatomic, assign) NSInteger adViewCount; //当天观看广告书

@property (nonatomic, assign) BOOL isNewbie; //是否新手
 
@property (nonatomic, assign) BOOL isRec; 

@property (nonatomic, assign) NSInteger launchAdIndex; //启动广告位置

@property (nonatomic, copy) NSString *marqueeContent; //跑马灯内容
@property (nonatomic, copy) NSString *marqueeLink; //跑马灯链接
@property (nonatomic, copy) NSString *noticeContent; //公告文案
@property (nonatomic, copy) NSString *noticeLink; //公告链接

@property (nonatomic, strong) NSArray *tagList;
@property (nonatomic, strong) NSArray *searchList;

@property (nonatomic, strong) NSString *sex; //性别 0 未知 1 男生 2 女生

@property (nonatomic, assign) BOOL isOn; //推送开关

@property (nonatomic, strong) DBAppStarModel *star;

+ (DBAppSetting *)setting;
- (void)reloadSetting;

+ (void)updateLaunchTime;
+ (NSString *)languageAbbrev;

@end


@interface DBAppVersionModel : NSObject
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) BOOL isTrue; //是否强制
@end

@interface DBAppStarModel : NSObject
@property (nonatomic, copy) NSString *version;
@property (nonatomic, assign) NSInteger timeStamp;
@property (nonatomic, assign) NSInteger lastSelection;
@end
NS_ASSUME_NONNULL_END
