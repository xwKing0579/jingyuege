//
//  DBTypeBookModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/23.
//

#import <Foundation/Foundation.h>
@class DBTypeBookListModel;
NS_ASSUME_NONNULL_BEGIN

@interface DBTypeBookModel : NSObject
@property (nonatomic, copy) NSString *form;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *stype;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *ltype;
@property (nonatomic, copy) NSString *words_number;
@property (nonatomic, copy) NSString *book_id;
@end

@interface DBTypeBookListModel : NSObject
@property (nonatomic, strong) NSArray <DBListsModel *> *lists;
@property (nonatomic, assign) NSInteger limit;
@end

NS_ASSUME_NONNULL_END
