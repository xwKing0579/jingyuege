//
//  DBAdServerDataModel.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/5/20.
//

#import "DBAdServerDataModel.h"

@implementation DBAdServerDataModel


+ (void)loadAdServerData{

    if (DBUnityAdConfig.adConfigModel){
        [DBUnityAdConfig.manager initAdConfig];
        [DBAFNetWorking postServiceRequestType:DBLinkBaseAdConfig combine:nil parameInterface:nil modelClass:DBAdServerDataModel.class serviceData:^(BOOL successfulRequest, DBAdServerDataModel *result, NSString * _Nullable message) {
            if (successfulRequest){
                [result reloadAdConfig];
            }
        }];
    }else{
        [DBAFNetWorking postServiceRequestType:DBLinkBaseAdConfig combine:nil parameInterface:nil modelClass:DBAdServerDataModel.class serviceData:^(BOOL successfulRequest, DBAdServerDataModel *result, NSString * _Nullable message) {
            if (successfulRequest){
                [result reloadAdConfig];
                [DBUnityAdConfig.manager initAdConfig];
            }
        }];
    }
}

- (void)reloadAdConfig{
    [NSUserDefaults saveValue:self.modelToJSONString forKey:DBAdServerDataValue];
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        @"novice" : DBAdNoviceModel.class,
        @"ad_pos" : DBAdPosModel.class,
        @"platform" : DBAdPlatformModel.class,
    };
}



@end

 

@implementation DBAdNoviceModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"switchOn":@"switch"};
}

@end

@implementation DBAdPosModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        @"ads" : DBAdsModel.class,
        @"extra" : DBAdExtra.class,
    };
}

@end

@implementation DBAdPlatformModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        @"gm" : DBThirdAdModel.class,
        @"gdt" : DBThirdAdModel.class,
        @"mg" : DBThirdAdModel.class
    };
}

@end

@implementation DBThirdAdModel



@end

@implementation DBAdsModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        @"selfAd" : DBSelfAdModel.class,
    };
}

@end

@implementation DBAdExtra
@end

@implementation DBSelfAdModel

- (instancetype)init{
    if (self == [super init]){
        self.adSize = CGSizeZero;
        self.muted = NO;
    }
    return self;
}

- (NSString *)image{
    if (_image.length > 0 && ![_image hasPrefix:@"http"]) return [DBLinkManager combineLinkWithType:DBLinkIconResUrl combine:_image];
    return _image;
}

- (NSString *)video{
    if (_video.length > 0 && ![_video hasPrefix:@"http"]) return [DBLinkManager combineLinkWithType:DBLinkIconResUrl combine:_video];
    return _video;
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        @"grid" : NSArray.class,
        @"grid.firstObject" : [DBSelfAdModel class] ?: [NSNull class]
    };
}

@end
