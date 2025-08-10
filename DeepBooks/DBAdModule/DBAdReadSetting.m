//
//  DBAdReadSetting.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/5/24.
//

#import "DBAdReadSetting.h"

NSString *const kDBAdReadSetting = @"kDBAdReadSetting";
@implementation DBAdReadSetting

- (instancetype)init{
    if (self == [super init]){
        self.addBookshelfCount = 0;
        self.seekingBookCount = 0;
        self.cacheChapterCount = 0;
        self.listenBookCount = 0;
        self.isFreeListenBook = NO;
        self.todayString = NSDate.now.dateToTimeString;
    }
    return self;
}


+ (DBAdReadSetting *)setting{
    NSString *result = [NSUserDefaults takeValueForKey:kDBAdReadSetting];
    if (result) {
        NSString *today = NSDate.now.dateToTimeString;
        DBAdReadSetting *model = [DBAdReadSetting modelWithJSON:result];
        if ([model.todayString isEqualToString:today]){
            return model;
        }
    }
    return DBAdReadSetting.new;
}

- (void)reloadSetting{
    [NSUserDefaults saveValue:self.modelToJSONString forKey:kDBAdReadSetting];
}

@end
