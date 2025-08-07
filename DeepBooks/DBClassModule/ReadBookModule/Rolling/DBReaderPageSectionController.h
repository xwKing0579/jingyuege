//
//  DBReaderPageSectionController.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/15.
//

#import <IGListKit/IGListKit.h>
#import "DBPageIGModel.h"
#import "DBReaderModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBReaderPageSectionController : IGListSectionController
@property (nonatomic, strong) DBPageIGModel *model;
@end

NS_ASSUME_NONNULL_END
