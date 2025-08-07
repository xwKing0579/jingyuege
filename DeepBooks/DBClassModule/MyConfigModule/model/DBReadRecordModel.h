//
//  DBReadRecordModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBReadRecordModel : NSObject
@property (nonatomic, strong) NSArray <DBBookModel *> *dataList;
@end

NS_ASSUME_NONNULL_END
