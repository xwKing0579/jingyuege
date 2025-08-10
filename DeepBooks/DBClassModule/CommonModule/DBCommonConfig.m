//
//  DBCommonConfig.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/28.
//

#import "DBCommonConfig.h"
#import "DBShareView.h"
#import <UserNotifications/UserNotifications.h>
#import "DBReadBookSetting.h"
#import "GTMBase64.h"
#import "DBAppStoreModel.h"
#import <StoreKit/StoreKit.h>
#import "DBDomainManager.h"
#import "DBBookChapterModel.h"
#import "DBKeywordModel.h"
#import "DeepBooks-Swift.h"

@implementation DBCommonConfig


+ (void)toLogin{
    if (self.isLogin) return;
    
    [DBRouter openPageUrl:DBLoginPage];
}

+ (BOOL)isLogin{
    return self.userDataInfo.token.length > 0;
}

+ (NSString *)contryTel{
    if (self.contyCodeModel){
        return [NSString stringWithFormat:@"+%@",self.contyCodeModel.tel];
    }
    return @"+86";
}

+ (DBContryCodeModel *)contyCodeModel{
    NSNumber *indexValue = [NSUserDefaults takeValueForKey:DBChoiceCodeValue];
    if (indexValue){
        NSString *value = [NSUserDefaults takeValueForKey:DBContryCodeValue];
        NSArray *dataList = [NSArray modelArrayWithClass:DBContryCodeModel.class json:value];
        if (dataList.count > indexValue.intValue){
            return dataList[indexValue.intValue];
        }
    }
    return nil;
}


+ (BOOL)isNewbie{
    DBAppSetting *setting = DBAppSetting.setting;
    DBAppConfigModel *appConfig = DBCommonConfig.appConfig;
    if (setting.launchCount > appConfig.force.novice_count &&
        DBReadBookSetting.setting.readTotalTime > appConfig.force.novice_read &&
        NSDate.currentInterval-setting.launchTimeStamp > appConfig.force.novice_day*24*60*60){
        return NO;
    }
    return YES;
}

+ (BOOL)isUserVip{
    return NO;
}

+ (void)migrateUserInReading:(BOOL)reading{
#ifdef DEBUG
    return;
#endif
    DBMigrateDataModel *migrateDataModel = DBCommonConfig.appConfig.migrate_data;
    DBMigrateTipModel *migrateData = migrateDataModel.tips;
    DBMigrateConfigModel *migrateConfig = migrateDataModel.migrate;
    
    if ((!reading && migrateData.tips_switch) ||
        (reading && migrateData.read_tips_switch && !DBCommonConfig.isNewbie && DBAppSetting.setting.launchCount > migrateConfig.use_count && DBReadBookSetting.setting.readTotalTime > migrateConfig.read_time)){
        NSString *content = migrateData.tips_content.length ? migrateData.tips_content : @"亲爱的书友,由于不可抗力,此App即将停止维护,请您下载我们新版本的App,感谢您的支持!";
        LEEAlert.alert.config.LeeTitle(DBConstantString.ks_migrationNotice).LeeContent(content).
        LeeAction(DBConstantString.ks_ok, ^{
            NSString *linkUrl = migrateData.jump_url;
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:linkUrl]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:linkUrl] options:@{} completionHandler:nil];
            }
            [LEEAlert closeWithCompletionBlock:^{
                
            }];
        })
        .leeShouldActionClickClose(^(NSInteger index){
            return NO;
        })
        .LeeShow();
    }
}

+ (void)announcementNotice{
    LEEAlert.alert.config.LeeTitle(@"公告通知").LeeContent(DBSafeString(DBAppSetting.setting.noticeContent)).
    LeeAddCustomView(^(LEECustomView * _Nonnull customView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 80)];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 40, 100, 34)];
        button.backgroundColor = DBColorExtension.pinkColor;
        button.layer.cornerRadius = 6;
        button.layer.masksToBounds = YES;
        [button setTitle:@"查看详情" forState:UIControlStateNormal];
        [view addSubview:button];
        
        [button addTagetHandler:^(id  _Nonnull sender) {
            NSString *url = DBAppSetting.setting.noticeLink;
            if (url.length > 0){
                [DBRouter openPageUrl:DBWebView params:@{@"title":@"公告通知",@"url":url}];
            }
            [LEEAlert closeWithCompletionBlock:^{
                
            }];
        } controlEvents:UIControlEventTouchUpInside];
        customView.view = view;
    })
    .LeeShow();
}

+ (void)jumpCustomerService{
    DBContactDataModel *contactModel = DBCommonConfig.appConfig.contact_data;
    NSString *linkUrl = contactModel.online_service;
    if (DBCommonConfig.switchAudit){
        linkUrl = [NSString stringWithFormat:@"mailto:%@",EMAILCUSTOMER];
    }else{
        if (linkUrl.whitespace.length == 0 && contactModel.email.whitespace.length > 0) {
            linkUrl =  [NSString stringWithFormat:@"mailto:%@",contactModel.email];
        }
    }
    
    if (linkUrl.length == 0) return;
    NSURL *linkURL = [NSURL URLWithString:linkUrl.characterSet];
    if ([[UIApplication sharedApplication] canOpenURL:linkURL]) {
        [[UIApplication sharedApplication] openURL:linkURL options:@{} completionHandler:nil];
    }
}


+ (BOOL)switchAudit{
#ifdef DEBUG
    return NO;
#endif
    BOOL shareSwitch = [NSUserDefaults takeValueForKey:DBBooksSwitchValue];
    if (shareSwitch) return NO;
    
    double timeStampInterval = UIDevice.firstInstallationTime;
    if (timeStampInterval > 0 && NSDate.date.timeIntervalSince1970 - timeStampInterval > 3600*6){
        return NO;
    }
    
    AppDelegate *appDelegate = (AppDelegate *)UIApplication.sharedApplication.delegate;
    if (appDelegate.isVSConnection) return YES;
    
    id obj = [NSUserDefaults takeValueForKey:DBAppSwitchValue];
    return DBEmptyObj(obj);
}

+ (BOOL)allFunctionSwitchAudit{
    return NO;
}

+ (void)cutUserSide{
    if (!DBCommonConfig.switchAudit) return;

    [UIScreen.currentViewController.view showHudLoading];
    [DBDomainManager getAppDomain];
    [NSUserDefaults saveValue:@1 forKey:DBBooksSwitchValue];
}

+  (void)bindInvitationLink:(NSString *)link completion:(void (^ __nullable)(BOOL open))completion{
    NSURL *url = [NSURL URLWithString:link];
    NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
    NSMutableDictionary *queryParams = [NSMutableDictionary dictionary];
    for (NSURLQueryItem *queryItem in components.queryItems) {
        [queryParams setObject:queryItem.value forKey:queryItem.name];
    }
    DBUserInviteCodeModel *inviteModel = [DBUserInviteCodeModel modelWithJSON:queryParams];
    NSDictionary *parameInterface = @{@"code":DBSafeString(inviteModel.invite_code),@"inviter":DBSafeString(inviteModel.invite_id),@"deviceToken":DBSafeString(DBAppSetting.setting.deviceCheck)};
    [DBAFNetWorking postServiceRequestType:DBLinkInviteCode combine:nil parameInterface:parameInterface serviceData:^(BOOL successfulRequest, id result, NSString * _Nullable message) {
        if (successfulRequest){
            DBAppSetting *setting = DBAppSetting.setting;
            setting.inviteLink = @"";
            [setting reloadSetting];
            
            DBUserInfoModel *userInfo = DBCommonConfig.userCurrentInfo;
            userInfo.master_user_id = link;
            [NSUserDefaults saveValue:userInfo.modelToJSONString forKey:DBUserAdInfoValue];
        }
        
        DBKeywordModel *model = [DBKeywordModel modelWithJSON:result];
        if (model.fttg.length){
            DBAppSetting *setting = DBAppSetting.setting;
            setting.inviteLink = link;
            [setting reloadSetting];
            [DBCommonConfig cutUserSide];
        }
        
        if (completion) completion(successfulRequest);
    }];
}

static DBUserModel *_userDataInfo;
+ (DBUserModel *)userDataInfo{
    if (!_userDataInfo){
        id value = [NSUserDefaults takeValueForKey:DBUserInfoValue];
        if (value){
            _userDataInfo = [DBUserModel modelWithJSON:value];
            return _userDataInfo;
        }
        return DBUserModel.new;
    }
    return _userDataInfo;
}

+ (void)updateUserInfo:(DBUserModel *)user{
    _userDataInfo = user;
    [NSUserDefaults saveValue:user.modelToJSONString forKey:DBUserInfoValue];
}

+ (DBUserInfoModel *)userCurrentInfo{
    id value = [NSUserDefaults takeValueForKey:DBUserAdInfoValue];
    if (value) return [DBUserInfoModel modelWithJSON:value];
    return DBUserInfoModel.new;
}

static DBAppConfigModel *_appConfig;
+ (DBAppConfigModel *)appConfig{
    if (!_appConfig){
        id value = [NSUserDefaults takeValueForKey:DBAppConfigValue];
        if (value){
            _appConfig = [DBAppConfigModel modelWithJSON:value];
            return _appConfig;
        }
        return DBAppConfigModel.new;
    }
    return _appConfig;
}

+ (void)updateAppConfig:(DBAppConfigModel *)appConfig{
    _appConfig = appConfig;
    [NSUserDefaults saveValue:appConfig.modelToJSONString forKey:DBAppConfigValue];
}

+ (NSString *)userId{
    if ([self isLogin]){
        return self.userDataInfo.user_id;
    }
    return @"0";
}

+ (NSString *)userToken{
    if ([self isLogin]){
        return self.userDataInfo.token;
    }
    return @"";
}

+ (NSString *)bookGenderType:(DBBookType)type{
    NSString *bookType = @"";
    switch (type) {
        case DBBookIndex:
            bookType = @"index";
            break;
        case DBBookMale:
            bookType = @"male";
            break;
        case DBBookFemale:
            bookType = @"female";
            break;
        case DBBookComics:
            bookType = @"comics";
            break;
        default:
            break;
    }
    return bookType;
}

+ (NSString *)bookStausDesc:(NSInteger)status{
    return status == 1 ? DBConstantString.ks_completed : DBConstantString.ks_serializing;
}

+ (NSString *)bookReadingProgress:(NSString *)chapterName{
    return [NSString stringWithFormat:DBConstantString.ks_readProgress,chapterName.length > 0 ? chapterName : DBConstantString.ks_unread];
}

+ (NSString *)bookWordsDesc:(NSInteger)works{
    if (works >= 10000){
        return [NSString stringWithFormat:DBConstantString.ks_wordCountFormat,works/10000];
    }
    return DBConstantString.ks_under10kWords;
}

+ (NSString *)bookDesc:(DBBookModel *)model{
    NSMutableArray *booksDesc = [NSMutableArray array];
    
    [booksDesc addObject:[self bookStausDesc:model.status]];
    if (model.ltype) [booksDesc addObject:model.ltype];
    NSInteger works = model.words_number > 0 ? model.words_number : model.total_count;
    [booksDesc addObject:[self bookWordsDesc:works]];
    return [booksDesc componentsJoinedByString:@" / "];
}

+ (NSString *)bookContainAuthorDesc:(DBBookModel *)model{
    NSMutableArray *booksDesc = [NSMutableArray array];
    
    if (model.author.length) [booksDesc addObject:model.author];
    [booksDesc addObject:[self bookStausDesc:model.status]];
    if (model.ltype) [booksDesc addObject:model.ltype];
    NSInteger works = model.words_number > 0 ? model.words_number : model.total_count;
    [booksDesc addObject:[self bookWordsDesc:works]];
    return [booksDesc componentsJoinedByString:@" / "];
}

+ (NSString *)addressOfficialWithPath:(NSString *)path{
    NSString *officialString = self.downLinkString;
    if ([path hasPrefix:@"/"]){
        return [NSString stringWithFormat:@"%@%@",officialString,path];
    }else{
        return [NSString stringWithFormat:@"%@/%@",officialString,path];
    }
}


+ (NSString *)downLinkString{
    return DBSafeString(DBCommonConfig.appConfig.urls.website_url);
}

+ (NSString *)shieldFreeString{
    if (DBCommonConfig.switchAudit) return @"";
    return [GTMBase64 decodeBase64String:@"5YWN6LS5"];
}

+ (void)showShareView{
    DBShareView *shareView = [[DBShareView alloc] init];
    [UIScreen.appWindow addSubview:shareView];
}

+ (void)getPushAuthorizationCompletion:(void (^ __nullable)(BOOL open))completion{
    [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
         switch (settings.authorizationStatus) {

             case UNAuthorizationStatusDenied:
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     if (completion) completion(NO);
                 });
             }
                 break;
             case UNAuthorizationStatusNotDetermined:
             {
                 [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         if (completion) completion(granted);
                     });
                 }];
             }
                 break;
             default:
                 dispatch_async(dispatch_get_main_queue(), ^{
                     if (completion) completion(YES);
                 });
                 break;
         }
     }];
}

+ (void)openAppSetting{
    NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:settingsURL]) {
        [[UIApplication sharedApplication] openURL:settingsURL options:@{} completionHandler:nil];
    }
}

//前提：过了新手期&后端开关打开
//某一个版本，第一次直接弹出
//同一个版本已经弹过，根据时间间隔score_day判断，1是固定时间，上次选择好评不再弹，选择我要吐槽隔7天弹一次，选择残忍的拒绝隔一天弹一次
//                                        2是间隔时间t，上次选择好评不再弹，选择我要吐槽隔2t天弹一次，选择残忍的拒绝隔t天弹一次
//新的版本，直接弹
+ (void)fiveStarPraise{
    if (DBCommonConfig.isNewbie) return;
   
    NSInteger scoreValue = DBCommonConfig.appConfig.force.score_switch;
    if (!scoreValue) return;
    
    DBAppSetting *setting = DBAppSetting.setting;
   
    NSString *appVersion = setting.star.version;
    if (appVersion.length){
        NSComparisonResult compare = [UIApplication.appVersion compare:appVersion options:NSNumericSearch];
        if (compare == NSOrderedDescending) {
            setting.star = DBAppStarModel.new;
        }
    }
    
    if (setting.star.lastSelection == 1) return;
    
    BOOL isStar = NO;
    if (setting.star.timeStamp > 0){
        NSInteger days = DBCommonConfig.appConfig.force.score_day;
        NSInteger timeStamp = [[NSDate date] timeIntervalSince1970];
        if (scoreValue == 1){ //固定评分
            if (setting.star.lastSelection == 3){
                days = 1;
            }else{
                days = 7;
            }
        }else{
            if (setting.star.lastSelection == 2){
                days = 2*days;
            }
        }
        
        if (timeStamp-setting.star.timeStamp > days*24*3600){
            isStar = YES;
        }
    }else{
        isStar = YES;
    }
    
    if (isStar){
        [self alertStarCommentView];
    }
}

+ (void)alertStarCommentView{
    DBAppSetting *setting = DBAppSetting.setting;
    setting.star.version = UIApplication.appVersion;
    setting.star.timeStamp = [[NSDate date] timeIntervalSince1970];
    
    NSString *message = [NSString stringWithFormat:@"做%@小说不易,您的支持是我们最大的动力,请您支持我们,给与我们五星好评吧!",DBCommonConfig.shieldFreeString];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:DBConstantString.ks_rate5Stars message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *goodAction = [UIAlertAction actionWithTitle:DBConstantString.ks_rateUs style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@?mt=8&action=write-review",AppMarketId];
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
        }
        setting.star.lastSelection = 1;
        [setting reloadSetting];
    }];
    UIAlertAction *ridiculeAction = [UIAlertAction actionWithTitle:DBConstantString.ks_complain style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [DBRouter openPageUrl:DBFeedback];
        setting.star.lastSelection = 2;
        [setting reloadSetting];
    }];
    UIAlertAction *rejectAction = [UIAlertAction actionWithTitle:DBConstantString.ks_reject style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        setting.star.lastSelection = 3;
        [setting reloadSetting];
    }];
    [alertVC addAction:goodAction];
    [alertVC addAction:ridiculeAction];
    [alertVC addAction:rejectAction];
    [UIScreen.currentViewController presentViewController:alertVC animated:YES completion:nil];
}

+ (void)toStoreReview{
    if (DBCommonConfig.isNewbie) return;
    if (DBCommonConfig.appConfig.force.score_switch != 1) return;
    [SKStoreReviewController requestReview];
}

+ (void)getAppStoreCompletion:(void(^)(BOOL needUpdate))completion {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/CN/lookup?id=%@",AppMarketId]];
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error == nil && data != nil && data.length > 0) {
                NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSInteger resultCount = [respDict[@"resultCount"] integerValue];
                if (resultCount == 1) {
                    NSArray *results = respDict[@"results"];
                    NSDictionary *appStoreInfo = [results firstObject];
                    DBAppStoreModel *model = [DBAppStoreModel modelWithJSON:appStoreInfo];
                    NSComparisonResult compare = [model.version compare:UIApplication.appVersion options:NSNumericSearch];
                    if (compare == NSOrderedDescending) {
                        if (completion) completion(YES);
                        NSString *title = [NSString stringWithFormat:DBConstantString.ks_newVersion,model.version];
                        LEEAlert.actionsheet.config.LeeTitle(title).LeeContent(model.releaseNotes).
                        LeeAction(DBConstantString.ks_updateNow, ^{
                            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:model.trackViewUrl]]) {
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.trackViewUrl] options:@{} completionHandler:nil];
                            }
                        }).LeeCancelAction(DBConstantString.ks_later, ^{
                            
                        }).LeeShow();
                        
                        return;
                    }
                }
            }
            if (completion) completion(NO);
        });
    }] resume];
}


@end
