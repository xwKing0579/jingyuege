//
//  DBMineIndexCollectionViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/8/10.
//

#import "DBMineIndexCollectionViewCell.h"
#import "DBBookMenuPanView.h"
#import "DBReadBookCatalogsViewController.h"
#import "DBReaderManagerViewController.h"
#import "UIViewController+CWLateralSlide.h"
#import "DBBookCatalogModel.h"

@interface DBMineIndexCollectionViewCell ()
@property (nonatomic, strong) UIImageView *pictureImageView;
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) DBBaseLabel *contentTextLabel;
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) DBBookMenuPanView *panView;
@property (nonatomic, strong) DBBaseLabel *scoreLabel;
@end

@implementation DBMineIndexCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]){
        self.backgroundColor = DBColorExtension.noColor;
        self.contentView.backgroundColor = DBColorExtension.noColor;
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{
    [self.contentView addSubviews:@[self.pictureImageView,self.titleTextLabel,self.contentTextLabel,self.topImageView]];
    [self.pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(self.pictureImageView.mas_width).multipliedBy(5.0/4.0);
    }];
    [self.titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.pictureImageView);
        make.top.mas_equalTo(self.pictureImageView.mas_bottom).offset(4);
    }];
    [self.contentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.pictureImageView);
        make.top.mas_equalTo(self.titleTextLabel.mas_bottom).offset(2);
    }];
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
    }];
    

}


                                                                     
- (void)setModel:(DBBookModel *)model{
    _model = model;
    self.pictureImageView.imageObj = model.image;
    self.titleTextLabel.text = model.name;
    self.contentTextLabel.text = model.author;
    self.topImageView.hidden = !model.is_top;
//    self.scoreLabel.text = [NSString stringWithFormat:DBConstantString.ks_pointsSuffix,model.score];
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
        _titleTextLabel.font = DBFontExtension.bodySmallFont;
        _titleTextLabel.textColor = DBColorExtension.blackAltColor;
        _titleTextLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleTextLabel;
}

- (DBBaseLabel *)contentTextLabel{
    if (!_contentTextLabel){
        _contentTextLabel = [[DBBaseLabel alloc] init];
        _contentTextLabel.font = DBFontExtension.bodySmallFont;
        _contentTextLabel.textColor = DBColorExtension.silverColor;
        _contentTextLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _contentTextLabel;
}

- (UIImageView *)topImageView{
    if (!_topImageView){
        _topImageView = [[UIImageView alloc] init];
        _topImageView.contentMode = UIViewContentModeScaleAspectFill;
        _topImageView.image = [UIImage imageNamed:@"jjApexInsignia"];
    }
    return _topImageView;
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
