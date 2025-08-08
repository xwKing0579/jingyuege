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
    
    NSArray *dataList = @[@{@"title":@"头像",@"avater":imageData?:avater,@"isArrow":@1},
                          @{@"title":@"用户名",@"content":DBSafeString(DBCommonConfig.userDataInfo.phone),@"isArrow":@0},
                          @{@"title":@"昵称",@"content":DBSafeString(DBCommonConfig.userDataInfo.nick),@"isArrow":@1}];
    return [NSArray yy_modelArrayWithClass:self.class json:dataList];
}

@end
