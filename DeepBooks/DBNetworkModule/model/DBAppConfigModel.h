//
//  DBAppConfigModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class DBAdSettingModel;
@class DBMigrateDataModel;
@class DBForceModel;
@class DBGameModel;
@class DBUrlsModel;
@class DBSecondaryDomainModel;
@class DBNotifyModel;
@class DBSplashScreenModel;
@class DBSplashScreenErrModel;
@class DBAwakenModel;
@class DBAwakenErrModel;
@class DBBookselfModel;
@class DBSearchModel;
@class DBRankModel;
@class DBListsModel;
@class DBCommentListsModel;
@class DBBookConfigModel;
@class DBBookCityModel;
@class DBBookCityMaleModel;
@class DBBookCityFemaleModel;
@class DBBookCityEndModel;
@class DBBookCityClassificationModel;
@class DBChapterConfigModel;
@class DBComicsChapterModel;
@class DBMigrateTipModel;
@class DBMigrateConfigModel;


@class DBKsCityModel;
@class DBCsjComicsReadModel;
@class DBSigninModel;
@class DBCenter2Model;
@class DBTop2Model;
@class DBBottom2Model;
@class DBGdtReadModel;
@class DBBottomModel;
@class DBPushDataModel;
@class DBGpModel;
@class DBKsReadModel;
@class DBGdtListsModel;
@class DBGmModel;
@class DBGdtNewModel;
@class DBBdModel;
@class DBKsModel;
@class DBKsListsModel;
@class DBKsComicsReadModel;
@class DBCsjReadModel;
@class DBCsjListsModel;
@class DBCsjNewModel;
@class DBCsjCityModel;
@class DBAdDataModel;
@class DBIndexModel;
@class DBMinDataModel;
@class DBSignin2Model;
@class DBContentPage12Model;
@class DBTablePlaque2Model;
@class DBSourceModel;
@class DBVideoAddBookModel;
@class DBInterfaceTopModel;
@class DBWelfareCenterModel;
@class DBTopModel;
@class DBHotBookModel;
@class DBTablePlaqueModel;
@class DBContentPage2Model;
@class DBReadAdLockModel;
@class DBContentBottomModel;
@class DBCenterModel;
@class DBErrPhoneModel;
@class DBComicsExemptAdModel;
@class DBInterfaceTop2Model;
@class DBContentEnd2Model;
@class DBReadAdLock2Model;
@class DBContentBottom2Model;
@class DBContentEndModel;
@class DBContentPageModel;
@class DBContentPage1Model;
@class DBContactDataModel;
@class DBReaderFontModel;

@interface DBAppConfigModel : NSObject

@property (nonatomic, strong) DBForceModel *force;
@property (nonatomic, strong) DBGameModel *game;
@property (nonatomic, strong) DBUrlsModel *urls;
@property (nonatomic, strong) DBNotifyModel *notify;
@property (nonatomic, strong) DBSecondaryDomainModel *secondary_domain;
@property (nonatomic, strong) DBSplashScreenModel *splash_screen;
@property (nonatomic, strong) DBSplashScreenErrModel *splash_screen_err;
@property (nonatomic, strong) DBAwakenModel *awaken;
@property (nonatomic, strong) DBAwakenErrModel *awaken_err;
@property (nonatomic, strong) DBBookselfModel *bookself;
@property (nonatomic, strong) DBSearchModel *search;
@property (nonatomic, strong) DBRankModel *rank;
@property (nonatomic, strong) DBListsModel *lists;
@property (nonatomic, strong) DBCommentListsModel *comment_lists;
@property (nonatomic, strong) DBBookConfigModel *book;
@property (nonatomic, strong) DBBookCityModel *book_city;
@property (nonatomic, strong) DBBookCityMaleModel *book_city_male;
@property (nonatomic, strong) DBBookCityFemaleModel *book_city_female;
@property (nonatomic, strong) DBBookCityEndModel *book_city_end;
@property (nonatomic, strong) DBBookCityClassificationModel *book_city_classification;

@property (nonatomic, strong) DBChapterConfigModel *chapter;
@property (nonatomic, strong) DBComicsChapterModel *comics_chapter;
@property (nonatomic, strong) DBHotBookModel *hot_book;
@property (nonatomic, strong) DBAdDataModel *ad_data;

@property (nonatomic, strong) DBAdSettingModel *asking_book;
@property (nonatomic, strong) DBAdSettingModel *err_ad;
@property (nonatomic, strong) DBAdSettingModel *exempt_ad;
@property (nonatomic, strong) DBAdSettingModel *listening_book;
@property (nonatomic, strong) DBAdSettingModel *down_cache;

@property (nonatomic, strong) DBMigrateDataModel *migrate_data;  
@property (nonatomic, strong) DBContactDataModel *contact_data;
@property (nonatomic, strong) NSArray <DBReaderFontModel *> *font;

@property (nonatomic, copy) NSString *qq;
@property (nonatomic, copy) NSString *wechat;

@property (nonatomic, strong) id download;
@property (nonatomic, strong) DBPushDataModel *push_data;
@property (nonatomic, strong) DBComicsExemptAdModel *comics_exempt_ad;
@property (nonatomic, strong) DBVideoAddBookModel *video_add_book;
@property (nonatomic, strong) id bd_data;
@property (nonatomic, assign) NSInteger data_conf;
@property (nonatomic, assign) NSInteger phone_reg;
@property (nonatomic, strong) DBWelfareCenterModel *welfare_center;
@property (nonatomic, strong) DBErrPhoneModel *err_phone;
@property (nonatomic, strong) id signin_ad;

@end

@interface DBReaderFontModel : NSObject

@property (nonatomic, copy) NSString *font_en_name;
@property (nonatomic, copy) NSString *font_suffix_name;
@property (nonatomic, copy) NSString *fontmd5;
@property (nonatomic, copy) NSString *fontname;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString *size;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *img;
@end

@interface DBContactDataModel : NSObject

@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *email_a;
@property (nonatomic, copy) NSString *online_service;

@end

@interface DBAdSettingModel : NSObject

@property (nonatomic, assign) NSInteger interval_count;
@property (nonatomic, assign) NSInteger total_count;
@property (nonatomic, assign) NSInteger interval_min;

@property (nonatomic, strong) NSArray *stochastic;

@end

@interface DBMigrateDataModel : NSObject
@property (nonatomic, strong) DBNotifyModel *notify;
@property (nonatomic, strong) DBMigrateTipModel *tips;
@property (nonatomic, strong) DBMigrateConfigModel *migrate;
@end

@interface DBMigrateConfigModel : NSObject
@property (nonatomic, assign) NSInteger use_count;
@property (nonatomic, assign) NSInteger read_time;
@end

@interface DBMigrateTipModel : NSObject
@property (nonatomic, assign) BOOL tips_switch;
@property (nonatomic, assign) BOOL read_tips_switch;
@property (nonatomic, copy) NSString *tips_content;
@property (nonatomic, copy) NSString *jump_url;
@end

@interface DBAwakenModel : NSObject

@property (nonatomic, assign) NSInteger second;
@property (nonatomic, assign) NSInteger scheme;
@property (nonatomic, assign) NSInteger interval_min;
@property (nonatomic, assign) NSInteger interval_count;

@end


@interface DBComicsChapterModel : NSObject

@property (nonatomic, strong) DBContentEndModel *content_end;
@property (nonatomic, strong) DBInterfaceTopModel *interface_top;
@property (nonatomic, assign) NSInteger next_button_switch;
@property (nonatomic, strong) DBContentBottomModel *content_bottom;
@property (nonatomic, strong) DBContentPageModel *content_page;
@property (nonatomic, strong) DBReadAdLockModel *read_ad_lock;
@property (nonatomic, strong) DBContentPage1Model *content_page1;

@end


@interface DBContentPage1Model : NSObject

@property (nonatomic, assign) NSInteger interval_count;
@property (nonatomic, assign) NSInteger style;

@end


@interface DBRankModel : NSObject


@end


@interface DBSplashScreenErrModel : NSObject


@end


@interface DBContentPageModel : NSObject

@property (nonatomic, assign) NSInteger interval_count;
@property (nonatomic, assign) NSInteger style;

@end


@interface DBContentEndModel : NSObject


@end

@interface DBSearchModel : NSObject


@end


@interface DBNotifyModel : NSObject

@property (nonatomic, copy) NSString *notify_content;
@property (nonatomic, assign) NSInteger notify_open_type;
@property (nonatomic, copy) NSString *notify_url;
@property (nonatomic, assign) NSInteger notify_tips_type;

@end


@interface DBSplashScreenModel : NSObject

@property (nonatomic, assign) NSInteger second;
@property (nonatomic, assign) NSInteger interval_count;
@property (nonatomic, assign) NSInteger video_count;
@property (nonatomic, strong) NSArray *stochastic;

@end


@interface DBChapterConfigModel : NSObject

@property (nonatomic, strong) DBContentPage12Model *content_page12;
@property (nonatomic, strong) DBContentPage2Model *content_page2;
@property (nonatomic, strong) DBContentBottom2Model *content_bottom2;
@property (nonatomic, strong) DBInterfaceTop2Model *interface_top2;
@property (nonatomic, assign) NSInteger next_button_switch;
@property (nonatomic, strong) DBReadAdLock2Model *read_ad_lock2;
@property (nonatomic, strong) DBContentEnd2Model *content_end2;

@end


@interface DBContentBottom2Model : NSObject


@end


@interface DBReadAdLock2Model : NSObject

@property (nonatomic, assign) NSInteger play;
@property (nonatomic, assign) NSInteger interval_min;
@property (nonatomic, assign) NSInteger scheme;
@property (nonatomic, assign) NSInteger back;
@property (nonatomic, assign) NSInteger loading;

@end


@interface DBContentEnd2Model : NSObject


@end


@interface DBInterfaceTop2Model : NSObject


@end


@interface DBGameModel : NSObject

@property (nonatomic, assign) NSInteger game_interval_seconds;
@property (nonatomic, assign) NSInteger game_switch;

@end


@interface DBComicsExemptAdModel : NSObject

@property (nonatomic, strong) DBSigninModel *signin;
@property (nonatomic, assign) NSInteger interval_count;
@property (nonatomic, assign) NSInteger interval_min;

@end


@interface DBErrPhoneModel : NSObject

@property (nonatomic, copy) NSString *phone_list;
@property (nonatomic, strong) id stochastic;

@end


@interface DBBookCityModel : NSObject

@property (nonatomic, strong) DBCenterModel *center;
@property (nonatomic, strong) DBTopModel *top;
@property (nonatomic, strong) DBBottomModel *bottom;
@property (nonatomic, strong) DBTablePlaqueModel *table_plaque;

@end


@interface DBCenterModel : NSObject


@end


@interface DBContentBottomModel : NSObject


@end


@interface DBBookCityFemaleModel : NSObject

@property (nonatomic, strong) DBBottom2Model *bottom2;
@property (nonatomic, strong) DBCenter2Model *center2;
@property (nonatomic, strong) DBTop2Model *top2;

@end


@interface DBBottom2Model : NSObject


@end


@interface DBReadAdLockModel : NSObject

@property (nonatomic, assign) NSInteger back;
@property (nonatomic, assign) NSInteger scheme;
@property (nonatomic, assign) NSInteger play;
@property (nonatomic, assign) NSInteger interval_min;
@property (nonatomic, assign) NSInteger loading;

@end


@interface DBCommentListsModel : NSObject

@property (nonatomic, assign) NSInteger interval_count;

@end


@interface DBContentPage2Model : NSObject

@property (nonatomic, assign) NSInteger style;
@property (nonatomic, assign) NSInteger interval_count;

@end


@interface DBTablePlaqueModel : NSObject

@property (nonatomic, assign) NSInteger interval_count;

@end


@interface DBBookCityEndModel : NSObject

@property (nonatomic, strong) DBBottom2Model *bottom2;
@property (nonatomic, strong) DBCenter2Model *center2;
@property (nonatomic, strong) DBTop2Model *top2;

@end




@interface DBForceModel : NSObject

@property (nonatomic, assign) NSInteger ad_alone;
@property (nonatomic, copy) NSString *txl;
@property (nonatomic, assign) NSInteger hide_tts_switch;
@property (nonatomic, assign) NSInteger google_volume;
@property (nonatomic, assign) NSInteger read_time;
@property (nonatomic, assign) BOOL jg_switch;
@property (nonatomic, assign) NSInteger comics_switch;
@property (nonatomic, assign) NSInteger content_interval_page;
@property (nonatomic, assign) NSInteger read_second;
@property (nonatomic, assign) NSInteger source_switch;
@property (nonatomic, copy) NSString *zgid;
@property (nonatomic, assign) BOOL um_switch;
@property (nonatomic, assign) NSInteger pay_tips_switch;
@property (nonatomic, assign) NSInteger ad_chapter_count;
@property (nonatomic, assign) NSInteger novice_type;  //新手模式选择
@property (nonatomic, assign) NSInteger splash_show_time_interval;
@property (nonatomic, assign) NSInteger search_read1;
@property (nonatomic, assign) NSInteger invalid_request_min;
@property (nonatomic, assign) NSInteger end_tips_ad_switch;
@property (nonatomic, copy) NSString *txls;
@property (nonatomic, assign) NSInteger novice_day;
@property (nonatomic, assign) NSInteger novice_read;
@property (nonatomic, copy) NSString *tterr_pk;
@property (nonatomic, assign) NSInteger ad_timeout;
@property (nonatomic, assign) NSInteger interstitial_preload_count;
@property (nonatomic, assign) NSInteger score_switch;
@property (nonatomic, assign) NSInteger hide_source_switch;
@property (nonatomic, assign) NSInteger request_state_interval;
@property (nonatomic, assign) NSInteger bdk1source;
@property (nonatomic, assign) NSInteger source_import;
@property (nonatomic, assign) NSInteger comment_switch;
@property (nonatomic, assign) NSInteger book_ad_interval;
@property (nonatomic, assign) BOOL media_banner_switch;
@property (nonatomic, assign) NSInteger read_network_switch;
@property (nonatomic, assign) NSInteger guest_book_number;
@property (nonatomic, assign) NSInteger ifh_big;
@property (nonatomic, copy) NSString *bdid1;
@property (nonatomic, copy) NSString *bdk;
@property (nonatomic, copy) NSString *stamp;
@property (nonatomic, copy) NSString *read_ad_content;
@property (nonatomic, assign) NSInteger pay_switch;
@property (nonatomic, assign) NSInteger show_image_switch;
@property (nonatomic, assign) NSInteger slide_switch;
@property (nonatomic, copy) NSString *ad_cache_code;
@property (nonatomic, assign) NSInteger book_status;
@property (nonatomic, assign) NSInteger ad_night_switch;
@property (nonatomic, assign) NSInteger interval_ad_next_switch;
@property (nonatomic, assign) NSInteger comics_barrage_switch;
@property (nonatomic, copy) NSString *source_url2;
@property (nonatomic, assign) NSInteger read_ad_tips_switch;
@property (nonatomic, assign) NSInteger novice_count;
@property (nonatomic, copy) NSString *txlpk;
@property (nonatomic, assign) NSInteger source_open_switch;
@property (nonatomic, assign) NSInteger interval_ad_second;
@property (nonatomic, assign) NSInteger chapter_switch;
@property (nonatomic, assign) BOOL google_switch;
@property (nonatomic, assign) BOOL shield_switch;
@property (nonatomic, assign) NSInteger ad_polling_iphone_second;
@property (nonatomic, assign) NSInteger search_start_up1;
@property (nonatomic, copy) NSString *source_url1;
@property (nonatomic, assign) NSInteger no_network_type;
@property (nonatomic, assign) NSInteger ks_switch;
@property (nonatomic, assign) NSInteger pay_tips_count;
@property (nonatomic, copy) NSString *bdsn1;
@property (nonatomic, assign) NSInteger ad_polling_second;
@property (nonatomic, assign) NSInteger max_ad_count;
@property (nonatomic, copy) NSString *ad_err_code;
@property (nonatomic, assign) BOOL bug_switch;
@property (nonatomic, copy) NSString *bdk1;
@property (nonatomic, copy) NSString *read_ad_content1;
@property (nonatomic, assign) NSInteger search_type;
@property (nonatomic, assign) NSInteger lr_switch;
@property (nonatomic, assign) NSInteger asking_book_switch;
@property (nonatomic, assign) NSInteger read_start_up;
@property (nonatomic, assign) NSInteger sdk_init_time;
@property (nonatomic, assign) NSInteger fission_switch;
@property (nonatomic, assign) NSInteger chapter_count;
@property (nonatomic, assign) NSInteger app_network_switch;
@property (nonatomic, assign) NSInteger interval_ad_switch;
@property (nonatomic, assign) NSInteger horizontal_switch;
@property (nonatomic, assign) NSInteger share_switch;
@property (nonatomic, assign) NSInteger search_read;
@property (nonatomic, assign) NSInteger show_author;
@property (nonatomic, assign) NSInteger ad_popup_switch;
@property (nonatomic, assign) NSInteger comics_related_switch;
@property (nonatomic, assign) NSInteger ad_polling_iphone;
@property (nonatomic, assign) NSInteger read_ad_switch;
@property (nonatomic, assign) NSInteger score_day;
@property (nonatomic, assign) NSInteger reminder_page_count;
@property (nonatomic, assign) NSInteger icon_style;
@property (nonatomic, assign) BOOL max_exempt_ad_switch;
@property (nonatomic, assign) NSInteger self_switch;
@property (nonatomic, assign) NSInteger start_main;
@property (nonatomic, assign) NSInteger is_alone;
@property (nonatomic, copy) NSString *bdsn;
@property (nonatomic, assign) NSInteger novice_switch;
@property (nonatomic, copy) NSString *bds;
@property (nonatomic, copy) NSString *kf_url;
@property (nonatomic, assign) NSInteger vip_ad_init_switch;
@property (nonatomic, assign) NSInteger excitation_delay_time;
@property (nonatomic, assign) BOOL gdt_switch;
@property (nonatomic, strong) NSArray <NSString *> *read_ad_content2;
@property (nonatomic, copy) NSString *disclaimer;
@property (nonatomic, assign) NSInteger search_start_up;
@property (nonatomic, copy) NSString *bds1;
@property (nonatomic, copy) NSString *ad_version;
@property (nonatomic, copy) NSString *bdid;
@property (nonatomic, assign) NSInteger topon_switch;
@property (nonatomic, assign) NSInteger ifh_small;
@property (nonatomic, assign) NSInteger login_book_number;
@property (nonatomic, assign) NSInteger no_network_count;
@property (nonatomic, copy) NSString *bmob;
@property (nonatomic, assign) NSInteger read_bottom_switch;
@property (nonatomic, assign) NSInteger https_switch;
@property (nonatomic, assign) BOOL csj_switch;
@property (nonatomic, assign) BOOL update_switch;
@property (nonatomic, copy) NSString *source_tips;
@property (nonatomic, assign) NSInteger record_switch;
@property (nonatomic, assign) NSInteger read_ad_interval;
@property (nonatomic, assign) NSInteger comics_fav_switch;
@property (nonatomic, assign) NSInteger click_down_switch;
@property (nonatomic, assign) NSInteger down_speed;
@property (nonatomic, assign) BOOL vip_splash_screen_switch;
@property (nonatomic, copy) NSString *xfid;
@property (nonatomic, assign) NSInteger read_ad_content_page;
@property (nonatomic, assign) NSInteger show_a_switch;
@property (nonatomic, assign) NSInteger reward_video_preload_count;
@property (nonatomic, assign) NSInteger excitation_loading_switch;

@end


@interface DBHotBookModel : NSObject

@property (nonatomic, strong) NSArray *book_male;
@property (nonatomic, strong) NSArray *book_comics;
@property (nonatomic, strong) NSArray *book_default;
@property (nonatomic, strong) NSArray *book_female;

@end


@interface DBBookselfModel : NSObject

@property (nonatomic, strong) DBTop2Model *top2;
@property (nonatomic, strong) DBTablePlaque2Model *table_plaque2;
@property (nonatomic, strong) DBCenter2Model *center2;

@end


@interface DBTopModel : NSObject


@end


@interface DBTop2Model : NSObject


@end


@interface DBWelfareCenterModel : NSObject


@end


@interface DBInterfaceTopModel : NSObject


@end


@interface DBVideoAddBookModel : NSObject

@property (nonatomic, assign) NSInteger today_count;
@property (nonatomic, assign) NSInteger interval_min;
@property (nonatomic, assign) NSInteger total_count;
@property (nonatomic, assign) NSInteger add_count;

@end


@interface DBBookConfigModel : NSObject

@property (nonatomic, strong) DBSourceModel *source;
@property (nonatomic, strong) DBBottom2Model *bottom2;
@property (nonatomic, strong) DBTablePlaque2Model *table_plaque2;
@property (nonatomic, strong) DBTop2Model *top2;
@property (nonatomic, strong) DBCenter2Model *center2;

@end



@interface DBSourceModel : NSObject


@end



@interface DBTablePlaque2Model : NSObject

@property (nonatomic, assign) NSInteger interval_count;

@end


@interface DBContentPage12Model : NSObject

@property (nonatomic, assign) NSInteger style;
@property (nonatomic, assign) NSInteger interval_count;

@end


@interface DBSecondaryDomainModel : NSObject

@property (nonatomic, copy) NSString *c_pic;
@property (nonatomic, copy) NSString *c_res;
@property (nonatomic, copy) NSString *conf;
@property (nonatomic, copy) NSString *catalog;
@property (nonatomic, copy) NSString *d;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *book;
@property (nonatomic, copy) NSString *s;
@property (nonatomic, copy) NSString *ad;
@property (nonatomic, copy) NSString *my;
@property (nonatomic, copy) NSString *res;
@property (nonatomic, copy) NSString *chapter;
@property (nonatomic, copy) NSString *c_chapter;
@property (nonatomic, copy) NSString *c_catalog;

@end

@interface DBSignin2Model : NSObject

@property (nonatomic, assign) NSInteger ad_switch1;
@property (nonatomic, strong) NSArray <DBMinDataModel *> *data;
@property (nonatomic, assign) NSInteger week_min;
@property (nonatomic, assign) NSInteger ad_switch;
@property (nonatomic, assign) NSInteger double_min;

@end


@interface DBMinDataModel : NSObject

@property (nonatomic, assign) NSInteger min;

@end


@interface DBAwakenErrModel : NSObject


@end


@interface DBBookCityClassificationModel : NSObject

@property (nonatomic, strong) DBBottom2Model *bottom2;
@property (nonatomic, strong) DBIndexModel *index;
@property (nonatomic, strong) DBTop2Model *top2;
@property (nonatomic, strong) DBCenter2Model *center2;

@end


@interface DBIndexModel : NSObject


@end



@interface DBAdDataModel : NSObject

@property (nonatomic, strong) id topon_global;
@property (nonatomic, strong) DBKsReadModel *ks_read;
@property (nonatomic, strong) id csj;
@property (nonatomic, strong) DBGdtReadModel *gdt_read;
@property (nonatomic, strong) DBGpModel *gp;
@property (nonatomic, strong) DBKsListsModel *ks_lists;
@property (nonatomic, strong) DBCsjCityModel *csj_city;
@property (nonatomic, strong) DBGdtNewModel *gdt_new;
@property (nonatomic, strong) id js;
@property (nonatomic, strong) DBKsComicsReadModel *ks_comics_read;
@property (nonatomic, strong) id csj_bottom_bg;
@property (nonatomic, strong) id csj_big_picture_bg;
@property (nonatomic, strong) DBCsjComicsReadModel *csj_comics_read;
@property (nonatomic, strong) DBCsjListsModel *csj_lists;
@property (nonatomic, strong) DBGdtListsModel *gdt_lists;
@property (nonatomic, strong) id csj_arr;
@property (nonatomic, strong) DBGmModel *gm;
@property (nonatomic, strong) id topon;
@property (nonatomic, strong) id google;
@property (nonatomic, strong) DBKsModel *ks;
@property (nonatomic, strong) DBKsCityModel *ks_city;
@property (nonatomic, strong) id gdt;
@property (nonatomic, strong) DBCsjNewModel *csj_new;
@property (nonatomic, strong) DBBdModel *bd;
@property (nonatomic, strong) id topon_read;
@property (nonatomic, strong) id gdt_bottom_bg;
@property (nonatomic, strong) id gdt_big_picture_bg;
@property (nonatomic, strong) DBCsjReadModel *csj_read;

@end


@interface DBCsjCityModel : NSObject

@property (nonatomic, copy) NSString *b_big;
@property (nonatomic, copy) NSString *i_small_black;
@property (nonatomic, copy) NSString *i_big_white;
@property (nonatomic, copy) NSString *i_small_white;
@property (nonatomic, copy) NSString *i_big_black;
@property (nonatomic, copy) NSString *b_small;

@end


@interface DBCsjNewModel : NSObject

@property (nonatomic, copy) NSString *v;
@property (nonatomic, copy) NSString *h;
@property (nonatomic, copy) NSString *q;
@property (nonatomic, copy) NSString *l;
@property (nonatomic, copy) NSString *n;
@property (nonatomic, copy) NSString *ecode1;
@property (nonatomic, copy) NSString *ecode;
@property (nonatomic, copy) NSString *s;
@property (nonatomic, copy) NSString *t;
@property (nonatomic, copy) NSString *aa1;
@property (nonatomic, copy) NSString *b;
@property (nonatomic, copy) NSString *o;
@property (nonatomic, copy) NSString *i;
@property (nonatomic, copy) NSString *g;
@property (nonatomic, copy) NSString *c;
@property (nonatomic, copy) NSString *m;
@property (nonatomic, copy) NSString *j;
@property (nonatomic, copy) NSString *e;
@property (nonatomic, copy) NSString *f;
@property (nonatomic, assign) BOOL sound_switch;
@property (nonatomic, copy) NSString *a;
@property (nonatomic, copy) NSString *d;
@property (nonatomic, copy) NSString *k;
@property (nonatomic, copy) NSString *ai;
@property (nonatomic, copy) NSString *u;
@property (nonatomic, copy) NSString *r;
@property (nonatomic, copy) NSString *p;

@end


@interface DBCsjListsModel : NSObject

@property (nonatomic, copy) NSString *b_black;
@property (nonatomic, copy) NSString *c_small_black;
@property (nonatomic, copy) NSString *c_small_white;
@property (nonatomic, copy) NSString *b_small_white;
@property (nonatomic, copy) NSString *b_small_black;
@property (nonatomic, copy) NSString *b_small;
@property (nonatomic, copy) NSString *c_small;
@property (nonatomic, copy) NSString *c_black;

@end


@interface DBCsjReadModel : NSObject

@property (nonatomic, copy) NSString *a;
@property (nonatomic, copy) NSString *p_small_white;
@property (nonatomic, copy) NSString *b;
@property (nonatomic, copy) NSString *b_small_white;
@property (nonatomic, copy) NSString *p_big_white;
@property (nonatomic, copy) NSString *b_small;
@property (nonatomic, copy) NSString *c;
@property (nonatomic, copy) NSString *p_big;
@property (nonatomic, copy) NSString *b_small_black;
@property (nonatomic, copy) NSString *p_small;
@property (nonatomic, copy) NSString *p_big_black;
@property (nonatomic, copy) NSString *p_small_black;

@end


@interface DBKsComicsReadModel : NSObject

@property (nonatomic, copy) NSString *h_c_img;
@property (nonatomic, copy) NSString *b_small_white;
@property (nonatomic, copy) NSString *b_small;
@property (nonatomic, copy) NSString *h_c_video;
@property (nonatomic, copy) NSString *p_big;
@property (nonatomic, copy) NSString *p_big_white;
@property (nonatomic, copy) NSString *p_small;
@property (nonatomic, copy) NSString *h_s_img;
@property (nonatomic, copy) NSString *p_small_white;

@end


@interface DBKsListsModel : NSObject

@property (nonatomic, copy) NSString *b_small;
@property (nonatomic, copy) NSString *c_small;
@property (nonatomic, copy) NSString *b_small_white;
@property (nonatomic, copy) NSString *c_small_white;

@end


@interface DBKsModel : NSObject

@property (nonatomic, copy) NSString *r;
@property (nonatomic, copy) NSString *b;
@property (nonatomic, copy) NSString *v;
@property (nonatomic, copy) NSString *h;
@property (nonatomic, copy) NSString *d;
@property (nonatomic, copy) NSString *o;
@property (nonatomic, copy) NSString *k;
@property (nonatomic, copy) NSString *g;
@property (nonatomic, copy) NSString *ecode;
@property (nonatomic, assign) NSInteger sound_switch;
@property (nonatomic, copy) NSString *q;
@property (nonatomic, copy) NSString *ai;
@property (nonatomic, copy) NSString *ecode1;
@property (nonatomic, copy) NSString *p;
@property (nonatomic, copy) NSString *a;
@property (nonatomic, copy) NSString *e;
@property (nonatomic, copy) NSString *u;
@property (nonatomic, copy) NSString *j;
@property (nonatomic, copy) NSString *i;
@property (nonatomic, copy) NSString *n;
@property (nonatomic, copy) NSString *f;
@property (nonatomic, copy) NSString *c;

@end


@interface DBBdModel : NSObject

@property (nonatomic, copy) NSString *k;
@property (nonatomic, copy) NSString *b;
@property (nonatomic, copy) NSString *l;
@property (nonatomic, copy) NSString *h;
@property (nonatomic, copy) NSString *d;
@property (nonatomic, copy) NSString *o;
@property (nonatomic, copy) NSString *r;
@property (nonatomic, copy) NSString *aid;
@property (nonatomic, copy) NSString *g;
@property (nonatomic, copy) NSString *e;
@property (nonatomic, copy) NSString *q;
@property (nonatomic, copy) NSString *a;
@property (nonatomic, copy) NSString *ai;
@property (nonatomic, copy) NSString *p;
@property (nonatomic, copy) NSString *j;
@property (nonatomic, copy) NSString *i;
@property (nonatomic, copy) NSString *n;
@property (nonatomic, copy) NSString *m;
@property (nonatomic, copy) NSString *f;
@property (nonatomic, copy) NSString *c;

@end


@interface DBGdtNewModel : NSObject

@property (nonatomic, copy) NSString *r;
@property (nonatomic, copy) NSString *b;
@property (nonatomic, copy) NSString *v;
@property (nonatomic, copy) NSString *g;
@property (nonatomic, copy) NSString *d;
@property (nonatomic, copy) NSString *o;
@property (nonatomic, copy) NSString *h;
@property (nonatomic, copy) NSString *k;
@property (nonatomic, copy) NSString *ecode;
@property (nonatomic, assign) NSInteger sound_switch;
@property (nonatomic, copy) NSString *e;
@property (nonatomic, copy) NSString *ecode1;
@property (nonatomic, copy) NSString *u;
@property (nonatomic, copy) NSString *p;
@property (nonatomic, copy) NSString *ai;
@property (nonatomic, copy) NSString *a;
@property (nonatomic, copy) NSString *q;
@property (nonatomic, copy) NSString *j;
@property (nonatomic, copy) NSString *s;
@property (nonatomic, copy) NSString *i;
@property (nonatomic, copy) NSString *t;
@property (nonatomic, copy) NSString *n;
@property (nonatomic, copy) NSString *f;
@property (nonatomic, copy) NSString *c;

@end


@interface DBGmModel : NSObject

@property (nonatomic, copy) NSString *c;
@property (nonatomic, copy) NSString *a;
@property (nonatomic, copy) NSString *f;
@property (nonatomic, copy) NSString *k;
@property (nonatomic, copy) NSString *d;
@property (nonatomic, copy) NSString *b;
@property (nonatomic, copy) NSString *i;
@property (nonatomic, copy) NSString *aid;
@property (nonatomic, copy) NSString *g;
@property (nonatomic, copy) NSString *e;
@property (nonatomic, copy) NSString *h;
@property (nonatomic, copy) NSString *j;

@end


@interface DBGdtListsModel : NSObject

@property (nonatomic, copy) NSString *b_small_white;
@property (nonatomic, copy) NSString *c_big_black;
@property (nonatomic, copy) NSString *b_small_sr;
@property (nonatomic, copy) NSString *c_big_white;
@property (nonatomic, copy) NSString *b_banner2;
@property (nonatomic, copy) NSString *b_small_black;
@property (nonatomic, copy) NSString *c_banner2;
@property (nonatomic, copy) NSString *c_small_white;
@property (nonatomic, copy) NSString *c_small_black;
@property (nonatomic, copy) NSString *c_small_sr;
@property (nonatomic, copy) NSString *c_big_sr;

@end


@interface DBKsReadModel : NSObject

@property (nonatomic, copy) NSString *a;
@property (nonatomic, copy) NSString *c;
@property (nonatomic, copy) NSString *p_big;
@property (nonatomic, copy) NSString *b_small_white;
@property (nonatomic, copy) NSString *b_small;
@property (nonatomic, copy) NSString *p_big_white;
@property (nonatomic, copy) NSString *p_small;
@property (nonatomic, copy) NSString *b;
@property (nonatomic, copy) NSString *p_small_white;

@end


@interface DBGpModel : NSObject

@property (nonatomic, copy) NSString *b;
@property (nonatomic, copy) NSString *g;
@property (nonatomic, copy) NSString *d;
@property (nonatomic, copy) NSString *h;
@property (nonatomic, strong) id aid;
@property (nonatomic, copy) NSString *e;
@property (nonatomic, strong) id ai;
@property (nonatomic, copy) NSString *a;
@property (nonatomic, copy) NSString *j;
@property (nonatomic, copy) NSString *i;
@property (nonatomic, copy) NSString *as;
@property (nonatomic, copy) NSString *f;
@property (nonatomic, copy) NSString *c;

@end


@interface DBUrlsModel : NSObject

@property (nonatomic, copy) NSString *iflytek_tts_url;
@property (nonatomic, copy) NSString *domain;
@property (nonatomic, copy) NSString *diversion_url;
@property (nonatomic, strong) id site_source_url;
@property (nonatomic, copy) NSString *page_url;
@property (nonatomic, copy) NSString *website_url;
@property (nonatomic, copy) NSString *baidu_tts_url;
@property (nonatomic, copy) NSString *qr_code_url;

@end


@interface DBListsModel : NSObject


@end


@interface DBPushDataModel : NSObject

@property (nonatomic, copy) NSString *master_secret;
@property (nonatomic, copy) NSString *bug_key;
@property (nonatomic, copy) NSString *um_key;
@property (nonatomic, copy) NSString *um_message_secret;
@property (nonatomic, copy) NSString *tt_id;
@property (nonatomic, copy) NSString *appkey;
@property (nonatomic, copy) NSString *bd_id;
@property (nonatomic, copy) NSString *um_master_secret;

@end


@interface DBBottomModel : NSObject


@end


@interface DBGdtReadModel : NSObject

@property (nonatomic, copy) NSString *c;
@property (nonatomic, copy) NSString *b;
@property (nonatomic, copy) NSString *h_c_img;
@property (nonatomic, copy) NSString *sr_small;
@property (nonatomic, copy) NSString *a;
@property (nonatomic, copy) NSString *h_c_video;
@property (nonatomic, copy) NSString *h_s_img;
@property (nonatomic, copy) NSString *banner2;
@property (nonatomic, copy) NSString *csr_big;
@property (nonatomic, copy) NSString *sr_big;
@property (nonatomic, copy) NSString *cbanner2;
@property (nonatomic, copy) NSString *csr_small;
@property (nonatomic, copy) NSString *sr_ps;
@property (nonatomic, copy) NSString *csr_ps;

@end


@interface DBBookCityMaleModel : NSObject

@property (nonatomic, strong) DBBottom2Model *bottom2;
@property (nonatomic, strong) DBCenter2Model *center2;
@property (nonatomic, strong) DBTop2Model *top2;

@end


@interface DBCenter2Model : NSObject


@end


@interface DBSigninModel : NSObject

@property (nonatomic, strong) id data;
@property (nonatomic, assign) NSInteger ad_switch;
@property (nonatomic, assign) NSInteger double_min;
@property (nonatomic, assign) NSInteger ad_switch1;
@property (nonatomic, assign) NSInteger week_min;

@end


@interface DBCsjComicsReadModel : NSObject

@property (nonatomic, copy) NSString *h_c_img;
@property (nonatomic, copy) NSString *b_small_white;
@property (nonatomic, copy) NSString *b_small;
@property (nonatomic, copy) NSString *h_c_video;
@property (nonatomic, copy) NSString *p_big;
@property (nonatomic, copy) NSString *p_big_white;
@property (nonatomic, copy) NSString *p_small;
@property (nonatomic, copy) NSString *h_s_video;
@property (nonatomic, copy) NSString *h_s_img;
@property (nonatomic, copy) NSString *p_small_white;

@end


@interface DBKsCityModel : NSObject

@property (nonatomic, copy) NSString *b_big;
@property (nonatomic, copy) NSString *i_big_white;
@property (nonatomic, copy) NSString *i_small_white;
@property (nonatomic, copy) NSString *b_small;

@end

NS_ASSUME_NONNULL_END
