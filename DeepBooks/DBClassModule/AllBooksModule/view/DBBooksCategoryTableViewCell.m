//
//  DBBooksCategoryTableViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/3.
//

#import "DBBooksCategoryTableViewCell.h"

@interface DBBooksCategoryTableViewCell ()
@property (nonatomic, strong) UIImageView *pictureImageView;
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) DBBaseLabel *contentTextLabel;
@property (nonatomic, strong) DBBaseLabel *descTextLabel;
@property (nonatomic, strong) DBBaseLabel *scoreLabel;
@end

@implementation DBBooksCategoryTableViewCell

- (void)setUpSubViews{
    [self.contentView addSubviews:@[self.pictureImageView,self.titleTextLabel,self.contentTextLabel,self.descTextLabel,self.scoreLabel]];
    CGFloat width = (UIScreen.screenWidth-60)/4;
    [self.pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(width*5.0/4.0);
    }];
    
    [self.titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.pictureImageView.mas_right).offset(10);
        make.top.mas_equalTo(self.pictureImageView);
        make.right.mas_equalTo(-66);
    }];
    [self.contentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleTextLabel);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(self.titleTextLabel.mas_bottom).offset(4);
    }];
    [self.descTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentTextLabel);
        make.bottom.mas_equalTo(self.pictureImageView);
    }];
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.pictureImageView);
        make.width.height.mas_equalTo(36);
    }];
}

- (void)setModel:(DBAuthorBooksModel *)model{
    _model = model;
    
    self.pictureImageView.imageObj = model.image;
    self.titleTextLabel.text = model.name;
    self.contentTextLabel.text = model.remark;
    self.descTextLabel.text = [DBCommonConfig bookDesc:model];
    self.scoreLabel.text = model.score;
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
        _titleTextLabel.textColor = DBColorExtension.charcoalColor;
    }
    return _titleTextLabel;
}

- (DBBaseLabel *)contentTextLabel{
    if (!_contentTextLabel){
        _contentTextLabel = [[DBBaseLabel alloc] init];
        _contentTextLabel.font = DBFontExtension.bodyMediumFont;
        _contentTextLabel.textColor = DBColorExtension.grayColor;
        _contentTextLabel.numberOfLines = 2;
    }
    return _contentTextLabel;
}

- (DBBaseLabel *)descTextLabel{
    if (!_descTextLabel){
        _descTextLabel = [[DBBaseLabel alloc] init];
        _descTextLabel.font = DBFontExtension.bodyMediumFont;
        _descTextLabel.textColor = DBColorExtension.grayColor;
    }
    return _descTextLabel;
}

- (DBBaseLabel *)scoreLabel{
    if (!_scoreLabel){
        _scoreLabel = [[DBBaseLabel alloc] init];
        _scoreLabel.font = DBFontExtension.pingFangSemiboldRegular;
        _scoreLabel.textColor = DBColorExtension.whiteColor;
        _scoreLabel.backgroundColor = DBColorExtension.coralColor;
        _scoreLabel.textAlignment = NSTextAlignmentCenter;
        _scoreLabel.layer.cornerRadius = 18;
        _scoreLabel.layer.masksToBounds = YES;
    }
    return _scoreLabel;
}
@end
