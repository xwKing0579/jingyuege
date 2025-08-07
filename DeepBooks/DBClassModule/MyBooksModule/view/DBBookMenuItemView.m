//
//  DBBookMenuItemView.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/31.
//

#import "DBBookMenuItemView.h"


@interface DBBookMenuItemView ()
@property (nonatomic, strong) UISwitch *switchView;
@property (nonatomic, strong) UIImageView *pictureImageView;
@property (nonatomic, strong) DBBaseLabel *contentTextLabel;
@end

@implementation DBBookMenuItemView

- (instancetype)init{
    if (self = [super init]){
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{
    [self addSubviews:@[self.switchView,self.pictureImageView,self.contentTextLabel]];
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(30);
    }];
    [self.pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(30);
    }];
    [self.contentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.pictureImageView.mas_bottom).offset(10);
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-10);
    }];
}

- (void)changeSwitch:(UISwitch *)sender{
    if (self.switchBlock) self.switchBlock(sender.isOn);
}

- (void)setModel:(DBBookMenuItemModel *)model{
    _model = model;
   
    self.pictureImageView.imageObj = model.icon;
    if (DBColorExtension.userInterfaceStyle) {
        self.pictureImageView.image = [self.pictureImageView.image imageWithTintColor:DBColorExtension.coolGrayColor];
    }
    self.contentTextLabel.text = model.name;
    
    if (model.isSwitch){
        self.switchView.hidden = NO;
        self.pictureImageView.hidden = YES;
    }else{
        self.switchView.hidden = YES;
        self.pictureImageView.hidden = NO;
    }
}

- (void)setIsSwitch:(BOOL)isSwitch{
    _isSwitch = isSwitch;
    self.switchView.on = isSwitch;
}

- (UISwitch *)switchView{
    if (!_switchView){
        _switchView = [[UISwitch alloc] init];
        _switchView.hidden = YES;
        _switchView.onTintColor = DBColorExtension.redColor;
        _switchView.thumbTintColor = DBColorExtension.whiteColor;
        [_switchView addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchView;
}

- (UIImageView *)pictureImageView{
    if (!_pictureImageView){
        _pictureImageView = [[UIImageView alloc] init];
        _pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _pictureImageView;
}

- (DBBaseLabel *)contentTextLabel{
    if (!_contentTextLabel){
        _contentTextLabel = [[DBBaseLabel alloc] init];
        _contentTextLabel.font = DBFontExtension.bodySixTenFont;
        _contentTextLabel.textColor = DBColorExtension.charcoalColor;
        _contentTextLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _contentTextLabel;
}
@end
