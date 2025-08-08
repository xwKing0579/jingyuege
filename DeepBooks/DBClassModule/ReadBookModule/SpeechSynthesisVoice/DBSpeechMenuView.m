//
//  DBSpeechMenuView.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/17.
//

#import "DBSpeechMenuView.h"
#import "DBReadBookSetting.h"

@interface DBSpeechMenuView ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIButton *bottomView;

@property (nonatomic, strong) DBBaseLabel *speedLabel;
@property (nonatomic, strong) DBBaseLabel *voiceLabel;
@property (nonatomic, strong) DBBaseLabel *fixedLabel;

@property (nonatomic, strong) UISlider *sliderView;
@property (nonatomic, strong) UIButton *speechVoiceButton;

@property (nonatomic, strong) UIButton *exitButton;
@property (nonatomic, strong) UIButton *pauseButton;

@property (nonatomic, strong) NSArray *viewsButton;

@end

@implementation DBSpeechMenuView

- (instancetype)init{
    if (self == [super init]){
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{
    self.frame = UIScreen.mainScreen.bounds;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    
    [self addSubview:self.bottomView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMenuBackground)];
    tapGesture.delegate = self;
    [self addGestureRecognizer:tapGesture];
}

- (void)clickMenuBackground{
    [self removeAudiobookMenuView];
}

- (void)showAudiobookMenuView{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.bottomView.frame = CGRectMake(0, UIScreen.screenHeight-self.bottomView.height, UIScreen.screenWidth, self.bottomView.height);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)removeAudiobookMenuView{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.bottomView.frame = CGRectMake(0, UIScreen.screenHeight, UIScreen.screenWidth, self.bottomView.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)scrollSliderValueChanged:(UISlider *)sender{
    if (self.speechRateBlock) self.speechRateBlock(sender.value);
}

- (void)changeSpeechVoiceAction{
    if (self.speechBlock) self.speechBlock(3);
}

- (void)clickTimeAction:(UIButton *)sender{
    for (UIButton *btn in self.viewsButton) {
        btn.selected = [sender isEqual:btn];
    }
    if (self.speechBlock) self.speechBlock(sender.tag+10);
}

- (void)clickExitAction{
    [self removeAudiobookMenuView];
    if (self.speechBlock) self.speechBlock(2);
}

- (void)clickPauseAction{
    self.pauseButton.selected = !self.pauseButton.selected;
    if (self.speechBlock) self.speechBlock(!self.pauseButton.selected);
}

- (void)setName:(NSString *)name{
    _name = name;
    [self.speechVoiceButton setTitle:name forState:UIControlStateNormal];
}

- (void)setAudioRate:(CGFloat)audioRate{
    _audioRate = audioRate;
    self.sliderView.value = audioRate;
}

- (UIButton *)bottomView{
    if (!_bottomView){
        _bottomView = [[UIButton alloc] initWithFrame:CGRectMake(0, UIScreen.screenHeight, UIScreen.screenWidth, 198+UIScreen.navbarSafeHeight+30)];
        _bottomView.backgroundColor = DBColorExtension.paleGrayAltColor;
        
        NSArray *titleLabels = @[self.speedLabel,self.voiceLabel,self.fixedLabel];
        NSArray *actionButton = @[self.exitButton,self.pauseButton];
        [_bottomView addSubviews:titleLabels];
        [_bottomView addSubviews:@[self.sliderView,self.speechVoiceButton]];
        [_bottomView addSubviews:actionButton];
        
        [titleLabels mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:24 leadSpacing:30 tailSpacing:100+UIScreen.tabbarSafeHeight];
        [titleLabels mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.width.mas_equalTo(40);
        }];
        
        [actionButton mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:30 leadSpacing:30 tailSpacing:30];
        [actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-UIScreen.tabbarSafeHeight-38);
            make.height.mas_equalTo(40);
        }];
        
        [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.speedLabel.mas_right);
            make.right.mas_equalTo(-16);
            make.height.mas_equalTo(30);
            make.centerY.mas_equalTo(self.speedLabel);
        }];
        
        [self.speechVoiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.voiceLabel.mas_right);
            make.centerY.mas_equalTo(self.voiceLabel);
            make.height.mas_equalTo(32);
        }];
        
        NSArray *times = @[@"1分钟",@"15分钟",@"30分钟",@"60分钟"];
        NSMutableArray *timeArray = [NSMutableArray array];
        for (NSString *time in times) {
            UIButton *button = [[UIButton alloc] init];
            button.tag = [times indexOfObject:time];
            button.titleLabel.font = DBFontExtension.bodyMediumFont;
            [button setTitle:time forState:UIControlStateNormal];
            [button setTitleColor:DBColorExtension.charcoalAltColor forState:UIControlStateNormal];
            [button setTitleColor:DBColorExtension.roseGoldColor forState:UIControlStateSelected];
            [button addTarget:self action:@selector(clickTimeAction:) forControlEvents:UIControlEventTouchUpInside];
            [timeArray addObject:button];
        }
        self.viewsButton = timeArray;
        [_bottomView addSubviews:timeArray];
        [timeArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:56 tailSpacing:16];
        [timeArray mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.fixedLabel);
            make.height.mas_equalTo(36);
        }];
    }
    return _bottomView;
}

- (UISlider *)sliderView{
    if (!_sliderView){
        _sliderView = [[UISlider alloc] init];
        _sliderView.minimumValue = 0;
        _sliderView.maximumValue = 1;
        _sliderView.value = UIScreen.mainScreen.brightness;
        [_sliderView setThumbImage:[UIImage imageNamed:@"jjIlluminationModulator"] forState:UIControlStateNormal];
        _sliderView.minimumTrackTintColor = DBColorExtension.goldColor;
        [_sliderView addTarget:self action:@selector(scrollSliderValueChanged:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
        _sliderView.enlargedEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
    }
    return _sliderView;
}

- (DBBaseLabel *)speedLabel{
    if (!_speedLabel){
        _speedLabel = [[DBBaseLabel alloc] init];
        _speedLabel.font = DBFontExtension.bodyMediumFont;
        _speedLabel.textColor = DBColorExtension.charcoalAltColor;
        _speedLabel.text = @"语速";
    }
    return _speedLabel;
}

- (DBBaseLabel *)voiceLabel{
    if (!_voiceLabel){
        _voiceLabel = [[DBBaseLabel alloc] init];
        _voiceLabel.font = DBFontExtension.bodyMediumFont;
        _voiceLabel.textColor = DBColorExtension.charcoalAltColor;
        _voiceLabel.text = @"发声";
    }
    return _voiceLabel;
}

- (DBBaseLabel *)fixedLabel{
    if (!_fixedLabel){
        _fixedLabel = [[DBBaseLabel alloc] init];
        _fixedLabel.font = DBFontExtension.bodyMediumFont;
        _fixedLabel.textColor = DBColorExtension.charcoalAltColor;
        _fixedLabel.text = @"定时";
    }
    return _fixedLabel;
}

- (UIButton *)speechVoiceButton{
    if (!_speechVoiceButton){
        _speechVoiceButton = [[UIButton alloc] init];
        _speechVoiceButton.layer.cornerRadius = 8;
        _speechVoiceButton.layer.masksToBounds = YES;
        _speechVoiceButton.backgroundColor = DBColorExtension.oceanBlueColor;
        _speechVoiceButton.titleLabel.font = DBFontExtension.bodyMediumFont;
        _speechVoiceButton.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 12);
        [_speechVoiceButton setTitle:DBReadBookSetting.setting.speechSetting.name forState:UIControlStateNormal];
        [_speechVoiceButton setTitleColor:DBColorExtension.whiteColor forState:UIControlStateNormal];
        [_speechVoiceButton addTarget:self action:@selector(changeSpeechVoiceAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _speechVoiceButton;
}

- (UIButton *)exitButton{
    if (!_exitButton){
        _exitButton = [[UIButton alloc] init];
        _exitButton.titleLabel.font = DBFontExtension.pingFangSemiboldRegular;
        _exitButton.layer.cornerRadius = 8;
        _exitButton.layer.masksToBounds = YES;
        _exitButton.layer.borderWidth = 1;
        _exitButton.layer.borderColor = DBColorExtension.charcoalAltColor.CGColor;
        [_exitButton setTitle:@"退出阅读" forState:UIControlStateNormal];
        [_exitButton setTitleColor:DBColorExtension.charcoalAltColor forState:UIControlStateNormal];
        [_exitButton addTarget:self action:@selector(clickExitAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exitButton;
}

- (UIButton *)pauseButton{
    if (!_pauseButton){
        _pauseButton = [[UIButton alloc] init];
        _pauseButton.titleLabel.font = DBFontExtension.pingFangSemiboldRegular;
        _pauseButton.layer.cornerRadius = 8;
        _pauseButton.layer.masksToBounds = YES;
        _pauseButton.layer.borderWidth = 1;
        _pauseButton.layer.borderColor = DBColorExtension.charcoalAltColor.CGColor;
        [_pauseButton setTitle:@"暂停阅读" forState:UIControlStateNormal];
        [_pauseButton setTitle:@"开启阅读" forState:UIControlStateSelected];
        [_pauseButton setTitleColor:DBColorExtension.charcoalAltColor forState:UIControlStateNormal];
        [_pauseButton addTarget:self action:@selector(clickPauseAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pauseButton;
}
@end
