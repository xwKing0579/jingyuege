//
//  DBClearBooksCacheTableViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/28.
//

#import "DBClearBooksCacheTableViewCell.h"
#import "DBBookChapterModel.h"

@interface DBClearBooksCacheTableViewCell ()
@property (nonatomic, strong) UIImageView *pictureImageView;
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) DBBaseLabel *contentTextLabel;
@property (nonatomic, strong) DBBaseLabel *descTextLabel;
@property (nonatomic, strong) UIButton *clearButton;
@end

@implementation DBClearBooksCacheTableViewCell

- (void)setUpSubViews{
    [self.contentView addSubviews:@[self.pictureImageView,self.titleTextLabel,self.contentTextLabel,self.descTextLabel,self.clearButton]];
    [self.pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(60*4.0/3.0);
        make.bottom.mas_equalTo(-10);
    }];
    [self.titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.pictureImageView.mas_right).offset(10);
        make.top.mas_equalTo(self.pictureImageView);
    }];
    [self.contentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleTextLabel);
        make.top.mas_equalTo(self.titleTextLabel.mas_bottom).offset(10);
    }];
    [self.descTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleTextLabel);
        make.bottom.mas_equalTo(self.pictureImageView);
    }];
    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(0);
    }];
}

- (void)clickClearAction{
    DBWeakSelf
    NSString *message = [NSString stringWithFormat:DBConstantString.ks_clearBookCacheConfirm,self.model.name];
    LEEAlert.actionsheet.config.LeeTitle(DBConstantString.ks_clearCache).LeeContent(message).
    LeeAction(DBConstantString.ks_confirmCacheClear, ^{
        DBStrongSelfElseReturn
        [DBBookChapterModel removeBookChapter:self.model.chapterForm];
        [UIScreen.currentViewController dynamicAllusionTomethod:@"reloadData"];
    }).LeeCancelAction(DBConstantString.ks_cancel, ^{
        
    }).LeeShow();
}

- (void)setModel:(DBClearBookModel *)model{
    _model = model;
    self.pictureImageView.imageObj = model.image;
    self.titleTextLabel.text = model.name;
    self.contentTextLabel.text = model.author;
    self.descTextLabel.text = model.cacheSize;
    
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
        _titleTextLabel.font = DBFontExtension.bodyMediumFont;
        _titleTextLabel.textColor = DBColorExtension.charcoalColor;
    }
    return _titleTextLabel;
}

- (DBBaseLabel *)contentTextLabel{
    if (!_contentTextLabel){
        _contentTextLabel = [[DBBaseLabel alloc] init];
        _contentTextLabel.font = DBFontExtension.bodySmallFont;
        _contentTextLabel.textColor = DBColorExtension.grayColor;
        _contentTextLabel.numberOfLines = 2;
    }
    return _contentTextLabel;
}

- (DBBaseLabel *)descTextLabel{
    if (!_descTextLabel){
        _descTextLabel = [[DBBaseLabel alloc] init];
        _descTextLabel.font = DBFontExtension.bodySmallFont;
        _descTextLabel.textColor = DBColorExtension.grayColor;
    }
    return _descTextLabel;
}

- (UIButton *)clearButton{
    if (!_clearButton){
        _clearButton = [[UIButton alloc] init];
        _clearButton.layer.cornerRadius = 6;
        _clearButton.layer.masksToBounds = YES;
        _clearButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        _clearButton.titleLabel.font = DBFontExtension.bodyMediumFont;
        [_clearButton setTitle:DBConstantString.ks_clearCache forState:UIControlStateNormal];
        [_clearButton setTitleColor:DBColorExtension.redColor forState:UIControlStateNormal];
        [_clearButton addTarget:self action:@selector(clickClearAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearButton;
}
@end
