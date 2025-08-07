//
//  DBRegisterViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/23.
//

#import "DBRegisterViewController.h"
#import "DBPhoneRegisterViewController.h"
#import "DBEmailRegisterViewController.h"
@interface DBRegisterViewController ()<UITextViewDelegate,JXCategoryViewDelegate,JXCategoryListContainerViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) DBBaseLabel *titlePageLabel;
@property (nonatomic, strong) UITextView *privacyTextView;

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *categoryContainerView;
@end

@implementation DBRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setUpSubViews];
}

- (void)setUpSubViews{
    [self.view addSubviews:@[self.titlePageLabel,self.categoryView,self.categoryContainerView,self.privacyTextView]];
    [self.titlePageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(UIScreen.navbarSafeHeight);
        make.height.mas_equalTo(UIScreen.navbarNetHeight);
    }];
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(UIScreen.navbarSafeHeight+100);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(180);
    }];
    [self.categoryContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.categoryView.mas_bottom);
        make.bottom.mas_equalTo(-50-UIScreen.tabbarHeight);
    }];
    [self.privacyTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-UIScreen.tabbarSafeHeight-20);
    }];
    [self.categoryView reloadData];
    [self.categoryView selectItemAtIndex:self.index];
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.categoryView.titles.count;
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    if (index){
        return DBEmailRegisterViewController.new;
    }else{
        return DBPhoneRegisterViewController.new;
    }
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    [DBRouter openPageUrl:DBWebView params:@{@"url":URL.absoluteString,@"title":DBSafeString([textView.text substringWithRange:characterRange]).removeBookMarks}];
    return NO;
}

- (DBBaseLabel *)titlePageLabel{
    if (!_titlePageLabel){
        _titlePageLabel = [[DBBaseLabel alloc] init];
        _titlePageLabel.font = DBFontExtension.bodySixTenFont;
        _titlePageLabel.textColor = DBColorExtension.charcoalColor;
        _titlePageLabel.textAlignment = NSTextAlignmentCenter;
        _titlePageLabel.text = @"注册";
    }
    return _titlePageLabel;
}

- (JXCategoryTitleView *)categoryView{
    if (!_categoryView){
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectZero];
        _categoryView.delegate = self;
   
        _categoryView.titleColor = DBColorExtension.mediumGrayColor;
        _categoryView.titleSelectedColor = DBColorExtension.whiteColor;
        _categoryView.titleFont = DBFontExtension.bodyMediumFont;
        _categoryView.titleSelectedFont = DBFontExtension.pingFangMediumMedium;
        _categoryView.listContainer = self.categoryContainerView;
        _categoryView.titles = @[@"手机号".textMultilingual,@"邮箱".textMultilingual];
        
        JXCategoryIndicatorBackgroundView *backgroundColorView = [[JXCategoryIndicatorBackgroundView alloc] init];
        backgroundColorView.layer.cornerRadius = 20;
        backgroundColorView.layer.masksToBounds = YES;
        backgroundColorView.indicatorHeight = 40;
        backgroundColorView.indicatorColor = DBColorExtension.accountThemeColor;
        backgroundColorView.indicatorWidthIncrement = 40;
        _categoryView.indicators = @[backgroundColorView];
    }
    return _categoryView;
}

- (JXCategoryListContainerView *)categoryContainerView{
    if (!_categoryContainerView){
        _categoryContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
        [_categoryContainerView.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    return _categoryContainerView;
}

- (UITextView *)privacyTextView{
    if (!_privacyTextView){
        _privacyTextView = [[UITextView alloc] init];
        _privacyTextView.linkTextAttributes = @{NSForegroundColorAttributeName:DBColorExtension.redColor};
        _privacyTextView.editable = NO;
        _privacyTextView.scrollEnabled = NO;
        _privacyTextView.delegate = self;
        _privacyTextView.textAlignment = NSTextAlignmentLeft;
        _privacyTextView.backgroundColor = DBColorExtension.noColor;
        _privacyTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _privacyTextView;
}

- (void)setDarkModel{
    [super setDarkModel];
    [self setPrivacyText];
}

- (void)setPrivacyText{
    NSArray *colors = @[DBColorExtension.charcoalColor,DBColorExtension.redColor];
    if (DBColorExtension.userInterfaceStyle) {
        colors = @[DBColorExtension.coolGrayColor,DBColorExtension.redColor];
    }
    self.privacyTextView.attributedText = [NSAttributedString combineAttributeTexts:@[@"注册即表示同意".textMultilingual,@"《用户服务协议》".textMultilingual,@"《隐私协议》".textMultilingual] colors:colors fonts:@[DBFontExtension.bodyMediumFont] attrs:@[@{},@{NSLinkAttributeName:UserServiceAgreementURL},@{NSLinkAttributeName:PrivacyAgreementURL}]];
}

@end
