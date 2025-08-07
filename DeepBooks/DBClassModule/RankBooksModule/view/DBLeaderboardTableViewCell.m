//
//  DBLeaderboardTableViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/1.
//

#import "DBLeaderboardTableViewCell.h"

@interface DBLeaderboardTableViewCell ()
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@end

@implementation DBLeaderboardTableViewCell


- (void)setUpSubViews{
    [self.contentView addSubview:self.titleTextLabel];
    [self.titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(20);
        make.bottom.mas_equalTo(-20);
    }];
}

- (void)setModel:(DBLeaderboardItemModel *)model{
    _model = model;
    self.titleTextLabel.text = model.rank_title;
}

- (void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
//    self.contentView.backgroundColor = isSelect ? DBColorExtension.whiteColor : DBColorExtension.noColor;
    self.titleTextLabel.textColor = isSelect ? DBColorExtension.sunsetOrangeColor : DBColorExtension.inkWashColor;
    self.titleTextLabel.font = isSelect ? DBFontExtension.pingFangMediumRegular : DBFontExtension.bodyMediumFont;
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

@end
