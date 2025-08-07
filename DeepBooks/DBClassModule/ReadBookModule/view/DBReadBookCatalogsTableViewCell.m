//
//  DBReadBookCatalogsTableViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/7.
//

#import "DBReadBookCatalogsTableViewCell.h"

@interface DBReadBookCatalogsTableViewCell ()
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) DBBaseLabel *contentTextLabel;
@property (nonatomic, strong) UIView *partingLineView;
@end

@implementation DBReadBookCatalogsTableViewCell

- (void)setUpSubViews{
    [self.contentView addSubviews:@[self.titleTextLabel,self.contentTextLabel,self.partingLineView]];
    [self.titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-66);
        make.centerY.mas_equalTo(0);
    }];
    [self.contentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.partingLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleTextLabel);
        make.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
        
    }];
}

- (void)setModel:(DBBookCatalogModel *)model{
    _model = model;
    NSString *name = model.title;
    self.titleTextLabel.text = name.length > 0 ? name : model.name;
}

- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if (isSelected){
        self.titleTextLabel.textColor = DBColorExtension.sunsetOrangeColor;
    }else{
        self.titleTextLabel.textColor = DBColorExtension.userInterfaceStyle ? DBColorExtension.whiteAltColor : DBColorExtension.blackAltColor;
    }
}

- (void)setIsLoaded:(BOOL)isLoaded{
    _isLoaded = isLoaded;
    self.contentTextLabel.hidden = !isLoaded;
}

- (DBBaseLabel *)titleTextLabel{
    if (!_titleTextLabel){
        _titleTextLabel = [[DBBaseLabel alloc] init];
        _titleTextLabel.font = DBFontExtension.bodySixTenFont;
        _titleTextLabel.textColor = DBColorExtension.blackAltColor;
    }
    return _titleTextLabel;
}

- (DBBaseLabel *)contentTextLabel{
    if (!_contentTextLabel){
        _contentTextLabel = [[DBBaseLabel alloc] init];
        _contentTextLabel.font = DBFontExtension.bodyMediumFont;
        _contentTextLabel.textColor = DBColorExtension.ashWhiteColor;
        _contentTextLabel.textAlignment = NSTextAlignmentRight;
        _contentTextLabel.text = @"已缓存";
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
