//
//  DBBookAddExpandCollectionViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/2.
//

#import "DBBookAddExpandCollectionViewCell.h"

@interface DBBookAddExpandCollectionViewCell ()
@property (nonatomic, strong) UIImageView *addBookImageView;
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) DBBaseLabel *contentTextLabel;
@end

@implementation DBBookAddExpandCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]){
        self.backgroundColor = DBColorExtension.noColor;
        self.contentView.backgroundColor = DBColorExtension.noColor;
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{
    [self.contentView addSubviews:@[self.addBookImageView,self.titleTextLabel,self.contentTextLabel]];
    CGFloat width = (UIScreen.screenWidth-60)/4;
    [self.addBookImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(10);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(width*5.0/4.0);
        make.bottom.mas_equalTo(-10);
    }];
    [self.titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.addBookImageView.mas_right).offset(12);
        make.top.mas_equalTo(self.addBookImageView.mas_top).offset(20);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(18);
    }];
    [self.contentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleTextLabel);
        make.top.mas_equalTo(self.titleTextLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(84);
        make.height.mas_equalTo(30);
    }];
}

- (UIImageView *)addBookImageView{
    if (!_addBookImageView){
        _addBookImageView = [[UIImageView alloc] init];
        _addBookImageView.image = [UIImage imageNamed:@"jjTomeAugment"];
        _addBookImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _addBookImageView;
}

- (DBBaseLabel *)titleTextLabel{
    if (!_titleTextLabel){
        _titleTextLabel = [[DBBaseLabel alloc] init];
        _titleTextLabel.font = DBFontExtension.bodySmallFont;
        _titleTextLabel.textColor = DBColorExtension.inkWashColor;
        _titleTextLabel.textAlignment = NSTextAlignmentLeft;
        _titleTextLabel.text = DBConstantString.ks_addFavorites;
    }
    return _titleTextLabel;
}

- (DBBaseLabel *)contentTextLabel{
    if (!_contentTextLabel){
        _contentTextLabel = [[DBBaseLabel alloc] init];
        _contentTextLabel.font = DBFontExtension.bodySmallFont;
        _contentTextLabel.textColor = DBColorExtension.sunsetOrangeColor;
        _contentTextLabel.textAlignment = NSTextAlignmentCenter;
        _contentTextLabel.text = DBConstantString.ks_goToBookstore;
        _contentTextLabel.layer.cornerRadius = 15;
        _contentTextLabel.layer.masksToBounds = YES;
        _contentTextLabel.backgroundColor = DBColorExtension.blushMistColor;
    }
    return _contentTextLabel;
}
@end
