//
//  UIView+Category.m
//  OCProject
//
//  Created by 王祥伟 on 2023/12/7.
//

#import "UIView+Category.h"
#import <objc/runtime.h>

@implementation UIView (Category)

- (void)setBf_x:(CGFloat)bf_x{
    CGRect frame = self.frame;
    frame.origin.x = bf_x;
    self.frame = frame;
}

- (CGFloat)bf_x{
    return self.frame.origin.x;
}


- (void)setBf_y:(CGFloat)bf_y{
    CGRect frame = self.frame;
    frame.origin.y = bf_y;
    self.frame = frame;
}

- (CGFloat)bf_y{
    return self.frame.origin.y;
}


- (void)setBf_width:(CGFloat)bf_width{
    CGRect frame = self.frame;
    frame.size.width = bf_width;
    self.frame = frame;
}

- (CGFloat)bf_width{
    return self.frame.size.width;
}

-(void)setBf_height:(CGFloat)bf_height{
    CGRect frame = self.frame;
    frame.size.height = bf_height;
    self.frame = frame;
}


- (CGFloat)bf_height{
    return self.frame.size.height;
}

-(void)setBf_origin:(CGPoint)bf_origin{
    CGRect frame = self.frame;
    frame.origin = bf_origin;
    self.frame = frame;
}


- (CGPoint)origin{
    return self.frame.origin;
}

-(void)setBf_size:(CGSize)bf_size{
    CGRect frame = self.frame;
    frame.size = bf_size;
    self.frame = frame;
}

- (CGSize)bf_size{
    return self.frame.size;
}

- (void)bf_addSubviews:(NSArray *)views{
    for (UIView *subview in views) {
        [self addSubview:subview];
    }
}

- (void)bf_removeAllSubView{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)bf_removeAllSubViewExcept:(NSArray *)views{
    NSArray *arraySubViews = [NSArray arrayWithArray:self.subviews];
    for (UIView *subview in arraySubViews) {
        if (![views containsObject:subview]) {
            [subview removeFromSuperview];
        }
    }
}

- (NSArray *)bf_allSubViews{
    NSMutableArray *allViews = [NSMutableArray arrayWithArray:self.subviews];
    for (UIView *subview in self.subviews) {
        [allViews addObjectsFromArray:subview.bf_allSubViews];
    }
    return allViews;
}

- (UIImage *)bf_toImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

@end
