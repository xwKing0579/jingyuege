//
//  DBAuthorBooksModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/2.
//

#import <Foundation/Foundation.h>
#import "DBBookModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBAuthorBooksModel : DBBookModel
@property (nonatomic, assign) NSInteger form;
@property (nonatomic, assign) NSInteger is_search_recommend;

@property (nonatomic, copy) NSString *remark;
@property (nonatomic, assign) NSInteger chapter_count;

@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, copy) NSString *stype;
@end

NS_ASSUME_NONNULL_END
