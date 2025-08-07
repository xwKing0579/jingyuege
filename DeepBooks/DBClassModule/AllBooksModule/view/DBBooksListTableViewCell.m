//
//  DBBooksListTableViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/31.
//

#import "DBBooksListTableViewCell.h"

@interface DBBooksListTableViewCell ()
@property (nonatomic, strong) UIImageView *pictureImageView;
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) DBBaseLabel *contentTextLabel;
@property (nonatomic, strong) DBBaseLabel *descTextLabel;
@end

@implementation DBBooksListTableViewCell

- (void)setUpSubViews{
    CGFloat width = (UIScreen.screenWidth-60)/4;
    [self.contentView addSubviews:@[self.pictureImageView,self.titleTextLabel,self.contentTextLabel,self.descTextLabel]];
    [self.pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(-5);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(width*5/4);
    }];
    
    [self.titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.pictureImageView.mas_right).offset(10);
        make.top.mas_equalTo(self.pictureImageView);
        make.right.mas_equalTo(-10);
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
}

- (void)setModel:(DBBooksModel *)model{
    _model = model;
    
    self.pictureImageView.imageObj = model.image;
    self.titleTextLabel.text = model.name;
    self.contentTextLabel.text = model.remark;
    
    NSMutableArray *booksDesc = [NSMutableArray array];
    
    if (model.author) [booksDesc addObject:model.author];
    if (model.ltype) [booksDesc addObject:model.ltype];
    if (model.stype) [booksDesc addObject:model.stype];

    self.descTextLabel.text = [booksDesc componentsJoinedByString:@" / "];
    
    [self setUserInterfaceStyleOrLight];
}

- (void)setUserInterfaceStyleOrLight{
    if (DBColorExtension.userInterfaceStyle) {
        self.titleTextLabel.textColor = DBColorExtension.lightGrayColor;
        self.contentTextLabel.textColor = DBColorExtension.battleshipGrayColor;
        self.descTextLabel.textColor = DBColorExtension.battleshipGrayColor;
    }else{
        self.titleTextLabel.textColor = DBColorExtension.charcoalColor;
        self.contentTextLabel.textColor = DBColorExtension.grayColor;
        self.descTextLabel.textColor = DBColorExtension.grayColor;
    }
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

@end
