//
//  DBMyThemeViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/20.
//

#import "DBMyThemeViewController.h"
#import "DBReaderSetting.h"

@interface DBMyThemeViewController ()
@property (nonatomic, strong) DBBaseLabel *darkLabel;
@property (nonatomic, strong) UISwitch *darkSwitch;
@property (nonatomic, strong) DBBaseLabel *eyeshadowLabel;
@property (nonatomic, strong) UISwitch *eyeshadowSwitch;

@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) DBBaseLabel *percentLabel;
@property (nonatomic, strong) UISlider *sliderView;
@property (nonatomic, strong) DBBaseLabel *sliderLabel;
@property (nonatomic, strong) UIButton *defaultButton;
@end

@implementation DBMyThemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
}

- (void)setUpSubViews{
//    self.fd_interactivePopDisabled = YES;
    [self.view addSubviews:@[self.navLabel,self.darkLabel,self.darkSwitch,self.eyeshadowLabel,self.eyeshadowSwitch,self.shadowView]];
    [self.navLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(UIScreen.navbarSafeHeight);
        make.height.mas_equalTo(UIScreen.navbarNetHeight);
    }];
    [self.darkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.navLabel.mas_bottom).offset(30);
    }];
    [self.darkSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(self.darkLabel);
        make.height.mas_equalTo(40);
    }];
    [self.eyeshadowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.darkLabel.mas_bottom).offset(30);
    }];
    [self.eyeshadowSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(self.eyeshadowLabel);
        make.height.mas_equalTo(40);
    }];
    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.eyeshadowLabel.mas_bottom).offset(30);
        make.height.mas_equalTo(100);
    }];
    
    DBReadBookSetting *setting = DBReadBookSetting.setting;
    self.darkSwitch.on = setting.isDark;
    self.eyeshadowSwitch.on = setting.isEyeShaow;
     
    self.shadowView.hidden = !self.eyeshadowSwitch.on;
    self.percentLabel.text = [NSString stringWithFormat:@"%.0lf%%",setting.shadowPercent*100];
    self.sliderView.value = setting.shadowPercent;
}

- (void)changeDarkSwitch:(UISwitch *)sender{
    DBReadBookSetting *setting = DBReadBookSetting.setting;
    setting.isDark = sender.isOn;
    
    [setting reloadSetting];
    [DBReaderSetting openEyeProtectionMode];
}

- (void)changeEyeshadowSwitch:(UISwitch *)sender{
    DBReadBookSetting *setting = DBReadBookSetting.setting;
    setting.isEyeShaow = sender.isOn;
    self.shadowView.hidden = !sender.isOn;
    
    [setting reloadSetting];
    [DBReaderSetting openEyeProtectionMode];
}

- (void)scrollSliderValueChanged:(UISlider *)sender{
    DBReadBookSetting *setting = DBReadBookSetting.setting;
    setting.shadowPercent = sender.value;
    [setting reloadSetting];
   
    self.percentLabel.text = [NSString stringWithFormat:@"%.0lf%%",setting.shadowPercent*100];
    [DBReaderSetting openEyeProtectionMode];
}

- (void)clickDefaultAction{
    DBReadBookSetting *setting = DBReadBookSetting.setting;
    setting.shadowPercent = 0.35;
    [setting reloadSetting];
    
    self.sliderView.value = setting.shadowPercent;
    self.percentLabel.text = [NSString stringWithFormat:@"%.0lf%%",setting.shadowPercent*100];
    [DBReaderSetting openEyeProtectionMode];
}

- (DBBaseLabel *)darkLabel{
    if (!_darkLabel){
        _darkLabel = [[DBBaseLabel alloc] init];
        _darkLabel.font = DBFontExtension.pingFangMediumLarge;
        _darkLabel.textColor = DBColorExtension.charcoalColor;
        _darkLabel.text = DBConstantString.ks_nightMode;
    }
    return _darkLabel;
}

- (UISwitch *)darkSwitch{
    if (!_darkSwitch){
        _darkSwitch = [[UISwitch alloc] init];
        _darkSwitch.onTintColor = DBColorExtension.redColor;
        _darkSwitch.thumbTintColor = DBColorExtension.whiteColor;
        [_darkSwitch addTarget:self action:@selector(changeDarkSwitch:) forControlEvents:UIControlEventValueChanged];
    }
    return _darkSwitch;
}

- (DBBaseLabel *)eyeshadowLabel{
    if (!_eyeshadowLabel){
        _eyeshadowLabel = [[DBBaseLabel alloc] init];
        _eyeshadowLabel.font = DBFontExtension.pingFangMediumLarge;
        _eyeshadowLabel.textColor = DBColorExtension.charcoalColor;
        _eyeshadowLabel.text = DBConstantString.ks_eyeCareMode;
    }
    return _eyeshadowLabel;
}


- (UISwitch *)eyeshadowSwitch{
    if (!_eyeshadowSwitch){
        _eyeshadowSwitch = [[UISwitch alloc] init];
        _eyeshadowSwitch.onTintColor = DBColorExtension.redColor;
        _eyeshadowSwitch.thumbTintColor = DBColorExtension.whiteColor;
        [_eyeshadowSwitch addTarget:self action:@selector(changeEyeshadowSwitch:) forControlEvents:UIControlEventValueChanged];
    }
    return _eyeshadowSwitch;
}

- (UIView *)shadowView{
    if (!_shadowView){
        _shadowView = [[UIView alloc] init];
        _shadowView.hidden = YES;
        
        DBBaseLabel *filtrateLabel = [[DBBaseLabel alloc] init];
        filtrateLabel.font = DBFontExtension.bodyMediumFont;
        filtrateLabel.textColor = DBColorExtension.charcoalColor;
        filtrateLabel.text = DBConstantString.ks_blueLightFilter;
        [_shadowView addSubview:filtrateLabel];
        [filtrateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.top.mas_equalTo(0);
        }];
        
        [_shadowView addSubview:self.percentLabel];
        [self.percentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-16);
            make.centerY.mas_equalTo(filtrateLabel);
        }];
        
        [_shadowView addSubview:self.sliderView];
        [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-16);
            make.top.mas_equalTo(filtrateLabel.mas_bottom).offset(10);
            make.height.mas_equalTo(30);
        }];
        
        [_shadowView addSubview:self.sliderLabel];
        [self.sliderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.top.mas_equalTo(self.sliderView.mas_bottom).offset(30);
        }];
        
        [_shadowView addSubview:self.defaultButton];
        [self.defaultButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-16);
            make.centerY.mas_equalTo(self.sliderLabel);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(36);
        }];
    }
    return _shadowView;
}

- (DBBaseLabel *)percentLabel{
    if (!_percentLabel){
        _percentLabel = [[DBBaseLabel alloc] init];
        _percentLabel.font = DBFontExtension.bodyMediumFont;
        _percentLabel.textColor = DBColorExtension.charcoalColor;
        _percentLabel.textAlignment = NSTextAlignmentRight;
    }
    return _percentLabel;
}

- (UISlider *)sliderView{
    if (!_sliderView){
        _sliderView = [[UISlider alloc] init];
        _sliderView.minimumValue = 0;
        _sliderView.maximumValue = 1;
        [_sliderView setThumbImage:[UIImage imageNamed:@"jjIlluminationModulator"] forState:UIControlStateNormal];
        _sliderView.minimumTrackTintColor = DBColorExtension.goldColor;
        [_sliderView addTarget:self action:@selector(scrollSliderValueChanged:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
        _sliderView.enlargedEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
    }
    return _sliderView;
}

- (DBBaseLabel *)sliderLabel{
    if (!_sliderLabel){
        _sliderLabel = [[DBBaseLabel alloc] init];
        _sliderLabel.font = DBFontExtension.bodyMediumFont;
        _sliderLabel.textColor = DBColorExtension.charcoalColor;
        _sliderLabel.text = DBConstantString.ks_adjustFilter;
    }
    return _sliderLabel;
}

- (UIButton *)defaultButton{
    if (!_defaultButton){
        _defaultButton = [[UIButton alloc] init];
        _defaultButton.titleLabel.font = DBFontExtension.pingFangMediumLarge;
        _defaultButton.layer.cornerRadius = 18;
        _defaultButton.layer.masksToBounds = YES;
        _defaultButton.backgroundColor = DBColorExtension.redColor;
        [_defaultButton setTitle:DBConstantString.ks_reset forState:UIControlStateNormal];
        [_defaultButton setTitleColor:DBColorExtension.whiteColor forState:UIControlStateNormal];
        [_defaultButton addTarget:self action:@selector(clickDefaultAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _defaultButton;
}

@end
