//
//  DBMyBookListTableViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/3.
//

#import "DBMyBookListTableViewCell.h"
@interface DBMyBookListTableViewCell ()
@property (nonatomic, strong) UIImageView *pictureImageView1;
@property (nonatomic, strong) UIImageView *pictureImageView2;
@property (nonatomic, strong) UIImageView *pictureImageView3;
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) DBBaseLabel *contentTextLabel;
@property (nonatomic, strong) DBBaseLabel *descTextLabel;
@end

@implementation DBMyBookListTableViewCell

- (void)setUpSubViews{
    CGFloat width = (UIScreen.screenWidth-60)/4;
    [self.contentView addSubviews:@[self.pictureImageView3,self.pictureImageView2,self.pictureImageView1,self.titleTextLabel,self.contentTextLabel,self.descTextLabel]];
    [self.pictureImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(8);
        make.bottom.mas_equalTo(-8);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(width*5/4);
    }];
    [self.pictureImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(self.pictureImageView1).multipliedBy(0.8);
        make.right.mas_equalTo(self.pictureImageView1).offset(10);
        make.bottom.mas_equalTo(self.pictureImageView1);
    }];
    [self.pictureImageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(self.pictureImageView2).multipliedBy(0.8);
        make.right.mas_equalTo(self.pictureImageView2).offset(10);
        make.bottom.mas_equalTo(self.pictureImageView2);
    }];
    [self.titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.pictureImageView1.mas_right).offset(30);
        make.top.mas_equalTo(self.pictureImageView1);
        make.right.mas_equalTo(-10);
    }];
    [self.contentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleTextLabel);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(self.titleTextLabel.mas_bottom).offset(4);
    }];
    [self.descTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentTextLabel);
        make.bottom.mas_equalTo(self.pictureImageView1);
    }];
}

- (void)setModel:(DBBooksListModel *)model{
    _model = model;
    self.titleTextLabel.text = model.title;
    self.contentTextLabel.text = model.remark;
    if (DBCommonConfig.switchAudit){
        self.descTextLabel.text = [NSString stringWithFormat:DBConstantString.ks_bookCountFormat,model.book_count];
    }else{
        self.descTextLabel.text = [NSString stringWithFormat:DBConstantString.ks_booksAndFavorites,model.book_count,model.fav_count];
    }
   
    
    if (model.books.count > 0){
        self.pictureImageView1.imageObj = model.books[0].image;
    }
    if (model.books.count > 1){
        self.pictureImageView2.hidden = NO;
        self.pictureImageView2.imageObj = model.books[1].image;
    }else{
        self.pictureImageView2.hidden = YES;
    }
    if (model.books.count > 2){
        self.pictureImageView3.hidden = NO;
        self.pictureImageView3.imageObj = model.books[2].image;
    }else{
        self.pictureImageView3.hidden = YES;
    }
}

- (UIImageView *)pictureImageView1{
    if (!_pictureImageView1){
        _pictureImageView1 = [[UIImageView alloc] init];
        _pictureImageView1.contentMode = UIViewContentModeScaleAspectFill;
        _pictureImageView1.clipsToBounds = YES;
        _pictureImageView1.layer.cornerRadius = 4;
        _pictureImageView1.layer.masksToBounds = YES;
    }
    return _pictureImageView1;
}

- (UIImageView *)pictureImageView2{
    if (!_pictureImageView2){
        _pictureImageView2 = [[UIImageView alloc] init];
        _pictureImageView2.contentMode = UIViewContentModeScaleAspectFill;
        _pictureImageView2.clipsToBounds = YES;
        _pictureImageView2.layer.cornerRadius = 4;
        _pictureImageView2.layer.masksToBounds = YES;
    }
    return _pictureImageView2;
}

- (UIImageView *)pictureImageView3{
    if (!_pictureImageView3){
        _pictureImageView3 = [[UIImageView alloc] init];
        _pictureImageView3.contentMode = UIViewContentModeScaleAspectFill;
        _pictureImageView3.clipsToBounds = YES;
        _pictureImageView3.layer.cornerRadius = 4;
        _pictureImageView3.layer.masksToBounds = YES;
    }
    return _pictureImageView3;
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
        _descTextLabel.font = DBFontExtension.bodyMediumFont;
        _descTextLabel.textColor = DBColorExtension.grayColor;
    }
    return _descTextLabel;
}
@end
