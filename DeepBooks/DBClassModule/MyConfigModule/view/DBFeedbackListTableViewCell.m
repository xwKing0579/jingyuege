//
//  DBFeedbackListTableViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/26.
//

#import "DBFeedbackListTableViewCell.h"

@interface DBFeedbackListTableViewCell ()
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) DBBaseLabel *dateLabel;
@property (nonatomic, strong) DBBaseLabel *replyContentLabel;
@property (nonatomic, strong) DBBaseLabel *contentTextLabel;
@property (nonatomic, strong) UIView *partingLineView;
@end

@implementation DBFeedbackListTableViewCell

- (void)setUpSubViews{
    NSArray *views = @[self.titleTextLabel,self.dateLabel,self.replyContentLabel,self.contentTextLabel];
    
    UIView *lastView = nil;
    for (UIView *subview in views) {
        [self.contentView addSubview:subview];
        [subview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-16);
            if (lastView) {
                make.top.mas_equalTo(lastView.mas_bottom).offset(3);
            }else{
                make.top.mas_equalTo(8);
            }
            if ([subview isEqual:views.lastObject]){
                make.bottom.mas_equalTo(-8);
            }
        }];
        
        lastView = subview;
    }
    
    [self.contentView addSubview:self.partingLineView];
    [self.partingLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)setModel:(DBFeedbackModel *)model{
    _model = model;
    [self setUserInterfaceStyleOrLight];
}

- (void)setUserInterfaceStyleOrLight{
    UIColor *textColor = DBColorExtension.charcoalColor;
    if (DBColorExtension.userInterfaceStyle) {
        textColor = DBColorExtension.platinumColor;
    }
    
    self.titleTextLabel.attributedText = [NSAttributedString combineAttributeTexts:@[DBConstantString.ks_feedbackContent.textMultilingual,DBSafeString(self.model.content).textMultilingual] colors:@[textColor] fonts:@[DBFontExtension.bodyMediumFont,DBFontExtension.bodySixTenFont]];
    self.dateLabel.attributedText = [NSAttributedString combineAttributeTexts:@[DBConstantString.ks_feedbackTime,DBSafeString(self.model.created_at)] colors:@[textColor,DBColorExtension.grayColor] fonts:@[DBFontExtension.bodyMediumFont,DBFontExtension.bodySixTenFont]];
    
    NSString *state = DBConstantString.ks_pending;
    UIColor *color = DBColorExtension.redColor;
    if (self.model.status == 2){
        state = DBConstantString.ks_repliedStatus;
        color = DBColorExtension.skyBlueColor;
    }
    self.contentTextLabel.attributedText = [NSAttributedString combineAttributeTexts:@[DBConstantString.ks_feedbackStatus.textMultilingual,state.textMultilingual] colors:@[textColor,color] fonts:@[DBFontExtension.bodyMediumFont,DBFontExtension.bodySixTenFont]];
    
    if (self.model.reply.length > 0){
        self.replyContentLabel.text = [NSString stringWithFormat:@"回复内容：%@",self.model.reply];
    }else{
        self.replyContentLabel.text = nil;
    }
    self.replyContentLabel.textColor = textColor;
}

- (DBBaseLabel *)titleTextLabel{
    if (!_titleTextLabel){
        _titleTextLabel = [[DBBaseLabel alloc] init];
        _titleTextLabel.font = DBFontExtension.titleSmallFont;
    }
    return _titleTextLabel;
}

- (DBBaseLabel *)dateLabel{
    if (!_dateLabel){
        _dateLabel = [[DBBaseLabel alloc] init];
        _dateLabel.font = DBFontExtension.titleSmallFont;
    }
    return _dateLabel;
}

- (DBBaseLabel *)replyContentLabel{
    if (!_replyContentLabel){
        _replyContentLabel = [[DBBaseLabel alloc] init];
        _replyContentLabel.font = DBFontExtension.bodyMediumFont;
        _replyContentLabel.textColor = DBColorExtension.charcoalColor;
        _replyContentLabel.numberOfLines = 0;
    }
    return _replyContentLabel;
}

- (DBBaseLabel *)contentTextLabel{
    if (!_contentTextLabel){
        _contentTextLabel = [[DBBaseLabel alloc] init];
        _contentTextLabel.font = DBFontExtension.bodySixTenFont;
        _contentTextLabel.numberOfLines = 0;
    }
    return _contentTextLabel;
}

- (UIView *)partingLineView{
    if (!_partingLineView){
        _partingLineView = [[UIView alloc] init];
        _partingLineView.backgroundColor = DBColorExtension.paleGrayAltColor;
    }
    return _partingLineView;
}

@end
