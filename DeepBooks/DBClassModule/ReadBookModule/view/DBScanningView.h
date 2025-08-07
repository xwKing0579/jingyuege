//
//  DBScanningView.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^DBScanCompletionBlock)(void); // 定义回调 Block
@interface DBScanningView : UIView
@property (nonatomic, strong) UIView *targetView; // 要扫描的目标视图
@property (nonatomic, assign, readonly) CGFloat scanProgress; // 扫描进度 (0.0 到 1.0)
@property (nonatomic, assign) BOOL isAutoScanning; // 是否正在自动扫描
@property (nonatomic, copy) DBScanCompletionBlock scanCompletionBlock; // 当前页扫描完成回调
@property (nonatomic, copy) DBScanCompletionBlock scanFinishBlock; //扫描页移除回调

@property (nonatomic, strong) UIView *nextPageContentView;

- (void)startAutoScan; // 开始自动扫描
- (void)stopAutoScan;  // 停止自动扫描
@end

NS_ASSUME_NONNULL_END
