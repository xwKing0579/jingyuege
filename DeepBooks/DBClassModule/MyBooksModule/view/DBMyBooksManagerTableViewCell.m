//
//  DBMyBooksManagerTableViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/21.
//

#import "DBMyBooksManagerTableViewCell.h"
#import "DBBookCatalogModel.h"
@interface DBMyBooksManagerTableViewCell ()
@property (nonatomic, strong) UIButton *choiceButton;
@property (nonatomic, strong) UIImageView *pictureImageView;
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) DBBaseLabel *contentTextLabel;
@property (nonatomic, strong) DBBaseLabel *descTextLabel;
@end

@implementation DBMyBooksManagerTableViewCell

- (void)setUpSubViews{
    [self.contentView addSubviews:@[self.choiceButton,self.pictureImageView,self.titleTextLabel,self.contentTextLabel,self.descTextLabel]];
    [self.choiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.centerY.mas_equalTo(0);
    }];
    CGFloat width = 60;
    [self.pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(width*5.0/4.0);
        make.top.mas_equalTo(6);
        make.bottom.mas_equalTo(-6);
    }];
    [self.titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.pictureImageView);
        make.left.mas_equalTo(self.pictureImageView.mas_right).offset(10);
        make.right.mas_equalTo(-10);
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

- (void)setModel:(DBMyBooksManagerModel *)model{
    _model = model;
    self.choiceButton.selected = model.isSelect;
    self.pictureImageView.imageObj = model.image;
    self.titleTextLabel.text = model.name;
    self.contentTextLabel.text = model.last_chapter_name;
    if (DBCommonConfig.switchAudit){
        NSArray *chapters = [DBBookCatalogModel getBookCatalogs:model.catalogForm];
        if (model.updateTime == 0) {
            self.descTextLabel.text = @"未阅读";
        }else{
            self.descTextLabel.text = [NSString stringWithFormat:@"已读：%.0lf%%",((CGFloat)model.chapter_index+1)/chapters.count*100.0];
        }
    }else{
        self.descTextLabel.text = [DBCommonConfig bookReadingProgress:model.readChapterName];
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
        _titleTextLabel.font = DBFontExtension.bodyMediumFont;
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

- (UIButton *)choiceButton{
    if (!_choiceButton){
        _choiceButton = [[UIButton alloc] init];
        [_choiceButton setImage:[UIImage imageNamed:@"unsel_icon"] forState:UIControlStateNormal];
        [_choiceButton setImage:[UIImage imageNamed:@"sel_icon"] forState:UIControlStateSelected];
        _choiceButton.userInteractionEnabled = NO;
    }
    return _choiceButton;
}

@end
