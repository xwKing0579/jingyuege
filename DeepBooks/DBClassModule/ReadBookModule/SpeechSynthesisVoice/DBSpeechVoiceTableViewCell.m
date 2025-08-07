//
//  DBSpeechVoiceTableViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/18.
//

#import "DBSpeechVoiceTableViewCell.h"

@interface DBSpeechVoiceTableViewCell ()
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) UIView *partingLineView;
@end

@implementation DBSpeechVoiceTableViewCell

- (void)setUpSubViews{
    [self.contentView addSubviews:@[self.titleTextLabel,self.partingLineView]];
    [self.titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-16);
    }];
    
    [self.partingLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)setContent:(NSString *)content{
    _content = content;
    self.titleTextLabel.text = content;
}

- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    self.titleTextLabel.textColor = isSelected ? DBColorExtension.pineGreenColor : DBColorExtension.charcoalColor;
}

- (DBBaseLabel *)titleTextLabel{
    if (!_titleTextLabel){
        _titleTextLabel = [[DBBaseLabel alloc] init];
        _titleTextLabel.font = DBFontExtension.bodySixTenFont;
        _titleTextLabel.textColor = DBColorExtension.charcoalColor;
        _titleTextLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleTextLabel;
}

- (UIView *)partingLineView{
    if (!_partingLineView){
        _partingLineView = [[UIView alloc] init];
        _partingLineView.backgroundColor = DBColorExtension.paleGrayColor;
    }
    return _partingLineView;
}
@end
