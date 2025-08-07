//
//  DEBookCommentListModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/2.
//

#import <Foundation/Foundation.h>
#import "DBBookCommentModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DEBookCommentListModel : NSObject
@property (nonatomic, strong) NSArray <DBBookCommentModel *> *lists;
@property (nonatomic, assign) NSInteger limit;
@end



NS_ASSUME_NONNULL_END
