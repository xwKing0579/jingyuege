//
//  DBBookDetailBannerTableViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/6/5.
//

#import "DBBookDetailBannerTableViewCell.h"
@interface DBBookDetailBannerTableViewCell ()
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIImageView *pictureImageView;
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) UIButton *authorButton;
@property (nonatomic, strong) DBBaseLabel *descTextLabel;
@end

@implementation DBBookDetailBannerTableViewCell

- (void)setUpSubViews{
    [self.contentView addSubviews:@[self.coverImageView,self.pictureImageView,self.titleTextLabel,self.authorButton,self.descTextLabel]];
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.height.mas_equalTo(208.0*UIScreen.screenWidth/375.0+UIScreen.navbarSafeHeight);
    }];
    CGFloat width = (UIScreen.screenWidth-60)/4;
    [self.pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.bottom.mas_equalTo(self.coverImageView).offset(-30);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(width*5.0/4.0);
    }];
    [self.titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.pictureImageView.mas_right).offset(10);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(self.pictureImageView);
    }];
    [self.descTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.titleTextLabel);
        make.bottom.mas_equalTo(self.pictureImageView);
    }];
    [self.authorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleTextLabel);
        make.centerY.mas_equalTo(self.pictureImageView);
    }];
}

- (void)clickAuthorInfoAction{
    [DBRouter openPageUrl:DBAuthorBooks params:@{@"autherName":DBSafeString(self.model.author)}];
}

- (void)setModel:(DBBookDetailModel *)model{
    _model = model;
    self.coverImageView.imageObj = model.image;
    self.pictureImageView.imageObj = model.image;
    self.titleTextLabel.text = model.name;
    self.descTextLabel.text = [DBCommonConfig bookDesc:model];
    NSString *auther = [NSString stringWithFormat:@"%@ >",model.author];
    [self.authorButton setTitle:auther forState:UIControlStateNormal];
}

- (UIImageView *)coverImageView{
    if (!_coverImageView){
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
        _coverImageView.backgroundColor = DBColorExtension.peachColor;
        
        UIToolbar *toolbar = [[UIToolbar alloc] init];
        toolbar.barStyle = UIBarStyleBlack;
        [_coverImageView addSubview:toolbar];
        [toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return _coverImageView;
}

- (UIImageView *)pictureImageView{
    if (!_pictureImageView){
        _pictureImageView = [[UIImageView alloc] init];
        _pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
        _pictureImageView.clipsToBounds = YES;
        _pictureImageView.layer.cornerRadius = 6;
        _pictureImageView.layer.masksToBounds = YES;
    }
    return _pictureImageView;
}

- (DBBaseLabel *)titleTextLabel{
    if (!_titleTextLabel){
        _titleTextLabel = [[DBBaseLabel alloc] init];
        _titleTextLabel.font = DBFontExtension.bodySixTenFont;
        _titleTextLabel.textColor = DBColorExtension.whiteColor;
    }
    return _titleTextLabel;
}

- (UIButton *)authorButton{
    if (!_authorButton){
        _authorButton = [[UIButton alloc] init];
        _authorButton.titleLabel.font = DBFontExtension.bodyMediumFont;
        _authorButton.contentEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 5);
        [_authorButton setTitleColor:DBColorExtension.whiteColor forState:UIControlStateNormal];
        [_authorButton addTarget:self action:@selector(clickAuthorInfoAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _authorButton;
}

- (DBBaseLabel *)descTextLabel{
    if (!_descTextLabel){
        _descTextLabel = [[DBBaseLabel alloc] init];
        _descTextLabel.font = DBFontExtension.bodyMediumFont;
        _descTextLabel.textColor = DBColorExtension.whiteColor;
    }
    return _descTextLabel;
}
@end
