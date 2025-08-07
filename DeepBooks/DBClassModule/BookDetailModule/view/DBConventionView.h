//
//  DBConventionView.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBConventionView : UIView
+ (void)conventionViewCompletion:(void (^ __nullable)(BOOL finished))completion;
@end

NS_ASSUME_NONNULL_END
