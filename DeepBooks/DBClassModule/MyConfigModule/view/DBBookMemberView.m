//
//  DBBookMemberView.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/1.
//

#import "DBBookMemberView.h"

@interface DBBookMemberView ()
@property (nonatomic, strong) UIImageView *pictureImageView;
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) DBBaseLabel *dateValidityLabel;
@property (nonatomic, strong) UIButton *renewalButton;
@end

@implementation DBBookMemberView

- (instancetype)init{
    if (self == [super init]){
        [self setUpSubViews];
    }
    return self;
}


- (void)setUpSubViews{
    [self addSubviews:@[self.pictureImageView,self.titleTextLabel,self.dateValidityLabel,self.renewalButton]];
    [self.pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.mas_equalTo(14);
        make.width.height.mas_equalTo(36);
    }];
    [self.titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(72);
        make.top.mas_equalTo(16);
    }];
    [self.dateValidityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleTextLabel);
        make.top.mas_equalTo(36);
    }];
    [self.renewalButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-24);
        make.top.mas_equalTo(16);
        make.size.mas_equalTo(self.renewalButton.size);
    }];
}

- (void)setDateValidity:(NSString *)dateValidity{
    _dateValidity = dateValidity;
    NSString *validity = DBConstantString.ks_expiryDate.textMultilingual;
    self.dateValidityLabel.text = [NSString stringWithFormat:@"%@ %@",validity,dateValidity];
}

- (UIImageView *)pictureImageView{
    if (!_pictureImageView){
        _pictureImageView = [[UIImageView alloc] init];
        _pictureImageView.image = [UIImage imageNamed:@""];
        _pictureImageView.layer.cornerRadius = 18;
        _pictureImageView.layer.masksToBounds = YES;
    }
    return _pictureImageView;
}

- (DBBaseLabel *)titleTextLabel{
    if (!_titleTextLabel){
        _titleTextLabel = [[DBBaseLabel alloc] init];
        _titleTextLabel.font = DBFontExtension.bodySixTenFont;
        _titleTextLabel.textColor = DBColorExtension.blackAltColor;
    }
    return _titleTextLabel;
}

- (DBBaseLabel *)dateValidityLabel{
    if (!_dateValidityLabel){
        _dateValidityLabel = [[DBBaseLabel alloc] init];
        _dateValidityLabel.font = DBFontExtension.microFont;
        _dateValidityLabel.textColor = DBColorExtension.fogSilverColor;
    }
    return _dateValidityLabel;
}

- (UIButton *)renewalButton{
    if (!_renewalButton){
        _renewalButton = [[UIButton alloc] init];
        _renewalButton.layer.cornerRadius = 16;
        _renewalButton.layer.masksToBounds = YES;
        _renewalButton.size = CGSizeMake(80, 32);
        _renewalButton.backgroundColor = [UIColor gradientColorSize:_renewalButton.size direction:DBColorDirectionDownDiagonalLine startColor:DBColorExtension.duneGoldColor endColor:DBColorExtension.silkCreamColor];
    }
    return _renewalButton;
}

@end
