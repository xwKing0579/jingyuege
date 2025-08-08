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
    NSArray *dataList = @[@{@"name":@"我要分享",@"icon":@"jjVaultOne",@"needLogin":@"1"},
    @{@"name":@"夜间护眼",@"icon":@"jjVaultTwo",@"needLogin":@"0",@"vc":DBMyTheme},
                          @{@"name":@"阅读历史",@"icon":@"jjVaultThree",@"needLogin":@"0",@"vc":DBReadRecord},
                          @{@"name":@"我的求书",@"icon":@"jjVaultFour",@"needLogin":@"1",@"vc":DBWantBooks,@"unreadCount":@(useInfo.asking_book_number)},
                          @{@"name":@"意见反馈",@"icon":@"jjVaultFive",@"needLogin":@"1",@"vc":DBFeedback,@"unreadCount":@(useInfo.service_appeal_number)},
                          @{@"name":@"收藏书单",@"icon":@"jjVaultSix",@"needLogin":@"1",@"vc":DBMyBookList},
                          @{@"name":@"我的设置",@"icon":@"jjVaultSeven",@"needLogin":@"0",@"vc":DBMySetting},
                          @{@"name":@"关于我们",@"icon":@"jjVaultEight",@"needLogin":@"0",@"vc":DBAboutUs},];
    if (DBCommonConfig.switchAudit){
        dataList = @[
            @{@"name":@"阅读历史",@"icon":@"jjVaultThree",@"needLogin":@"0",@"vc":DBReadRecord},
            @{@"name":@"阅读管理",@"icon":@"jjVaultFour",@"needLogin":@"0",@"vc":DBMyTheme},
            @{@"name":@"书籍管理",@"icon":@"jjVaultSix",@"needLogin":@"0",@"vc":DBMyBooksManager},
            @{@"name":@"五星好评",@"icon":@"jjMasterVault",@"needLogin":@"0"},
            @{@"name":@"关于我们",@"icon":@"jjVaultEight",@"needLogin":@"0",@"vc":DBAboutUs}
        ];
    }
    
    NSMutableArray *dataModelList = [NSMutableArray arrayWithArray:dataList];
    
    NSInteger inviterSwitch = DBCommonConfig.appConfig.force.pay_tips_switch;
    if (inviterSwitch == 0 || inviterSwitch == 100){
     
    }else{
        [dataModelList insertObject: @{@"name":@"绑定邀请码",@"icon":@"jjVaultNine",@"needLogin":@"0"} atIndex:dataList.count-2];
    }
    
    DBContactDataModel *contactModel = DBCommonConfig.appConfig.contact_data;
    if (DBCommonConfig.switchAudit){
        [dataModelList addObject:@{@"name":@"点击联系客服",@"icon":@"jjVaultTen",@"content":EMAILCUSTOMER,@"needLogin":@"0"}];
    }else{
        NSString *link = contactModel.online_service;
        if (link.whitespace.length > 0) {
            [dataModelList addObject:@{@"name":@"点击联系客服",@"icon":@"jjVaultTen",@"content":@"",@"needLogin":@"0"}];
        }else{
            [dataModelList addObject:@{@"name":@"点击联系客服",@"icon":@"jjVaultTen",@"content":DBSafeString(contactModel.email),@"needLogin":@"0"}];
        }
    }
    
   
    return [NSArray yy_modelArrayWithClass:self.class json:dataModelList];
}

+ (NSArray *)myConfigContent{
    DBReadBookSetting *setting = DBReadBookSetting.setting;
    NSString *readTime = [NSString stringWithFormat:@"%.0lf",ceil(setting.readTotalTime/60.0)];
    NSString *collectBooks = [NSString stringWithFormat:@"%ld",DBBookModel.getAllCollectBooks.count];
    NSString *readCount = [NSString stringWithFormat:@"%ld",DBBookModel.getAllReadingBooks.count];
    return @[readTime,collectBooks,readCount];
}

@end
