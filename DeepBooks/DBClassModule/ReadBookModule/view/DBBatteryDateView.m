//
//  DBBatteryDateView.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/20.
//

#import "DBBatteryDateView.h"
#import "DBBatteryView.h"
@interface DBBatteryDateView ()
@property (nonatomic, strong) DBBatteryView *batteryView;
@property (nonatomic, strong) DBBaseLabel *dateLabel;
@property (nonatomic, strong) DBBaseLabel *pageLabel;
@end

@implementation DBBatteryDateView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{
    self.layer.zPosition = 3;
    self.userInteractionEnabled = NO;
    self.backgroundColor = DBColorExtension.noColor;
    [self addSubviews:@[self.batteryView,self.dateLabel,self.pageLabel]];
    [self.batteryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(5);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(10);
    }];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.batteryView.mas_right).offset(10);
        make.centerY.mas_equalTo(self.batteryView);
    }];
    [self.pageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(self.batteryView);
    }];
}

- (void)setTimeStr:(NSString *)timeStr{
    _timeStr = timeStr;
    self.dateLabel.text = timeStr;
}

- (void)setPageStr:(NSString *)pageStr{
    _pageStr = pageStr;
    self.pageLabel.text = pageStr;
}

- (void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    self.dateLabel.textColor = textColor;
    self.pageLabel.textColor = textColor;
}

- (DBBatteryView *)batteryView{
    if (!_batteryView){
        _batteryView = [[DBBatteryView alloc] init];
        _batteryView.backgroundColor = [UIColor clearColor];
    }
    return _batteryView;
}

- (DBBaseLabel *)dateLabel{
    if (!_dateLabel){
        _dateLabel = [[DBBaseLabel alloc] init];
        _dateLabel.font = DBFontExtension.bodySmallFont;
        _dateLabel.textColor = DBColorExtension.onyxColor;
    }
    return _dateLabel;
}

- (DBBaseLabel *)pageLabel{
    if (!_pageLabel){
        _pageLabel = [[DBBaseLabel alloc] init];
        _pageLabel.font = DBFontExtension.bodySmallFont;
        _pageLabel.textColor = DBColorExtension.onyxColor;
        _pageLabel.textAlignment = NSTextAlignmentRight;
    }
    return _pageLabel;
}

@end
