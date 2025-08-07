//
//  DBScaningSettingView.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/14.
//

#import <UIKit/UIKit.h>
typedef void (^DBScanContinueBlock)(BOOL finish);
typedef void (^DBScanFinishBlock)(BOOL finish);
NS_ASSUME_NONNULL_BEGIN

@interface DBScaningSettingView : UIView
@property (nonatomic, copy) DBScanContinueBlock scanContinueBlock;
@property (nonatomic, copy) DBScanFinishBlock scanFinishBlock;
- (void)showAnimate;

@end

NS_ASSUME_NONNULL_END
