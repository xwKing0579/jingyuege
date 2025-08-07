//
//  DBBookDetailModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/2.
//

#import <Foundation/Foundation.h>
#import "DBBooksDataModel.h"
#import "DBBookModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBBookDetailModel : DBBookModel

@property (nonatomic, copy) NSString *remark;
@property (nonatomic, assign) NSInteger comment_number;
@property (nonatomic, copy) NSString *stype;


@property (nonatomic, assign) NSInteger fav_count;
@property (nonatomic, assign) NSInteger form;
@property (nonatomic, assign) NSInteger view_count;

@property (nonatomic, assign) NSInteger last_crawler_book_id;


@property (nonatomic, copy) NSString *is_related;
@property (nonatomic, copy) NSString *score_number;
@property (nonatomic, copy) NSString *source_count;
@property (nonatomic, assign) NSInteger sex;


@property (nonatomic, strong) NSArray <DBBooksDataModel *> *author_book;
@property (nonatomic, strong) NSArray <DBBooksDataModel *> *relevant_book;

@property (nonatomic, assign) NSInteger numberOfLines;

//屏蔽
@property (nonatomic, strong) NSArray *shield_data;
@end

@interface DBBookDetailCustomModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray <DBBooksDataModel *> *bookList;

@end
NS_ASSUME_NONNULL_END
