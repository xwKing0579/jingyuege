//
//  DBCoinControl.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/1.
//

#import "DBCoinControl.h"

@interface DBCoinControl ()
@property (nonatomic, strong) DBBaseLabel *contentTextLabel;
@property (nonatomic, strong) DBBaseLabel *descTextLabel;
@end

@implementation DBCoinControl

- (instancetype)init{
    if (self = [super init]){
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{
    self.size = CGSizeMake(172, 247);
    self.backgroundColor = [UIColor gradientColorSize:self.size direction:DBColorDirectionDownDiagonalLine startColor:DBColorExtension.blushSnowColor endColor:DBColorExtension.blushMistColor];
    
    self.layer.cornerRadius = 12;
    self.layer.masksToBounds = YES;
    
    self.layer.borderWidth = 1;
    self.layer.backgroundColor = DBColorExtension.diatomColor.CGColor;
    
    [self addSubviews:@[self.contentTextLabel,self.descTextLabel]];
    [self.contentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(75);
    }];
    [self.descTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentTextLabel);
        make.bottom.mas_equalTo(-32);
    }];
}

- (void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    
    if (isSelect){
        self.backgroundColor = DBColorExtension.blushMistColor;
        self.descTextLabel.textColor = DBColorExtension.sunsetOrangeColor;
        self.layer.backgroundColor = DBColorExtension.sunsetOrangeColor.CGColor;
        [self addOuterShadow];
    }else{
        self.backgroundColor = DBColorExtension.diatomColor;
        self.descTextLabel.textColor = DBColorExtension.inkWashColor;
        self.layer.backgroundColor = DBColorExtension.diatomColor.CGColor;
        [self removeOuterShadow];
    }
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
