//
//  DBBookCommentTableViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/10.
//

#import "DBBookCommentTableViewCell.h"

@interface DBBookCommentTableViewCell ()
@property (nonatomic, strong) UIImageView *pictureImageView;
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) DBBaseLabel *contentTextLabel;
@property (nonatomic, strong) DBBaseLabel *dateLabel;
@property (nonatomic, strong) UIButton *favButton;
@property (nonatomic, strong) UIView *partingLineView;
@end

@implementation DBBookCommentTableViewCell

- (void)setUpSubViews{
    [self.contentView addSubviews:@[self.pictureImageView,self.titleTextLabel,self.contentTextLabel,self.dateLabel,self.favButton,self.partingLineView]];
    [self.pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(10);
        make.width.height.mas_equalTo(24);
    }];
    [self.titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.pictureImageView.mas_right).offset(8);
        make.centerY.mas_equalTo(self.pictureImageView);
    }];
    [self.contentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(self.pictureImageView.mas_bottom).offset(6);
    }];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentTextLabel);
        make.top.mas_equalTo(self.contentTextLabel.mas_bottom).offset(6);
    }];
    [self.favButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(self.dateLabel);
    }];
    [self.partingLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentTextLabel);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.dateLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(1);
    }];
}

- (void)setModel:(DBBookCommentModel *)model{
    _model = model;
    self.pictureImageView.imageObj = model.avatar;
    self.titleTextLabel.text = model.nick;
    self.contentTextLabel.text = model.content;
    self.dateLabel.text = model.created_at.timeToDate.dateToTimeString;
    self.favButton.selected = [model.fav_arr containIvar:@"user_id" value:DBCommonConfig.userId];
}

- (void)clickFavAction{
    if (!DBCommonConfig.isLogin) {
        [DBCommonConfig toLogin];
        return;
    }
    if (self.favButton.selected) return;
    [DBAFNetWorking postServiceRequestType:DBLinkCommentReplayLike combine:nil parameInterface:@{@"id":DBSafeString(self.model.reply_comment_id)} serviceData:^(BOOL successfulRequest, id  _Nullable result, NSString * _Nullable message) {
        if (successfulRequest){
            self.favButton.selected = YES;
        }
        [UIScreen.appWindow showAlertText:message];
    }];
}

- (UIImageView *)pictureImageView{
    if (!_pictureImageView){
        _pictureImageView = [[UIImageView alloc] init];
        _pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
        _pictureImageView.clipsToBounds = YES;
        _pictureImageView.layer.cornerRadius = 12;
        _pictureImageView.layer.masksToBounds = YES;
    }
    return _pictureImageView;
}

- (DBBaseLabel *)titleTextLabel{
    if (!_titleTextLabel){
        _titleTextLabel = [[DBBaseLabel alloc] init];
        _titleTextLabel.font = DBFontExtension.bodySixTenFont;
        _titleTextLabel.textColor = DBColorExtension.charcoalColor;
    }
    return _titleTextLabel;
}

- (DBBaseLabel *)contentTextLabel{
    if (!_contentTextLabel){
        _contentTextLabel = [[DBBaseLabel alloc] init];
        _contentTextLabel.font = DBFontExtension.bodyMediumFont;
        _contentTextLabel.textColor = DBColorExtension.grayColor;
        _contentTextLabel.numberOfLines = 0;
    }
    return _contentTextLabel;
}

- (DBBaseLabel *)dateLabel{
    if (!_dateLabel){
        _dateLabel = [[DBBaseLabel alloc] init];
        _dateLabel.font = DBFontExtension.bodyMediumFont;
        _dateLabel.textColor = DBColorExtension.grayColor;
    }
    return _dateLabel;
}

- (UIButton *)favButton{
    if (!_favButton){
        _favButton = [[UIButton alloc] init];
        [_favButton setImage:[UIImage imageNamed:@"fav_unsel_icon"] forState:UIControlStateNormal];
        [_favButton setImage:[UIImage imageNamed:@"fav_sel_icon"] forState:UIControlStateSelected];
        [_favButton addTarget:self action:@selector(clickFavAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _favButton;
}

- (UIView *)partingLineView{
    if (!_partingLineView){
        _partingLineView = [[UIView alloc] init];
        _partingLineView.backgroundColor = DBColorExtension.paleGrayColor;
    }
    return _partingLineView;
}
@end
