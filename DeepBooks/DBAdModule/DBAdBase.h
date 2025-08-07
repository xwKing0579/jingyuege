//
//  DBAdBase.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/23.
//

#import <Foundation/Foundation.h>
#import <MSaas/MSaas.h>
#import "DBSelfAdConfig.h"

NS_ASSUME_NONNULL_BEGIN



#define kAd_gm_key   @"gm"
#define kAd_gdt_key  @"gdt"
#define kAd_mg_key   @"mg"
#define kAd_self_key @"self"



typedef BOOL (^AdObjectBlock)( NSObject * _Nullable adObject);
typedef BOOL (^AdViewsBlock)( NSArray <UIView *>* _Nullable adContainerView);

@interface NSObject (DBSpaceType)

@property (nonatomic, strong) DBAdsModel *adTrackModel;
@property (nonatomic, assign) DBAdSpaceType spaceType;
@property (nonatomic, assign) NSInteger timeInterval;
@end

@interface DBAdBase : NSObject

@property (nonatomic, strong) NSMutableDictionary *adLoadersDict;
@property (nonatomic, strong) NSMutableDictionary *adViewsDict;
@property (nonatomic, strong) NSMutableDictionary *adCompleteDict;

@end


NS_ASSUME_NONNULL_END
