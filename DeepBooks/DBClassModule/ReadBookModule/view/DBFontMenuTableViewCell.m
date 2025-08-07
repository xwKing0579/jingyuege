//
//  DBFontMenuTableViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/14.
//

#import "DBFontMenuTableViewCell.h"

@interface DBFontMenuTableViewCell ()
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) DBBaseLabel *contentTextLabel;
@property (nonatomic, strong) UIView *partingLineView;
@end

@implementation DBFontMenuTableViewCell

- (void)setUpSubViews{
    [self.contentView addSubviews:@[self.titleTextLabel,self.contentTextLabel,self.partingLineView]];
    [self.titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(100);
    }];
    
    [self.contentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(self.titleTextLabel);
    }];
    [self.partingLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)setModel:(DBFontModel *)model{
    _model = model;
    self.titleTextLabel.text = model.name;
    self.titleTextLabel.font = [UIFont fontWithName:model.fontName size:24];
    
    if (model.isUsing){
        self.contentTextLabel.text = @"使用中";
        self.contentTextLabel.textColor = DBColorExtension.pineGreenColor;
    }else if (model.isSystem){
        self.contentTextLabel.text = @"系统字体";
        self.contentTextLabel.textColor = DBColorExtension.charcoalColor;
    }else if (model.isDowload){
        self.contentTextLabel.text = @"已下载";
        self.contentTextLabel.textColor = DBColorExtension.charcoalColor;
    }else{
        self.contentTextLabel.text = @"未下载";
        self.contentTextLabel.textColor = DBColorExtension.mediumGrayColor;
    }
}

- (DBBaseLabel *)titleTextLabel{
    if (!_titleTextLabel){
        _titleTextLabel = [[DBBaseLabel alloc] init];
        _titleTextLabel.font = DBFontExtension.bodyMediumFont;
        _titleTextLabel.textColor = DBColorExtension.charcoalColor;
        _titleTextLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleTextLabel;
}

- (DBBaseLabel *)contentTextLabel{
    if (!_contentTextLabel){
        _contentTextLabel = [[DBBaseLabel alloc] init];
        _contentTextLabel.font = DBFontExtension.bodySixTenFont;
        _contentTextLabel.textColor = DBColorExtension.grayColor;
        _contentTextLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _contentTextLabel;
}

- (UIView *)partingLineView{
    if (!_partingLineView){
        _partingLineView = [[UIView alloc] init];
        _partingLineView.backgroundColor = DBColorExtension.paleGrayColor;
    }
    return _partingLineView;
}
@end
