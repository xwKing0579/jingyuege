//
//  DEUserSettingTableViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/25.
//

#import "DEUserSettingTableViewCell.h"

@interface DEUserSettingTableViewCell ()
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) DBBaseLabel *contentTextLabel;
@property (nonatomic, strong) UIImageView *pictureImageView;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIView *partingLineView;
@end

@implementation DEUserSettingTableViewCell

- (void)setUpSubViews{
    [self.contentView addSubviews:@[self.titleTextLabel,self.contentTextLabel,self.pictureImageView,self.arrowImageView,self.partingLineView]];
    [self.titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(16);
    }];
    [self.contentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-40);
        make.centerY.mas_equalTo(0);
    }];
    [self.pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-40);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(60);
    }];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(0);
    }];
    [self.partingLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)setModel:(DBUserSettingModel *)model{
    _model = model;
    self.titleTextLabel.text = model.title;
   
    if (model.avater){
        self.contentTextLabel.hidden = YES;
        self.pictureImageView.hidden = NO;
        self.pictureImageView.imageObj = model.avater;
    }else{
        self.contentTextLabel.hidden = NO;
        self.pictureImageView.hidden = YES;
        self.contentTextLabel.text = model.content;
    }
    
    self.arrowImageView.hidden = !model.isArrow;
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
        _contentTextLabel.font = DBFontExtension.bodySixTenFont;
        _contentTextLabel.textColor = DBColorExtension.grayColor;
        _contentTextLabel.textAlignment = NSTextAlignmentRight;
    }
    return _contentTextLabel;
}

- (UIImageView *)pictureImageView{
    if (!_pictureImageView){
        _pictureImageView = [[UIImageView alloc] init];
        _pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
        _pictureImageView.hidden = YES;
        _pictureImageView.layer.cornerRadius = 6;
        _pictureImageView.layer.masksToBounds = YES;
    }
    return _pictureImageView;
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

- (UIView *)partingLineView{
    if (!_partingLineView){
        _partingLineView = [[UIView alloc] init];
        _partingLineView.backgroundColor = DBColorExtension.paleGrayColor;
    }
    return _partingLineView;
}

@end
