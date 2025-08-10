//
//  DBMyConfigModel.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/27.
//

#import "DBMyConfigModel.h"
#import "DBReadBookSetting.h"
@implementation DBMyConfigModel

+ (NSArray *)dataSourceList{
    DBUserInfoModel *useInfo = DBCommonConfig.userCurrentInfo;
    NSArray *dataList = @[@{@"name":DBConstantString.ks_share,@"icon":@"jjVaultOne",@"needLogin":@"1"},
    @{@"name":DBConstantString.ks_nightCare,@"icon":@"jjVaultTwo",@"needLogin":@"0",@"vc":DBMyTheme},
                          @{@"name":DBConstantString.ks_history,@"icon":@"jjVaultThree",@"needLogin":@"0",@"vc":DBReadRecord},
                          @{@"name":DBConstantString.ks_myRequests,@"icon":@"jjVaultFour",@"needLogin":@"1",@"vc":DBWantBooks,@"unreadCount":@(useInfo.asking_book_number)},
                          @{@"name":DBConstantString.ks_feedbackOpinion,@"icon":@"jjVaultFive",@"needLogin":@"1",@"vc":DBFeedback,@"unreadCount":@(useInfo.service_appeal_number)},
                          @{@"name":DBConstantString.ks_favoriteLists,@"icon":@"jjVaultSix",@"needLogin":@"1",@"vc":DBMyBookList},
                          @{@"name":DBConstantString.ks_mySettings,@"icon":@"jjVaultSeven",@"needLogin":@"0",@"vc":DBMySetting},
                          @{@"name":DBConstantString.ks_about,@"icon":@"jjVaultEight",@"needLogin":@"0",@"vc":DBAboutUs},];
    if (DBCommonConfig.switchAudit){
        dataList = @[
            @{@"name":DBConstantString.ks_history,@"icon":@"jjVaultThree",@"needLogin":@"0",@"vc":DBReadRecord},
            @{@"name":DBConstantString.ks_reading,@"icon":@"jjVaultFour",@"needLogin":@"0",@"vc":DBMyTheme},
            @{@"name":DBConstantString.ks_management,@"icon":@"jjVaultSix",@"needLogin":@"0",@"vc":DBMyBooksManager},
            @{@"name":DBConstantString.ks_fiveStar,@"icon":@"jjMasterVault",@"needLogin":@"0"},
            @{@"name":DBConstantString.ks_about,@"icon":@"jjVaultEight",@"needLogin":@"0",@"vc":DBAboutUs}
        ];
    }
    
    NSMutableArray *dataModelList = [NSMutableArray arrayWithArray:dataList];
    
    NSInteger inviterSwitch = DBCommonConfig.appConfig.force.pay_tips_switch;
    if (inviterSwitch == 0 || inviterSwitch == 100){
     
    }else{
        [dataModelList insertObject: @{@"name":DBConstantString.ks_bindInviteCode,@"icon":@"jjVaultNine",@"needLogin":@"0"} atIndex:dataList.count-2];
    }
    
    DBContactDataModel *contactModel = DBCommonConfig.appConfig.contact_data;
    if (DBCommonConfig.switchAudit){
        [dataModelList addObject:@{@"name":DBConstantString.ks_contactSupport,@"icon":@"jjVaultTen",@"content":EMAILCUSTOMER,@"needLogin":@"0"}];
    }else{
        NSString *link = contactModel.online_service;
        if (link.whitespace.length > 0) {
            [dataModelList addObject:@{@"name":DBConstantString.ks_contactSupport,@"icon":@"jjVaultTen",@"content":@"",@"needLogin":@"0"}];
        }else{
            [dataModelList addObject:@{@"name":DBConstantString.ks_contactSupport,@"icon":@"jjVaultTen",@"content":DBSafeString(contactModel.email),@"needLogin":@"0"}];
        }
    }
    
   
    return [NSArray modelArrayWithClass:self.class json:dataModelList];
}

+ (NSArray *)myConfigContent{
    DBReadBookSetting *setting = DBReadBookSetting.setting;
    NSString *readTime = [NSString stringWithFormat:@"%.0lf",ceil(setting.readTotalTime/60.0)];
    NSString *collectBooks = [NSString stringWithFormat:@"%ld",DBBookModel.getAllCollectBooks.count];
    NSString *readCount = [NSString stringWithFormat:@"%ld",DBBookModel.getAllReadingBooks.count];
    return @[readTime,collectBooks,readCount];
}

@end
