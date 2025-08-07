//
//  DBBooksItemView.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/1.
//

#import "DBBooksItemView.h"

@interface DBBooksItemView ()
@property (nonatomic, strong) UIImageView *pictureImageView;
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) DBBaseLabel *contentTextLabel;
@property (nonatomic, strong) DBBaseLabel *descTextLabel;
@property (nonatomic, strong) DBBaseLabel *scoreLabel;
@property (nonatomic, strong) UIView *containerBoxView;
@end

@implementation DBBooksItemView

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
    CGFloat width = 87;
    [self addSubviews:@[self.pictureImageView,self.titleTextLabel,self.contentTextLabel,self.descTextLabel,self.scoreLabel,self.containerBoxView]];
    [self.pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(12);
        make.bottom.mas_equalTo(-12);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(width*5/4);
    }];
    
    [self.titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.pictureImageView.mas_right).offset(12);
        make.top.mas_equalTo(self.pictureImageView);
        make.right.mas_equalTo(-66);
        make.height.mas_equalTo(24);
    }];
    [self.contentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleTextLabel);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(self.titleTextLabel.mas_bottom).offset(2);
        make.height.mas_equalTo(18);
    }];
    [self.descTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentTextLabel);
        make.top.mas_equalTo(self.contentTextLabel.mas_bottom).offset(4);
    }];
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.centerY.mas_equalTo(self.titleTextLabel);
        make.width.mas_equalTo(46);
        make.height.mas_equalTo(22);
    }];
    [self.containerBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleTextLabel);
        make.bottom.mas_equalTo(self.pictureImageView);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
}

- (void)setModel:(DBBooksDataModel *)model{
    _model = model;
    self.pictureImageView.imageObj = model.image;
    self.titleTextLabel.text = model.name;
    self.contentTextLabel.text = model.author;
    self.descTextLabel.text = model.remark;
    self.scoreLabel.text = model.score;
    
    [self.containerBoxView removeAllSubView];
    CGFloat left = 0;
    for (NSString *tagStr in [DBProcessBookConfig bookTagList:model]) {
        UIFont *font = DBFontExtension.microFont;
        CGRect textRect = [tagStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 19)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName: font}
                                             context:nil];
        CGFloat width = textRect.size.width;
        if (left + width + 36 > UIScreen.screenWidth-132) break;
        DBBaseLabel *tagLabel = [[DBBaseLabel alloc] initWithFrame:CGRectMake(left, 0, width+12, 20)];
        tagLabel.font = font;
        tagLabel.text = tagStr;
        tagLabel.layer.cornerRadius = 10;
        tagLabel.layer.masksToBounds = YES;
        tagLabel.textColor = DBColorExtension.sunsetOrangeColor;
        tagLabel.backgroundColor = DBColorExtension.blushMistColor;
        tagLabel.textColor = DBColorExtension.sunsetOrangeColor;
        tagLabel.textAlignment = NSTextAlignmentCenter;
        [self.containerBoxView addSubview:tagLabel];
        left += width + 16;
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
    }
    return _contentTextLabel;
}

- (DBBaseLabel *)descTextLabel{
    if (!_descTextLabel){
        _descTextLabel = [[DBBaseLabel alloc] init];
        _descTextLabel.font = DBFontExtension.bodySmallFont;
        _descTextLabel.textColor = DBColorExtension.grayColor;
        _descTextLabel.numberOfLines = 2;
    }
    return _descTextLabel;
}

- (DBBaseLabel *)scoreLabel{
    if (!_scoreLabel){
        _scoreLabel = [[DBBaseLabel alloc] init];
        _scoreLabel.size = CGSizeMake(46, 22);
        _scoreLabel.font = DBFontExtension.bodyMediumFont;
        _scoreLabel.textColor = DBColorExtension.whiteColor;
        _scoreLabel.textAlignment = NSTextAlignmentCenter;
        _scoreLabel.layer.cornerRadius = 11;
        _scoreLabel.layer.masksToBounds = YES;
        _scoreLabel.backgroundColor = [UIColor gradientColorSize:_scoreLabel.size direction:DBColorDirectionLevel startColor:DBColorExtension.marmaladeColor endColor:DBColorExtension.coralFlameColor];
    }
    return _scoreLabel;
}

- (UIView *)containerBoxView{
    if (!_containerBoxView){
        _containerBoxView = [[UIView alloc] init];
    }
    return _containerBoxView;
}
@end
