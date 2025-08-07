//
//  DBExchangeTableViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/1.
//

#import "DBExchangeTableViewCell.h"

@interface DBExchangeTableViewCell ()
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) DBBaseLabel *contentTextLabel;
@property (nonatomic, strong) DBBaseLabel *descTextLabel;
@end

@implementation DBExchangeTableViewCell

- (void)setUpSubViews{
    [self.contentView addSubviews:@[self.titleTextLabel,self.contentTextLabel,self.descTextLabel]];
    [self.titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(12);
    }];
    [self.contentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleTextLabel);
        make.top.mas_equalTo(self.titleTextLabel.mas_bottom).offset(2);
        make.bottom.mas_equalTo(-12);
    }];
    [self.descTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(0);
    }];
}


- (DBBaseLabel *)titleTextLabel{
    if (!_titleTextLabel){
        _titleTextLabel = [[DBBaseLabel alloc] init];
        _titleTextLabel.font = DBFontExtension.bodySixTenFont;
        _titleTextLabel.textColor = DBColorExtension.blackAltColor;
        _titleTextLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleTextLabel;
}

- (DBBaseLabel *)contentTextLabel{
    if (!_contentTextLabel){
        _contentTextLabel = [[DBBaseLabel alloc] init];
        _contentTextLabel.font = DBFontExtension.bodySmallFont;
        _contentTextLabel.textColor = DBColorExtension.inkWashColor;
        _contentTextLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _contentTextLabel;
}

- (DBBaseLabel *)descTextLabel{
    if (!_descTextLabel){
        _descTextLabel = [[DBBaseLabel alloc] init];
        _descTextLabel.font = DBFontExtension.pingFangMediumLarge;
        _descTextLabel.textColor = DBColorExtension.sunsetOrangeColor;
        _descTextLabel.textAlignment = NSTextAlignmentRight;
    }
    return _descTextLabel;
}
@end
