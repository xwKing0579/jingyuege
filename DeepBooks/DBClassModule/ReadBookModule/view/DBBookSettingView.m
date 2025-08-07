//
//  DBBookSettingView.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/7.
//

#import "DBBookSettingView.h"
#import "DBReadBookSetting.h"
#import "DBReaderSetting.h"
#import "DBFontMenuPanView.h"

@interface DBBookSettingView ()
@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, strong) UISlider *sliderView;
@property (nonatomic, strong) UIButton *eyeShaowButton;

@property (nonatomic, strong) UIButton *reduceButton;
@property (nonatomic, strong) DBBaseLabel *fontLabel;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIButton *fontNameButton;

@property (nonatomic, strong) UIButton *reduceLineButton;
@property (nonatomic, strong) DBBaseLabel *lineSpacingLabel;
@property (nonatomic, strong) UIButton *addLineButton;

@property (nonatomic, strong) NSArray *views;
@property (nonatomic, strong) NSArray *backgroundColorViews;

@end

@implementation DBBookSettingView

- (instancetype)init{
    if (self == [super init]){
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{
    self.layer.zPosition = 2;
    self.frame = UIScreen.mainScreen.bounds;
    self.backgroundColor = DBColorExtension.noColor;
    [self addSubview:self.coverView];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(220+70+UIScreen.navbarSafeHeight);
    }];
    
    [self.coverView addSubviews:@[self.sliderView,self.eyeShaowButton,self.reduceButton,self.fontLabel,self.addButton,self.fontNameButton,self.reduceLineButton,self.lineSpacingLabel,self.addLineButton]];
    [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-100);
        make.top.mas_equalTo(25);
        make.height.mas_equalTo(30);
    }];
    [self.eyeShaowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(self.sliderView);
        make.size.mas_equalTo(self.eyeShaowButton.size);
    }];
    [self.reduceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.sliderView);
        make.width.mas_equalTo(self.sliderView.mas_width).multipliedBy(1.0/3.0);
        make.top.mas_equalTo(self.sliderView.mas_bottom).offset(20);
        make.height.mas_equalTo(30);
    }];
    [self.fontLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.reduceButton.mas_right);
        make.top.height.mas_equalTo(self.reduceButton);
        make.width.mas_equalTo(self.reduceButton.mas_width).offset(-20);
    }];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.fontLabel.mas_right);
        make.top.width.height.mas_equalTo(self.reduceButton);
    }];
    [self.fontNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(self.reduceButton);
    }];
    [self.reduceLineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.sliderView);
        make.top.mas_equalTo(self.reduceButton.mas_bottom).offset(20);
        make.width.height.mas_equalTo(self.reduceButton);
    }];
    [self.lineSpacingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.reduceLineButton);
        make.left.width.height.mas_equalTo(self.fontLabel);
    }];
    [self.addLineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.reduceLineButton);
        make.width.height.mas_equalTo(self.reduceLineButton);
        make.left.mas_equalTo(self.lineSpacingLabel.mas_right);
    }];
    
    CGFloat width = 80;
    CGFloat space = 10;
    CGFloat height = 40;
    NSArray *colors = DBReadBookSetting.settingBackgroundColors;
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(UIScreen.screenWidth);
        make.top.mas_equalTo(self.reduceLineButton.mas_bottom).offset(20);
        make.height.mas_equalTo(height);
    }];
    NSMutableArray *backgroundColorViews = [NSMutableArray array];
    for (UIColor *color in colors) {
        NSInteger index = [colors indexOfObject:color];
        UIButton *colorView = [[UIButton alloc] init];
        colorView.tag = 30+index;
        colorView.backgroundColor = color;
        colorView.layer.cornerRadius = 6;
        colorView.layer.masksToBounds = YES;
        [colorView addTarget:self action:@selector(clickColorsSettingAction:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:colorView];
        [backgroundColorViews addObject:colorView];
        
        colorView.layer.borderWidth = 1;
        if ([color isEqual:DBReadBookSetting.setting.backgroundColor]){
            colorView.layer.borderColor = DBColorExtension.charcoalAltColor.CGColor;
        }else{
            colorView.layer.borderColor = DBColorExtension.noColor.CGColor;
        }
        [colorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo((width+space)*index+16);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
        }];
    }
    self.backgroundColorViews = backgroundColorViews;
    scrollView.contentSize = CGSizeMake((width+space)*(colors.count-1)+width+32, height);
    
    NSMutableArray *views = [NSMutableArray array];
    NSArray *titles = @[@"左右",@"拟真",@"上下",@"自动"];
    NSInteger turnStyle = DBReadBookSetting.setting.turnStyle;

    for (NSInteger index = 0; index < titles.count; index++) {
        BOOL isSelect = (turnStyle == index);
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = index;
        btn.layer.cornerRadius = 2;
        btn.layer.masksToBounds = YES;
        btn.layer.borderWidth = 1;
        btn.titleLabel.font = DBFontExtension.bodyMediumFont;
        btn.layer.borderColor = isSelect ? DBColorExtension.redColor.CGColor : DBColorExtension.charcoalAltColor.CGColor;
        [btn setTitle:titles[index] forState:UIControlStateNormal];
        [btn setTitleColor:isSelect ? DBColorExtension.redColor : DBColorExtension.charcoalAltColor forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickSettingAction:) forControlEvents:UIControlEventTouchUpInside];
        [views addObject:btn];
    }
    self.views = views;
    
    [self addSubviews:views];
    [views mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:16 leadSpacing:16 tailSpacing:16];
    [views mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(scrollView.mas_bottom).offset(20);
        make.height.mas_equalTo(30);
    }];
    
    self.styleIndex = turnStyle;
    
//    [self.coverView addTapGestureTarget:self action:@selector(clickMenuBackground)];
}

//- (void)clickMenuBackground{}

- (void)showAnimate{
    self.frame = CGRectMake(0, UIScreen.screenHeight, UIScreen.screenWidth, 220+70+UIScreen.navbarSafeHeight);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = CGRectMake(0, UIScreen.screenHeight-220-70-UIScreen.navbarSafeHeight, UIScreen.screenWidth, 220+70+UIScreen.navbarSafeHeight);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)setFontSize:(CGFloat)fontSize{
    _fontSize = fontSize;
    self.fontLabel.text = [NSString stringWithFormat:@"%.0lf",fontSize];
}

- (void)setLineSpacing:(CGFloat)lineSpacing{
    _lineSpacing = lineSpacing;
    self.lineSpacingLabel.text = [NSString stringWithFormat:@"%.0lf",lineSpacing];
}

- (void)setStyleIndex:(NSInteger)styleIndex{
    _styleIndex = styleIndex%3;
    for (UIButton *btn in self.views) {
        BOOL isSelect = (btn.tag == _styleIndex);
        btn.layer.borderColor = isSelect ? DBColorExtension.redColor.CGColor : DBColorExtension.charcoalAltColor.CGColor;
        [btn setTitleColor:isSelect ? DBColorExtension.redColor : DBColorExtension.charcoalAltColor forState:UIControlStateNormal];
    }
}

- (void)setBookgroundColor:(UIColor *)bookgroundColor{
    _bookgroundColor = bookgroundColor;
    self.coverView.backgroundColor = bookgroundColor;
    
    UIColor *color = DBColorExtension.charcoalAltColor;
    if ([bookgroundColor isEqual:DBColorExtension.ravenColor]){
        color = DBColorExtension.darkGrayColor;
    }
    
    [self.eyeShaowButton setTitleColor:color forState:UIControlStateNormal];
    [self.reduceButton setTitleColor:color forState:UIControlStateNormal];
    [self.addButton setTitleColor:color forState:UIControlStateNormal];
    [self.fontNameButton setTitleColor:color forState:UIControlStateNormal];
    self.fontLabel.textColor = color;
    
    for (UIButton *styleButton in self.views) {
        [styleButton setTitleColor:color forState:UIControlStateNormal];
    }
}

- (void)scrollSliderValueChanged:(UISlider *)sender{
    UIScreen.mainScreen.brightness = sender.value;
}

- (void)clickColorsSettingAction:(UIButton *)sender{
    for (UIButton *colorButton in self.backgroundColorViews) {
        if ([colorButton isEqual:sender]){
            colorButton.layer.borderColor = DBColorExtension.charcoalAltColor.CGColor;
        }else{
            colorButton.layer.borderColor = DBColorExtension.noColor.CGColor;
        }
    }
    if (self.clickMenuAction) self.clickMenuAction(sender, sender.tag);
}

- (void)clickSettingAction:(UIButton *)sender{
    if (self.clickMenuAction) self.clickMenuAction(sender, sender.tag);
}

- (UIView *)coverView{
    if (!_coverView){
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = DBReadBookSetting.setting.backgroundColor;
        
        UIView *maskView = [[UIView alloc] init];
        maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.10];
        [_coverView addSubview:maskView];
        [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        [maskView addTopEdgeShadow];
    }
    return _coverView;
}

- (UISlider *)sliderView{
    if (!_sliderView){
        _sliderView = [[UISlider alloc] init];
        _sliderView.minimumValue = 0;
        _sliderView.maximumValue = 1;
        _sliderView.value = UIScreen.mainScreen.brightness;
        [_sliderView setThumbImage:[UIImage imageNamed:@"slider_bright"] forState:UIControlStateNormal];
        _sliderView.minimumTrackTintColor = DBColorExtension.goldColor;
        [_sliderView addTarget:self action:@selector(scrollSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        _sliderView.enlargedEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
    }
    return _sliderView;
}

- (UIButton *)eyeShaowButton{
    if (!_eyeShaowButton){
        _eyeShaowButton = [[UIButton alloc] init];
        _eyeShaowButton.tag = 10;
        _eyeShaowButton.titleLabel.font = DBFontExtension.bodyMediumFont;
        [_eyeShaowButton setTitle:@"护眼" forState:UIControlStateNormal];
        [_eyeShaowButton setTitle:@"关闭" forState:UIControlStateSelected];
        [_eyeShaowButton setImage:[UIImage imageNamed:@"eye_close"] forState:UIControlStateSelected];
        [_eyeShaowButton setImage:[UIImage imageNamed:@"eye_open"] forState:UIControlStateNormal];
        [_eyeShaowButton setTitleColor:DBColorExtension.charcoalAltColor forState:UIControlStateNormal];
        [_eyeShaowButton addTarget:self action:@selector(clickSettingAction:) forControlEvents:UIControlEventTouchUpInside];
        _eyeShaowButton.size = CGSizeMake(60, 30);
        _eyeShaowButton.selected = DBReadBookSetting.setting.isEyeShaow;
        [_eyeShaowButton setTitlePosition:TitlePositionRight spacing:6];
    }
    return _eyeShaowButton;
}

- (UIButton *)reduceButton{
    if (!_reduceButton){
        _reduceButton = [[UIButton alloc] init];
        _reduceButton.tag = 20;
        _reduceButton.layer.cornerRadius = 4;
        _reduceButton.layer.masksToBounds = YES;
        _reduceButton.layer.borderWidth = 1;
        _reduceButton.layer.borderColor = DBColorExtension.grayColor.CGColor;
        _reduceButton.titleLabel.font = DBFontExtension.bodyMediumFont;
        [_reduceButton setTitle:@"A-" forState:UIControlStateNormal];
        [_reduceButton setTitleColor:DBColorExtension.charcoalAltColor forState:UIControlStateNormal];
        [_reduceButton addTarget:self action:@selector(clickSettingAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reduceButton;
}

- (DBBaseLabel *)fontLabel{
    if (!_fontLabel){
        _fontLabel = [[DBBaseLabel alloc] init];
        _fontLabel.font = DBFontExtension.bodyMediumFont;
        _fontLabel.textColor = DBColorExtension.charcoalAltColor;
        _fontLabel.textAlignment = NSTextAlignmentCenter;
        _fontLabel.text = [NSString stringWithFormat:@"%.0lf",DBReadBookSetting.setting.textFontSize];
    }
    return _fontLabel;
}

- (UIButton *)addButton{
    if (!_addButton){
        _addButton = [[UIButton alloc] init];
        _addButton.tag = 21;
        _addButton.layer.cornerRadius = 4;
        _addButton.layer.masksToBounds = YES;
        _addButton.layer.borderWidth = 1;
        _addButton.layer.borderColor = DBColorExtension.grayColor.CGColor;
        _addButton.titleLabel.font = DBFontExtension.bodyMediumFont;
        [_addButton setTitle:@"A+" forState:UIControlStateNormal];
        [_addButton setTitleColor:DBColorExtension.charcoalAltColor forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(clickSettingAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

- (UIButton *)fontNameButton{
    if (!_fontNameButton){
        _fontNameButton = [[UIButton alloc] init];
        _fontNameButton.tag = 22;
        _fontNameButton.titleLabel.font = DBFontExtension.bodyMediumFont;
        NSString *title = [NSString stringWithFormat:@"%@",DBReadBookSetting.setting.fontFamily];
        [_fontNameButton setTitle:title forState:UIControlStateNormal];
        [_fontNameButton setTitleColor:DBColorExtension.charcoalAltColor forState:UIControlStateNormal];
        [_fontNameButton setImage:[UIImage imageNamed:@"font_icon"] forState:UIControlStateNormal];
        [_fontNameButton addTarget:self action:@selector(clickDownloadFontAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fontNameButton;
}

- (UIButton *)reduceLineButton{
    if (!_reduceLineButton){
        _reduceLineButton = [[UIButton alloc] init];
        _reduceLineButton.tag = 23;
//        _reduceLineButton.layer.cornerRadius = 4;
//        _reduceLineButton.layer.masksToBounds = YES;
//        _reduceLineButton.layer.borderWidth = 1;
//        _reduceLineButton.layer.borderColor = DBColorExtension.grayColor.CGColor;
        [_reduceLineButton setImage:[UIImage imageNamed:@"reduceLineSpacing"] forState:UIControlStateNormal];
        [_reduceLineButton addTarget:self action:@selector(clickSettingAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reduceLineButton;
}

- (DBBaseLabel *)lineSpacingLabel{
    if (!_lineSpacingLabel){
        _lineSpacingLabel = [[DBBaseLabel alloc] init];
        _lineSpacingLabel.font = DBFontExtension.bodyMediumFont;
        _lineSpacingLabel.textColor = DBColorExtension.charcoalAltColor;
        _lineSpacingLabel.textAlignment = NSTextAlignmentCenter;
        _lineSpacingLabel.text = [NSString stringWithFormat:@"%.0lf",DBReadBookSetting.setting.lineSpacing];
    }
    return _lineSpacingLabel;
}

- (UIButton *)addLineButton{
    if (!_addLineButton){
        _addLineButton = [[UIButton alloc] init];
        _addLineButton.tag = 24;
//        _addLineButton.layer.cornerRadius = 4;
//        _addLineButton.layer.masksToBounds = YES;
//        _addLineButton.layer.borderWidth = 1;
//        _addLineButton.layer.borderColor = DBColorExtension.grayColor.CGColor;
        [_addLineButton setImage:[UIImage imageNamed:@"addLineSpacing"] forState:UIControlStateNormal];
        [_addLineButton addTarget:self action:@selector(clickSettingAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addLineButton;
}

- (void)clickDownloadFontAction{
    if (DBCommonConfig.switchAudit) return;
    DBFontMenuPanView *fontView = [[DBFontMenuPanView alloc] init];
    [fontView presentInView:UIScreen.appWindow];
    
    DBWeakSelf
    fontView.fontSwitchBlock = ^(DBFontModel *fontModel) {
        DBStrongSelfElseReturn
        NSString *fontFamily = DBSafeString(fontModel.name);
        [self.fontNameButton setTitle:fontFamily forState:UIControlStateNormal];
        DBReadBookSetting *setting = DBReadBookSetting.setting;
        setting.fontFamily = fontFamily;
        setting.fontName = fontModel.fontName;
        [setting reloadSetting];
        
        if (self.clickMenuAction) self.clickMenuAction(self.fontNameButton, self.fontNameButton.tag);
    };
}

@end
