//
//  DBBookTypesCollectionViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/22.
//

#import "DBBookTypesCollectionViewCell.h"

@interface DBBookTypesCollectionViewCell ()
@property (nonatomic, strong) UIView *containerBoxView;
@property (nonatomic, strong) UIImageView *pictureImageView;
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) DBBaseLabel *contentTextLabel;
@end

@implementation DBBookTypesCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]){
        self.backgroundColor = DBColorExtension.noColor;
        self.contentView.backgroundColor = DBColorExtension.noColor;
        [self setUpSubViews];
    }
    return self;
}

- (void)setModel:(DBBookTypesGenderModel *)model{
    _model = model;
    NSString *imageUrl = model.ltype_image;
    self.pictureImageView.imageObj = imageUrl;
   
    self.titleTextLabel.text = model.ltype_name;
    self.contentTextLabel.text = model.ltype_desc;
}

- (void)setUpSubViews{
    [self.contentView addSubviews:@[self.containerBoxView]];
    [self.containerBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(6);
        make.right.mas_equalTo(-6);
        make.top.mas_equalTo(8);
        make.bottom.mas_equalTo(-8);
    }];
    [self.containerBoxView addSubviews:@[self.pictureImageView,self.titleTextLabel,self.contentTextLabel]];

    [self.pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(16);
        make.bottom.mas_equalTo(-16);
        make.width.mas_equalTo(43.0);
        make.height.mas_equalTo(54.0);
    }];
    [self.titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.pictureImageView.mas_right).offset(8);
        make.right.mas_equalTo(-8);
        make.top.mas_equalTo(21);
        make.height.mas_equalTo(24);
    }];
    [self.contentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.titleTextLabel);
        make.top.mas_equalTo(self.titleTextLabel.mas_bottom).offset(2);
    }];
}

- (UIView *)containerBoxView{
    if (!_containerBoxView){
        _containerBoxView = [[UIView alloc] init];
        _containerBoxView.layer.cornerRadius = 12;
        _containerBoxView.layer.masksToBounds = YES;
        _containerBoxView.backgroundColor = DBColorExtension.diatomColor;
    }
    return _containerBoxView;
}

- (UIImageView *)pictureImageView{
    if (!_pictureImageView){
        _pictureImageView = [[UIImageView alloc] init];
        _pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
        _pictureImageView.clipsToBounds = YES;
        _pictureImageView.layer.cornerRadius = 4;
        _pictureImageView.layer.masksToBounds = YES;
    }
    return _pictureImageView;
}


- (DBBaseLabel *)titleTextLabel{
    if (!_titleTextLabel){
        _titleTextLabel = [[DBBaseLabel alloc] init];
        _titleTextLabel.font = DBFontExtension.pingFangSemiboldLarge;
        _titleTextLabel.textColor = DBColorExtension.blackAltColor;
    }
    return _titleTextLabel;
}

- (DBBaseLabel *)contentTextLabel{
    if (!_contentTextLabel){
        _contentTextLabel = [[DBBaseLabel alloc] init];
        _contentTextLabel.font = DBFontExtension.bodySmallFont;
        _contentTextLabel.textColor = DBColorExtension.ashWhiteColor;
    }
    return _contentTextLabel;
}

@end
