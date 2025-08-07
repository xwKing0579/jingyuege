//
//  DBMyBookListModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class DBBookIdsListModel,DBBookIdModel;
@interface DBMyBookListModel : NSObject

@end


@interface DBBookIdsListModel : NSObject
@property (nonatomic, assign) NSInteger limit;
@property (nonatomic, strong) NSArray <DBBookIdModel *>*lists;
@end

@interface DBBookIdModel : NSObject
@property (nonatomic, copy) NSString *list_id;
@end

NS_ASSUME_NONNULL_END
