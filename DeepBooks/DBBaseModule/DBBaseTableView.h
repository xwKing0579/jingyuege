//
//  DBBaseTableView.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBBaseTableView : UITableView<UIGestureRecognizerDelegate>
@property (nonatomic, assign) BOOL multipleGestures;
@end

NS_ASSUME_NONNULL_END
