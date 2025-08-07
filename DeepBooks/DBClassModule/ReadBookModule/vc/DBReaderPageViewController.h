//
//  DBReaderPageViewController.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/5.
//

#import <UIKit/UIKit.h>
#import "DBReaderModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBReaderPageViewController : UIViewController

@property (nonatomic, copy) DBReaderModel *model;
@property (nonatomic, copy) NSAttributedString *audioText;

@property (nonatomic, assign) NSInteger currentPageIndex;
@property (nonatomic, assign) NSInteger currentChapterIndex;

@end

NS_ASSUME_NONNULL_END
