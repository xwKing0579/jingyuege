//
//  DBProcessBookConfig.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBProcessBookConfig : NSObject

//书籍标签
+ (NSArray *)bookTagList:(DBBookModel *)model;

//状态
+ (NSString *)bookStausSimpleDesc:(NSInteger)status;

@end

NS_ASSUME_NONNULL_END
