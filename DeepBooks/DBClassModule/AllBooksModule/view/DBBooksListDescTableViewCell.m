//
//  DBBooksListDescTableViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/1.
//

#import "DBBooksListDescTableViewCell.h"

@interface DBBooksListDescTableViewCell ()
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) DBBaseLabel *contentTextLabel;
@end

@implementation DBBooksListDescTableViewCell

- (void)setUpSubViews{
    [self.contentView addSubviews:@[self.titleTextLabel,self.contentTextLabel]];
    [self.titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(10);
    }];
    [self.contentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(self.titleTextLabel.mas_bottom).offset(6);
        make.bottom.mas_equalTo(-10);
    }];
}

- (void)setModel:(DBBooksListModel *)model{
    _model = model;
    self.contentTextLabel.text = model.remark;
    
    [self setUserInterfaceStyleOrLight];
}

- (void)setUserInterfaceStyleOrLight{
    if (DBColorExtension.userInterfaceStyle) {
        self.contentTextLabel.textColor = DBColorExtension.slateGrayColor;
    }else{
        self.contentTextLabel.textColor = DBColorExtension.grayColor;
    }
}

- (DBBaseLabel *)titleTextLabel{
    if (!_titleTextLabel){
        _titleTextLabel = [[DBBaseLabel alloc] init];
        _titleTextLabel.font = DBFontExtension.bodySmallFont;
        _titleTextLabel.textColor = DBColorExtension.charcoalColor;
        _titleTextLabel.text = @"书单简介：";
    }
    return _titleTextLabel;
}

- (DBBaseLabel *)contentTextLabel{
    if (!_contentTextLabel){
        _contentTextLabel = [[DBBaseLabel alloc] init];
        _contentTextLabel.font = DBFontExtension.bodySmallFont;
        _contentTextLabel.textColor = DBColorExtension.grayColor;
        _contentTextLabel.numberOfLines = 0;
    }
    return _contentTextLabel;
}
@end
