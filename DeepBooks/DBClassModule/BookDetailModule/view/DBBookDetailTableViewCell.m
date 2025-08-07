//
//  DBBookDetailTableViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/2.
//

#import "DBBookDetailTableViewCell.h"
#import <YYText.h>
#import "DBBookSocreView.h"

@interface DBBookDetailTableViewCell ()

@property (nonatomic, strong) YYLabel *contentTextLabel;

@property (nonatomic, strong) DBBookSocreView *scoreView;

@property (nonatomic, strong) UIView *containerBoxView;
@property (nonatomic, strong) DBBaseLabel *sourceLabel;
@property (nonatomic, strong) DBBaseLabel *chapterLabel;
@end

@implementation DBBookDetailTableViewCell

- (void)setUpSubViews{
    [self.contentView addSubviews:@[self.containerBoxView,self.contentTextLabel]];

    if (DBCommonConfig.switchAudit){
        [self.contentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-16);
            make.top.mas_equalTo(20);
        }];
    }else{
        [self.contentView addSubview:self.scoreView];
        [self.scoreView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(20);
            make.height.mas_equalTo(80);
        }];
        [self.contentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-16);
            make.top.mas_equalTo(self.scoreView.mas_bottom).offset(20);
        }];
    }
    
    [self.containerBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(self.contentTextLabel.mas_bottom).offset(20);
        make.bottom.mas_equalTo(-16);
        make.height.mas_equalTo(80);
    }];
}

- (void)clickBookSourceAction{
    [DBRouter openPageUrl:DBBookSource params:@{@"book":self.model,kDBRouterDrawerSideslip:@1}];
}

- (void)setModel:(DBBookDetailModel *)model{
    _model = model;

    [self setExtendRemarkLabel:model.remark];

    self.chapterLabel.text = [NSString stringWithFormat:@"%@ / %@",[DBCommonConfig bookStausDesc:model.status],model.last_chapter_name];
    
    if (!DBCommonConfig.switchAudit){
        self.scoreView.model = model;
    }
    
    [self setUserInterfaceStyleOrLight];
}

- (void)setUserInterfaceStyleOrLight{
    NSString *source = [NSString stringWithFormat:@"共有%@个书源",self.model.source_count];
    NSString *time = [NSString stringWithFormat:@" %@ 更新",self.model.updated_at.timeFormat];
    
    UIColor *textColor = DBColorExtension.charcoalColor;
    if (DBColorExtension.userInterfaceStyle) {
        self.chapterLabel.textColor = DBColorExtension.slateGrayColor;
        self.containerBoxView.backgroundColor = DBColorExtension.jetBlackColor;
        textColor = DBColorExtension.lightGrayColor;
    }else{
        self.chapterLabel.textColor = DBColorExtension.mediumGrayColor;
        self.containerBoxView.backgroundColor = DBColorExtension.paleGrayAltColor;
    }
    self.sourceLabel.attributedText = [NSAttributedString combineAttributeTexts:@[source.textMultilingual,time.textMultilingual] colors:@[textColor,DBColorExtension.redColor] fonts:@[DBFontExtension.bodyMediumFont]];
}

- (void)setExtendRemarkLabel:(NSString *)content{
    if (DBEmptyObj(content)){
        self.contentTextLabel.text = @"该书暂无简介，敬请期待！！！";
        return;
    }
    
    BOOL isExpand = self.model.numberOfLines == 0;
    self.contentTextLabel.numberOfLines = self.model.numberOfLines;
 
    NSMutableAttributedString *contentAttri = [NSAttributedString combineAttributeTexts:@[content] colors:@[self.contentTextLabel.textColor] fonts:@[self.contentTextLabel.font]];

    NSString *moreString = (isExpand?@"收起":@"展开").textMultilingual;
    NSString *spaceString = isExpand?@"  ":@"...  ";
    NSMutableAttributedString *attri = [NSAttributedString combineAttributeTexts:@[spaceString,moreString.textMultilingual] colors:@[DBColorExtension.mediumGrayColor,DBColorExtension.azureColor] fonts:@[DBFontExtension.bodyMediumFont,DBFontExtension.pingFangMediumRegular]];
    
    YYTextHighlight *hi = [YYTextHighlight new];
    [attri yy_setTextHighlight:hi range:[attri.string rangeOfString:moreString]];
 
    if (!isExpand) {
        self.contentTextLabel.attributedText = contentAttri;
        
        YYLabel *seeMore = [YYLabel new];
        seeMore.attributedText = attri;
        [seeMore sizeToFit];
        
        NSAttributedString *truncationToken = [NSAttributedString yy_attachmentStringWithContent:seeMore contentMode:UIViewContentModeCenter attachmentSize:seeMore.frame.size alignToFont:attri.yy_font alignment:YYTextVerticalAlignmentBottom];
        self.contentTextLabel.truncationToken = truncationToken;
    }else{
        [contentAttri appendAttributedString:attri];
        self.contentTextLabel.attributedText = contentAttri;
    }
 
    DBWeakSelf
    hi.tapAction = ^(UIView * _Nonnull containerBoxView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        DBStrongSelfElseReturn
        dispatch_async(dispatch_get_main_queue(), ^{
            self.model.numberOfLines = isExpand ? 3 : 0;
            if (self.remarkBlock) self.remarkBlock();
        });
    };
}


- (YYLabel *)contentTextLabel{
    if (!_contentTextLabel){
        _contentTextLabel = [[YYLabel alloc] init];
        _contentTextLabel.font = DBFontExtension.bodyMediumFont;
        _contentTextLabel.textColor = DBColorExtension.mediumGrayColor;
        _contentTextLabel.numberOfLines = 3;
        _contentTextLabel.preferredMaxLayoutWidth = UIScreen.screenWidth-32;
    }
    return _contentTextLabel;
}

- (UIView *)containerBoxView{
    if (!_containerBoxView){
        _containerBoxView = [[UIView alloc] init];
        _containerBoxView.layer.cornerRadius = 4;
        _containerBoxView.layer.masksToBounds = YES;
        _containerBoxView.backgroundColor = DBColorExtension.paleGrayAltColor;
        [_containerBoxView addTapGestureTarget:self action:@selector(clickBookSourceAction)];
        
        UIImageView *arrowImageView = [[UIImageView alloc] init];
        arrowImageView.image = [UIImage imageNamed:@"arrowIcon"];
        
        [_containerBoxView addSubviews:@[self.sourceLabel,self.chapterLabel,arrowImageView]];
        [self.sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(18);
            make.right.mas_equalTo(-32);
        }];
        [self.chapterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.sourceLabel);
            make.bottom.mas_equalTo(-18);
            make.right.mas_equalTo(-32);
        }];
        
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-16);
            make.centerY.mas_equalTo(0);
        }];
    }
    return _containerBoxView;
}

- (DBBaseLabel *)sourceLabel{
    if (!_sourceLabel){
        _sourceLabel = [[DBBaseLabel alloc] init];
        _sourceLabel.font = DBFontExtension.bodyMediumFont;
        _sourceLabel.textColor = DBColorExtension.charcoalColor;
    }
    return _sourceLabel;
}

- (DBBaseLabel *)chapterLabel{
    if (!_chapterLabel){
        _chapterLabel = [[DBBaseLabel alloc] init];
        _chapterLabel.font = DBFontExtension.bodySmallFont;
        _chapterLabel.textColor = DBColorExtension.mediumGrayColor;
    }
    return _chapterLabel;
}

- (DBBookSocreView *)scoreView{
    if (!_scoreView){
        _scoreView = [[DBBookSocreView alloc] init];
    }
    return _scoreView;
}
@end
