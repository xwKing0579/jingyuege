//
//  DBActivityEntranceView.h
//  DeepBooks
//
//  Created by king on 2025/8/14.
//

#import <UIKit/UIKit.h>
#import "DBUserActivityModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBActivityEntranceView : UIView
@property (nonatomic, copy) NSString *activityText;
@property (nonatomic, copy) NSString *bookID;
@property (nonatomic, copy) void (^didRewardBlock)(NSInteger freeSeconds);
@end

NS_ASSUME_NONNULL_END
