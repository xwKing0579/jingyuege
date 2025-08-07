//
//  DBSearchBooksModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class DBSearchBookDateModel;

@interface DBSearchBooksModel : NSObject
@property (nonatomic, copy) NSString *ltype;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *stype;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *is_search_recommend;
@property (nonatomic, copy) NSString *form;
@property (nonatomic, copy) NSString *chapter_count;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *book_id;
@end

@interface DBSearchBookDateModel : NSObject
@property (nonatomic, strong) NSArray <DBSearchBookDateModel *> *book;
@end

NS_ASSUME_NONNULL_END
