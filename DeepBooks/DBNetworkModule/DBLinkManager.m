//
//  DBLinkManager.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/28.
//

#import "DBLinkManager.h"
#import "DBReadBookSetting.h"
@class DBAdServerDataModel;

typedef NS_ENUM(NSInteger,DBCombineType) {
    DBCombineDefault,
    DBCombineConf,
    DBCombineMy,
    DBCombineS,
    DBCombineBook,
    DBCombineAvater,
    DBCombineRes,
    DBCombineCatalog,
    DBCombineChapter,
};

@implementation DBLinkManager

+ (NSString *)combineLinkWithType:(DBLinkType)type combine:(_Nullable id)combine{
    NSString *path = @"";

    NSString *v4 = @"v4";
    NSString *os_number = @"2";
    NSString *combineDomain = [self getCombineDomainWithCombineType:[self getCombineType:type]];
    
    switch (type) {
        case DBLinkAppSwitch:
            path = [NSString stringWithFormat:@"%@/%@",combineDomain,LINKAPPSWITCH];
            break;
        case DBLinkInviteCode:
            path = [NSString stringWithFormat:@"%@/%@",combineDomain,LINKINVITECODE];
            break;
        case DBLinkBaseKeyword:
            path = [NSString stringWithFormat:@"%@/%@?keyword=%@",combineDomain,LINKBASEKEYWORD,combine];
            break;
        case DBLinkUserPlane:
            path = [NSString stringWithFormat:@"%@/v12/2/bpage",combineDomain];
            break;
        case DBLinkTrackAdData:
        {
            NSString *trackDomain = DBUnityAdConfig.adConfigModel.trackDomain;
            if (trackDomain.length > 0) {
                trackDomain = [NSString stringWithFormat:@"https://%@",trackDomain];
            }
            path = [NSString stringWithFormat:@"%@/v1/track.api",combineDomain];
        }
            break;
        case DBUserClickReport:
            path = [NSString stringWithFormat:@"%@/v1/track.api",combineDomain];
            break;
        case DBLinkSearchReport:
            path = [NSString stringWithFormat:@"%@/log/v4/keyword.api",combineDomain];
            break;
        case DBLinkSearchClickReport:
            path = [NSString stringWithFormat:@"%@/log/v4/book.api",combineDomain];
            break;
        case DBLinkUserVipInfo:
            path = [NSString stringWithFormat:@"%@/v12/membership/status",combineDomain];
            break;
        case DBLinkUserActivities:
            path = [NSString stringWithFormat:@"%@/v12/coin_activity/activities?type=%@",combineDomain,combine];
            break;
        case DBLinkCheckActivity:
            path = [NSString stringWithFormat:@"%@/v12/coin_activity/participate/check",combineDomain];
            break;
        case DBLinkActivityReward:
            path = [NSString stringWithFormat:@"%@/v12/coin_activity/participate",combineDomain];
            break;
        case DBLinkFreeVipConsume:
            path = [NSString stringWithFormat:@"%@/v12/membership/consume_free_vip",combineDomain];
            break;
            
            
            
            
        case DBLinkBookSelfRec:
            path = [NSString stringWithFormat:@"%@/book/details/v4/%d/%@.html",combineDomain,[combine intValue]/1000,combine];
            break;
        case DBLinkStateConfig:
            path = [NSString stringWithFormat:@"%@/state.api",combineDomain];
            break;
        case DBLinkBaseConfig:
            path = [NSString stringWithFormat:@"%@/%@/conf2",combineDomain,v4];
            break;
        case DBLinkBaseAdConfig:
            path = [NSString stringWithFormat:@"%@/v12/alld2",combineDomain];
            break;
        case DBLinkAppVserion:
            path = [NSString stringWithFormat:@"%@/v5/appstore/download.html",combineDomain];
            break;
        case DBLinkUserSignIn:
            path = [NSString stringWithFormat:@"%@/%@/login.api",combineDomain,v4];
            break;
        case DBLinkUserInviteCode:
            path = [NSString stringWithFormat:@"%@/v12/invite/code",combineDomain];
            break;
        case DBLinkUserInviteBind:
            path = [NSString stringWithFormat:@"%@/v12/invite/bind",combineDomain];
            break;
        case DBLinkUserRegiste:
            path = [NSString stringWithFormat:@"%@/%@/reg.api",combineDomain,v4];
            break;
        case DBLinkUserAvatarUpload:
            path = [NSString stringWithFormat:@"%@/v1/center/avatar/upload.api",combineDomain];
            break;
        case DBLinkUserNickModify:
            path = [NSString stringWithFormat:@"%@/v1/center/update/nick.api",combineDomain];
            break;
        case DBLinkUserPhoneVeriCodeSend:
            path = [NSString stringWithFormat:@"%@/v2/phone/send.api",combineDomain];
            break;
        case DBLinkUserPhoneCancelVeriCodeSend:
            path = [NSString stringWithFormat:@"%@/v5/phone/cancel.api",combineDomain];
            break;
        case DBLinkUserPhoneCancel:
            path = [NSString stringWithFormat:@"%@/v5/center/account/cancel.api",combineDomain];
            break;
        case DBLinkUserPasswordForget:
            path = [NSString stringWithFormat:@"%@/v2/forgot_password.api",combineDomain];
            break;
        case DBLinkUserPhoneAreaCode:
            path = [NSString stringWithFormat:@"%@/v2/phone/area_code.api",combineDomain];
            break;
        case DBLinkBookQualityChoice:
            path = [NSString stringWithFormat:@"%@/book_city/v7/%@/%@/%@/%@.html",combineDomain,combine[@"sex"],os_number,combine[@"data_conf"],combine[@"rand"]];
            break;
        case DBLinkIconResUrl:
        case DBLinkHeaderAvatarUrl:
        {
            path = DBSafeString((NSString *)combine);
            if (path.length && ![path hasPrefix:@"http"]){
                if ([path hasPrefix:@"/"]){
                    path = [NSString stringWithFormat:@"%@%@",combineDomain,path];
                }else{
                    path = [NSString stringWithFormat:@"%@/%@",combineDomain,path];
                }
            }
        }
            break;
        case DBLinkBookStoreRankCatalog:
            path = [NSString stringWithFormat:@"%@/rank_lists/%@/index.html",combineDomain,v4];
            break;
        case DBLinkBookStoreRankDetailData:
            path = [NSString stringWithFormat:@"%@/rank_lists/%@/details/%@.html",combineDomain,v4,combine];
            break;
        case DBLinkBookDetailData:
        {
            NSString *bookId = combine;
            path = [NSString stringWithFormat:@"%@/book/details/%@/%d/%@.html",combineDomain,v4,bookId.intValue/1000,bookId];
        }
            break;
        case DBLinkBookAuthorRelate:
            path = [NSString stringWithFormat:@"%@/%@/2/author.api",combineDomain,[self searchType]];
            break;
        case DBLinkBookHottest:
            path = [NSString stringWithFormat:@"%@/rank_lists/details/1/zssq/%@/1.html",combineDomain,combine];
            break;
        case DBLinkBookBestseller:
            path = [NSString stringWithFormat:@"%@/rank_lists/details/1/zhangyue/%@/1.html",combineDomain,combine];
            break;
        case DBLinkBookSummary:
        {
            NSString *bookId = combine;
            path = [NSString stringWithFormat:@"%@/book/source/%@/%d/%@.html",combineDomain,v4,bookId.intValue/1000,bookId];
        }
            break;
        case DBLinkBookQualityChoiceMore:
            path = [NSString stringWithFormat:@"%@/book_city/v7_more/%@/%@/%@/%@/%@.html",combineDomain,combine[@"sex"],os_number,combine[@"data_conf"],combine[@"category"],combine[@"page"]];
            break;
        case DBLinkBookQualityModuleMore:
            path = [NSString stringWithFormat:@"%@/book_city/index_more/%@/%@/%@.html",combineDomain,combine[@"category"],combine[@"attributes"],combine[@"page"]];
            break;
        case DBLinkBookCatalog:
        case DBLinkBookChapter:
            path = [NSString stringWithFormat:@"%@/%@",combineDomain,combine];
            break;
        case DBLinkCommentList:
            path = [NSString stringWithFormat:@"%@/v1/comment/lists.api",combineDomain];
            break;
        case DBLinkBookDetailCommentList:
            path = [NSString stringWithFormat:@"%@/v1/comment/book_details.api?book_id=%@",combineDomain,combine];
            break;
        case DBLinkBookSearchHotWords:
            path = [NSString stringWithFormat:@"%@/%@/2/keyword.api",combineDomain,v4];
            break;
        case DBLinkBookClassifyCatalog:
            path = [NSString stringWithFormat:@"%@/classify/%@/index.html",combineDomain,v4];
            break;
        case DBLinkBookClassifyWhole:
            path = [NSString stringWithFormat:@"%@/classify/%@/all/%@/%@/%@/%@/%@/%@.html",combineDomain,v4,combine[@"sex"],combine[@"ltype"],combine[@"stype"],combine[@"end"],combine[@"score"],combine[@"page"]];
            break;
        case DBLinkBookSearchResult:
            path = [NSString stringWithFormat:@"%@/%@/2/lists.api",combineDomain,self.searchType];
            break;
        case DBLinkBookShelfList:
            path = [NSString stringWithFormat:@"%@/%@/book/fav/lists.api?form=1",combineDomain,v4];
            break;
        case DBLinkUserAskBook:
            path = [NSString stringWithFormat:@"%@/%@/center/asking/book/add.api",combineDomain,v4];
            break;
        case DBLinkUserAskBookList:
            path = [NSString stringWithFormat:@"%@/%@/center/asking/book/lists.api",combineDomain,v4];
            break;
        case DBLinkFeedBackSubmit:
            path = [NSString stringWithFormat:@"%@/v1/service/add.api",combineDomain];
            break;
        case DBLinkFeedBackList:
            path = [NSString stringWithFormat:@"%@/v1/service/lists.api",combineDomain];
            break;
        case DBLinkUserPasswordModify:
            path = [NSString stringWithFormat:@"%@/v1/center/update/pwd.api",combineDomain];
            break;
        case DBLinkCommentSubmit:
            path = [NSString stringWithFormat:@"%@/v4/comment/submit.api",combineDomain];
            break;
        case DBLinkCommentLike:
            path = [NSString stringWithFormat:@"%@/v1/comment/fav.api",combineDomain];
            break;
        case DBLinkCommentReplayLike:
            path = [NSString stringWithFormat:@"%@/v1/comment/reply/fav.api",combineDomain];
            break;
        case DBLinkCommentReplayList:
            path = [NSString stringWithFormat:@"%@/v1/comment/reply/lists.api",combineDomain];
            break;
        case DBLinkBookShelfBookAdd:
            path = [NSString stringWithFormat:@"%@/v4/book/fav/add.api",combineDomain];
            break;
        case DBLinkBookShelfBookDelete:
            path = [NSString stringWithFormat:@"%@/v4/book/fav/del.api",combineDomain];
            break;
        case DBLinkBookShelfMultiBookDelete:
            path = [NSString stringWithFormat:@"%@/v4/book/fav/del_batch.api",combineDomain];
            break;
        case DBLinkBookThemeCollectList:
            path = [NSString stringWithFormat:@"%@/v1/book/list/lists.api",combineDomain];
            break;
        case DBLinkBookThemeDetailData:
            path = [NSString stringWithFormat:@"%@/book_lists/v4/details/%@/%@.html",combineDomain,combine[@"index"],combine[@"list_id"]];
            break;
        case DBLinkRBookThemeWhetherOrNot:
            path = [NSString stringWithFormat:@"%@/v1/book/list/is_fav.api",combineDomain];
            break;
        case DBLinkBookThemeCollectMore:
            path = [NSString stringWithFormat:@"%@/book_lists/lists/%@/%@.html",combineDomain,combine[@"sex"],combine[@"page"]];
            break;
        case DBLinkRBookThemeAdd:
            path = [NSString stringWithFormat:@"%@/v1/book/list/add.api",combineDomain];
            break;
        case DBLinkRBookThemeDelete:
            path = [NSString stringWithFormat:@"%@/v1/book/list/del.api",combineDomain];
            break;
        case DBLinkChapterContentSubmit:
            path = [NSString stringWithFormat:@"%@/v1/service/chapter/err.api",combineDomain];
            break;
        case DBLinkBookShelfBookTop:
            path = [NSString stringWithFormat:@"%@/v4/book/fav/top.api",combineDomain];
            break;
        case DBLinkBookShelfBookTopCancel:
            path = [NSString stringWithFormat:@"%@/v4/book/fav/top_del.api",combineDomain];
            break;
        case DBLinkBookShelfBookFeedUp:
            path = [NSString stringWithFormat:@"%@/v1/book/fav/fatten.api",combineDomain];
            break;
        case DBLinkBookShelfBookFeedUpCancel:
            path = [NSString stringWithFormat:@"%@/v1/book/fav/fatten_del.api",combineDomain];
            break;
        case DBLinkBookReadingHistoryList:
            path = [NSString stringWithFormat:@"%@/v4/book/history/lists.api",combineDomain];
            break;
        case DBLinkBookReadingCleanUp:
            path = [NSString stringWithFormat:@"%@/v4/book/history/del_all.api",combineDomain];
            break;
        case DBLinkUserInfoCenter:
            path = [NSString stringWithFormat:@"%@/v2/center/index.api",combineDomain];
            break;
        case DBLinkCommentReplaySubmit:
            path = [NSString stringWithFormat:@"%@/v1/comment/reply/submit.api",combineDomain];
            break;
        default:
            break;
    }
    return path.characterSet;
}

+ (DBCombineType)getCombineType:(DBLinkType)type{
    DBCombineType combineType = DBCombineDefault;
 
    switch (type) {
        case DBLinkBaseConfig:
        case DBLinkStateConfig:
        case DBLinkAppVserion:
        case DBLinkBaseAdConfig:
            combineType = DBCombineConf;
            break;
        case DBLinkTrackAdData:
        case DBLinkBaseKeyword:
        case DBLinkUserSignIn:
        case DBLinkUserInviteCode:
        case DBLinkUserInviteBind:
        case DBLinkUserRegiste:
        case DBLinkUserPasswordModify:
        case DBLinkBookShelfList:
        case DBLinkUserAvatarUpload:
        case DBLinkUserNickModify:
        case DBLinkUserPhoneVeriCodeSend:
        case DBLinkUserPhoneCancelVeriCodeSend:
        case DBLinkUserPhoneCancel:
        case DBLinkUserPasswordForget:
        case DBLinkUserPhoneAreaCode:
        case DBLinkBookDetailCommentList:
        case DBLinkCommentList:
        case DBLinkUserAskBook:
        case DBLinkUserAskBookList:
        case DBLinkFeedBackSubmit:
        case DBLinkFeedBackList:
        case DBLinkCommentSubmit:
        case DBLinkCommentLike:
        case DBLinkCommentReplayLike:
        case DBLinkCommentReplayList:
        case DBLinkBookShelfBookAdd:
        case DBLinkBookShelfBookDelete:
        case DBLinkBookShelfMultiBookDelete:
        case DBLinkBookThemeCollectList:
        case DBLinkRBookThemeWhetherOrNot:
        case DBLinkRBookThemeAdd:
        case DBLinkRBookThemeDelete:
        case DBLinkChapterContentSubmit:
        case DBLinkBookShelfBookTop:
        case DBLinkBookShelfBookTopCancel:
        case DBLinkBookShelfBookFeedUp:
        case DBLinkBookShelfBookFeedUpCancel:
        case DBLinkBookReadingHistoryList:
        case DBLinkBookReadingCleanUp:
        case DBLinkUserInfoCenter:
        case DBLinkCommentReplaySubmit:
            
        case DBLinkAppSwitch:
        case DBLinkInviteCode:
        case DBLinkUserPlane:
        case DBUserClickReport:
        case DBLinkUserVipInfo:
        case DBLinkUserActivities:
        case DBLinkCheckActivity:
        case DBLinkActivityReward:
        case DBLinkFreeVipConsume:
            combineType = DBCombineMy;
            break;
        case DBLinkBookQualityChoice:
        case DBLinkBookQualityChoiceMore:
        case DBLinkBookQualityModuleMore:
        case DBLinkBookThemeCollectMore:
        case DBLinkBookStoreRankCatalog:
        case DBLinkBookStoreRankDetailData:
        case DBLinkBookDetailData:
        case DBLinkBookSummary:
        case DBLinkBookClassifyCatalog:
        case DBLinkBookClassifyWhole:
        case DBLinkBookThemeDetailData:
        case DBLinkBookSelfRec:
        case DBLinkBookHottest:
        case DBLinkBookBestseller:
            combineType = DBCombineBook;
            break;
        case DBLinkIconResUrl:
            combineType = DBCombineRes;
            break;
        case DBLinkBookAuthorRelate:
        case DBLinkBookSearchHotWords:
        case DBLinkBookSearchResult:
        case DBLinkSearchReport:
        case DBLinkSearchClickReport:
            combineType = DBCombineS;
            break;
        case DBLinkBookCatalog:
            combineType = DBCombineCatalog;
            break;
        case DBLinkBookChapter:
            combineType = DBCombineChapter;
            break;
        case DBLinkHeaderAvatarUrl:
            combineType = DBCombineAvater;
            break;
        default:
            break;
    }
    return combineType;
}

+ (NSString *)getCombineDomainWithCombineType:(DBCombineType)combineType{
    NSString *combineDomain = @"";
    
    NSString *http = @"https";
    NSString *domain = DBBaseAlamofire.domainString;
    //#ifdef DEBUG
    //    domain = @"dkhaqtjfu.cn";
    //#else
    
    switch (combineType) {
        case DBCombineConf:
            combineDomain = [NSString stringWithFormat:@"%@://conf.%@",http,domain];
            break;
        case DBCombineMy:
            combineDomain = [NSString stringWithFormat:@"%@://my.%@",http,domain];
            break;
        case DBCombineS:
            combineDomain = [NSString stringWithFormat:@"%@://s.%@",http,domain];
            break;
        case DBCombineBook:
            combineDomain = [NSString stringWithFormat:@"%@://book.%@",http,domain];
            break;
        case DBCombineRes:
            combineDomain = [NSString stringWithFormat:@"%@://c-res.%@",http,domain];
            break;
        case DBCombineCatalog:
            combineDomain = [NSString stringWithFormat:@"%@://catalog.%@",http,domain];
            break;
        case DBCombineChapter:
            combineDomain = [NSString stringWithFormat:@"%@://chapter.%@",http,domain];
            break;
        case DBCombineAvater:
            combineDomain = [NSString stringWithFormat:@"%@://avatar.%@",http,domain];
            break;
        default:
            break;
    }
    return combineDomain;
}

/*
 8 屏蔽YELLOW书籍
 6 纯净版
 7 添加福利书籍
 5 不限制投诉书籍
 4 限制投诉书籍
 */
+ (NSString *)searchType{
    if (DBCommonConfig.switchAudit) return @"v8";
    
    DBAppSetting *appSetting = DBAppSetting.setting;
    DBAppConfigModel *appConfig = DBCommonConfig.appConfig;
    DBReadBookSetting *readSetting = DBReadBookSetting.setting;
    
    if (appConfig.force.search_type == 4) return @"v8";
    if (appConfig.force.search_type == 2) return @"v6";
    if (appConfig.force.search_read > 0 && readSetting.readTotalTime > appConfig.force.search_read*60) {
        if (appSetting.launchCount > appConfig.force.search_start_up1) return @"v7";
        if (appSetting.launchCount > appConfig.force.search_start_up) return @"v5";
    }
    
    return @"v4";
}

@end
