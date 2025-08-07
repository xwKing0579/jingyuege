//
//  DBTypeBooksListViewController.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/22.
//

#import "DBBaseViewController.h"
#import "DBBookTypesModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBTypeBooksListViewController : DBBaseViewController
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, strong) DBBookTypesGenderModel *typeModel;
@end

NS_ASSUME_NONNULL_END
