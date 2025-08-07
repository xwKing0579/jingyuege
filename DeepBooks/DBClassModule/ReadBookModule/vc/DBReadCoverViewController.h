//
//  DBReadCoverViewController.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/6/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class DBReadCoverViewController;
@protocol DBReadCoverViewControllerDelegate <NSObject>

- (void)coverController:(DBReadCoverViewController * _Nonnull)coverController currentController:(UIViewController * _Nullable)currentController finish:(BOOL)isFinish;


- (UIViewController * _Nullable)coverController:(DBReadCoverViewController * _Nonnull)coverController getAboveControllerWithCurrentController:(UIViewController * _Nullable)currentController;


- (UIViewController * _Nullable)coverController:(DBReadCoverViewController * _Nonnull)coverController getBelowControllerWithCurrentController:(UIViewController * _Nullable)currentController;

@end

@interface DBReadCoverViewController : UIViewController

@property (nonatomic,weak,nullable) id<DBReadCoverViewControllerDelegate> delegate;
@property (nonatomic,strong, nullable) UIViewController *currentController;

- (void)setController:(UIViewController * _Nullable)controller;

@end

NS_ASSUME_NONNULL_END
