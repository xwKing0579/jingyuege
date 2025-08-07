//
//  DBAppConfigModel.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/28.
//

#import "DBAppConfigModel.h"

@implementation DBAppConfigModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        @"migrate_data" : DBMigrateDataModel.class,
        @"force" : DBForceModel.class,
        @"game" : DBGameModel.class,
        @"urls" : DBUrlsModel.class,
        @"notify" : DBNotifyModel.class,
        @"secondary_domain" : DBSecondaryDomainModel.class,
        @"exempt_ad" : DBAdSettingModel.class,
        @"splash_screen" : DBSplashScreenModel.class,
        @"splash_screen_err" : DBSplashScreenErrModel.class,
        @"awaken" : DBAwakenModel.class,
        
        @"awaken_err" : DBAwakenErrModel.class,
        @"bookself" : DBBookselfModel.class,
        @"search" : DBSearchModel.class,
        @"rank" : DBRankModel.class,
        @"lists" : DBListsModel.class,
        @"comment_lists" : DBCommentListsModel.class,
        @"book" : DBBookConfigModel.class,
        @"book_city" : DBBookCityModel.class,
        @"book_city_male" : DBBookCityMaleModel.class,
        
        @"book_city_female" : DBBookCityFemaleModel.class,
        @"book_city_end" : DBBookCityEndModel.class,
        @"book_city_classification" : DBBookCityClassificationModel.class,
        @"err_ad" : DBAdSettingModel.class,
        @"listening_book" : DBAdSettingModel.class,
        @"down_cache" : DBAdSettingModel.class,
        @"asking_book" : DBAdSettingModel.class,
        
        @"chapter" : DBChapterConfigModel.class,
        @"comics_chapter" : DBComicsChapterModel.class,
        @"hot_book" : DBHotBookModel.class,
        @"ad_data" : DBAdDataModel.class,
        @"contact_data" : DBContactDataModel.class,
        @"font": DBReaderFontModel.class,
    };
}

@end

@implementation DBForceModel

- (instancetype)init{
    if (self == [super init]){
        self.guest_book_number = 10;
    }
    return self;
}

@end

@implementation DBReaderFontModel

@end

@implementation DBContactDataModel

@end

@implementation DBMigrateDataModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"notify" : DBNotifyModel.class,
             @"tips" : DBMigrateTipModel.class,
             @"migrate" : DBMigrateConfigModel.class};
}
@end

@implementation DBMigrateConfigModel

@end

@implementation DBMigrateTipModel

@end

@implementation DBAdSettingModel

@end

@implementation DBGameModel

@end


@implementation DBUrlsModel

- (NSString *)qr_code_url{
    return [DBLinkManager combineLinkWithType:DBLinkIconResUrl combine:_qr_code_url];
}

@end

@implementation DBSecondaryDomainModel

@end


@implementation DBNotifyModel

@end

@implementation DBSplashScreenModel

@end

@implementation DBSplashScreenErrModel

@end

@implementation DBAwakenModel

@end

@implementation DBAwakenErrModel

@end

@implementation DBBookselfModel

@end

@implementation DBSearchModel

@end


@implementation DBRankModel

@end


@implementation DBListsModel

@end

@implementation DBCommentListsModel

@end

@implementation DBBookConfigModel

@end


@implementation DBBookCityModel

@end

@implementation DBBookCityMaleModel

@end

@implementation DBBookCityFemaleModel

@end

@implementation DBBookCityEndModel

@end

@implementation DBBookCityClassificationModel

@end

@implementation DBChapterConfigModel

@end

@implementation DBComicsChapterModel

@end

@implementation DBKsCityModel

@end



@implementation DBCsjComicsReadModel

@end


@implementation DBSigninModel

@end


@implementation DBCenter2Model

@end

@implementation DBTop2Model

@end

@implementation DBBottom2Model

@end

@implementation DBGdtReadModel

@end

@implementation DBBottomModel

@end

@implementation DBPushDataModel

@end

@implementation DBGpModel

@end

@implementation DBKsReadModel

@end

@implementation DBGmModel

@end

@implementation DBGdtListsModel

@end


@implementation DBGdtNewModel

@end

@implementation DBBdModel

@end

@implementation DBKsModel

@end

@implementation DBKsListsModel

@end

@implementation DBKsComicsReadModel

@end

@implementation DBCsjReadModel

@end

@implementation DBCsjListsModel

@end

@implementation DBCsjNewModel

@end

@implementation DBCsjCityModel

@end

@implementation DBAdDataModel

@end

@implementation DBIndexModel

@end

@implementation DBMinDataModel

@end

@implementation DBSignin2Model

@end

@implementation DBContentPage12Model

@end

@implementation DBTablePlaque2Model

@end

@implementation DBSourceModel

@end

@implementation DBVideoAddBookModel

@end

@implementation DBInterfaceTopModel

@end

@implementation DBWelfareCenterModel

@end

@implementation DBTopModel

@end

@implementation DBHotBookModel

@end

@implementation DBTablePlaqueModel

@end

@implementation DBContentPage2Model

@end

@implementation DBReadAdLockModel

@end

@implementation DBContentBottomModel

@end

@implementation DBCenterModel

@end

@implementation DBErrPhoneModel

@end

@implementation DBComicsExemptAdModel

@end

@implementation DBInterfaceTop2Model

@end

@implementation DBContentEnd2Model

@end

@implementation DBReadAdLock2Model

@end


@implementation DBContentBottom2Model

@end

@implementation DBContentEndModel

@end

@implementation DBContentPageModel

@end

@implementation DBContentPage1Model

@end

