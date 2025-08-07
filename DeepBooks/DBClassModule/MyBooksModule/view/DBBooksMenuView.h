//
//  DBBooksMenuView.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBBooksMenuView : UIView
@property (nonatomic, copy) void (^menuBlock)(NSInteger action);
@end

NS_ASSUME_NONNULL_END
