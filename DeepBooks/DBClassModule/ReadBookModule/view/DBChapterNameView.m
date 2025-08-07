//
//  DBChapterNameView.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/20.
//

#import "DBChapterNameView.h"

@interface DBChapterNameView ()
@property (nonatomic, strong) DBBaseLabel *titlePageLabel;
@end

@implementation DBChapterNameView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{
    self.backgroundColor = DBColorExtension.noColor;
    [self addSubview:self.titlePageLabel];
    [self.titlePageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(UIScreen.navbarSafeHeight);
    }];
}

- (void)setNameStr:(NSString *)nameStr{
    _nameStr = nameStr;
    self.titlePageLabel.text = nameStr;
}

- (void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    self.titlePageLabel.textColor = textColor;
}

- (DBBaseLabel *)titlePageLabel{
    if (!_titlePageLabel){
        _titlePageLabel = [[DBBaseLabel alloc] init];
        _titlePageLabel.font = DBFontExtension.bodySmallFont;
        _titlePageLabel.textColor = DBColorExtension.onyxColor;
    }
    return _titlePageLabel;
}

@end
