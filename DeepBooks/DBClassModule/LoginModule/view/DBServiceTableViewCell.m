//
//  DBServiceTableViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/23.
//

#import "DBServiceTableViewCell.h"

@interface DBServiceTableViewCell ()
@property (nonatomic, strong) DBBaseLabel *titlePageLabel;
@property (nonatomic, strong) UIView *partingLineView;
@end

@implementation DBServiceTableViewCell

- (void)setUpSubViews{
    [self.contentView addSubviews:@[self.titlePageLabel,self.partingLineView]];
    [self.titlePageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.centerY.mas_equalTo(0);
    }];
    [self.partingLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)setModel:(DBServiceModel *)model{
    _model = model;
    self.titlePageLabel.text = model.name;
}

- (DBBaseLabel *)titlePageLabel{
    if (!_titlePageLabel){
        _titlePageLabel = [[DBBaseLabel alloc] init];
        _titlePageLabel.font = DBFontExtension.bodySixTenFont;
        _titlePageLabel.textColor = DBColorExtension.charcoalColor;
    }
    return _titlePageLabel;
}

- (UIView *)partingLineView{
    if (!_partingLineView){
        _partingLineView = [[UIView alloc] init];
        _partingLineView.backgroundColor = DBColorExtension.paleGrayColor;
    }
    return _partingLineView;
}

@end
