//
//  DBGenderSelectView.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/6.
//

#import "DBGenderSelectView.h"
#import "DBBookActionManager.h"
#import "DBAppSetting.h"
#import "DBMuteLanguageModel.h"
@interface DBGenderSelectView ()
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) DBBaseLabel *contentTextLabel;
@property (nonatomic, strong) UIButton *manControl;
@property (nonatomic, strong) UIButton *femanControl;

@property (nonatomic, strong) UIButton *hansLan;
@property (nonatomic, strong) UIButton *hantLan;
@property (nonatomic, strong) UIButton *enLan;

@property (nonatomic, strong) UIButton *skipButton;

@property (nonatomic, strong) NSString *choiceAbbrev;
@end

@implementation DBGenderSelectView

- (instancetype)init{
    if (self == [super init]){
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{
    self.backgroundColor = DBColorExtension.whiteAltColor;
    [self addSubviews:@[self.titleTextLabel,self.contentTextLabel,self.manControl,self.femanControl,self.hansLan,self.hantLan,self.enLan,self.skipButton]];
    [self.titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(UIScreen.navbarHeight+30);
    }];
    [self.contentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.titleTextLabel.mas_bottom).offset(10);
    }];
    [self.manControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(self.contentTextLabel.mas_bottom).offset(20);
    }];
    [self.femanControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(self.manControl.mas_bottom).offset(20);
    }];
    
   
    NSArray *Languages = @[self.hansLan,self.hantLan,self.enLan];
    [self addSubviews:Languages];
    [Languages mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:30 leadSpacing:30 tailSpacing:30];
    [Languages mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.femanControl.mas_bottom).offset(30);
        make.height.mas_equalTo(36);
    }];
    
    [self.skipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.femanControl.mas_bottom).offset(100);
    }];
}

- (void)clickManAction{
    [self clickGenderAction:YES];
}

- (void)clickFemanAction{
    [self clickGenderAction:NO];
}

- (void)clickGenderAction:(BOOL)man{
    DBAppSetting *setting = DBAppSetting.setting;
    setting.sex = man?@"1":@"2";
    
    if (setting.keyword.length){
        [DBRouter openPageUrl:DBSearchBooks params:@{@"keyword":setting.keyword,kDBRouterPathJumpStyle:@1,kDBRouterPathSetNavigation:@1}];
        setting.keyword = @"";
    }
    
    [setting reloadSetting];
    [self removeFromSuperview];
    
    [DBBookActionManager bookFirstRecommendation];
    
    self.choiceAbbrev = DBAppSetting.languageAbbrev;
}

- (void)clickSkipAction{
    DBAppSetting *setting = DBAppSetting.setting;
    setting.sex = @"0";
    
    if (setting.keyword.length){
        [DBRouter openPageUrl:DBSearchBooks params:@{@"keyword":setting.keyword,kDBRouterPathJumpStyle:@1,kDBRouterPathSetNavigation:@1}];
        setting.keyword = @"";
    }
    
    [setting reloadSetting];
    [self removeFromSuperview];
    
    [DBBookActionManager bookFirstRecommendation];
}

- (void)switchLanguageAction:(UIButton *)sender{
    NSArray *Languages = @[self.hansLan,self.hantLan,self.enLan];
    for (UIButton *lanButton in Languages) {
        if ([lanButton isEqual:sender]){
            lanButton.layer.borderColor = DBColorExtension.sunsetOrangeColor.CGColor;
            [lanButton setTitleColor:DBColorExtension.sunsetOrangeColor forState:UIControlStateNormal];
            
            if ([lanButton isEqual:self.hansLan]){
                self.choiceAbbrev = @"zh-Hans";
            }else if ([lanButton isEqual:self.hantLan]){
                self.choiceAbbrev = @"zh-Hant";
            }else{
                self.choiceAbbrev = @"en";
            }
            [DBMuteLanguageModel saveLanguageAbbrev:self.choiceAbbrev];
        }else{
            lanButton.layer.borderColor = DBColorExtension.inkWashColor.CGColor;
            [lanButton setTitleColor:DBColorExtension.inkWashColor forState:UIControlStateNormal];
        }
    }
}





- (DBBaseLabel *)titleTextLabel{
    if (!_titleTextLabel){
        _titleTextLabel = [[DBBaseLabel alloc] init];
        _titleTextLabel.font = DBFontExtension.titleBigFont;
        _titleTextLabel.textColor = DBColorExtension.charcoalColor;
        _titleTextLabel.textAlignment = NSTextAlignmentCenter;
        _titleTextLabel.text = @"您喜欢看哪类书？";
    }
    return _titleTextLabel;
}

- (DBBaseLabel *)contentTextLabel{
    if (!_contentTextLabel){
        _contentTextLabel = [[DBBaseLabel alloc] init];
        _contentTextLabel.font = DBFontExtension.bodyMediumFont;
        _contentTextLabel.textColor = DBColorExtension.grayColor;
        _contentTextLabel.textAlignment = NSTextAlignmentCenter;
        _contentTextLabel.text = @"“设置”可更改阅读偏好";
    }
    return _contentTextLabel;
}

- (UIButton *)manControl{
    if (!_manControl){
        _manControl = [[UIButton alloc] init];
        [_manControl setBackgroundImage:[UIImage imageNamed:@"jjTerraForma"] forState:UIControlStateNormal];
        [_manControl addTarget:self action:@selector(clickManAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _manControl;
}

- (UIButton *)femanControl{
    if (!_femanControl){
        _femanControl = [[UIButton alloc] init];
        [_femanControl setBackgroundImage:[UIImage imageNamed:@"jjCelestialSilhouette"] forState:UIControlStateNormal];
        [_femanControl addTarget:self action:@selector(clickFemanAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _femanControl;
}

- (UIButton *)skipButton{
    if (!_skipButton){
        _skipButton = [[UIButton alloc] init];
        _skipButton.titleLabel.font = DBFontExtension.pingFangMediumXLarge;
        [_skipButton setTitle:@"下次再说" forState:UIControlStateNormal];
        [_skipButton setTitleColor:DBColorExtension.blackAltColor forState:UIControlStateNormal];
        [_skipButton addTarget:self action:@selector(clickSkipAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _skipButton;
}

- (UIButton *)hansLan{
    if (!_hansLan){
        _hansLan = [[UIButton alloc] init];
        _hansLan.layer.cornerRadius = 4;
        _hansLan.layer.masksToBounds = YES;
        _hansLan.layer.borderWidth = 1;
        _hansLan.layer.borderColor = DBColorExtension.inkWashColor.CGColor;
        _hansLan.titleLabel.font = DBFontExtension.pingFangMediumRegular;
        [_hansLan setTitle:@"简体中文" forState:UIControlStateNormal];
        [_hansLan setTitleColor:DBColorExtension.inkWashColor forState:UIControlStateNormal];
        [_hansLan addTarget:self action:@selector(switchLanguageAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hansLan;
}

- (UIButton *)hantLan{
    if (!_hantLan){
        _hantLan = [[UIButton alloc] init];
        _hantLan.layer.cornerRadius = 4;
        _hantLan.layer.masksToBounds = YES;
        _hantLan.layer.borderWidth = 1;
        _hantLan.layer.borderColor = DBColorExtension.inkWashColor.CGColor;
        _hantLan.titleLabel.font = DBFontExtension.pingFangMediumRegular;
        [_hantLan setTitle:@"繁体中文" forState:UIControlStateNormal];
        [_hantLan setTitleColor:DBColorExtension.inkWashColor forState:UIControlStateNormal];
        [_hantLan addTarget:self action:@selector(switchLanguageAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hantLan;
}


- (UIButton *)enLan{
    if (!_enLan){
        _enLan = [[UIButton alloc] init];
        _enLan.layer.cornerRadius = 4;
        _enLan.layer.masksToBounds = YES;
        _enLan.layer.borderWidth = 1;
        _enLan.layer.borderColor = DBColorExtension.inkWashColor.CGColor;
        _enLan.titleLabel.font = DBFontExtension.pingFangMediumRegular;
        [_enLan setTitle:@"English" forState:UIControlStateNormal];
        [_enLan setTitleColor:DBColorExtension.inkWashColor forState:UIControlStateNormal];
        [_enLan addTarget:self action:@selector(switchLanguageAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enLan;
}
@end
