//
//  DBReadDetailTableViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/22.
//

#import "DBReadDetailTableViewCell.h"


@interface DBReadDetailTableViewCell ()
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIImageView *pictureImageView;
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) UIButton *authorButton;
@property (nonatomic, strong) DBBaseLabel *descTextLabel;

@property (nonatomic, strong) YYLabel *contentTextLabel;
@end
@implementation DBReadDetailTableViewCell

- (void)setUpSubViews{
    [self.contentView addSubviews:@[self.coverImageView,self.pictureImageView,self.titleTextLabel,self.authorButton,self.descTextLabel,self.contentTextLabel]];
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(208.0*UIScreen.screenWidth/375.0+UIScreen.navbarSafeHeight);
    }];
    
    CGFloat width = (UIScreen.screenWidth-60)/4;
    [self.pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.bottom.mas_equalTo(self.coverImageView).offset(-30);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(width*5.0/4.0);
    }];
    [self.titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.pictureImageView.mas_right).offset(10);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(self.pictureImageView);
    }];
    [self.descTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.titleTextLabel);
        make.bottom.mas_equalTo(self.pictureImageView);
    }];
    [self.authorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleTextLabel);
        make.centerY.mas_equalTo(self.pictureImageView);
    }];
    
    [self.contentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(self.coverImageView.mas_bottom).offset(20);
        make.bottom.mas_equalTo(-20);
    }];

}

- (void)clickBookSourceAction{
    [DBRouter openPageUrl:DBBookSource params:@{@"book":self.model,kDBRouterDrawerSideslip:@1}];
}

- (void)setModel:(DBBookDetailModel *)model{
    _model = model;

    self.coverImageView.imageObj = model.image;
    self.pictureImageView.imageObj = model.image;
    self.titleTextLabel.text = model.name;
    self.descTextLabel.text = [DBCommonConfig bookDesc:model];
    NSString *auther = [NSString stringWithFormat:@"%@",model.author];
    [self.authorButton setTitle:auther forState:UIControlStateNormal];
    
    [self setExtendRemarkLabel:model.remark];
}

- (void)setExtendRemarkLabel:(NSString *)content{
    if (DBEmptyObj(content)){
        self.contentTextLabel.text = DBConstantString.ks_noSynopsis;
        return;
    }
    
    BOOL isExpand = self.model.numberOfLines == 0;
    self.contentTextLabel.numberOfLines = 20;
 
    NSMutableAttributedString *contentAttri = [NSAttributedString combineAttributeTexts:@[content] colors:@[self.contentTextLabel.textColor] fonts:@[self.contentTextLabel.font]];

    NSString *moreString = isExpand?DBConstantString.ks_less:DBConstantString.ks_unfold;
    NSString *spaceString = isExpand?@"  ":@"...  ";
    NSMutableAttributedString *attri = [NSAttributedString combineAttributeTexts:@[spaceString,moreString.textMultilingual] colors:@[DBColorExtension.mediumGrayColor,DBColorExtension.azureColor] fonts:@[DBFontExtension.bodyMediumFont,DBFontExtension.pingFangMediumRegular]];
    
    YYTextHighlight *hi = [YYTextHighlight new];
    [attri setTextHighlight:hi range:[attri.string rangeOfString:moreString]];
 
    if (!isExpand) {
        self.contentTextLabel.attributedText = contentAttri;
        
        YYLabel *seeMore = [YYLabel new];
        seeMore.attributedText = attri;
        [seeMore sizeToFit];
        
        NSAttributedString *truncationToken = [NSAttributedString attachmentStringWithContent:seeMore contentMode:UIViewContentModeCenter attachmentSize:seeMore.frame.size alignToFont:attri.font alignment:YYTextVerticalAlignmentBottom];
        self.contentTextLabel.truncationToken = truncationToken;
    }else{
        [contentAttri appendAttributedString:attri];
        self.contentTextLabel.attributedText = contentAttri;
    }
 
    DBWeakSelf
    hi.tapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        DBStrongSelfElseReturn
        dispatch_async(dispatch_get_main_queue(), ^{
            self.model.numberOfLines = isExpand ? 20 : 0;
            if (self.remarkBlock) self.remarkBlock();
        });
    };
}

- (UIImageView *)coverImageView{
    if (!_coverImageView){
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
        _coverImageView.backgroundColor = DBColorExtension.peachColor;
        
        UIToolbar *toolbar = [[UIToolbar alloc] init];
        toolbar.barStyle = UIBarStyleBlack;
        [_coverImageView addSubview:toolbar];
        [toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return _coverImageView;
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
        _titleTextLabel.textColor = DBColorExtension.whiteColor;
    }
    return _titleTextLabel;
}

- (UIButton *)authorButton{
    if (!_authorButton){
        _authorButton = [[UIButton alloc] init];
        _authorButton.titleLabel.font = DBFontExtension.bodyMediumFont;
        _authorButton.contentEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 5);
        [_authorButton setTitleColor:DBColorExtension.whiteColor forState:UIControlStateNormal];
    }
    return _authorButton;
}

- (DBBaseLabel *)descTextLabel{
    if (!_descTextLabel){
        _descTextLabel = [[DBBaseLabel alloc] init];
        _descTextLabel.font = DBFontExtension.bodyMediumFont;
        _descTextLabel.textColor = DBColorExtension.whiteColor;
    }
    return _descTextLabel;
}

- (YYLabel *)contentTextLabel{
    if (!_contentTextLabel){
        _contentTextLabel = [[YYLabel alloc] init];
        _contentTextLabel.font = DBFontExtension.bodyMediumFont;
        _contentTextLabel.textColor = DBColorExtension.mediumGrayColor;
        _contentTextLabel.numberOfLines = 20;
        _contentTextLabel.preferredMaxLayoutWidth = UIScreen.screenWidth-32;
    }
    return _contentTextLabel;
}


@end
