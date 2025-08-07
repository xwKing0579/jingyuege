//
//  DBConventionView.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/4.
//

#import "DBConventionView.h"

@interface DBConventionView ()<UITextViewDelegate>
@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, strong) UIImageView *pictureImageView;
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) UIButton *nextButton;

@property (nonatomic, copy) void (^completion)(BOOL finish);
@end

@implementation DBConventionView

- (instancetype)init{
    if (self == [super init]){
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{
    self.frame = UIScreen.mainScreen.bounds;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    
    [self addSubviews:@[self.coverView]];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.centerY.mas_equalTo(-30);
    }];
    
    [self.coverView addSubviews:@[self.pictureImageView,self.titleTextLabel,self.contentTextView,self.nextButton]];
    [self.pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo((UIScreen.screenWidth-100)*413.0/800.0);
    }];
    [self.titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(self.pictureImageView.mas_bottom).offset(20);
    }];
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(self.titleTextLabel.mas_bottom).offset(10);
    }];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.contentTextView.mas_bottom).offset(15);
        make.bottom.mas_equalTo(-20);
    }];
    [self setStyleDark];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    [self setStyleDark];
}

- (void)setStyleDark{
    UIColor *color = DBColorExtension.charcoalColor;
    if (DBColorExtension.userInterfaceStyle){
        color = DBColorExtension.lightGrayColor;
    }
    
    DBAppConfigModel *appConfig = DBCommonConfig.appConfig;
    NSString *path = [NSString stringWithFormat:@"notice/v3/comment.html?pname=%@&wx=%@&qq=%@",UIApplication.appName,DBSafeString(appConfig.wechat),DBSafeString(appConfig.qq)];
    NSString *url = [DBLinkManager combineLinkWithType:DBLinkIconResUrl combine:path];
    self.contentTextView.attributedText = [NSAttributedString combineAttributeTexts:@[@"提倡文明用语，禁止低俗恶意，好评论可获得官方推荐，违反规则将可能执行删除、禁言及封号处罚。查看完整",@"《社区公约》".textMultilingual] colors:@[color,DBColorExtension.redColor] fonts:@[DBFontExtension.bodyMediumFont] attrs:@[@{},@{NSLinkAttributeName:url}]];
}

+ (void)conventionViewCompletion:(void (^ __nullable)(BOOL finished))completion{
    NSString *conventionKey = @"conventionKey";
    BOOL isConvention = [[NSUserDefaults takeValueForKey:conventionKey] boolValue];
    if (isConvention){
        if (completion) completion(YES);
    }else{
        DBConventionView *view = [[DBConventionView alloc] init];
        view.completion = completion;
        [UIScreen.currentViewController.view addSubview:view];
        [NSUserDefaults saveValue:@1 forKey:conventionKey];
    }
}

- (void)clickNextAction{
    [self removeFromSuperview];
    if (self.completion) self.completion(YES);
}

- (BOOL)contentTextView:(UITextView *)contentTextView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    [DBRouter openPageUrl:DBWebView params:@{@"title":@"社区公约",@"url":URL.absoluteString}];
    return NO;
}

- (UIView *)coverView{
    if (!_coverView){
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = DBColorExtension.whiteColor;
        _coverView.layer.cornerRadius = 20;
        _coverView.layer.masksToBounds = YES;
    }
    return _coverView;
}

- (UIImageView *)pictureImageView{
    if (!_pictureImageView){
        _pictureImageView = [[UIImageView alloc] init];
        _pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
        _pictureImageView.clipsToBounds = YES;
        _pictureImageView.image = [UIImage imageNamed:@"convention_icon"];
    }
    return _pictureImageView;
}

- (DBBaseLabel *)titleTextLabel{
    if (!_titleTextLabel){
        _titleTextLabel = [[DBBaseLabel alloc] init];
        _titleTextLabel.font = DBFontExtension.bodySixTenFont;
        _titleTextLabel.textColor = DBColorExtension.pinkColor;
        _titleTextLabel.textAlignment = NSTextAlignmentCenter;
        _titleTextLabel.text = @"请遵守评论规范哦";
    }
    return _titleTextLabel;
}

- (UITextView *)contentTextView{
    if (!_contentTextView){
        _contentTextView = [[UITextView alloc] init];
        _contentTextView.textAlignment = NSTextAlignmentCenter;
        _contentTextView.backgroundColor = DBColorExtension.noColor;
        _contentTextView.textContainerInset = UIEdgeInsetsZero;
        _contentTextView.linkTextAttributes = @{NSForegroundColorAttributeName:DBColorExtension.redColor};
        _contentTextView.editable = NO;
        _contentTextView.scrollEnabled = NO;
        _contentTextView.delegate = self;
    }
    return _contentTextView;
}


- (UIButton *)nextButton{
    if (!_nextButton){
        _nextButton = [[UIButton alloc] init];
        _nextButton.layer.cornerRadius = 6;
        _nextButton.layer.masksToBounds = YES;
        _nextButton.backgroundColor = DBColorExtension.redColor;
        _nextButton.contentEdgeInsets = UIEdgeInsetsMake(6, 16, 6, 16);
        _nextButton.titleLabel.font = DBFontExtension.bodySixTenFont;
        [_nextButton setTitle:@"知道了" forState:UIControlStateNormal];
        [_nextButton setTitleColor:DBColorExtension.whiteColor forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(clickNextAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}
@end
