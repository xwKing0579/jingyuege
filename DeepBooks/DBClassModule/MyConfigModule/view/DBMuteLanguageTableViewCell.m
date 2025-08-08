//
//  DBMuteLanguageTableViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/6/18.
//

#import "DBMuteLanguageTableViewCell.h"

@interface DBMuteLanguageTableViewCell ()
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIView *partingLineView;
@end

@implementation DBMuteLanguageTableViewCell

- (void)setUpSubViews{
    [self.contentView addSubviews:@[self.titleTextLabel,self.arrowImageView,self.partingLineView]];
    [self.titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.bottom.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(self.titleTextLabel);
    }];
    [self.partingLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleTextLabel);
        make.right.mas_equalTo(self.arrowImageView);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)setModel:(DBMuteLanguageModel *)model{
    _model = model;
    self.titleTextLabel.text = model.language;
}

- (void)setAbbrev:(NSString *)abbrev{
    _abbrev = abbrev;
    self.arrowImageView.hidden = ![self.model.abbrev isEqualToString:abbrev];
}

- (DBBaseLabel *)titleTextLabel{
    if (!_titleTextLabel){
        _titleTextLabel = [[DBBaseLabel alloc] init];
        _titleTextLabel.font = DBFontExtension.bodySixTenFont;
        _titleTextLabel.textColor = DBColorExtension.charcoalColor;
    }
    return _titleTextLabel;
}

- (UIImageView *)arrowImageView{
    if (!_arrowImageView){
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.contentMode = UIViewContentModeScaleAspectFill;
        _arrowImageView.clipsToBounds = YES;
        _arrowImageView.image = [UIImage imageNamed:@"jjForkedEmblem"];
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
