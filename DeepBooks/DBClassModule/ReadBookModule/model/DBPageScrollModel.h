//
//  DBPageScrollModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBPageScrollModel : NSObject
@property (nonatomic, assign) NSInteger chapter;
@property (nonatomic, strong) NSArray *contentList;
@property (nonatomic, assign) BOOL faiure;
@property (nonatomic, strong) NSDictionary *adDict;

@property (nonatomic, assign) NSInteger pageNum;
@end

NS_ASSUME_NONNULL_END
