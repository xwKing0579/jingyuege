//
//  DBWantBookListTableViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/26.
//

#import "DBWantBookListTableViewCell.h"

@interface DBWantBookListTableViewCell ()
@property (nonatomic, strong) DBBaseLabel *contentTextLabel;
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;

@property (nonatomic, strong) DBBaseLabel *authorLabel;
@property (nonatomic, strong) DBBaseLabel *stateLabel;
@property (nonatomic, strong) DBBaseLabel *timeLabel;

@property (nonatomic, strong) UIView *partingLineView;
@end

@implementation DBWantBookListTableViewCell

- (void)setUpSubViews{
    NSArray *views = @[self.contentTextLabel,self.titleTextLabel,self.authorLabel,self.stateLabel,self.timeLabel];
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

- (void)setModel:(DBWantBookModel *)model{
    _model = model;
    self.contentTextLabel.text = @"求书信息";
    self.titleTextLabel.text = [NSString stringWithFormat:@"书名：%@",model.name];
    self.authorLabel.text = [NSString stringWithFormat:@"作者：%@",model.author];
    if (model.book_id.intValue > 0){
        self.stateLabel.text = @"处理状态：求书成功（点击查看）";
        self.stateLabel.textColor = DBColorExtension.redColor;
    }else if (model.msg.length > 0){
        self.stateLabel.text = [NSString stringWithFormat:@"处理状态：%@",model.msg];
        self.stateLabel.textColor = DBColorExtension.redColor;
    }else{
        self.stateLabel.text = @"处理状态：还在处理中...";
        self.stateLabel.textColor = DBColorExtension.mediumGrayColor;
    }
    self.timeLabel.text = model.created_at.timeFormat;
}

- (DBBaseLabel *)titleTextLabel{
    if (!_titleTextLabel){
        _titleTextLabel = [[DBBaseLabel alloc] init];
        _titleTextLabel.font = DBFontExtension.titleSmallFont;
        _titleTextLabel.textColor = DBColorExtension.charcoalColor;
    }
    return _titleTextLabel;
}

- (DBBaseLabel *)contentTextLabel{
    if (!_contentTextLabel){
        _contentTextLabel = [[DBBaseLabel alloc] init];
        _contentTextLabel.font = DBFontExtension.bodySixTenFont;
        _contentTextLabel.textColor = DBColorExtension.charcoalColor;
    }
    return _contentTextLabel;
}

- (DBBaseLabel *)authorLabel{
    if (!_authorLabel){
        _authorLabel = [[DBBaseLabel alloc] init];
        _authorLabel.font = DBFontExtension.bodySixTenFont;
        _authorLabel.textColor = DBColorExtension.charcoalColor;
    }
    return _authorLabel;
}

- (DBBaseLabel *)stateLabel{
    if (!_stateLabel){
        _stateLabel = [[DBBaseLabel alloc] init];
        _stateLabel.font = DBFontExtension.bodySixTenFont;
        _stateLabel.textColor = DBColorExtension.grayColor;
    }
    return _stateLabel;
}

- (DBBaseLabel *)timeLabel{
    if (!_timeLabel){
        _timeLabel = [[DBBaseLabel alloc] init];
        _timeLabel.font = DBFontExtension.bodySixTenFont;
        _timeLabel.textColor = DBColorExtension.charcoalColor;
    }
    return _timeLabel;
}

- (UIView *)partingLineView{
    if (!_partingLineView){
        _partingLineView = [[UIView alloc] init];
        _partingLineView.backgroundColor = DBColorExtension.paleGrayColor;
    }
    return _partingLineView;
}
@end
