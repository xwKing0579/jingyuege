//
//  DBScaningSettingView.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/14.
//

#import "DBScaningSettingView.h"
#import "DBReadBookSetting.h"
@interface DBScaningSettingView ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIButton *slowButton;
@property (nonatomic, strong) UIButton *speedUpButton;
@property (nonatomic, strong) DBBaseLabel *speedLabel;

@property (nonatomic, strong) UIButton *exitAutoButton;
@end

@implementation DBScaningSettingView

- (instancetype)init{
    if (self == [super init]){
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{
    self.frame = UIScreen.mainScreen.bounds;
    self.backgroundColor = DBColorExtension.noColor;
    
    [self addSubview:self.coverView];
    
    NSArray *views = @[self.slowButton,self.speedLabel,self.speedUpButton,self.exitAutoButton];
    [self.coverView addSubviews:views];

    [self.exitAutoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-UIScreen.tabbarSafeHeight);
        make.height.mas_equalTo(30);
    }];
    
    [@[self.slowButton,self.speedLabel,self.speedUpButton] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:40 tailSpacing:40];
    [@[self.slowButton,self.speedLabel,self.speedUpButton] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.exitAutoButton.mas_top).offset(-10);
        make.height.mas_equalTo(40);
    }];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGesture.delegate = self;
    [self addGestureRecognizer:tapGesture];
}

- (void)handleTap:(UITapGestureRecognizer *)gesture{
    [self hiddenAnimate:^(BOOL finished) {
        if (self.scanContinueBlock) self.scanContinueBlock(YES);
    }];
}

- (void)showAnimate{
    CGFloat h = 100+UIScreen.navbarSafeHeight;
    self.coverView.frame = CGRectMake(0, UIScreen.screenHeight, UIScreen.screenWidth, h);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.coverView.frame = CGRectMake(0, UIScreen.screenHeight-h, UIScreen.screenWidth, h);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hiddenAnimate:(void (^ __nullable)(BOOL finished))completion{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.coverView.frame = CGRectMake(0, UIScreen.screenHeight, UIScreen.screenWidth, self.coverView.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (completion) completion(finished);
    }];
}

- (void)slowSpeedAction{
    DBReadBookSetting *setting = DBReadBookSetting.setting;
    CGFloat speed = setting.scrollSpeed*10000.0;
    if (speed < 1) return;
    speed -= 1;
    self.speedLabel.text = [NSString stringWithFormat:@"翻页速度：%.0lf",speed];
    setting.scrollSpeed = speed/10000.0;
    [setting reloadSetting];
}

- (void)speedUpAction{
    DBReadBookSetting *setting = DBReadBookSetting.setting;
    CGFloat speed = setting.scrollSpeed*10000;
    if (speed > 35) return;
    speed += 1;
    self.speedLabel.text = [NSString stringWithFormat:@"翻页速度：%.0lf",speed];
    setting.scrollSpeed = speed/10000.0;
    [setting reloadSetting];
}

- (void)exitAutoReadingAction{
    [self hiddenAnimate:nil];
    if (self.scanFinishBlock) self.scanFinishBlock(YES);
}

- (UIView *)coverView{
    if (!_coverView){
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = DBColorExtension.paleGrayAltColor;
    }
    return _coverView;
}

- (UIButton *)slowButton{
    if (!_slowButton){
        _slowButton = [[UIButton alloc] init];
        _slowButton.titleLabel.font = DBFontExtension.bodyMediumFont;
        _slowButton.layer.cornerRadius = 4;
        _slowButton.layer.masksToBounds = YES;
        _slowButton.layer.borderWidth = 1;
        _slowButton.layer.borderColor = DBColorExtension.charcoalAltColor.CGColor;
        [_slowButton setTitle:@"- 减速" forState:UIControlStateNormal];
        [_slowButton setTitleColor:DBColorExtension.charcoalAltColor forState:UIControlStateNormal];
        [_slowButton addTarget:self action:@selector(slowSpeedAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _slowButton;
}

- (DBBaseLabel *)speedLabel{
    if (!_speedLabel){
        _speedLabel = [[DBBaseLabel alloc] init];
        _speedLabel.font = DBFontExtension.pingFangMediumSmall;
        _speedLabel.textColor = DBColorExtension.charcoalAltColor;
        _speedLabel.textAlignment = NSTextAlignmentCenter;
        _speedLabel.text = [NSString stringWithFormat:@"翻页速度：%.0lf",DBReadBookSetting.setting.scrollSpeed*10000];
    }
    return _speedLabel;
}

- (UIButton *)speedUpButton{
    if (!_speedUpButton){
        _speedUpButton = [[UIButton alloc] init];
        _speedUpButton.titleLabel.font = DBFontExtension.bodyMediumFont;
        _speedUpButton.layer.cornerRadius = 4;
        _speedUpButton.layer.masksToBounds = YES;
        _speedUpButton.layer.borderWidth = 1;
        _speedUpButton.layer.borderColor = DBColorExtension.charcoalAltColor.CGColor;
        [_speedUpButton setTitle:@"+ 加速" forState:UIControlStateNormal];
        [_speedUpButton setTitleColor:DBColorExtension.charcoalAltColor forState:UIControlStateNormal];
        [_speedUpButton addTarget:self action:@selector(speedUpAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _speedUpButton;
}

- (UIButton *)exitAutoButton{
    if (!_exitAutoButton){
        _exitAutoButton = [[UIButton alloc] init];
        _exitAutoButton.titleLabel.font = DBFontExtension.bodyMediumFont;
        _exitAutoButton.enlargedEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [_exitAutoButton setTitle:@"退出自动翻页" forState:UIControlStateNormal];
        [_exitAutoButton setTitleColor:DBColorExtension.charcoalAltColor forState:UIControlStateNormal];
        [_exitAutoButton addTarget:self action:@selector(exitAutoReadingAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exitAutoButton;
}

@end
