//
//  DBBookAddCollectionViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/10.
//

#import "DBBookAddCollectionViewCell.h"

@interface DBBookAddCollectionViewCell ()
@property (nonatomic, strong) UIImageView *addBookImageView;
@property (nonatomic, strong) DBBaseLabel *contentTextLabel;
@end

@implementation DBBookAddCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]){
        self.backgroundColor = DBColorExtension.noColor;
        self.contentView.backgroundColor = DBColorExtension.noColor;
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{
    [self.contentView addSubviews:@[self.addBookImageView,self.contentTextLabel]];
    [self.addBookImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
    }];
    [self.contentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.left.right.mas_equalTo(self.addBookImageView);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(self.addBookImageView.mas_bottom).offset(10);
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

- (DBBaseLabel *)contentTextLabel{
    if (!_contentTextLabel){
        _contentTextLabel = [[DBBaseLabel alloc] init];
        _contentTextLabel.font = DBFontExtension.bodySmallFont;
        _contentTextLabel.textColor = DBColorExtension.sunsetOrangeColor;
        _contentTextLabel.textAlignment = NSTextAlignmentCenter;
        _contentTextLabel.text = @"去书城逛逛";
        _contentTextLabel.layer.cornerRadius = 15;
        _contentTextLabel.layer.masksToBounds = YES;
        _contentTextLabel.backgroundColor = DBColorExtension.blushMistColor;
    }
    return _contentTextLabel;
}
@end
