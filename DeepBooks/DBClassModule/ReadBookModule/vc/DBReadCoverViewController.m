//
//  DBReadCoverViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/6/19.
//



#define kDBAnimateDuration 0.20

#import "DBReadCoverViewController.h"

typedef NS_OPTIONS(NSUInteger, DBPanDirection) {
    DBPanDirectionUnknow     = 0,
    DBPanDirectionleft       = 1,
    DBPanDirectionRight      = 2,
};

@interface DBReadCoverViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic,strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic,strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, assign) CGPoint originalCenter;
@property (nonatomic, assign) CGFloat lastOffsetX;
@property (nonatomic,assign) DBPanDirection panDirection;
@property (nonatomic, strong) NSMutableArray *offsetList;
@property (nonatomic, assign) BOOL haveNearController;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIViewController *oldController;
@end

@implementation DBReadCoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
}

- (void)setUpSubViews{
    self.view.layer.masksToBounds = YES;
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(touchPan:)];
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchTap:)];
    [self.view addGestureRecognizer:self.panGesture];
    [self.view addGestureRecognizer:self.tapGesture];

    self.tapGesture.delegate = self;
}


- (void)touchPan:(UIPanGestureRecognizer *)pan{
    CGPoint touchPoint = [pan locationInView:self.view];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.panDirection = DBPanDirectionUnknow;
        self.originalCenter = touchPoint;
    }else if (pan.state == UIGestureRecognizerStateChanged) {
        if (self.panDirection == DBPanDirectionUnknow){
            CGFloat deltaX = touchPoint.x - self.originalCenter.x;
            if (fabs(deltaX) > 5){
                if (deltaX > 0){
                    self.panDirection = DBPanDirectionleft;
                }else{
                    self.panDirection = DBPanDirectionRight;
                }
                [self.offsetList removeAllObjects];
                UIViewController *animationVc = [self getNearControllerWithDirection:self.panDirection == DBPanDirectionleft];
                if (animationVc){
                    self.haveNearController = YES;
                    [self setController:animationVc directionLeft:self.panDirection == DBPanDirectionleft];
                    self.topView = self.view.subviews.lastObject;
                }else{
                    self.haveNearController = NO;
                }
            }
        }else if (self.haveNearController){
            CGFloat deltaX = touchPoint.x - self.lastOffsetX;
            if (self.offsetList.count > 20){
                [self.offsetList removeObjectAtIndex:0];
            }
            [self.offsetList addObject:@(deltaX)];
            if (self.panDirection == DBPanDirectionleft){
                self.topView.x = touchPoint.x - UIScreen.screenWidth - self.originalCenter.x;
            }else{
                self.topView.x = touchPoint.x - self.originalCenter.x;
            }
            self.lastOffsetX = touchPoint.x;
        }
    }else{
        if (self.haveNearController){
            NSInteger count = 0;
            for (NSNumber *number in self.offsetList) {
                if (self.panDirection == DBPanDirectionleft){
                    if (number.floatValue >= 0) count++;
                }else{
                    if (number.floatValue <= 0) count++;
                }
            }
            [self successGesture:count>=self.offsetList.count*0.5 animateView:self.topView isLeft:self.panDirection == DBPanDirectionleft];
            self.topView = nil;
            self.lastOffsetX = 0;
            self.haveNearController = NO;
            self.originalCenter = CGPointZero;
            self.panDirection = DBPanDirectionUnknow;
        }
    }
}


- (void)touchTap:(UITapGestureRecognizer *)tap{
    CGPoint touchPoint = [tap locationInView:self.view];
    DBPanDirection panDirection = DBPanDirectionUnknow;
    if (touchPoint.x < UIScreen.screenWidth/3.0) {
        panDirection = DBPanDirectionleft;
    }else if (touchPoint.x > UIScreen.screenWidth*2.0/3.0){
        panDirection = DBPanDirectionRight;
    }
    
    if (panDirection == DBPanDirectionleft){
        UIViewController *animationVc = [self getNearControllerWithDirection:YES];
        if (animationVc){
            
            [self setController:animationVc directionLeft:YES];
            if (self.view.subviews.count > 1) {
                UIView *animateView = self.view.subviews.lastObject;
                if (animateView) [self successGesture:YES animateView:animateView isLeft:YES];
            }
        }else{
            
        }
    }else if (panDirection == DBPanDirectionRight){
        UIViewController *animationVc = [self getNearControllerWithDirection:NO];
        if (animationVc){
            [self setController:animationVc directionLeft:NO];
            if (self.view.subviews.count > 1) {
                UIView *animateView = self.view.subviews[1];
                if (animateView) [self successGesture:YES animateView:animateView isLeft:NO];
            }
        }
    }
}

- (void)successGesture:(BOOL)isPanSuccess animateView:(UIView *)animateView isLeft:(BOOL)isLeft{
    __block BOOL isAbove = isLeft;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        if (isPanSuccess) {
            if (isAbove){
                animateView.frame = self.view.bounds;
            }else{
                animateView.x = -self.view.width;
            }
        }else{
            if (isAbove){
                animateView.x = -self.view.width;
            }else{
                animateView.x = 0;
            }
        }
    } completion:^(BOOL finished) {
        [self animateFinish:isPanSuccess animateView:animateView isAbove:isAbove];
    }];
}

- (void)animateFinish:(BOOL)success animateView:(UIView *)animateView isAbove:(BOOL)isAbove{
    if (success){
        UIView *removeView = [self getNearViewWithAnimateView:animateView isAbove:isAbove];
        if (removeView){
            [removeView removeFromSuperview];
            if ([removeView.nextResponder isKindOfClass:UIViewController.class]){
                [(UIViewController *)removeView.nextResponder removeFromParentViewController];
            }
        }
    }else{
        UIView *removeView = [self getNearViewWithAnimateView:animateView isAbove:!isAbove];
        if (removeView){
            [removeView removeFromSuperview];
            if ([removeView.nextResponder isKindOfClass:UIViewController.class]){
                [(UIViewController *)removeView.nextResponder removeFromParentViewController];
            }
        }
        if (isAbove) self.currentController = self.childViewControllers.lastObject;
    }

    if ([self.delegate respondsToSelector:@selector(coverController:currentController:finish:)]) {
        [self.delegate coverController:self currentController:self.currentController finish:success];
    }
}

- (UIView *)getNearViewWithAnimateView:(UIView *)animateView isAbove:(BOOL)isAbove{
    if (self.view.subviews.count > 1){
        if (isAbove) {
            return self.view.subviews.firstObject;
        }else{
            return animateView;
        }
    }
    return nil;
}

- (UIViewController *)getNearControllerWithDirection:(BOOL)left{
    if (left) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(coverController:getAboveControllerWithCurrentController:)]) {
            return [self.delegate coverController:self getAboveControllerWithCurrentController:self.currentController];
        }
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(coverController:getBelowControllerWithCurrentController:)]) {
            return [self.delegate coverController:self getBelowControllerWithCurrentController:self.currentController];
        }
    }
    return nil;
}

- (void)setController:(UIViewController * _Nullable)controller directionLeft:(BOOL)left{
    if (!controller) return;
    if ([self.childViewControllers containsObject:controller]) return;
    
    self.currentController = controller;
    [self addChildViewController:controller];
    if (left){
        [self.view addSubview:controller.view];
        controller.view.frame = CGRectMake(-UIScreen.screenWidth, 0, UIScreen.screenWidth, UIScreen.screenHeight);
    }else{
        [self.view insertSubview:controller.view atIndex:0];
        controller.view.frame = self.view.bounds;
    }
    [self setShadowController:controller];
}

- (void)setController:(UIViewController * _Nullable)controller{
    if (!controller) return;

    for (UIViewController *childVc in self.childViewControllers) {
        [childVc.view removeFromSuperview];
        [childVc removeFromParentViewController];
    }
    
    self.currentController = controller;
    [self addChildViewController:controller];
    [self.view addSubview:controller.view];
    controller.view.frame = self.view.bounds;
    [self setShadowController:controller];
}

- (void)setShadowController:(UIViewController * _Nullable)controller{
    if (!controller) return;
    controller.view.layer.shadowColor = [DBColorExtension blackColor].CGColor;
    controller.view.layer.shadowOffset = CGSizeMake(0, 0);
    controller.view.layer.shadowOpacity = 0.5;
    controller.view.layer.shadowRadius = 10.0;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] && [gestureRecognizer isEqual:self.tapGesture]) {
        CGPoint touchPoint = [self.tapGesture locationInView:self.view];
        if (touchPoint.x > UIScreen.screenWidth/3.0 && touchPoint.x < UIScreen.screenWidth*2.0/3.0) {
            return YES;
        }
    }
    return NO;
}


- (NSMutableArray *)offsetList{
    if (!_offsetList){
        _offsetList = [NSMutableArray array];
    }
    return _offsetList;
}
@end
