//
//  DBMySettingTableViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/26.
//

#import "DBMySettingTableViewCell.h"

@interface DBMySettingTableViewCell ()
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) DBBaseLabel *contentTextLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UISwitch *noticeSwitch;
@end

@implementation DBMySettingTableViewCell

- (void)setUpSubViews{
    [self.contentView addSubviews:@[self.titleTextLabel,self.contentTextLabel,self.arrowImageView,self.noticeSwitch]];
    [self.titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.centerY.mas_equalTo(0);
    }];
    [self.contentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-40);
        make.centerY.mas_equalTo(0);
    }];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(0);
    }];
    [self.noticeSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
}

- (void)changeNoticeSwitch:(UISwitch *)sender{
    DBAppSetting *setting = DBAppSetting.setting;
    setting.isOn = sender.isOn;
    [setting reloadSetting];
}

- (void)setModel:(DBMySettingModel *)model{
    _model = model;
    self.titleTextLabel.text = model.name;
    if (model.content.length){
        self.contentTextLabel.hidden = NO;
        self.contentTextLabel.text = model.content;
    }else{
        self.contentTextLabel.hidden = YES;
    }
    self.arrowImageView.hidden = !model.isArrow;
    self.noticeSwitch.hidden = !model.isSwitch;
    self.noticeSwitch.on = model.isOn;
}

- (DBBaseLabel *)titleTextLabel{
    if (!_titleTextLabel){
        _titleTextLabel = [[DBBaseLabel alloc] init];
        _titleTextLabel.font = DBFontExtension.bodyMediumFont;
        _titleTextLabel.textColor = DBColorExtension.charcoalColor;
    }
    return _titleTextLabel;
}

- (UISwitch *)noticeSwitch{
    if (!_noticeSwitch){
        _noticeSwitch = [[UISwitch alloc] init];
        _noticeSwitch.onTintColor = DBColorExtension.redColor;
        _noticeSwitch.thumbTintColor = DBColorExtension.whiteColor;
        _noticeSwitch.hidden = YES;
        [_noticeSwitch addTarget:self action:@selector(changeNoticeSwitch:) forControlEvents:UIControlEventValueChanged];
    }
    return _noticeSwitch;
}

- (DBBaseLabel *)contentTextLabel{
    if (!_contentTextLabel){
        _contentTextLabel = [[DBBaseLabel alloc] init];
        _contentTextLabel.font = DBFontExtension.bodyMediumFont;
        _contentTextLabel.textColor = DBColorExtension.grayColor;
        _contentTextLabel.textAlignment = NSTextAlignmentRight;
        _contentTextLabel.hidden = YES;
    }
    return _contentTextLabel;
}

- (UIImageView *)arrowImageView{
    if (!_arrowImageView){
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.contentMode = UIViewContentModeScaleAspectFill;
        _arrowImageView.clipsToBounds = YES;
        _arrowImageView.image = [UIImage imageNamed:@"jjCosmicNavigator"];
        _arrowImageView.hidden = YES;
    }
    return _arrowImageView;
}

@end
