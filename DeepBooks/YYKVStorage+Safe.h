//
//  YYKVStorage+Safe.h
//  FXTP
//
//  Created by 王祥伟 on 2024/10/21.
//

#import "YYKVStorage.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYKVStorage (Safe)
@property (nonatomic, readonly) NSString *path;
@property (nonatomic, readonly) YYKVStorageType type;
@property (nonatomic) BOOL errorLogsEnabled; 
@end

NS_ASSUME_NONNULL_END
