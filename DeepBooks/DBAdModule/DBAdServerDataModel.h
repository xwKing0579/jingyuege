//
//  DBAdServerDataModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/5/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class DBAdNoviceModel,DBAdPosModel,DBAdPlatformModel,DBThirdAdModel,DBAdsModel,DBSelfAdModel,DBAdExtra;

@interface DBAdServerDataModel : NSObject

@property (nonatomic, strong) DBAdNoviceModel *novice;
@property (nonatomic, strong) NSArray <DBAdPosModel *> *ad_pos;
@property (nonatomic, copy) NSString *trackDomain;
@property (nonatomic, strong) DBAdPlatformModel *platform;

+ (void)loadAdServerData;
- (void)reloadAdConfig;

@end

@interface DBAdNoviceModel : NSObject

@property (nonatomic, assign) NSInteger time;
@property (nonatomic, assign) NSInteger days;
@property (nonatomic, assign) BOOL switchOn;
@property (nonatomic, assign) NSInteger count;

@end

@interface DBAdPosModel : NSObject

@property (nonatomic, strong) NSArray <DBAdsModel *> *ads;
@property (nonatomic, copy) NSString *position;
@property (nonatomic, strong) DBAdExtra *extra;

@end

@interface DBAdPlatformModel : NSObject

@property (nonatomic, strong) DBThirdAdModel *gm;
@property (nonatomic, strong) DBThirdAdModel *gdt;
@property (nonatomic, strong) DBThirdAdModel *mg;
@end

@interface DBThirdAdModel : NSObject
@property (nonatomic, copy) NSString *appid;
@end


@interface DBAdsModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *platform;
@property (nonatomic, strong) DBSelfAdModel *selfAd;
@property (nonatomic, copy) NSString *position;

@end

@interface DBAdExtra : NSObject
@property (nonatomic, assign) NSInteger free_count;
@property (nonatomic, assign) NSInteger limit;
@property (nonatomic, assign) NSInteger interval;
@end

@interface DBSelfAdModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, assign) NSInteger remarks;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *video;
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, assign) NSInteger close_sec;
@property (nonatomic, assign) NSInteger reward_sec;
@property (nonatomic, strong) NSArray <NSArray <DBSelfAdModel *> *> *grid;

@property (nonatomic, assign) BOOL hiddenCloseAd;
@property (nonatomic, assign) BOOL muted;

@property (nonatomic, assign) CGSize adSize;

@end
NS_ASSUME_NONNULL_END
