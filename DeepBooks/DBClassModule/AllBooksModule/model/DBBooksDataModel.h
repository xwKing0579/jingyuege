//
//  DBBooksDataModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/2.
//

#import <Foundation/Foundation.h>
#import "DBBookModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBBooksDataModel : DBBookModel

@property (nonatomic, copy) NSString *url_path;
@property (nonatomic, copy) NSString *book_list_path;

@property (nonatomic, copy) NSString *list_id;
@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *stype;
@property (nonatomic, assign) NSInteger form;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger book_count;
@property (nonatomic, assign) NSInteger fav_count;
@end

NS_ASSUME_NONNULL_END
