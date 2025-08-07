//
//  DBPageRollingViewController.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/18.
//

#import <UIKit/UIKit.h>
#import "DBReaderModel.h"
#import "DBReaderContentViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBPageRollingViewController : UIViewController
@property (nonatomic, copy) DBReaderModel *model;
@property (nonatomic, strong) DBReaderContentViewModel *readerContentViewModel;
@end

NS_ASSUME_NONNULL_END
