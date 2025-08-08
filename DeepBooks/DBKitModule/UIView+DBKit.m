//
//  UIView+DBKit.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/27.
//

#import "UIView+DBKit.h"
#import "DBReadBookSettingView.h"
#import "DBBookSettingView.h"
#import <SVProgressHUD/SVProgressHUD.h>

@implementation UIView (DBKit)

- (void)setX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height{
    return self.frame.size.height;
}

- (void)setOrigin:(CGPoint)origin{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin{
    return self.frame.origin;
}

- (void)setSize:(CGSize)size{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size{
    return self.frame.size;
}

- (void)addSubviews:(NSArray *)subviews{
    for (UIView *view in subviews) {
        [self addSubview:view];
    }
}

- (void)removeAllSubView{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)removeAllSubViewExcept:(NSArray *)views{
    NSArray *arraySubViews = [NSArray arrayWithArray:self.subviews];
    for (UIView *subview in arraySubViews) {
        if (![views containsObject:subview]) {
            [subview removeFromSuperview];
        }
    }
}

- (void)addRoudCorners:(UIRectCorner)corners cornerRadii:(CGSize)radii{
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc]init];
    shapeLayer.frame = self.bounds;
    shapeLayer.path = bezierPath.CGPath;
    self.layer.mask = shapeLayer;
}


- (void)showAlertText:(NSString *)text{
    NSTimeInterval delay = text.length < 8 ? 1.2 : 2.0;
    [self showAlertText:text afterDelay:delay];
}

- (void)showAlertText:(NSString *)text afterDelay:(NSTimeInterval)delay{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (DBEmptyObj(text)) return;
        
        [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0.f alpha:0.5]];
        [SVProgressHUD setForegroundColor:DBColorExtension.whiteColor];
        [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, -50)];
        [SVProgressHUD setContainerView:self];
        if ([self isKindOfClass:UIWindow.class]) {
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        }else{
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
        }
        [SVProgressHUD showWithStatus:text];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [SVProgressHUD setContainerView:nil];
        });
    });
}

- (void)showHudLoading{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0.f alpha:0.35]];
        [SVProgressHUD setForegroundColor:DBColorExtension.whiteColor];
        [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, -50)];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD setContainerView:self];
        if ([self isKindOfClass:UIWindow.class]) {
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        }else{
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
        }
        [SVProgressHUD show];
    });
}

- (void)removeHudLoading{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        [SVProgressHUD setContainerView:nil];
    });
}

static UIView *_maskView;
static DBBaseLabel *_textLabel;
- (void)showCloseAndText:(NSString *)text completion:(void (^ __nullable)(BOOL close))completion{
    if (_maskView && _textLabel) {
        _textLabel.text = text;
        return;
    }
    
    UIView *maskView = [[UIView alloc] initWithFrame:self.bounds];
    maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];
    [self addSubview:maskView];
    _maskView = maskView;
    
    UIView *containerBoxView = [[UIView alloc] init];
    containerBoxView.backgroundColor = DBColorExtension.whiteColor;
    containerBoxView.layer.cornerRadius = 10;
    containerBoxView.layer.masksToBounds = YES;
    [maskView addSubview:containerBoxView];
    [containerBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(maskView);
    }];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]
                                          initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    [indicator startAnimating];
    [containerBoxView addSubview:indicator];
    [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(30);
        make.width.height.mas_equalTo(40);
    }];
    
    DBBaseLabel *textLabel = [[DBBaseLabel alloc] init];
    textLabel.textColor = DBColorExtension.charcoalAltColor;
    textLabel.font = DBFontExtension.bodyMediumFont;
    textLabel.numberOfLines = 0;
    textLabel.text = text;
    textLabel.textAlignment = NSTextAlignmentCenter;
    [containerBoxView addSubview:textLabel];
    _textLabel = textLabel;
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.right.mas_equalTo(-24);
        make.top.mas_equalTo(indicator.mas_bottom).offset(20);
        make.width.mas_lessThanOrEqualTo(UIScreen.screenWidth*0.5);
        make.bottom.mas_equalTo(-30);
    }];
    
    UIButton *closeButton = [[UIButton alloc] init];
    closeButton.enlargedEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
    [closeButton setImage:[UIImage imageNamed:@"jjCrystallineBarrier"] forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [maskView addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(containerBoxView).offset(8);
        make.right.mas_equalTo(containerBoxView).offset(-8);
    }];
    
    [closeButton addTagetHandler:^(id  _Nonnull sender) {
        if (completion) completion(YES);
    } controlEvents:UIControlEventTouchUpInside];
}

- (void)removeCloseHudLoading{
    [_maskView removeAllSubView];
    [_maskView removeFromSuperview];
}

- (void)addTapGestureTarget:(id)target action:(SEL)action{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tapGesture];
}


- (UIImage *)imageShot{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

- (UIImage *)captureMirrorImage{
    CGRect rect = self.bounds;
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGAffineTransform transform = CGAffineTransformMake(-1.0, 0.0, 0.0, 1.0, rect.size.width, 0.0);
    CGContextConcatCTM(context,transform);
    [self.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)addTopEdgeShadow {
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0, 0, UIScreen.screenWidth, 10);
    
    gl.colors = @[
        (id)[[UIColor colorWithWhite:0.0 alpha:0.06] CGColor],
        (id)[[UIColor colorWithWhite:0.0 alpha:0.03] CGColor],
        (id)[[UIColor colorWithWhite:0.0 alpha:0.0] CGColor]
    ];
    
    gl.locations = @[@0.0, @0.5, @1.0];
    
    gl.startPoint = CGPointMake(0.5, 0.0);
    gl.endPoint = CGPointMake(0.5, 1.0);
    
    [self.layer addSublayer:gl];
}

- (void)addOuterShadow{
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(17,470,170,245);
    gl.startPoint = CGPointMake(0.17, 0.13);
    gl.endPoint = CGPointMake(0.85, 0.85);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:250/255.0 blue:247/255.0 alpha:1].CGColor, (__bridge id)[UIColor colorWithRed:255/255.0 green:234/255.0 blue:226/255.0 alpha:1].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    self.layer.cornerRadius = 12;
    self.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2500].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,4);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 16;
}

- (void)removeOuterShadow{
    self.layer.shadowColor = nil;
    self.layer.shadowOpacity = 0;
    self.layer.shadowRadius = 0;
    self.layer.shadowOffset = CGSizeZero;
}


- (void)traverseAllSubviewsWithBlock:(void (^)(UIView *subview))block {
    for (UIView *subview in self.subviews) {
        if (block) {
            block(subview);
        }
        [subview traverseAllSubviewsWithBlock:block];
    }
}

@end
