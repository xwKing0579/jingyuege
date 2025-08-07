//
//  DBGridQuotedView.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/2.
//

#import "DBGridQuotedView.h"

@interface DBGridQuotedView ()
@property (nonatomic, strong) UIView *containerBoxView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) DBBaseLabel *contentTextLabel;
@end

@implementation DBGridQuotedView

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
    [self addSubviews:@[self.containerBoxView]];
    [self.containerBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.containerBoxView addSubviews:@[self.iconImageView,self.contentTextLabel]];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.width.height.mas_equalTo(28);
    }];
    [self.contentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(6);
        make.right.mas_equalTo(-6);
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(6);
    }];
}

- (void)setImageObj:(id)imageObj{
    _imageObj = imageObj;
    self.iconImageView.imageObj = imageObj;
}

- (void)setNameStr:(NSString *)nameStr{
    _nameStr = nameStr;
    self.contentTextLabel.text = nameStr;
}

- (void)gradientStartColor:(UIColor *)startcolor endColor:(UIColor *)endColor{
    [self.containerBoxView layoutIfNeeded];
    self.containerBoxView.backgroundColor = [UIColor gradientColorSize:self.containerBoxView.size direction:DBColorDirectionDownDiagonalLine startColor:startcolor endColor:endColor];
}

- (UIView *)containerBoxView{
    if (!_containerBoxView){
        _containerBoxView = [[UIView alloc] init];
        _containerBoxView.layer.cornerRadius = 12;
        _containerBoxView.layer.masksToBounds = YES;
    }
    return _containerBoxView;
}

- (UIImageView *)iconImageView{
    if (!_iconImageView){
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView.clipsToBounds = YES;
    }
    return _iconImageView;
}

- (DBBaseLabel *)contentTextLabel{
    if (!_contentTextLabel){
        _contentTextLabel = [[DBBaseLabel alloc] init];
        _contentTextLabel.font = DBFontExtension.bodyMediumFont;
        _contentTextLabel.textColor = DBColorExtension.warmAshColor;
        _contentTextLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _contentTextLabel;
}


@end
