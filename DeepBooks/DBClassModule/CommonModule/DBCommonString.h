//
//  DBCommonString.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/28.
//

#ifndef DBCommonString_h
#define DBCommonString_h

#define ISON DBCommonConfig.switchAudit
#define DBBookDetail ISON ? @"DBReadDetailViewController" : @"DBBookDetailViewController"
#define DBLoginPage ISON ? @"DBMobileSignInViewController" : @"DBSignInViewController"

static NSString *DBGenderBooks = @"DBGenderBooksViewController";
static NSString *DBReadBookPage = @"DBReaderManagerViewController";
static NSString *DBAuthorBooks = @"DBAuthorBooksViewController";
static NSString *DBBookSource = @"DBBookSourceViewController";
static NSString *DBBookCategory = @"DBBooksCategoryViewController";
static NSString *DBCollectionList = @"DBCollectionListViewController";
static NSString *DBReadBookCatalogs = @"DBReadBookCatalogsViewController";
static NSString *DBMyTheme = @"DBMyThemeViewController";
static NSString *DBReadRecord = @"DBReadRecordViewController";
static NSString *DBMyBooksManager = @"DBMyBooksManagerViewController";
static NSString *DBAboutUs = @"DBAboutUsViewController";
static NSString *DBService = @"DBServiceViewController";
static NSString *DBWebView = @"DBWebViewController";
static NSString *DBSearchBooks = @"DBSearchBooksViewController";
static NSString *DBTypeBooksList = @"DBTypeBooksListViewController";
static NSString *DBServiceList = @"DBServiceListViewController";
static NSString *DBRegister = @"DBRegisterViewController";
static NSString *DBResetPassword = @"DBResetPasswordViewController";
static NSString *DBContryCode = @"DBContryCodeViewController";
static NSString *DEUserSetting = @"DEUserSettingViewController";
static NSString *DBChangeName = @"DBChangeNameViewController";
static NSString *DBWantBooks = @"DBWantBooksViewController";
static NSString *DBFeedback = @"DBFeedbackViewController";
static NSString *DBClearBooksCache = @"DBClearBooksCacheViewController";
static NSString *DBMySetting = @"DBMySettingViewController";
static NSString *DBAccountCancel = @"DBAccountCancelViewController";
static NSString *DBBooksList = @"DBBooksListViewController";
static NSString *DBMyCultivateBooks = @"DBMyCultivateBooksViewController";
static NSString *DEBookComment = @"DEBookCommentViewController";
static NSString *DBMyBookList = @"DBMyBookListViewController";
static NSString *DBFogetPassword = @"DBFogetPasswordViewController";
static NSString *DBBookComment = @"DBBookCommentViewController";
static NSString *DBMuteLanguage = @"DBMuteLanguageViewController";
static NSString *DBHottestList = @"DBHottestListViewController";
static NSString *DBBestsellerList = @"DBBestsellerListViewController";

// key
static NSString *DBContryCodeValue = @"DBContryCodeValue";
static NSString *DBChoiceCodeValue = @"DBChoiceCodeValue";
static NSString *DBUserInfoValue = @"DBUserInfoValue"; //用户信息
static NSString *DBUserAdInfoValue = @"DBUserAdInfoValue"; 
static NSString *DBUserBookList = @"DBUserBookList"; //用户书单
static NSString *DBUserAvaterKey = @"DBUserAvaterKey"; //本地头像
static NSString *DBAppConfigValue = @"DBAppConfigValue"; //配置
static NSString *DBBooksExpandValue = @"DBBooksExpandValue"; //书架是否展开
static NSString *DBBooksSwitchValue = @"DBBooksSwitchValue";
static NSString *DBAppSwitchValue = @"DBAppSwitchValue";
static NSString *DBAdServerDataValue = @"DBAdServerDataValue";
static NSString *DBDomainIpMapValue = @"DBDomainIpMapValue";
static NSString *DBLocalLanguageValue = @"DBLocalLanguageValue";

// Notification
static NSString *DBUserLoginSuccess = @"DBUserLoginSuccess";
static NSString *DBUpdateCollectBooks = @"DBUpdateCollectBooks";
static NSString *DBBookSourceUpdate = @"DBBookSourceUpdate"; //更新目录
static NSString *DBTableViewEnable = @"DBTableViewEnable";
static NSString *DBAuditSwitchChange = @"DBAuditSwitchChange";
static NSString *DBsecondsTimeChange = @"DBsecondsTimeChange";
static NSString *DBNetReachableChange = @"DBNetReachableChange";
static NSString *DBLocalLanguageChange = @"DBLocalLanguageChange";
static NSString *DBUpdateMarqueeContent = @"DBUpdateMarqueeContent";


typedef NS_ENUM(NSInteger,DBBookType) {
    DBBookIndex,
    DBBookMale,
    DBBookFemale,
    DBBookComics,
};





#endif /* DBCommonString_h */
