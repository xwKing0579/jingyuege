//
//  DBServiceModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBServiceModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) id params;

+ (NSArray *)dataSourceList;
@end

NS_ASSUME_NONNULL_END
