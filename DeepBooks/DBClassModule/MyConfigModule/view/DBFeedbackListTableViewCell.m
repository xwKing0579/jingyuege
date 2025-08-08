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
@property (nonatomic, strong) DBBaseLabel *contentTextLabel;
@property (nonatomic, strong) UIView *partingLineView;
@end

@implementation DBFeedbackListTableViewCell

- (void)setUpSubViews{
    NSArray *views = @[self.titleTextLabel,self.dateLabel,self.contentTextLabel];
    [self.contentView addSubviews:views];
   
    [views mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:10 leadSpacing:16 tailSpacing:16];
    [views mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
    }];
    
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
}

- (DBBaseLabel *)titleTextLabel{
    if (!_titleTextLabel){
        _titleTextLabel = [[DBBaseLabel alloc] init];
        _titleTextLabel.font = DBFontExtension.titleSmallFont;
        _titleTextLabel.textColor = DBColorExtension.whiteColor;
    }
    return _titleTextLabel;
}

- (DBBaseLabel *)dateLabel{
    if (!_dateLabel){
        _dateLabel = [[DBBaseLabel alloc] init];
        _dateLabel.font = DBFontExtension.titleSmallFont;
        _contentTextLabel.textColor = DBColorExtension.whiteColor;
    }
    return _dateLabel;
}

- (DBBaseLabel *)contentTextLabel{
    if (!_contentTextLabel){
        _contentTextLabel = [[DBBaseLabel alloc] init];
        _contentTextLabel.font = DBFontExtension.bodySixTenFont;
        _contentTextLabel.textColor = DBColorExtension.whiteColor;
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
