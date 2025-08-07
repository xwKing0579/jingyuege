//
//  DBAutoScanViewController.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/9.
//

#import <UIKit/UIKit.h>
#import "DBReaderModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBAutoScanViewController : UIViewController
@property (nonatomic, copy) DBReaderModel *model;
@property (nonatomic, copy) void (^finishAutoScanBlock)(void);
@end

NS_ASSUME_NONNULL_END
