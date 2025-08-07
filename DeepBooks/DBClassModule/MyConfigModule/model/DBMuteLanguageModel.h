//
//  DBMuteLanguageModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/6/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBMuteLanguageModel : NSObject
@property (nonatomic, copy) NSString *language;
@property (nonatomic, copy) NSString *abbrev;
+ (NSArray *)dataSourceList;

+ (void)saveLanguageAbbrev:(NSString *)abbrev;

@end

NS_ASSUME_NONNULL_END
