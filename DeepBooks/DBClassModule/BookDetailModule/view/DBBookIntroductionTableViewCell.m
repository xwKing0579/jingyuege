//
//  DBBookIntroductionTableViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/3.
//

#import "DBBookIntroductionTableViewCell.h"

@interface DBBookIntroductionTableViewCell ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) DBBaseLabel *bookTitleLabel;
@property (nonatomic, strong) DBBaseLabel *bookStateLabel;
@property (nonatomic, strong) DBBaseLabel *bookDescLabel;

@end

@implementation DBBookIntroductionTableViewCell

- (void)setUpSubViews{
    [self.contentView addSubviews:@[self.iconImageView,self.bookTitleLabel,self.bookStateLabel,self.bookDescLabel]];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(UIScreen.navbarSafeHeight+52);
        make.width.mas_equalTo(104);
        make.height.mas_equalTo(132);
    }];
    [self.bookTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(-18);
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(18);
        make.height.mas_equalTo(20);
    }];
    [self.bookStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bookTitleLabel.mas_right).offset(4);
        make.centerY.mas_equalTo(self.bookTitleLabel);
        make.size.mas_equalTo(self.bookStateLabel.size);
    }];
    [self.bookDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(self.bookTitleLabel.mas_bottom).offset(8);
        make.bottom.mas_equalTo(-8);
    }];
}

- (void)setModel:(DBBookDetailModel *)model{
    _model = model;
    self.iconImageView.imageObj = model.image;
    self.bookTitleLabel.text = model.name;
    self.bookStateLabel.text = [DBProcessBookConfig bookStausSimpleDesc:model.status];
    
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:@"jjAdvancementTracker"];
    attachment.bounds = CGRectMake(0, 0, 10, 10);
    NSArray *bookTags = [DBProcessBookConfig bookTagList:model];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    NSMutableAttributedString *authorAttri = [[NSMutableAttributedString alloc] initWithString:model.author];
    [authorAttri addAttributes:@{NSForegroundColorAttributeName:DBColorExtension.sunsetOrangeColor,NSFontAttributeName:DBFontExtension.bodySmallFont} range:NSMakeRange(0, authorAttri.length)];
    [authorAttri appendAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
    [attributedString appendAttributedString:authorAttri];
    
    NSString *point = @" · ";
    NSString *tagsStr = [bookTags componentsJoinedByString:point];
    tagsStr = [NSString stringWithFormat:@"%@%@",point,tagsStr];
    NSMutableAttributedString *tagsAttri = [[NSMutableAttributedString alloc] initWithString:tagsStr];
    [tagsAttri addAttributes:@{NSForegroundColorAttributeName:DBColorExtension.inkWashColor,NSFontAttributeName:DBFontExtension.bodySmallFont} range:NSMakeRange(0, tagsAttri.length)];
    [attributedString appendAttributedString:tagsAttri];
    
    self.bookDescLabel.attributedText = attributedString;
}

- (UIImageView *)iconImageView{
    if (!_iconImageView){
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView.clipsToBounds = YES;
        _iconImageView.layer.cornerRadius = 8;
        _iconImageView.layer.masksToBounds = YES;
    }
    return _iconImageView;
}

- (DBBaseLabel *)bookTitleLabel{
    if (!_bookTitleLabel){
        _bookTitleLabel = [[DBBaseLabel alloc] init];
        _bookTitleLabel.font = DBFontExtension.pingFangSemiboldXXLarge;
        _bookTitleLabel.textColor = DBColorExtension.blackAltColor;
        _bookTitleLabel.textAlignment = NSTextAlignmentRight;
    }
    return _bookTitleLabel;
}

- (DBBaseLabel *)bookStateLabel{
    if (!_bookStateLabel){
        _bookStateLabel = [[DBBaseLabel alloc] init];
        _bookStateLabel.font = DBFontExtension.microFont;
        _bookStateLabel.textColor = DBColorExtension.whiteColor;
        _bookStateLabel.layer.cornerRadius = 10;
        _bookStateLabel.layer.masksToBounds = YES;
        _bookStateLabel.size = CGSizeMake(32, 20);
        _bookStateLabel.textAlignment = NSTextAlignmentCenter;
        _bookStateLabel.backgroundColor = [UIColor gradientColorSize:_bookStateLabel.size direction:DBColorDirectionLevel startColor:DBColorExtension.marmaladeColor endColor:DBColorExtension.coralFlameColor];
    }
    return _bookStateLabel;
}

- (DBBaseLabel *)bookDescLabel{
    if (!_bookDescLabel){
        _bookDescLabel = [[DBBaseLabel alloc] init];
        _bookDescLabel.font = DBFontExtension.bodySixTenFont;
        _bookDescLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _bookDescLabel;
}

@end
