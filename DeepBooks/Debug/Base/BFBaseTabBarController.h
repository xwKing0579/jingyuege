//
//  BFBaseTabBarController.h
//  OCProject
//
//  Created by 王祥伟 on 2023/12/5.
//

#import <UIKit/UIKit.h>
#import "UIFont+Category.h"
#import "UIColor+Category.h"
#import "UIImage+Category.h"
NS_ASSUME_NONNULL_BEGIN

@interface BFBaseTabBarController : UITabBarController

- (void)setUpViewControllersInNavClass:(Class)navClass
                             rootClass:(Class)rootClass
                            tabBarName:(NSString *)name
                       tabBarImageName:(NSString *)imageName;

- (void)setUpViewControllersInNavClass:(Class)navClass
                             rootClass:(Class)rootClass
                            tabBarName:(NSString *)name
                       tabBarImageName:(NSString *)imageName
                                  size:(UIFont *)size
                                 color:(UIColor *)color
                              selColor:(UIColor *)selColor;

@end

NS_ASSUME_NONNULL_END
