//
//  DBReaderChapterView.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/8.
//

#import "DBReaderChapterView.h"

@interface DBReaderChapterView ()
@property (nonatomic, strong) DBBaseLabel *chapterNameLabel;
@property (nonatomic, strong) DBBaseLabel *rateValueLabel;
@end

@implementation DBReaderChapterView

- (instancetype)init{
    if (self == [super init]){
        [self setUpSubViews];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{
    self.layer.cornerRadius = 6;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    
    [self addSubviews:@[self.chapterNameLabel,self.rateValueLabel]];
    [self.chapterNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-100);
        make.centerY.mas_equalTo(0);
    }];
    [self.rateValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(0);
    }];
}

- (void)setChapterName:(NSString *)chapterName{
    _chapterName = chapterName;
    self.chapterNameLabel.text = chapterName;
}

- (void)setRateValue:(NSString *)rateValue{
    _rateValue = rateValue;
    self.rateValueLabel.text = rateValue;
}

- (DBBaseLabel *)chapterNameLabel{
    if (!_chapterNameLabel){
        _chapterNameLabel = [[DBBaseLabel alloc] init];
        _chapterNameLabel.font = DBFontExtension.bodyMediumFont;
        _chapterNameLabel.textColor = DBColorExtension.silverColor;
    }
    return _chapterNameLabel;
}

- (DBBaseLabel *)rateValueLabel{
    if (!_rateValueLabel){
        _rateValueLabel = [[DBBaseLabel alloc] init];
        _rateValueLabel.font = DBFontExtension.bodyMediumFont;
        _rateValueLabel.textColor = DBColorExtension.silverColor;
        _rateValueLabel.textAlignment = NSTextAlignmentRight;
    }
    return _rateValueLabel;
}

@end
