//
//  DBAdReadSetting.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/5/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBAdReadSetting : NSObject

@property (nonatomic, copy) NSString *todayString;
@property (nonatomic, assign) NSInteger addBookshelfCount;
@property (nonatomic, assign) NSInteger seekingBookCount;
@property (nonatomic, assign) NSInteger cacheChapterCount;
@property (nonatomic, assign) NSInteger listenBookCount;
@property (nonatomic, assign) BOOL isFreeListenBook;
@property (nonatomic, assign) BOOL isFreeCacheBook;
@property (nonatomic, assign) BOOL isFreeRequestBook;

+ (DBAdReadSetting *)setting;
- (void)reloadSetting;

@end


NS_ASSUME_NONNULL_END
