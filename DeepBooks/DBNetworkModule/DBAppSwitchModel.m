//
//  DBAppSwitchModel.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/29.
//

#import "DBAppSwitchModel.h"
#import "DBKeywordModel.h"
#import "DBDomainModel.h"
#import "DBDecryptManager.h"
#import "DBIpAddressModel.h"
@implementation DBAppSwitchModel

+ (void)getDomainLinkTest:(BOOL)test completion:(void (^ __nullable)(BOOL success))completion{
    
    NSArray *requestList = DOMAINJSONLIST;
    if (test){
        requestList = @[@"https://www.a.appwan.info/test.html"];
    }
    [self traverseAllInterfaces:requestList index:0 completion:completion];
}

+ (void)traverseAllInterfaces:(NSArray *)interfaces index:(NSInteger)index completion:(void (^ __nullable)(BOOL success))completion{
    
    if (index >= interfaces.count) {
        if (completion) completion(NO);
        return;
    }
    
    NSString *interfaceString = interfaces[index];
    if ([interfaceString hasSuffix:@"type=txt"]){
        [DBAFNetWorking downloadServiceRequest:interfaceString fileName:@"domainInfo" modelClass:DBDomainModel.class serviceData:^(BOOL successfulRequest, DBDomainModel *result, NSString * _Nullable message) {
            if (successfulRequest){
                [self interfaceHandle:result completion:^(BOOL success) {
                    if (successfulRequest){
                        if (completion) completion(YES);
                    }else{
                        [self traverseAllInterfaces:interfaces index:index+1 completion:completion];
                    }
                }];
            }else{
                [self traverseAllInterfaces:interfaces index:index+1 completion:completion];
            }
        }];
    }else if ([interfaceString isEqualToString:@"https://www.a.appwan.info/test.html"]){
        [DBBaseAlamofire getWithPath:interfaceString parameInterface:nil responseBlock:^(BOOL success, NSData *result, NSError * _Nullable error) {
            if (success){
                NSString *asciiString = [[NSString alloc] initWithData:result encoding:NSASCIIStringEncoding];
                DBBaseAlamofire.domainString = asciiString;
                if (completion) completion(YES);
            }else{
                [self traverseAllInterfaces:interfaces index:index+1 completion:completion];
            }
        }];
    }else{
        [DBAFNetWorking getServiceRequest:interfaceString parameInterface:nil modelClass:DBDomainModel.class serviceData:^(BOOL successfulRequest, DBDomainModel *result, NSString * _Nullable message) {
            if (successfulRequest){
                [self interfaceHandle:result completion:^(BOOL success) {
                    if (successfulRequest){
                        if (completion) completion(YES);
                    }else{
                        [self traverseAllInterfaces:interfaces index:index+1 completion:completion];
                    }
                }];
            }else{
                [self traverseAllInterfaces:interfaces index:index+1 completion:completion];
            }
        }];
    }
}


+ (void)interfaceHandle:(DBDomainModel *)result completion:(void (^ __nullable)(BOOL success))completion{
    NSString *content = result.Answer.firstObject.data;
    content = [content stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    NSString *domainString = [DBDecryptManager decryptText:content ver:1];
    domainString = [domainString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if (domainString.length == 0){
        if (completion) completion(NO);
        return;
    }
    DBBaseAlamofire.domainString = domainString;
    
    [self getApiStateCompletion:^(BOOL enable) {
        if (completion) completion(enable);
    }];
}

+ (void)getApiStateCompletion:(void (^ __nullable)(BOOL enable))completion{
    [DBAFNetWorking getServiceRequestType:DBLinkStateConfig combine:nil parameInterface:nil serviceData:^(BOOL successfulRequest, id  _Nullable result, NSString * _Nullable message) {
        NSInteger code = [result[@"code"] intValue];
        if (completion) completion(code == 1);
    }];
}

+ (void)getAppSwitchCompletion:(void (^ __nullable)(BOOL success))completion{
    //口令开启
    BOOL shareSwitch = [NSUserDefaults takeValueForKey:DBBooksSwitchValue];
    if (shareSwitch) {
        completion(NO);
        return;
    }
    
    //时间超6h
    double firstInstalTimeStamp = UIDevice.firstInstallationTime;
    if (firstInstalTimeStamp > 0 && NSDate.date.timeIntervalSince1970 - firstInstalTimeStamp > 3600*6){
        completion(NO);
        return;
    }
    
    AppDelegate *appDelegate = (AppDelegate *)UIApplication.sharedApplication.delegate;
    if (appDelegate.isVSConnection) {
        completion(YES);
        return;
    }
    
    [DBAFNetWorking postServiceRequestType:DBLinkAppSwitch combine:nil parameInterface:nil serviceData:^(BOOL successfulRequest, id result, NSString * _Nullable message) {
        DBKeywordModel *model = [DBKeywordModel yy_modelWithJSON:result];
        if (model.fttg.length){
            [NSUserDefaults saveValue:model.fttg forKey:DBAppSwitchValue];
            [UIDevice saveFirstInstallationTime];
        }
        if (completion) completion(successfulRequest);
    }];
}

+ (void)getAppSwitchWithInvitationCode:(NSString *)code{
    if (DBCommonConfig.switchAudit) {
        [DBAFNetWorking postServiceRequestType:DBLinkInviteCode combine:nil parameInterface:@{@"code":DBSafeString(code),@"deviceToken":DBSafeString(DBAppSetting.setting.deviceCheck)} serviceData:^(BOOL successfulRequest, id result, NSString * _Nullable message) {
            DBKeywordModel *model = [DBKeywordModel yy_modelWithJSON:result];
            if (model.fttg.length){
                DBAppSetting *setting = DBAppSetting.setting;
                setting.inviteLink = [NSString stringWithFormat:@"?invite_code=%@",code];
                [setting reloadSetting];
                [DBCommonConfig cutUserSide];
            }
        }];
    }else{
        if (!DBCommonConfig.isLogin) {
            [DBCommonConfig toLogin];
            return;
        }
        
        [DBAFNetWorking postServiceRequestType:DBLinkUserInviteBind combine:nil parameInterface:@{@"code":DBSafeString(code),@"deviceToken":DBSafeString(DBAppSetting.setting.deviceCheck)} serviceData:^(BOOL successfulRequest, id  _Nullable result, NSString * _Nullable message) {
            if (successfulRequest){
                DBUserInfoModel *userInfo = DBCommonConfig.userCurrentInfo;
                userInfo.master_user_id = code;
                [NSUserDefaults saveValue:userInfo.yy_modelToJSONString forKey:DBUserAdInfoValue];
            }
            [UIScreen.appWindow showAlertText:message];
        }];
    }
}

+ (void)getAppSwitchWithPassword:(NSString *)password{
    [DBAFNetWorking postServiceRequestType:DBLinkBaseKeyword combine:DBSafeString(password) parameInterface:@{@"deviceToken":DBSafeString(DBAppSetting.setting.deviceCheck)} serviceData:^(BOOL successfulRequest, id  _Nullable result, NSString * _Nullable message) {
        DBKeywordModel *model = [DBKeywordModel yy_modelWithJSON:result];
        if (model.fttg.length){
            [DBCommonConfig cutUserSide];
        }
    }];
}

+ (void)getNetSafetyProvidePlan:(void (^ __nullable)(BOOL success))completion{
    NSDictionary *ipValues = [NSUserDefaults takeValueForKey:DBDomainIpMapValue];
    if (ipValues.allKeys.count){
        DBBaseAlamofire.ipAddressMap = ipValues;
        if (completion) completion(YES);
    }
    
    [DBAFNetWorking downloadServiceRequest:IPCONNECTION fileName:@"domainPlanB" modelClass:DBDomainModel.class serviceData:^(BOOL successfulRequest, DBDomainModel *result, NSString * _Nullable message) {
        if (successfulRequest){
            NSString *content = result.Answer.firstObject.data;
            content = [content stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            NSString *apiString = [DBDecryptManager decryptText:content ver:1];
            apiString = [apiString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            DBIpAddressModel *ipModel = [DBIpAddressModel yy_modelWithJSON:apiString];
            NSMutableDictionary *ipDict = [NSMutableDictionary dictionary];
            for (DBIpAddressMapModel *mapModel in ipModel.ip_map) {
                NSString *key = [NSString stringWithFormat:@"https://%@.%@",mapModel.domain,DBBaseAlamofire.domainString];
                NSMutableArray *temp = [NSMutableArray array];
                for (NSString *ipStr in mapModel.ip) {
                    [temp addObject:[NSString stringWithFormat:@"http://%@",ipStr]];
                }
                [ipDict setValue:temp forKey:key];
            }
            DBBaseAlamofire.ipAddressMap = ipDict;
            if (ipDict) [NSUserDefaults saveValue:ipDict forKey:DBDomainIpMapValue];
        }
        if (completion && !ipValues.allKeys.count) completion(successfulRequest);
    }];
}

@end
