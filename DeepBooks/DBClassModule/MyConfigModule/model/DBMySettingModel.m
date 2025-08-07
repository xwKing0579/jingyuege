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
    
    NSDictionary *data1 = @{@"title":@"推送设置",@"data":@[@{@"name":@"更新提醒",@"isSwitch":@1,@"isOn":@(DBAppSetting.setting.isOn)}]};
    NSDictionary *data2 = @{@"title":@"通用设置",@"data":@[
        @{@"name":@"书架排序",@"isArrow":@1,@"target":@1},
        @{@"name":@"小说书架同步",@"isArrow":@1,@"needLogin":@1,@"target":@2},
        @{@"name":@"清理网络缓存",@"content":netCache,@"isArrow":@1,@"target":@3},
        @{@"name":@"清理书籍缓存",@"content":booksCache,@"isArrow":@1,@"target":@4,@"vc":DBClearBooksCache}]};
    if (DBCommonConfig.switchAudit){
        data2 = @{@"title":@"通用设置",@"data":@[
            @{@"name":@"清理网络缓存",@"content":netCache,@"isArrow":@1,@"target":@3},
            @{@"name":@"清理书籍缓存",@"content":booksCache,@"isArrow":@1,@"target":@4,@"vc":DBClearBooksCache}]};
    }
    NSDictionary *data3 = @{@"title":@"用户设置",@"data":@[
        @{@"name":@"多语言",@"isArrow":@1,@"vc":DBMuteLanguage},
        @{@"name":@"修改登录密码",@"isArrow":@1,@"vc":DBResetPassword},
        @{@"name":@"账号注销",@"isArrow":@1,@"vc":DBAccountCancel},
        @{@"name":@"退出登录",@"isArrow":@1}]};
    if (DBCommonConfig.userDataInfo.account.isEmail){
        data3 = @{@"title":@"用户设置",@"data":@[
            @{@"name":@"多语言",@"isArrow":@1,@"vc":DBMuteLanguage},
            @{@"name":@"修改登录密码",@"isArrow":@1,@"vc":DBResetPassword},
            @{@"name":@"退出登录",@"isArrow":@1}]};
    }
    [dataList addObject:data1];
    [dataList addObject:data2];
    if (DBCommonConfig.isLogin) [dataList addObject:data3];
    return [NSArray yy_modelArrayWithClass:self.class json:dataList];
}

+ (NSArray *)dataSourceList2{
    NSArray *data = @[@{@"name":@"修改登录密码",@"isArrow":@1,@"vc":DBResetPassword},
                            @{@"name":@"账号注销",@"isArrow":@1,@"vc":DBAccountCancel},
                            @{@"name":@"退出登录",@"isArrow":@1}
    ];
    return [NSArray yy_modelArrayWithClass:DBMySettingModel.class json:data];
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        @"data" : DBMySettingModel.class,
    };
}

@end
