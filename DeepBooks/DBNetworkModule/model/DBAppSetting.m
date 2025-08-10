//
//  DBAppSetting.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/21.
//

#import "DBAppSetting.h"
NSString *const kDBAppSetting = @"kDBAppSetting";
@implementation DBAppSetting

+ (DBAppSetting *)setting{
    NSString *result = [NSUserDefaults takeValueForKey:kDBAppSetting];
    if (result) {
        DBAppSetting *model = [DBAppSetting modelWithJSON:result];
        return model;
    }
    
    DBAppSetting *setting = DBAppSetting.new;
    NSInteger interval = NSDate.currentInterval;
    setting.launchTimeStamp = interval;
    setting.currentLaunchTimeStamp = interval;
    setting.isNewbie = YES;
    setting.isOn = YES;
    setting.star = DBAppStarModel.new;
    return setting;
}

- (void)reloadSetting{
    [NSUserDefaults saveValue:self.modelToJSONString forKey:kDBAppSetting];
}

+ (void)updateLaunchTime{
    DBAppSetting *setting = DBAppSetting.setting;
    setting.currentLaunchTimeStamp = NSDate.currentInterval;
    [setting reloadSetting];
}

+ (NSString *)languageAbbrev{
    NSString *abbrev = [NSUserDefaults takeValueForKey:DBLocalLanguageValue];
    if (abbrev) return abbrev;
    
    NSString *language = NSLocale.preferredLanguages.firstObject;
    if ([language containsString:@"zh-Hans"]){
        abbrev = @"zh-Hans";
    }else if ([language containsString:@"zh-Hant"]){
        abbrev = @"zh-Hant";
    }
    return abbrev?:@"en";
}

@end


@implementation DBAppVersionModel
@end

@implementation DBAppStarModel
@end
