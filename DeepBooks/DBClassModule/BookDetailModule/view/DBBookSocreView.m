//
//  DBBookSocreView.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/20.
//

#import "DBBookSocreView.h"
#import "DBStarRating.h"
@interface DBBookSocreView ()
@property (nonatomic, strong) DBBaseLabel *scoreValueLabel;
@property (nonatomic, strong) DBStarRating *scoreView;
@property (nonatomic, strong) DBBaseLabel *scoreLabel;
@property (nonatomic, strong) DBBaseLabel *readerValueLabel;
@property (nonatomic, strong) DBBaseLabel *readerLabel;
@property (nonatomic, strong) UIView *partingLineView;
@end

@implementation DBBookSocreView

- (instancetype)init{
    if (self == [super init]){
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{
    [self addSubviews:@[self.scoreValueLabel,self.scoreView,self.scoreLabel,self.readerValueLabel,self.readerLabel,self.partingLineView]];
    [self.scoreValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(0);
    }];
    
    [self.scoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scoreValueLabel.mas_right);
        make.centerY.mas_equalTo(self.scoreValueLabel);
        make.size.mas_equalTo(self.scoreView.size);
    }];
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scoreValueLabel);
        make.top.mas_equalTo(self.scoreValueLabel.mas_bottom);
    }];
    [self.readerValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(UIScreen.screenWidth*0.6);
        make.centerY.mas_equalTo(self.scoreValueLabel);
        make.right.mas_equalTo(-16);
    }];
    [self.readerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.readerValueLabel);
        make.top.mas_equalTo(self.readerValueLabel.mas_bottom);
    }];
    [self.partingLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)setModel:(DBBookDetailModel *)model{
    _model = model;
    self.scoreValueLabel.text = [NSString stringWithFormat:@"%.1lf",model.score.floatValue];
    CGFloat scoreValue = self.scoreValueLabel.text.floatValue;
    self.scoreView.currentScore = scoreValue;
    
    NSString *count = [NSString stringWithFormat:@"%ld",model.view_count];
    NSString *unit = @" 人";
    if (model.view_count >= 10000){
        count = [NSString stringWithFormat:@"%.1lf",(CGFloat)model.view_count/10000.0];
        unit = @" 万人";
    }
    
    UIColor *scoreColor = DBColorExtension.charcoalColor;
    if (DBColorExtension.userInterfaceStyle) {
        scoreColor = DBColorExtension.whiteColor;
        self.scoreView.checkedImage = [[UIImage imageNamed:@"score_sel"] imageWithTintColor:scoreColor];
    }else{
        self.scoreView.checkedImage = [UIImage imageNamed:@"score_sel"];
    }
    
    self.readerValueLabel.attributedText = [NSAttributedString combineAttributeTexts:@[count.textMultilingual,unit.textMultilingual] colors:@[scoreColor] fonts:@[DBFontExtension.titleLargeFont,DBFontExtension.bodyMediumFont]];
    self.scoreValueLabel.textColor = scoreColor;
}

- (DBBaseLabel *)scoreValueLabel{
    if (!_scoreValueLabel){
        _scoreValueLabel = [[DBBaseLabel alloc] init];
        _scoreValueLabel.font = DBFontExtension.titleLargeFont;
        _scoreValueLabel.textColor = DBColorExtension.charcoalColor;
    }
    return _scoreValueLabel;
}

- (DBBaseLabel *)scoreLabel{
    if (!_scoreLabel){
        _scoreLabel = [[DBBaseLabel alloc] init];
        _scoreLabel.font = DBFontExtension.bodyMediumFont;
        _scoreLabel.textColor = DBColorExtension.mediumGrayColor;
        _scoreLabel.text = @"评分";
    }
    return _scoreLabel;
}

- (DBBaseLabel *)readerValueLabel{
    if (!_readerValueLabel){
        _readerValueLabel = [[DBBaseLabel alloc] init];
        _readerValueLabel.font = DBFontExtension.titleLargeFont;
        _readerValueLabel.textColor = DBColorExtension.charcoalColor;
    }
    return _readerValueLabel;
}

- (DBBaseLabel *)readerLabel{
    if (!_readerLabel){
        _readerLabel = [[DBBaseLabel alloc] init];
        _readerLabel.font = DBFontExtension.bodyMediumFont;
        _readerLabel.textColor = DBColorExtension.mediumGrayColor;
        _readerLabel.text = @"正在阅读";
    }
    return _readerLabel;
}

- (UIView *)partingLineView{
    if (!_partingLineView){
        _partingLineView = [[UIView alloc] init];
        _partingLineView.backgroundColor = DBColorExtension.paleGrayColor;
    }
    return _partingLineView;
}

- (DBStarRating *)scoreView{
    if (!_scoreView){
        CGFloat width = 24;
        _scoreView = [[DBStarRating alloc] initWithFrame:CGRectMake(0, 0, width*5+6*4, width)];
        _scoreView.spacing = 6;
   
        _scoreView.checkedImage = [UIImage imageNamed:@"score_sel"];
        _scoreView.uncheckedImage = [UIImage imageNamed:@"score_unsel"];
        _scoreView.minimumScore = 0.0;
        _scoreView.maximumScore = 10.0;
        _scoreView.type = RatingTypeUnlimited;
    }
    return _scoreView;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    if (DBColorExtension.userInterfaceStyle) {
        self.scoreView.checkedImage = [[UIImage imageNamed:@"score_sel"] imageWithTintColor:DBColorExtension.whiteColor];
    }else{
        self.scoreView.checkedImage = [UIImage imageNamed:@"score_sel"];
    }
}
@end
