//
//  DBUserModel.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/24.
//

#import "DBUserModel.h"

@implementation DBUserModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"data" : DBUserDataModel.class};
}


+ (void)loginWithParameters:(NSDictionary *)parameInterface completion:(void (^ __nullable)(BOOL success))completion{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameInterface];
    [dict setValue:@"apple" forKey:@"brand"];
    [dict setValue:@"website" forKey:@"channel"];
    [dict setValue:UIDevice.currentDeviceName forKey:@"device"];
    NSString *vercode = [NSString stringWithFormat:@"%d",UIApplication.appVersion.intValue];
    [dict setValue:vercode forKey:@"vercode"];
    [dict setValue:UIApplication.appVersion forKey:@"version"];
    [dict setValue:UIDevice.deviceuuidString forKey:@"serial"];
    
    NSString *tel = [dict valueForKey:@"tel"];
    if (tel.length){
        tel = [tel stringByReplacingOccurrencesOfString:@"+" withString:@""];
        [dict setValue:tel forKey:@"tel"];
    }
    [DBAFNetWorking postServiceRequestType:DBLinkUserSignIn combine:nil parameInterface:dict modelClass:DBUserModel.class serviceData:^(BOOL successfulRequest, DBUserModel *result, NSString * _Nullable message) {
        if (completion) completion(successfulRequest);
        if (successfulRequest){
            //移除本地头像
            [NSUserDefaults removeValueForKey:DBUserAvaterKey];
            if ([parameInterface valueForKey:@"login"]){
                result.account = parameInterface[@"login"];
            }
            if ([parameInterface valueForKey:@"email"]){
                result.account = parameInterface[@"email"];
            }
            [DBCommonConfig updateUserInfo:result];
            if (DBAppSetting.setting.inviteLink.length){
                [DBCommonConfig bindInvitationLink:DBAppSetting.setting.inviteLink completion:nil];
            }
            
            [self getUserVipInfoCompletion:nil];
            
            [DBRouter closePageRoot];
            [NSNotificationCenter.defaultCenter postNotificationName:DBUserLoginSuccess object:nil];
        }else{
            [UIScreen.appWindow showAlertText:message];
        }
    }];
}

+ (void)getUserCenterCompletion:(void (^ __nullable)(BOOL successfulRequest))completion{
    if (!DBCommonConfig.isLogin) {
        if (completion) completion(NO);
        return;
    };
    
    DBUserModel *user = DBCommonConfig.userDataInfo;
    NSDictionary *parameInterface = @{@"time_token":DBSafeString(user.data.ad_token?:user.token)};
    [DBAFNetWorking getServiceRequestType:DBLinkUserInfoCenter combine:nil parameInterface:parameInterface modelClass:DBUserInfoModel.class serviceData:^(BOOL successfulRequest, DBUserInfoModel *result, NSString * _Nullable message) {
        if (successfulRequest){
            [NSUserDefaults saveValue:result.modelToJSONString forKey:DBUserAdInfoValue];
        }
        if (completion) completion(successfulRequest);
    }];
}

+ (void)getUserInviteCompletion:(void (^ __nullable)(BOOL successfulRequest, DBUserInviteCodeModel *model))completion{
    [DBAFNetWorking postServiceRequestType:DBLinkUserInviteCode combine:nil parameInterface:nil modelClass:DBUserInviteCodeModel.class serviceData:^(BOOL successfulRequest, id  _Nullable result, NSString * _Nullable message) {
        if (completion) completion(successfulRequest, result);
    }];
}

+ (void)getUserVipInfoCompletion:(void (^ __nullable)(BOOL successfulRequest, DBUserVipModel *model))completion{
    [DBAFNetWorking postServiceRequestType:DBLinkUserVipInfo combine:nil parameInterface:nil modelClass:DBUserVipModel.class serviceData:^(BOOL successfulRequest, DBUserVipModel *result, NSString * _Nullable message) {
        if (successfulRequest){
            [NSUserDefaults saveValue:result.modelToJSONString forKey:DBUserVipInfoValue];
        }
        if (completion) completion(successfulRequest, result);
    }];
}

@end


@implementation DBUserDataModel
@end

@implementation DBUserInfoModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"ad" : DBUserAdModel.class};
}
@end

@implementation DBUserAdModel
@end

@implementation DBUserInviteCodeModel
@end

@implementation DBUserVipModel
@end
