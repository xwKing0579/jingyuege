//
//  DBUserVipConfig.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/8/13.
//

#import "DBUserVipConfig.h"
#import "DBActivityPermissionModel.h"
@implementation DBUserVipConfig

+ (BOOL)isUserVip{
    return NO;
}

+ (NSString *)readerButtonContent{
    return DBUserVipConfig.isUserVip ? @"VIP专属书籍" : [NSString stringWithFormat:@"%@阅读",DBCommonConfig.shieldFreeString];
}

+ (UIColor *)readerButtonBgColor{
    return DBUserVipConfig.isUserVip ? DBColorExtension.crowFeatherColor : DBColorExtension.sunsetOrangeColor;
}

+ (UIColor *)readerButtonTextColor{
    return DBUserVipConfig.isUserVip ? DBColorExtension.vipGoldenColor : DBColorExtension.whiteColor;
}

+ (void)checkFreeVipActivityCompletion:(void (^ __nullable)(DBUserActivityModel *activityModel))completion{
    [DBAFNetWorking postServiceRequestType:DBLinkUserActivities combine:@"19" parameInterface:nil modelClass:DBUserActivityModel.class serviceData:^(BOOL successfulRequest, NSArray <DBUserActivityModel *> *result, NSString * _Nullable message) {
        if (successfulRequest){
            DBUserActivityModel *activityModel = result.firstObject;
            NSArray *ids = @[activityModel.idStr];
            NSString *activity_ids = [ids.modelToJSONString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            [DBAFNetWorking postServiceRequestType:DBLinkCheckActivity combine:nil parameInterface:@{@"activity_ids":activity_ids} modelClass:DBActivityPermissionModel.class serviceData:^(BOOL successfulRequest, NSArray <DBActivityPermissionModel *>*result, NSString * _Nullable message) {
                if (successfulRequest && result.firstObject.can_participate){
                    if (completion) completion(activityModel);
                }else{
                    if (completion) completion(nil);
                }
            }];
        }else{
            if (completion) completion(nil);
        }
        
    }];
}

@end
