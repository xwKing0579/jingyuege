//
//  DBReadBookSettingView.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/7.
//

#import "DBReadBookSettingView.h"
#import "DBReadBookSetting.h"
#import "DBReaderChapterView.h"

@interface DBReadBookSettingView ()
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UISlider *sliderView;
@property (nonatomic, strong) DBReaderChapterView *chapterView;
@property (nonatomic, strong) DBBaseLabel *cacheTextLabel;
@end

@implementation DBReadBookSettingView

- (instancetype)init{
    if (self == [super init]){
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{
    self.layer.zPosition = 1;
    self.frame = UIScreen.mainScreen.bounds;
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    [self addSubviews:@[self.topView,self.centerView,self.bottomView,self.chapterView]];
    
    [self addTapGestureTarget:self action:@selector(clickMenuBackgroundAction)];
    [self.topView addTapGestureTarget:self action:@selector(clickMenuBackground)];
    [self.bottomView addTapGestureTarget:self action:@selector(clickMenuBackground)];
    UIPanGestureRecognizer *topPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(clickMenuBackground)];
    [self.topView addGestureRecognizer:topPanGesture];
    UIPanGestureRecognizer *bottomPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(clickMenuBackground)];
    [self.topView addGestureRecognizer:bottomPanGesture];
}

- (void)clickMenuBackground{}

- (void)showPanelViewAnimation{
    CGFloat h = DBCommonConfig.switchAudit ? UIScreen.navbarHeight : UIScreen.navbarHeight+30;
    self.topView.frame = CGRectMake(0, -h, UIScreen.screenWidth, h);
    self.centerView.frame = CGRectMake(UIScreen.screenWidth, UIScreen.screenHeight-UIScreen.tabbarHeight-222-60-100, 48, 106);
    self.bottomView.frame = CGRectMake(0, UIScreen.screenHeight, UIScreen.screenWidth, 160+UIScreen.tabbarSafeHeight);
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.topView.frame = CGRectMake(0, 0, UIScreen.screenWidth, h);
        self.centerView.frame = CGRectMake(UIScreen.screenWidth-48-16, UIScreen.screenHeight-UIScreen.tabbarHeight-222-60, 48, 106);
        self.bottomView.frame = CGRectMake(0, UIScreen.screenHeight-160-UIScreen.tabbarSafeHeight, UIScreen.screenWidth, 160+UIScreen.tabbarSafeHeight);
        self.centerView.frame = CGRectMake(UIScreen.screenWidth-48-16, UIScreen.screenHeight-UIScreen.tabbarHeight-222-60-100, 48, 106);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hiddenPanelViewAnimation{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGFloat h = DBCommonConfig.switchAudit ? UIScreen.navbarHeight : UIScreen.navbarHeight+30;
        self.topView.frame = CGRectMake(0, -h, UIScreen.screenWidth, h);
        self.centerView.frame = CGRectMake(UIScreen.screenWidth, UIScreen.screenHeight-UIScreen.tabbarHeight-222-60-100, 48, 106);
        self.bottomView.frame = CGRectMake(0, UIScreen.screenHeight, UIScreen.screenWidth, 160+UIScreen.tabbarSafeHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)clickMenuBackgroundAction{
    if (self.clickMenuAction) self.clickMenuAction(nil, 0);
    [self hiddenPanelViewAnimation];
}

- (void)scrollSliderValueChanged:(UISlider *)sender{
    self.chapterView.hidden = YES;
    if (self.scrollSliderAction) self.scrollSliderAction(sender.value, YES);
}

- (void)scrollSliderValueChanging:(UISlider *)sender{
    self.chapterView.hidden = NO;
    if (self.scrollSliderAction) self.scrollSliderAction(sender.value, NO);
}

- (void)clickMenuItem:(UIButton *)sender{
    if (self.clickMenuAction) self.clickMenuAction(sender,sender.tag);
}

- (void)setSliderValue:(CGFloat)sliderValue{
    _sliderValue = sliderValue;
    self.sliderView.value = sliderValue;
}

- (void)setBookgroundColor:(UIColor *)bookgroundColor{
    _bookgroundColor = bookgroundColor;
    self.topView.backgroundColor = bookgroundColor;
    self.bottomView.backgroundColor = bookgroundColor;
    
    UIColor *color = DBColorExtension.charcoalAltColor;
    if ([bookgroundColor isEqual:DBColorExtension.ravenColor]){
        color = DBColorExtension.darkGrayColor;
    }
    
    for (UIView *subview in self.bottomView.subviews) {
        if ([subview isKindOfClass:UILabel.class]){
            ((DBBaseLabel *)subview).textColor = color;
        }else if ([subview isKindOfClass:UIButton.class]){
            UIButton *button = (UIButton *)subview;
            [button setTitleColor:color forState:UIControlStateNormal];
            UIImage *normalImage = [button imageForState:UIControlStateNormal];
            UIImage *selectedImage = [button imageForState:UIControlStateSelected];
            [button setImage:[normalImage imageWithTintColor:color] forState:UIControlStateNormal];
            [button setImage:[selectedImage imageWithTintColor:color] forState:UIControlStateSelected];
        }
    }
}

- (void)setChapterName:(NSString *)chapterName{
    _chapterName = chapterName;
    self.chapterView.chapterName = chapterName;
}

- (void)setRateValue:(NSString *)rateValue{
    _rateValue = rateValue;
    self.chapterView.rateValue = rateValue;
}

- (void)setCacheText:(NSString *)cacheText{
    _cacheText = cacheText;
    self.cacheTextLabel.text = cacheText;
}

- (UIView *)topView{
    if (!_topView){
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = DBReadBookSetting.setting.backgroundColor;
        
        UIView *maskView = [[UIView alloc] init];
        maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        [_topView addSubview:maskView];
        [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
        UIButton *backButton = [[UIButton alloc] init];
        [backButton setImage:[UIImage imageNamed:@"jjRetreatCompass"] forState:UIControlStateNormal];
        DBWeakSelf
        [backButton addTagetHandler:^(id  _Nonnull sender) {
            DBStrongSelfElseReturn
            if (self.clickMenuAction) self.clickMenuAction(sender, 1);
        } controlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:backButton];
        [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(UIScreen.navbarSafeHeight);
            make.width.height.mas_equalTo(UIScreen.navbarNetHeight);
        }];

        if (DBCommonConfig.switchAudit) {
            NSArray *titles = @[@"目录"];
            CGFloat width = 80;
            for (NSInteger index = titles.count-1; index < titles.count; index--) {
                UIButton *button = [[UIButton alloc] init];
                button.tag = 30;
                button.titleLabel.font = DBFontExtension.pingFangMediumLarge;
                [button setTitle:titles[index] forState:UIControlStateNormal];
                [button setTitleColor:DBColorExtension.charcoalAltColor forState:UIControlStateNormal];
                [button addTarget:self action:@selector(clickMenuItem:) forControlEvents:UIControlEventTouchUpInside];
                [_topView addSubview:button];
                
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(backButton);
                    make.right.mas_equalTo(-index*width-16);
                    make.width.mas_equalTo(width);
                    make.height.mas_equalTo(30);
                }];
            }
        }else{
            NSArray *titles = @[@"反馈",@"下载",@"评论"];
            CGFloat width = 50;
            for (NSInteger index = titles.count-1; index < titles.count; index--) {
                UIButton *button = [[UIButton alloc] init];
                button.tag = index+10;
                button.titleLabel.font = DBFontExtension.pingFangMediumXLarge;
                [button setTitle:titles[index] forState:UIControlStateNormal];
                [button setTitleColor:DBColorExtension.charcoalAltColor forState:UIControlStateNormal];
                [button addTarget:self action:@selector(clickMenuItem:) forControlEvents:UIControlEventTouchUpInside];
                [_topView addSubview:button];
                
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(backButton);
                    make.right.mas_equalTo(-index*width-16);
                    make.width.mas_equalTo(width);
                    make.height.mas_equalTo(30);
                }];
                
                if (index == 1){
                    self.downloadButton = button;
                }
            }
            
            UIButton *linkButton = [[UIButton alloc] init];
            linkButton.tag = titles.count+10;
            linkButton.titleLabel.font = DBFontExtension.bodyMediumFont;
            linkButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
            [linkButton setTitle:@"第三方数据，点击访问" forState:UIControlStateNormal];
            [linkButton setTitleColor:DBColorExtension.charcoalAltColor forState:UIControlStateNormal];
            [_topView addSubview:linkButton];
            [linkButton addTarget:self action:@selector(clickMenuItem:) forControlEvents:UIControlEventTouchUpInside];
            [linkButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(0);
                make.height.mas_equalTo(30);
            }];
        }
     
    }
    return _topView;
}

- (UIView *)centerView{
    if (!_centerView){
        _centerView = [[UIView alloc] init];
        _centerView.backgroundColor = DBColorExtension.noColor;
        
        NSArray *titles = @[@"听书",@"书源"];
        for (NSInteger index = 0; index < titles.count; index++) {
            UIButton *button = [[UIButton alloc] init];
            button.tag = index+20;
            button.titleLabel.font = DBFontExtension.pingFangMediumXLarge;
            button.layer.cornerRadius = 24;
            button.layer.masksToBounds = YES;
            button.backgroundColor = DBColorExtension.silverColor;
            [button setTitle:titles[index] forState:UIControlStateNormal];
            [button setTitleColor:DBColorExtension.whiteColor forState:UIControlStateNormal];
            [button addTarget:self action:@selector(clickMenuItem:) forControlEvents:UIControlEventTouchUpInside];
            
            [_centerView addSubview:button];
            
            if (index == 0){
                self.listenBookButton = button;
            }
        }
        
        [_centerView.subviews mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:10 leadSpacing:0 tailSpacing:0];
        [_centerView.subviews mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
        }];
    }
    return _centerView;
}

- (UIView *)bottomView{
    if (!_bottomView){
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = DBReadBookSetting.setting.backgroundColor;
        
        UIView *maskView = [[UIView alloc] init];
        maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.10];
        [_bottomView addSubview:maskView];
        [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        [maskView addTopEdgeShadow];
        
        [_bottomView addSubview:self.sliderView];
        [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.right.mas_equalTo(-30);
            make.top.mas_equalTo(40);
            make.height.mas_equalTo(20);
        }];
        
        UIButton *catalogButton = [[UIButton alloc] init];
        catalogButton.tag = 30;
        catalogButton.titleLabel.font = DBFontExtension.pingFangMediumSmall;
        catalogButton.enlargedEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [catalogButton setTitle:@"目录" forState:UIControlStateNormal];
        [catalogButton setImage:[UIImage imageNamed:@"jjCodexRegistry"] forState:UIControlStateNormal];
        [catalogButton setTitleColor:DBColorExtension.charcoalAltColor forState:UIControlStateNormal];
        [catalogButton addTarget:self action:@selector(clickMenuItem:) forControlEvents:UIControlEventTouchUpInside];
        [catalogButton setTitlePosition:TitlePositionBottom spacing:2];
        [_bottomView addSubview:catalogButton];
        [catalogButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.sliderView);
            make.top.mas_equalTo(self.sliderView.mas_bottom).offset(24);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(60);
        }];
        
        UIButton *eyeshadowButton = [[UIButton alloc] init];
        eyeshadowButton.tag = 31;
        eyeshadowButton.titleLabel.font = DBFontExtension.pingFangMediumSmall;
        eyeshadowButton.enlargedEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [eyeshadowButton setTitle:@"夜间" forState:UIControlStateNormal];
        [eyeshadowButton setTitle:@"白天" forState:UIControlStateSelected];
        [eyeshadowButton setImage:[UIImage imageNamed:@"jjUmbraBadge"] forState:UIControlStateNormal];
        [eyeshadowButton setImage:[UIImage imageNamed:@"jjSolarisMark"] forState:UIControlStateSelected];
        eyeshadowButton.selected = DBReadBookSetting.setting.isDark;
        [eyeshadowButton setTitleColor:DBColorExtension.charcoalAltColor forState:UIControlStateNormal];
        [eyeshadowButton addTarget:self action:@selector(clickMenuItem:) forControlEvents:UIControlEventTouchUpInside];
        [eyeshadowButton setTitlePosition:TitlePositionBottom spacing:2];
        [_bottomView addSubview:eyeshadowButton];
        [eyeshadowButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(self.sliderView.mas_bottom).offset(24);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(60);
        }];
        
        UIButton *settingButton = [[UIButton alloc] init];
        settingButton.tag = 32;
        settingButton.titleLabel.font = DBFontExtension.pingFangMediumSmall;
        settingButton.enlargedEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [settingButton setTitle:@"设置" forState:UIControlStateNormal];
        [settingButton setImage:[UIImage imageNamed:@"jjMechanizationCog"] forState:UIControlStateNormal];
        [settingButton setTitleColor:DBColorExtension.charcoalAltColor forState:UIControlStateNormal];
        [settingButton addTarget:self action:@selector(clickMenuItem:) forControlEvents:UIControlEventTouchUpInside];
        [settingButton setTitlePosition:TitlePositionBottom spacing:2];
        [_bottomView addSubview:settingButton];
        [settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.sliderView);
            make.top.mas_equalTo(self.sliderView.mas_bottom).offset(24);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(60);
        }];
        
        [_bottomView addSubview:self.cacheTextLabel];
        [self.cacheTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.top.mas_equalTo(12);
        }];
    }
    return _bottomView;
}

- (UISlider *)sliderView{
    if (!_sliderView){
        _sliderView = [[UISlider alloc] init];
        _sliderView.minimumValue = 0;
        _sliderView.maximumValue = 1;
        [_sliderView setThumbImage:[UIImage imageNamed:@"jjIlluminationModulator"] forState:UIControlStateNormal];
        _sliderView.minimumTrackTintColor = DBColorExtension.goldColor;
        [_sliderView addTarget:self action:@selector(scrollSliderValueChanged:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
        [_sliderView addTarget:self action:@selector(scrollSliderValueChanging:) forControlEvents:UIControlEventValueChanged];
        _sliderView.enlargedEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
    }
    return _sliderView;
}

- (DBReaderChapterView *)chapterView{
    if (!_chapterView){
        _chapterView = [[DBReaderChapterView alloc] initWithFrame:CGRectMake(30, UIScreen.screenHeight-200-UIScreen.tabbarSafeHeight, UIScreen.screenWidth-60, 50)];
        _chapterView.hidden = YES;
    }
    return _chapterView;
}

- (DBBaseLabel *)cacheTextLabel{
    if (!_cacheTextLabel){
        _cacheTextLabel = [[DBBaseLabel alloc] init];
        _cacheTextLabel.font = DBFontExtension.bodySmallFont;
        _cacheTextLabel.textColor = DBColorExtension.inkWashColor;
    }
    return _cacheTextLabel;
}

@end
