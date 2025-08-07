//
//  DBAllBooksItemView.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/1.
//

#import "DBAllBooksItemView.h"

@implementation DBAllBooksItemView

- (instancetype)init{
    if (self == [super init]){
        [self setUpSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]){
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{
    [self addSubviews:@[self.pictureImageView,self.titleTextLabel,self.authorLabel]];
    [self.pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(self.pictureImageView.mas_width).multipliedBy(4.0/3.0);
    }];
    [self.titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.pictureImageView.mas_bottom).offset(8);
    }];
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.titleTextLabel.mas_bottom).offset(4);
    }];

}

- (UIImageView *)pictureImageView{
    if (!_pictureImageView){
        _pictureImageView = [[UIImageView alloc] init];
        _pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
        _pictureImageView.clipsToBounds = YES;
        _pictureImageView.layer.cornerRadius = 8;
        _pictureImageView.layer.masksToBounds = YES;
        
        [_pictureImageView addSubview:self.scoreLabel];
        [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
            make.size.mas_equalTo(self.scoreLabel.size);
        }];
    }
    return _pictureImageView;
}

- (DBBaseLabel *)titleTextLabel{
    if (!_titleTextLabel){
        _titleTextLabel = [[DBBaseLabel alloc] init];
        _titleTextLabel.font = DBFontExtension.pingFangMediumRegular;
        _titleTextLabel.textColor = DBColorExtension.blackAltColor;
        _titleTextLabel.textAlignment = NSTextAlignmentCenter;
        _titleTextLabel.numberOfLines = 2;
    }
    return _titleTextLabel;
}

- (DBBaseLabel *)authorLabel{
    if (!_authorLabel){
        _authorLabel = [[DBBaseLabel alloc] init];
        _authorLabel.font = DBFontExtension.bodySmallFont;
        _authorLabel.textColor = DBColorExtension.inkWashColor;
        _authorLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _authorLabel;
}

- (DBBaseLabel *)scoreLabel{
    if (!_scoreLabel){
        _scoreLabel = [[DBBaseLabel alloc] init];
        _scoreLabel.font = DBFontExtension.microFont;
        _scoreLabel.textColor = DBColorExtension.whiteColor;
        _scoreLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _scoreLabel.textAlignment = NSTextAlignmentCenter;
        _scoreLabel.size = CGSizeMake(35, 20);
        [_scoreLabel addRoudCorners:UIRectCornerBottomRight cornerRadii:CGSizeMake(8, 8)];
    }
    return _scoreLabel;
}

@end
