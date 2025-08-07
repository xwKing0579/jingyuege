//
//  BFBaseViewController.h
//  OCProject
//
//  Created by 王祥伟 on 2023/12/5.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "UIView+Category.h"
#import "UIFont+Category.h"
#import "UIColor+Category.h"
#import "UIImage+Category.h"
#import "BFRouter.h"
#import "NSString+Category.h"
NS_ASSUME_NONNULL_BEGIN

@interface BFBaseViewController : UIViewController
///通用回调
@property (nonatomic, copy) void (^block)(id obj);

///hidden navbar
- (BOOL)hideNavigationBar;
- (BOOL)disableNavigationBar;

///back
- (void)backViewController;
- (UIColor *)backButtonColor;
- (BOOL)hideBackButton;

@end

NS_ASSUME_NONNULL_END
