//
//  DBAdBannerView.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/6/8.
//

#import "DBAdBannerView.h"

@interface DBAdBannerView ()
@property (nonatomic, strong) UIImageView *pictureImageView;
@property (nonatomic, strong) UIButton *closeAdButton;

@end

@implementation DBAdBannerView

- (instancetype)init{
    if (self == [super init]){
        [self setUpSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]){
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{
    self.backgroundColor = DBColorExtension.noColor;
    [self addSubviews:@[self.pictureImageView,self.closeAdButton]];
    [self.pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.closeAdButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.width.height.mas_equalTo(40);
    }];
    [self addTapGestureTarget:self action:@selector(clickAdBackground)];
}

- (void)clickAdBackground{}

- (void)registerAdView:(UIViewController *)showAdController{
    self.splashAdConfig.showAdController = showAdController;
    [self.splashAdConfig registerAdForView:self adData:self.adData];
}

- (void)clickCloseAdView{
    if (self.adViewCloseAction) self.adViewCloseAction(self);
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    if (CGRectContainsPoint(CGRectMake(UIScreen.screenWidth-40, 0, 40, 40), point)){
        [self clickCloseAdView];
        UIView *currentView = UIScreen.currentViewController.view;
        currentView.userInteractionEnabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            currentView.userInteractionEnabled = YES;
        });
        return NO;
    }
    return YES;
}

- (UIView *)mainAdView{
    return self.pictureImageView;
}

- (UIImageView *)mainImageView{
    return self.pictureImageView;
}

- (NSArray *)clickViewArray{
    return @[self];
}

- (UIImageView *)pictureImageView{
    if (!_pictureImageView){
        _pictureImageView = [[UIImageView alloc] init];
        _pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
        _pictureImageView.clipsToBounds = YES;
        _pictureImageView.layer.cornerRadius = 6;
        _pictureImageView.layer.masksToBounds = YES;
        _pictureImageView.userInteractionEnabled = YES;
    }
    return _pictureImageView;
}

- (UIButton *)closeAdButton{
    if (!_closeAdButton){
        _closeAdButton = [[UIButton alloc] init];
        [_closeAdButton setImage:[UIImage imageNamed:@"jjMistDissipate"] forState:UIControlStateNormal];
    }
    return _closeAdButton;
}

- (void)dealloc{
    [self.splashAdConfig deallocAllFeedProperty];
}

@end
