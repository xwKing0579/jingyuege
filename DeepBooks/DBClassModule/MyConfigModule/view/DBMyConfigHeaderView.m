//
//  DBMyConfigHeaderView.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/28.
//

#import "DBMyConfigHeaderView.h"
#import "DBBookMemberView.h"

@interface DBMyConfigHeaderView ()
@property (nonatomic, strong) UIImageView *pictureImageView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *avaterImageView;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) DBBaseLabel *nickNameLabel;
@property (nonatomic, strong) UIView *containerBoxView;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) DBBookMemberView *memberView;

@property (nonatomic, strong) NSArray *contentArray;
@end

@implementation DBMyConfigHeaderView

- (instancetype)init{
    if (self == [super init]){
        [self setUpSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]){
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{
    [self addSubviews:@[self.pictureImageView,self.avaterImageView,self.titleTextLabel,self.nickNameLabel,self.loginButton,self.containerBoxView,self.memberView,self.bottomView]];
    [self.pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(UIScreen.screenWidth/375.0*253.0);
    }];
    [self.avaterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(26);
        make.top.mas_equalTo(UIScreen.navbarSafeHeight+30);
        make.width.height.mas_equalTo(64);
    }];
    [self.titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avaterImageView.mas_right).offset(10);
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(self.avaterImageView.mas_top).offset(9);
        make.height.mas_equalTo(27);
    }];
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleTextLabel);
        make.top.mas_equalTo(self.titleTextLabel.mas_bottom).offset(2);
    }];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avaterImageView.mas_right).offset(12);
        make.centerY.mas_equalTo(self.avaterImageView);
        make.width.mas_equalTo(101);
        make.height.mas_equalTo(30);
    }];
    [self.containerBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.avaterImageView.mas_bottom).offset(20);
        make.height.mas_equalTo(55);
    }];
    [self.memberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(self.memberView.height);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(self.bottomView.height);
    }];

    
    NSArray *titles = @[@"阅读时长(分钟)",@"书架收藏",@"阅读历史"];
    NSMutableArray *titleArray = [NSMutableArray array];
    NSMutableArray *contentArray = [NSMutableArray array];
    NSMutableArray *controlArray = [NSMutableArray array];
    self.contentArray = contentArray;
    for (NSString *title in titles) {
        NSInteger index = [titles indexOfObject:title];
        
        DBBaseLabel *titleLabel = [[DBBaseLabel alloc] init];
        titleLabel.font = DBFontExtension.bodySmallFont;
        titleLabel.textColor = DBColorExtension.whiteColor;
        titleLabel.text = title;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [titleArray addObject:titleLabel];
     
        DBBaseLabel *contentTextLabel = [[DBBaseLabel alloc] init];
        contentTextLabel.font = DBFontExtension.pingFangSemiboldXXLarge;
        contentTextLabel.textColor = DBColorExtension.whiteColor;
        contentTextLabel.textAlignment = NSTextAlignmentCenter;
        [contentArray addObject:contentTextLabel];
        
        UIControl *control = [[UIControl alloc] init];
        control.tag = index;
        [control addTarget:self action:@selector(clickControlAction:) forControlEvents:UIControlEventTouchUpInside];
        [controlArray addObject:control];
    }
    [self.containerBoxView addSubviews:titleArray];
    [self.containerBoxView addSubviews:contentArray];
    [self.containerBoxView addSubviews:controlArray];
    
    CGFloat space = 6;
    [titleArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:space leadSpacing:space tailSpacing:space];
    [contentArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:space leadSpacing:space tailSpacing:space];
    [controlArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:space leadSpacing:space tailSpacing:space];
    [titleArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-6);
    }];
    [contentArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(6);
    }];
    [controlArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)clickHeaderViewAction{
    if (!DBCommonConfig.isLogin) return;
    [DBRouter openPageUrl:DEUserSetting];
}

- (void)clickControlAction:(UIControl *)sender{
    switch (sender.tag) {
        case 1:
        {
            UITabBarController *tabbarVc = (UITabBarController *)UIScreen.appWindow.rootViewController;
            tabbarVc.selectedIndex = 0;
        }
            break;
        case 2:
        {
            [DBRouter openPageUrl:DBReadRecord];
        }
            break;
        default:
            break;
    }
}

- (void)setContents:(NSArray *)contents{
    _contents = contents;
    for (NSInteger index = 0; index < self.contentArray.count; index++) {
        DBBaseLabel *label = self.contentArray[index];
        label.text = contents[index];
    }
    
    BOOL isHidden = !DBCommonConfig.isLogin;
    self.titleTextLabel.hidden = isHidden;
    self.nickNameLabel.hidden = isHidden;
    self.loginButton.hidden = !isHidden;
    self.titleTextLabel.text = DBCommonConfig.userDataInfo.account;
    NSString *userNameString = @"用户名：".textMultilingual;
    self.nickNameLabel.text = [NSString stringWithFormat:@"%@%@",userNameString,DBCommonConfig.userDataInfo.nick];
    
    
    id imageObj = [UIImage imageNamed:@"jjMirageDouble"];
    if (DBCommonConfig.userDataInfo.avatar.length > 0){
        imageObj = [DBLinkManager combineLinkWithType:DBLinkHeaderAvatarUrl combine:DBCommonConfig.userDataInfo.avatar];
    }
    id imageData = [NSUserDefaults takeValueForKey:DBUserAvaterKey];
    if (DBCommonConfig.isLogin){
        self.avaterImageView.imageObj = imageData ?: imageObj;
    }else{
        self.avaterImageView.imageObj = imageObj;
    }
    
    self.memberView.hidden = !DBCommonConfig.isUserVip;
    
    if (DBColorExtension.userInterfaceStyle){
        self.maskView.hidden = NO;
        self.bottomView.backgroundColor = DBColorExtension.blackAltColor;
    }else{
        self.maskView.hidden = YES;
        self.bottomView.backgroundColor = DBColorExtension.whiteAltColor;
    }
}

- (UIImageView *)pictureImageView{
    if (!_pictureImageView){
        _pictureImageView = [[UIImageView alloc] init];
        _pictureImageView.image = [UIImage imageNamed:@"jjVoidHorizon"];
       
        
        [_pictureImageView addSubview:self.maskView];
        [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return _pictureImageView;
}

- (UIView *)maskView{
    if (!_maskView){
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = DBColorExtension.cosmicVeilColor;
        _maskView.alpha = 0.2;
        _maskView.hidden = YES;
    }
    return _maskView;
}

- (UIImageView *)avaterImageView{
    if (!_avaterImageView){
        _avaterImageView = [[UIImageView alloc] init];
        _avaterImageView.contentMode = UIViewContentModeScaleAspectFill;
        _avaterImageView.image = [UIImage imageNamed:@"jjMirageDouble"];
        _avaterImageView.layer.cornerRadius = 32;
        _avaterImageView.layer.masksToBounds = YES;
        
        [_avaterImageView addTapGestureTarget:self action:@selector(clickHeaderViewAction)];
    }
    return _avaterImageView;
}

- (UIButton *)loginButton{
    if (!_loginButton){
        _loginButton = [[UIButton alloc] init];
        _loginButton.layer.cornerRadius = 15;
        _loginButton.layer.masksToBounds = YES;
        _loginButton.backgroundColor = DBColorExtension.whiteColor;
        _loginButton.titleLabel.font = DBFontExtension.pingFangMediumSmall;
        [_loginButton setTitle:@"立即登录/注册" forState:UIControlStateNormal];
        [_loginButton setTitleColor:DBColorExtension.sunsetOrangeColor forState:UIControlStateNormal];
        
        [_loginButton addTagetHandler:^(id  _Nonnull sender) {
            [DBCommonConfig toLogin];
        } controlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

- (DBBaseLabel *)titleTextLabel{
    if (!_titleTextLabel){
        _titleTextLabel = [[DBBaseLabel alloc] init];
        _titleTextLabel.font = DBFontExtension.pingFangMediumXLarge;
        _titleTextLabel.textColor = DBColorExtension.whiteColor;
        _titleTextLabel.hidden = YES;
        [_titleTextLabel addTapGestureTarget:self action:@selector(clickHeaderViewAction)];
    }
    return _titleTextLabel;
}

- (DBBaseLabel *)nickNameLabel{
    if (!_nickNameLabel){
        _nickNameLabel = [[DBBaseLabel alloc] init];
        _nickNameLabel.font = DBFontExtension.bodySmallFont;
        _nickNameLabel.textColor = DBColorExtension.whiteColor;
        _nickNameLabel.hidden = YES;
        [_nickNameLabel addTapGestureTarget:self action:@selector(clickHeaderViewAction)];
    }
    return _nickNameLabel;
}

- (UIView *)containerBoxView{
    if (!_containerBoxView){
        _containerBoxView = [[UIView alloc] init];
    }
    return _containerBoxView;
}

- (UIView *)bottomView{
    if (!_bottomView){
        _bottomView = [[UIView alloc] init];
        _bottomView.size = CGSizeMake(UIScreen.screenWidth, 26);
        _bottomView.backgroundColor = DBColorExtension.whiteAltColor;
        [_bottomView addRoudCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(26, 26)];
    }
    return _bottomView;
}

- (DBBookMemberView *)memberView{
    if (!_memberView){
        _memberView = [[DBBookMemberView alloc] init];
        _memberView.hidden = YES;
        _memberView.size = CGSizeMake(UIScreen.screenWidth, 80);
        [_memberView addRoudCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(16, 16)];
        _memberView.backgroundColor = [UIColor gradientColorSize:_memberView.size direction:DBColorDirectionLevel startColor:DBColorExtension.crowFeatherColor endColor:DBColorExtension.abyssBlackColor];
    }
    return _memberView;
}
@end
