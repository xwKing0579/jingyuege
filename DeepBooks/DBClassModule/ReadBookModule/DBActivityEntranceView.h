//
//  DBActivityEntranceView.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/8/14.
//

#import <UIKit/UIKit.h>
#import "DBUserActivityModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBActivityEntranceView : UIView
@property (nonatomic, copy) NSString *activityText;
@property (nonatomic, copy) DBUserActivityModel *activityModel;
@property (nonatomic, copy) void (^didRewardBlock)(NSInteger freeSeconds);
@end

NS_ASSUME_NONNULL_END
