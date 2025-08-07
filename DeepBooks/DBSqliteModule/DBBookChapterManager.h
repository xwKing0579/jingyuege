//
//  DBBookChapterManager.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/28.
//

#import "DBSQLManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBBookChapterManager : DBSQLManager

+ (NSUInteger)getDataFileSize;
+ (BOOL)removeBookCacheFiles;

@end

NS_ASSUME_NONNULL_END
