//
//  DBMySettingModel.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/26.
//

#import "DBMySettingModel.h"
#import "DBBookChapterModel.h"

@implementation DBMySettingModel


@end

@implementation DBMySettingListModel

+ (NSArray *)dataSourceList{
    NSMutableArray *dataList = [NSMutableArray array];
    
    NSString *netCache = @"0B";
    NSString *booksCache = DBBookChapterModel.getAllBooksChapterMemory;
    if ([booksCache isEqualToString:@"0"]){
        booksCache = @"0B";
    }
    
    NSDictionary *data1 = @{@"title":DBConstantString.ks_notificationSettings,@"data":@[@{@"name":DBConstantString.ks_updateAlerts,@"isSwitch":@1,@"isOn":@(DBAppSetting.setting.isOn)}]};
    NSDictionary *data2 = @{@"title":DBConstantString.ks_general,@"data":@[
        @{@"name":DBConstantString.ks_shelfSorting,@"isArrow":@1,@"target":@1},
        @{@"name":DBConstantString.ks_syncShelf,@"isArrow":@1,@"needLogin":@1,@"target":@2},
        @{@"name":DBConstantString.ks_clearNetworkCache,@"content":netCache,@"isArrow":@1,@"target":@3},
        @{@"name":DBConstantString.ks_clearBookCache,@"content":booksCache,@"isArrow":@1,@"target":@4,@"vc":DBClearBooksCache}]};
    if (DBCommonConfig.switchAudit){
        data2 = @{@"title":DBConstantString.ks_general,@"data":@[
            @{@"name":DBConstantString.ks_clearNetworkCache,@"content":netCache,@"isArrow":@1,@"target":@3},
            @{@"name":DBConstantString.ks_clearBookCache,@"content":booksCache,@"isArrow":@1,@"target":@4,@"vc":DBClearBooksCache}]};
    }
    NSDictionary *data3 = @{@"title":DBConstantString.ks_userSettings,@"data":@[
        @{@"name":DBConstantString.ks_language,@"isArrow":@1,@"vc":DBMuteLanguage},
        @{@"name":DBConstantString.ks_changeLoginPassword,@"isArrow":@1,@"vc":DBResetPassword},
        @{@"name":DBConstantString.ks_deleteAccount,@"isArrow":@1,@"vc":DBAccountCancel},
        @{@"name":DBConstantString.ks_logout,@"isArrow":@1}]};
    if (DBCommonConfig.userDataInfo.account.isEmail){
        data3 = @{@"title":DBConstantString.ks_userSettings,@"data":@[
            @{@"name":DBConstantString.ks_language,@"isArrow":@1,@"vc":DBMuteLanguage},
            @{@"name":DBConstantString.ks_changeLoginPassword,@"isArrow":@1,@"vc":DBResetPassword},
            @{@"name":DBConstantString.ks_logout,@"isArrow":@1}]};
    }
    [dataList addObject:data1];
    [dataList addObject:data2];
    if (DBCommonConfig.isLogin) [dataList addObject:data3];
    return [NSArray modelArrayWithClass:self.class json:dataList];
}

+ (NSArray *)dataSourceList2{
    NSArray *data = @[@{@"name":DBConstantString.ks_changeLoginPassword,@"isArrow":@1,@"vc":DBResetPassword},
                            @{@"name":DBConstantString.ks_deleteAccount,@"isArrow":@1,@"vc":DBAccountCancel},
                            @{@"name":DBConstantString.ks_logout,@"isArrow":@1}
    ];
    return [NSArray modelArrayWithClass:DBMySettingModel.class json:data];
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        @"data" : DBMySettingModel.class,
    };
}

@end
