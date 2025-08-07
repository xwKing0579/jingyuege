//
//  DBWantBookListModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class DBWantBookModel;
@interface DBWantBookListModel : NSObject
@property (nonatomic, strong) NSArray <DBListsModel *> *lists;
@property (nonatomic, assign) NSInteger limit;
@end

@interface DBWantBookModel : NSObject
@property (nonatomic, copy) NSString *book_id;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *form;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *name;
@end
NS_ASSUME_NONNULL_END
