//
//  DBContryCodeTableViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/4.
//

#import "DBContryCodeTableViewCell.h"

@interface DBContryCodeTableViewCell ()
@property (nonatomic, strong) DBBaseLabel *titlePageLabel;
@property (nonatomic, strong) DBBaseLabel *codeLabel;
@property (nonatomic, strong) UIView *partingLineView;
@end

@implementation DBContryCodeTableViewCell

- (void)setUpSubViews{
    [self.contentView addSubviews:@[self.titlePageLabel,self.codeLabel,self.partingLineView]];
    [self.titlePageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.centerY.mas_equalTo(0);
        make.top.mas_equalTo(16);
        make.bottom.mas_equalTo(-16);
    }];
    [self.codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(20);
    }];
    [self.partingLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)setModel:(DBContryCodeModel *)model{
    _model = model;
    
    self.titlePageLabel.text = model.name;
    self.codeLabel.text = model.tel;
}

- (DBBaseLabel *)titlePageLabel{
    if (!_titlePageLabel){
        _titlePageLabel = [[DBBaseLabel alloc] init];
        _titlePageLabel.font = DBFontExtension.bodySixTenFont;
        _titlePageLabel.textColor = DBColorExtension.charcoalColor;
    }
    return _titlePageLabel;
}

- (DBBaseLabel *)codeLabel{
    if (!_codeLabel){
        _codeLabel = [[DBBaseLabel alloc] init];
        _codeLabel.font = DBFontExtension.bodySmallFont;
        _codeLabel.textColor = DBColorExtension.grayColor;
        _codeLabel.backgroundColor = DBColorExtension.paleGrayColor;
        _codeLabel.layer.cornerRadius = 6;
        _codeLabel.layer.masksToBounds = YES;
        _codeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _codeLabel;
}

- (UIView *)partingLineView{
    if (!_partingLineView){
        _partingLineView = [[UIView alloc] init];
        _partingLineView.backgroundColor = DBColorExtension.paleGrayColor;
    }
    return _partingLineView;
}
@end
