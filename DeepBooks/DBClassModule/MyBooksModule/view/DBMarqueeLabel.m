//
//  DBMarqueeLabel.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/6/28.
//

#import "DBMarqueeLabel.h"
#import "MarqueeView.h"

@interface DBMarqueeLabel ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) MarqueeView *marqueeTextLabel;
@property (nonatomic, strong) UIControl *actionControl;
@end

@implementation DBMarqueeLabel

- (instancetype)init{
    if (self == [super init]){
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{
    self.backgroundColor = DBColorExtension.cloudGrayColor;
    [self addSubviews:@[self.iconImageView,self.marqueeTextLabel,self.actionControl]];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(5);
        make.width.height.mas_equalTo(20);
    }];
    [self.marqueeTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-10);
    }];
    [self.actionControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)clickMarqueeAction{
    NSString *url = DBAppSetting.setting.marqueeLink;
    if (url.length > 0){
        [DBRouter openPageUrl:DBWebView params:@{@"title":@"用户公告",@"url":url}];
    }
}

- (void)startMarquee{
    [self.marqueeTextLabel start];
}

- (void)stopMarquee{
    [self.marqueeTextLabel stop];
}



- (UIImageView *)iconImageView{
    if (!_iconImageView){
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.imageObj = @"announcement_icon";
    }
    return _iconImageView;
}

- (MarqueeView *)marqueeTextLabel{
    if (!_marqueeTextLabel){
        _marqueeTextLabel = [[MarqueeView alloc] initWithFrame:CGRectMake(10+30, 0, UIScreen.screenWidth-50, 30) withTitle:DBAppSetting.setting.marqueeContent withTextFontSize:12 witTimeInteval:10 withDirection:MarqueeViewHorizontalStyle];
        _marqueeTextLabel.textColor = DBColorExtension.gunmetalColor;
        _marqueeTextLabel.userInteractionEnabled = YES;
    }
    return _marqueeTextLabel;
}

- (UIControl *)actionControl{
    if (!_actionControl){
        _actionControl = [[UIControl alloc] init];
        [_actionControl addTarget:self action:@selector(clickMarqueeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionControl;
}
@end
