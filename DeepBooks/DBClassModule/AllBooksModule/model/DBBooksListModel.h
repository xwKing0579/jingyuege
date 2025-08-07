//
//  DBBooksListModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/1.
//

#import <Foundation/Foundation.h>
@class DBBooksModel;
NS_ASSUME_NONNULL_BEGIN

@interface DBBooksListModel : NSObject

@property (nonatomic, copy) NSString *book_count;
@property (nonatomic, copy) NSString *fav_count;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, strong) NSArray <DBBooksModel *> *books;
@property (nonatomic, copy) NSString *list_id;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *title;

@end

@interface DBBooksModel : NSObject
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *book_id;
@property (nonatomic, copy) NSString *fav_count;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *form;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *ltype;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *stype;
@end

NS_ASSUME_NONNULL_END
