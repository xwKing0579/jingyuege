//
//  DBUserSettingModel.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/25.
//

#import "DBUserSettingModel.h"

@implementation DBUserSettingModel

+ (NSArray *)dataSourceList{
    NSString *avater = @"jjMirageDouble";
    if (DBCommonConfig.userDataInfo.avatar.length > 0){
        avater = [DBLinkManager combineLinkWithType:DBLinkHeaderAvatarUrl combine:DBCommonConfig.userDataInfo.avatar];
    }
 
    id imageData = [NSUserDefaults takeValueForKey:DBUserAvaterKey];
    
    NSArray *dataList = @[@{@"title":DBConstantString.ks_avatar,@"avater":imageData?:avater,@"isArrow":@1},
                          @{@"title":DBConstantString.ks_username,@"content":DBSafeString(DBCommonConfig.userDataInfo.phone),@"isArrow":@0},
                          @{@"title":DBConstantString.ks_nickname,@"content":DBSafeString(DBCommonConfig.userDataInfo.nick),@"isArrow":@1}];
    return [NSArray yy_modelArrayWithClass:self.class json:dataList];
}

@end
