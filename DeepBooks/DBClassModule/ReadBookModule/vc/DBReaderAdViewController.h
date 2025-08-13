//
//  DBReaderAdViewController.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/7.
//

#import <UIKit/UIKit.h>
#import "DBReaderAdViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBReaderAdViewController : UIViewController
@property (nonatomic, assign) DBReaderAdType readerAdType;
@property (nonatomic, assign) BOOL after;
@property (nonatomic, strong) DBReaderModel *model;
@end

NS_ASSUME_NONNULL_END
