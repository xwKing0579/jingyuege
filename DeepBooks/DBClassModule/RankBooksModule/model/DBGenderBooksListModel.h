//
//  DBGenderBooksListModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/2.
//

#import <Foundation/Foundation.h>
#import "DBBooksDataModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBGenderBooksListModel : NSObject
@property (nonatomic, strong) NSArray <DBBooksDataModel *> *dataList;
@end

NS_ASSUME_NONNULL_END
