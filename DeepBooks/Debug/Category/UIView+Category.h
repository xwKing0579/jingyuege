//
//  UIView+Category.h
//  OCProject
//
//  Created by 王祥伟 on 2023/12/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Category)
@property (nonatomic, assign) CGFloat bf_x;
@property (nonatomic, assign) CGFloat bf_y;
@property (nonatomic, assign) CGFloat bf_width;
@property (nonatomic, assign) CGFloat bf_height;
@property (nonatomic, assign) CGPoint bf_origin;
@property (nonatomic, assign) CGSize  bf_size;

- (void)bf_addSubviews:(NSArray *)views;
- (void)bf_removeAllSubView;
- (void)bf_removeAllSubViewExcept:(NSArray *)views;

//所有子视图
- (NSArray *)bf_allSubViews;

- (UIImage *)bf_toImage;


@end

NS_ASSUME_NONNULL_END
