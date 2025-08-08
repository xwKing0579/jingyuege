//
//  DBBookSourceTableViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/2.
//

#import "DBBookSourceTableViewCell.h"

@interface DBBookSourceTableViewCell ()
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) DBBaseLabel *contentTextLabel;
@property (nonatomic, strong) UIView *partingLineView;
@end

@implementation DBBookSourceTableViewCell

- (void)setUpSubViews{
    [self.contentView addSubviews:@[self.titleTextLabel,self.contentTextLabel,self.partingLineView]];
    [self.titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(12);
    }];
    [self.contentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.titleTextLabel);
        make.top.mas_equalTo(self.titleTextLabel.mas_bottom).offset(4);
        make.bottom.mas_equalTo(-12);
    }];
    [self.partingLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.titleTextLabel);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)setModel:(DBBookSourceModel *)model{
    _model = model;
    
    self.contentTextLabel.text = model.last_chapter_name;
    [self setUserInterfaceStyleOrLight];
}

- (void)setUserInterfaceStyleOrLight{
    DBBookSourceModel *model = self.model;
    NSString *source = @"";
    if ([model.site_id isEqualToString:@"ai"]){
        source = DBConstantString.ks_searchAll.textMultilingual;
    }else if (model.site_name.length){
        source = model.site_name;
    }
    source = [NSString stringWithFormat:@"%@ ",source];
    NSString *choose = [NSString stringWithFormat:DBConstantString.ks_choicePercentage,model.updated_at.timeFormat,model.choose];
    UIColor *textColor = DBColorExtension.blackAltColor;
    if (DBColorExtension.userInterfaceStyle){
        textColor = DBColorExtension.whiteAltColor;
    }
    self.titleTextLabel.attributedText = [NSAttributedString combineAttributeTexts:@[source,choose.textMultilingual] colors:@[textColor,self.isSelected?DBColorExtension.sunsetOrangeColor:textColor] fonts:@[DBFontExtension.pingFangMediumLarge,DBFontExtension.bodyMediumFont]];
}

- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
}

- (DBBaseLabel *)titleTextLabel{
    if (!_titleTextLabel){
        _titleTextLabel = [[DBBaseLabel alloc] init];
        _titleTextLabel.font = DBFontExtension.bodyMediumFont;
        _titleTextLabel.textColor = DBColorExtension.charcoalColor;
    }
    return _titleTextLabel;
}

- (DBBaseLabel *)contentTextLabel{
    if (!_contentTextLabel){
        _contentTextLabel = [[DBBaseLabel alloc] init];
        _contentTextLabel.font = DBFontExtension.bodyMediumFont;
        _contentTextLabel.textColor = DBColorExtension.inkWashColor;
    }
    return _contentTextLabel;
}

- (UIView *)partingLineView{
    if (!_partingLineView){
        _partingLineView = [[UIView alloc] init];
        _partingLineView.backgroundColor = DBColorExtension.noColor;
    }
    return _partingLineView;
}

@end
