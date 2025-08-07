//
//  DBAudiobookViewController.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/10.
//

#import <UIKit/UIKit.h>
#import "DBReaderModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBAudiobookViewController : UIViewController
@property (nonatomic, copy) DBReaderModel *model;
@property (nonatomic, copy) void (^finishAudiobookBlock)(void);

- (void)audiobookPausePlayback;
- (void)audiobookContinuePlayback;

@end

NS_ASSUME_NONNULL_END
