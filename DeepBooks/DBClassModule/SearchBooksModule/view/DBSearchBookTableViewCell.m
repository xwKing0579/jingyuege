//
//  DBSearchBookTableViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/23.
//

#import "DBSearchBookTableViewCell.h"

@interface DBSearchBookTableViewCell ()
@property (nonatomic, strong) UIImageView *pictureImageView;
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) DBBaseLabel *contentTextLabel;
@property (nonatomic, strong) DBBaseLabel *descTextLabel;
@end

@implementation DBSearchBookTableViewCell

- (void)setUpSubViews{
    [self.contentView addSubviews:@[self.pictureImageView,self.titleTextLabel,self.contentTextLabel,self.descTextLabel]];
    
    CGFloat width = (UIScreen.screenWidth-60)/4;
    [self.pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(width*5.0/4.0);
        make.bottom.mas_equalTo(-10);
    }];
    [self.titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.pictureImageView.mas_right).offset(10);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(self.pictureImageView);
    }];
    [self.contentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.titleTextLabel);
        make.centerY.mas_equalTo(0);
    }];
    [self.descTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.titleTextLabel);
        make.bottom.mas_equalTo(self.pictureImageView);
    }];
}

- (void)setSearchWords:(NSString *)searchWords{
    _searchWords = searchWords;
}

- (void)setModel:(DBSearchBooksModel *)model{
    _model = model;
    self.pictureImageView.imageObj = model.image;
    
    self.titleTextLabel.attributedText = [model.name lightContent:_searchWords lightColor:DBColorExtension.sunsetOrangeColor];
    self.contentTextLabel.attributedText = [model.remark lightContent:_searchWords lightColor:DBColorExtension.sunsetOrangeColor];
    NSMutableArray *result = [NSMutableArray array];
    if (model.author.length) [result addObject:model.author];
    if (model.ltype.length) [result addObject:model.ltype];
    if (model.stype.length) [result addObject:model.stype];
    self.descTextLabel.text = [result componentsJoinedByString:@" / "];
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
        _descTextLabel.textColor = DBColorExtension.mediumGrayColor;
    }
    return _descTextLabel;
}

@end
