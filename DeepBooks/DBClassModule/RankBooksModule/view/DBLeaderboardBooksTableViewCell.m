//
//  DBLeaderboardBooksTableViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/1.
//

#import "DBLeaderboardBooksTableViewCell.h"

@interface DBLeaderboardBooksTableViewCell ()
@property (nonatomic, strong) UIImageView *pictureImageView;
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) DBBaseLabel *contentTextLabel;
@property (nonatomic, strong) DBBaseLabel *descTextLabel;

@property (nonatomic, strong) UIImageView *rankImageView;
@property (nonatomic, strong) DBBaseLabel *rankLabel;
@end

@implementation DBLeaderboardBooksTableViewCell

- (void)setUpSubViews{
    [self.contentView addSubviews:@[self.pictureImageView,self.titleTextLabel,self.contentTextLabel,self.descTextLabel,self.rankImageView,self.rankLabel]];
    
    CGFloat width = (UIScreen.screenWidth-60)/4;
    [self.pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
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
    [self.rankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.pictureImageView);
        make.width.height.mas_equalTo(32);
    }];
    [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.pictureImageView);
        make.width.height.mas_equalTo(32);
    }];
}

- (void)setModel:(DBBooksDataModel *)model{
    _model = model;
    self.pictureImageView.imageObj = model.image;
    self.titleTextLabel.text = model.name;
    
    self.contentTextLabel.text = [DBCommonConfig bookContainAuthorDesc:model];
    self.descTextLabel.text = model.author;
}

- (void)setRank:(NSInteger)rank{
    _rank = rank;
    
    switch (rank) {
        case 1:
        case 2:
        case 3:
        {
            self.rankImageView.hidden = NO;
            self.rankLabel.hidden = YES;
 
            self.rankImageView.imageObj = [NSString stringWithFormat:@"book_rank_%ld",rank];
        }
            break;
            
        default:
        {
            self.rankImageView.hidden = YES;
            self.rankLabel.hidden = NO;
            self.rankLabel.text = [NSString stringWithFormat:@"%02ld",rank];
        }
            break;
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
        _titleTextLabel.font = DBFontExtension.pingFangMediumMedium;
        _titleTextLabel.textColor = DBColorExtension.blackAltColor;
    }
    return _titleTextLabel;
}

- (DBBaseLabel *)contentTextLabel{
    if (!_contentTextLabel){
        _contentTextLabel = [[DBBaseLabel alloc] init];
        _contentTextLabel.font = DBFontExtension.bodySmallFont;
        _contentTextLabel.textColor = DBColorExtension.inkWashColor;
        _contentTextLabel.numberOfLines = 2;
    }
    return _contentTextLabel;
}

- (DBBaseLabel *)descTextLabel{
    if (!_descTextLabel){
        _descTextLabel = [[DBBaseLabel alloc] init];
        _descTextLabel.font = DBFontExtension.bodySmallFont;
        _descTextLabel.textColor = DBColorExtension.mediumGrayColor;
    }
    return _descTextLabel;
}

- (UIImageView *)rankImageView{
    if (!_rankImageView){
        _rankImageView = [[UIImageView alloc] init];
        _rankImageView.contentMode = UIViewContentModeScaleAspectFill;
        _rankImageView.clipsToBounds = YES;
        _rankImageView.layer.cornerRadius = 16;
        _rankImageView.layer.masksToBounds = YES;
    }
    return _rankImageView;
}

- (DBBaseLabel *)rankLabel{
    if (!_rankLabel){
        _rankLabel = [[DBBaseLabel alloc] init];
        _rankLabel.font = DBFontExtension.pingFangMediumLarge;
        _rankLabel.textColor = DBColorExtension.whiteColor;
        _rankLabel.backgroundColor = DBColorExtension.coralColor;
        _rankLabel.layer.cornerRadius = 16;
        _rankLabel.layer.masksToBounds = YES;
        _rankLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rankLabel;
}
@end
