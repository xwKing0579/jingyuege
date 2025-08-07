//
//  DBAdBase.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/23.
//

#import "DBAdBase.h"

static char kAdTrackModelKey;
static char kSplashAdSpaceTypeKey;
static char kAdTimeIntervalKey;

@implementation NSObject (DBSpaceType)

- (void)setAdTrackModel:(DBAdsModel *)adTrackModel{
    objc_setAssociatedObject(self, &kAdTrackModelKey, adTrackModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (DBAdsModel *)adTrackModel{
    return objc_getAssociatedObject(self, &kAdTrackModelKey);
}

- (void)setSpaceType:(DBAdSpaceType)spaceType{
    objc_setAssociatedObject(self, &kSplashAdSpaceTypeKey, @(spaceType), OBJC_ASSOCIATION_ASSIGN);
}

- (DBAdSpaceType)spaceType{
    return [objc_getAssociatedObject(self, &kSplashAdSpaceTypeKey) intValue];
}

- (void)setTimeInterval:(NSInteger)timeInterval{
    objc_setAssociatedObject(self, &kAdTimeIntervalKey, @(timeInterval), OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)timeInterval{
    return [objc_getAssociatedObject(self, &kAdTimeIntervalKey) intValue];;
}

@end

@implementation DBAdBase

- (NSMutableDictionary *)adLoadersDict{
    if (!_adLoadersDict){
        _adLoadersDict = [NSMutableDictionary dictionary];
    }
    return _adLoadersDict;
}

- (NSMutableDictionary *)adViewsDict{
    if (!_adViewsDict){
        _adViewsDict = [NSMutableDictionary dictionary];
    }
    return _adViewsDict;
}

- (NSMutableDictionary *)adCompleteDict{
    if (!_adCompleteDict){
        _adCompleteDict = [NSMutableDictionary dictionary];
    }
    return _adCompleteDict;
}

@end
