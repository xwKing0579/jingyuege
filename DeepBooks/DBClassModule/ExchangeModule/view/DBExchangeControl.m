//
//  DBExchangeControl.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/1.
//

#import "DBExchangeControl.h"

@interface DBExchangeControl ()
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) DBBaseLabel *contentTextLabel;
@property (nonatomic, strong) DBBaseLabel *descTextLabel;
@end

@implementation DBExchangeControl

- (instancetype)init{
    if (self = [super init]){
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{
    self.layer.cornerRadius = 12;
    self.layer.masksToBounds = YES;
    
    self.layer.borderWidth = 1;
    self.layer.backgroundColor = DBColorExtension.diatomColor.CGColor;
    self.backgroundColor = DBColorExtension.diatomColor;
    
    [self addSubviews:@[self.titleTextLabel,self.contentTextLabel,self.descTextLabel]];
    [self.titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(32);
    }];
    [self.contentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.titleTextLabel);
        make.top.mas_equalTo(self.titleTextLabel.mas_bottom).offset(16);
    }];
    [self.descTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.titleTextLabel);
        make.top.mas_equalTo(self.contentTextLabel.mas_bottom).offset(28);
    }];
}

- (void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    
    if (isSelect){
        self.backgroundColor = DBColorExtension.blushMistColor;
        self.titleTextLabel.textColor = DBColorExtension.sunsetOrangeColor;
        self.descTextLabel.textColor = DBColorExtension.sunsetOrangeColor;
        self.layer.backgroundColor = DBColorExtension.sunsetOrangeColor.CGColor;
        [self addOuterShadow];
    }else{
        self.backgroundColor = DBColorExtension.diatomColor;
        self.titleTextLabel.textColor = DBColorExtension.blackAltColor;
        self.descTextLabel.textColor = DBColorExtension.inkWashColor;
        self.layer.backgroundColor = DBColorExtension.diatomColor.CGColor;
        [self removeOuterShadow];
    }
}

- (DBBaseLabel *)titleTextLabel{
    if (!_titleTextLabel){
        _titleTextLabel = [[DBBaseLabel alloc] init];
        _titleTextLabel.font = DBFontExtension.pingFangMediumXLarge;
        _titleTextLabel.textColor = DBColorExtension.blackAltColor;
        _titleTextLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleTextLabel;
}

- (DBBaseLabel *)contentTextLabel{
    if (!_contentTextLabel){
        _contentTextLabel = [[DBBaseLabel alloc] init];
        _contentTextLabel.font = DBFontExtension.pingFangSemiboldBigHeader;
        _contentTextLabel.textColor = DBColorExtension.blackAltColor;
        _contentTextLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _contentTextLabel;
}

- (DBBaseLabel *)descTextLabel{
    if (!_descTextLabel){
        _descTextLabel = [[DBBaseLabel alloc] init];
        _descTextLabel.font = DBFontExtension.bodySmallFont;
        _descTextLabel.textColor = DBColorExtension.inkWashColor;
        _descTextLabel.textAlignment = NSTextAlignmentCenter;
        _descTextLabel.numberOfLines = 3;
    }
    return _descTextLabel;
}
@end
