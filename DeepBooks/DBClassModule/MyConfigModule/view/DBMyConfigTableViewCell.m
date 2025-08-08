//
//  DBMyConfigTableViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/27.
//

#import "DBMyConfigTableViewCell.h"

@interface DBMyConfigTableViewCell ()
@property (nonatomic, strong) UIImageView *pictureImageView;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) DBBaseLabel *countLabel;
@end

@implementation DBMyConfigTableViewCell

- (void)setUpSubViews{
    [self.contentView addSubviews:@[self.pictureImageView,self.titleTextLabel,self.countLabel,self.arrowImageView]];
    [self.pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(14);
        make.bottom.mas_equalTo(-14);
        make.width.height.mas_equalTo(28);
    }];
    [self.titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.pictureImageView.mas_right).offset(12);
        make.centerY.mas_equalTo(0);
    }];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-33);
        make.centerY.mas_equalTo(0);
        make.width.mas_lessThanOrEqualTo(UIScreen.screenWidth-180);
    }];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(0);
    }];
}

- (void)setModel:(DBMyConfigModel *)model{
    _model = model;
    
    self.titleTextLabel.text = model.name;
    self.countLabel.text = model.content;
    [self setUserInterfaceStyleOrLight];
}

- (void)setUserInterfaceStyleOrLight{
    UIImage *originalImage = [UIImage imageNamed:self.model.icon];
    self.pictureImageView.image = originalImage;
    if (DBColorExtension.userInterfaceStyle) {
        self.titleTextLabel.textColor = DBColorExtension.whiteAltColor;
    }else{
        self.titleTextLabel.textColor = DBColorExtension.blackAltColor;
    }
}

- (UIImageView *)pictureImageView{
    if (!_pictureImageView){
        _pictureImageView = [[UIImageView alloc] init];
        _pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
        _pictureImageView.clipsToBounds = YES;
    }
    return _pictureImageView;
}

- (UIImageView *)arrowImageView{
    if (!_arrowImageView){
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.contentMode = UIViewContentModeScaleAspectFill;
        _arrowImageView.clipsToBounds = YES;
        _arrowImageView.image = [UIImage imageNamed:@"jjPrecisionTrajectory"];
    }
    return _arrowImageView;
}

- (DBBaseLabel *)titleTextLabel{
    if (!_titleTextLabel){
        _titleTextLabel = [[DBBaseLabel alloc] init];
        _titleTextLabel.font = DBFontExtension.bodySixTenFont;
        _titleTextLabel.textColor = DBColorExtension.blackAltColor;
    }
    return _titleTextLabel;
}

- (DBBaseLabel *)countLabel{
    if (!_countLabel){
        _countLabel = [[DBBaseLabel alloc] init];
        _countLabel.font = DBFontExtension.bodyMediumFont;
        _countLabel.textColor = DBColorExtension.inkWashColor;
        _countLabel.textAlignment = NSTextAlignmentRight;
    }
    return _countLabel;
}

@end
