//
//  DBSearchBooksViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/22.
//

#import "DBSearchBooksViewController.h"
#import "DBSearchResultViewController.h"
#import "DBSearchTagModel.h"
@interface DBSearchBooksViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) DBBaseLabel *hotLabel;
@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIView *containerBoxView;

@property (nonatomic, strong) UIButton *changeButton;
@property (nonatomic, strong) DBBaseLabel *historyLabel;
@property (nonatomic, strong) UIButton *deleteButton;

@property (nonatomic, strong) NSArray *tagViews;
@property (nonatomic, strong) NSArray *searchViews;

@property (nonatomic, strong) UIView *gradientColorView;
@end

@implementation DBSearchBooksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
    [self loadingTopAdView:YES];
}

- (void)setUpSubViews{
    UIView *gradientColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.screenWidth, UIScreen.navbarHeight+64)];
    self.gradientColorView = gradientColorView;
    [self.view addSubviews:@[gradientColorView,self.searchTextField,self.cancelButton,self.containerBoxView]];
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-84);
        make.top.mas_equalTo(UIScreen.navbarSafeHeight+4);
        make.height.mas_equalTo(36);
    }];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.searchTextField.mas_right).offset(8);
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(self.searchTextField);
        make.height.mas_equalTo(36);
    }];
    [self.containerBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.searchTextField.mas_bottom).offset(10);
    }];
    
    [self.containerBoxView addSubviews:@[self.hotLabel,self.changeButton,self.historyLabel,self.deleteButton]];
    [self.hotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(0);
    }];
    [self.changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(self.hotLabel);
    }];
    [self.historyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.hotLabel.mas_bottom).offset(44*3+10);
    }];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(self.historyLabel);
    }];
    gradientColorView.backgroundColor = [UIColor gradientColorSize:gradientColorView.size direction:DBColorDirectionVertical startColor:DBColorExtension.shellPinkColor endColor:DBColorExtension.whiteColor];

    [self setUpTagViews];
    [self setUpSearchTagViews];
    
    if (self.keyword.length){
        self.searchTextField.text = self.keyword;
        [self setUpSearchResult:self.keyword];
    }else{
        [self.searchTextField becomeFirstResponder];
    }
}

- (void)loadingTopAdView:(BOOL)reload{
    DBWeakSelf
    [DBUnityAdConfig.manager openBannerAdSpaceType:DBAdSpaceSearchPageTop showAdController:self reload:reload completion:^(UIView * _Nonnull adContainerView) {
        DBStrongSelfElseReturn
        if (!adContainerView) return;
        
        if ([self.adContainerView isEqual:adContainerView]) {
            [self.adContainerView removeFromSuperview];
            [self.containerBoxView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.searchTextField.mas_bottom).offset(10);
            }];
            
            self.adContainerView = nil;
        }else{
            if (self.adContainerView) [self.adContainerView removeFromSuperview];
            
            [self.view addSubview:adContainerView];
            [adContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(0);
                make.size.mas_equalTo(adContainerView.size);
                make.top.mas_equalTo(self.searchTextField.mas_bottom);
            }];
            
            [self.containerBoxView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.searchTextField.mas_bottom).offset(adContainerView.height+10);
            }];
            
            self.adContainerView = adContainerView;
        }
        
        self.adContainerView.hidden = self.containerBoxView.hidden;
    }];
}

- (void)setUpTagViews{
    DBSearchTagModel *tag = DBSearchTagModel.new;
    CGFloat left = tag.margin;
    CGFloat y = 30;
    CGFloat height = 34;
    NSMutableArray *tagViews = [NSMutableArray array];
    NSArray *tagsList = DBSearchTagModel.tagsList;
    if (self.tagViews.count){
        DBBaseLabel *label = self.tagViews.lastObject;
        NSInteger index = [tagsList indexOfObject:label.text];
        if (tagsList.count-index > 10)
            tagsList = [tagsList subarrayWithRange:NSMakeRange(index+1, tagsList.count-index-1)];
    }
    
    for (NSString *text in tagsList) {
        CGRect textRect = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName: tag.font}
                                             context:nil];
        if (left+textRect.size.width+tag.thicken > UIScreen.screenWidth-tag.margin){
            left = tag.margin;
            y += height+10;
        }
        if (y > 30+44*2) break;
        DBBaseLabel *tagLabel = [[DBBaseLabel alloc] initWithFrame:CGRectMake(left, y, textRect.size.width+tag.thicken, height)];
        tagLabel.font = tag.font;
        tagLabel.textColor = tag.textColor;
        tagLabel.layer.cornerRadius = tag.borderRadius;
        tagLabel.layer.masksToBounds = YES;
        tagLabel.layer.borderWidth = tag.borderWidth;
        tagLabel.layer.borderColor = tag.borderColor.CGColor;
        tagLabel.textAlignment = NSTextAlignmentCenter;
        tagLabel.text = text;
        [self.containerBoxView addSubview:tagLabel];
        [tagViews addObject:tagLabel];
        [tagLabel addTapGestureTarget:self action:@selector(clickTagAction:)];
        
        left += tagLabel.width+tag.spacing;
    }
    self.tagViews = tagViews;
}

- (void)setUpSearchTagViews{
    for (UIView *subView in self.searchViews) {
        [subView removeFromSuperview];
    }
    
    DBSearchTagModel *tag = DBSearchTagModel.new;
    CGFloat left = tag.margin;
    CGFloat y = 290-UIScreen.navbarHeight;
    CGFloat height = 34;
    NSMutableArray *tagViews = [NSMutableArray array];
    NSArray *tagsList = DBAppSetting.setting.searchList;
    for (NSString *text in tagsList.reverseObjectEnumerator) {
        CGRect textRect = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName: tag.font}
                                             context:nil];
        if (left+textRect.size.width+tag.thicken > UIScreen.screenWidth-tag.margin){
            left = tag.margin;
            y += height+10;
        }
     
        DBBaseLabel *tagLabel = [[DBBaseLabel alloc] initWithFrame:CGRectMake(left, y, textRect.size.width+tag.thicken, height)];
        tagLabel.font = tag.font;
        tagLabel.textColor = tag.textColor;
        tagLabel.layer.cornerRadius = tag.borderRadius;
        tagLabel.layer.masksToBounds = YES;
        tagLabel.backgroundColor = tag.borderColor;
        tagLabel.textAlignment = NSTextAlignmentCenter;
        tagLabel.text = text;
        [self.containerBoxView addSubview:tagLabel];
        [tagViews addObject:tagLabel];
        [tagLabel addTapGestureTarget:self action:@selector(clickTagAction:)];
        
        left += tagLabel.width+tag.spacing;
    }
    self.searchViews = tagViews;
}

- (void)clickChangeAction{
    for (UIView *subView in self.tagViews) {
        [subView removeFromSuperview];
    }
    
    [self setUpTagViews];
}

- (void)clickCancelAction{
    [DBRouter closePage:nil params:@{kDBRouterPathNoAnimation:@1}];
}

- (void)clickDeleteAction{
    DBAppSetting *setting = DBAppSetting.setting;
    if (setting.searchList.count == 0){
        [self.view showAlertText:@"暂无热搜历史"];
        return;
    }
    setting.searchList = @[];
    [setting reloadSetting];
    [self setUpSearchTagViews];
    [self.view showAlertText:@"热搜历史已清楚"];
}

- (void)setUpSearchResult:(NSString *)text{
    [DBAFNetWorking postServiceRequestType:DBLinkSearchReport combine:nil parameInterface:@{@"form":@"1",@"keyword":DBSafeString(text)} serviceData:^(BOOL successfulRequest, id  _Nullable result, NSString * _Nullable message) {
        
    }];
    
    DBAppSetting *setting = DBAppSetting.setting;
    NSMutableArray *searchList = [NSMutableArray arrayWithArray:setting.searchList];
    if (![searchList containsObject:text]){
        [searchList addObject:text];
        setting.searchList = searchList;
        [setting reloadSetting];
    }
    [self setUpSearchTagViews];
    [self.searchTextField resignFirstResponder];
    
    for (UIViewController *childVc in self.childViewControllers) {
        [childVc removeFromParentViewController];
        [childVc.view removeFromSuperview];
    }
    
    DBSearchResultViewController *searchResultVc = [[DBSearchResultViewController alloc] init];
    searchResultVc.searchWords = text;
    searchResultVc.form = @"1";
    [self addChildViewController:searchResultVc];
    [self.view addSubview:searchResultVc.view];
    searchResultVc.view.frame = CGRectMake(0, UIScreen.navbarHeight, UIScreen.screenWidth, UIScreen.screenHeight-UIScreen.navbarHeight);
    
    self.containerBoxView.hidden = YES;
    self.adContainerView.hidden = YES;
}

- (void)clickTagAction:(UITapGestureRecognizer *)tap{
    DBBaseLabel *label = (DBBaseLabel *)tap.view;
    NSString *text = label.text;
    self.searchTextField.text = label.text;
    [self setUpSearchResult:text];
}

- (void)clickCloseAction{
    self.searchTextField.text = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *text = textField.text.whitespace;
    if (text.length){
        [self setUpSearchResult:text];
    }else{
        [self.view showAlertText:@"请输入搜索内容"];
    }
 
    return YES;
}

- (UIView *)containerBoxView{
    if (!_containerBoxView){
        _containerBoxView = [[UIView alloc] init];
    }
    return _containerBoxView;
}

- (DBBaseLabel *)hotLabel{
    if (!_hotLabel){
        _hotLabel = [[DBBaseLabel alloc] init];
        _hotLabel.font = DBFontExtension.bodySixTenFont;
        _hotLabel.textColor = DBColorExtension.charcoalColor;
        _hotLabel.text = @"最新热搜";
    }
    return _hotLabel;
}

- (DBBaseLabel *)historyLabel{
    if (!_historyLabel){
        _historyLabel = [[DBBaseLabel alloc] init];
        _historyLabel.font = DBFontExtension.bodySixTenFont;
        _historyLabel.textColor = DBColorExtension.charcoalColor;
        _historyLabel.text = @"热搜历史";
    }
    return _historyLabel;
}

- (UITextField *)searchTextField{
    if (!_searchTextField){
        _searchTextField = [[UITextField alloc] init];
        _searchTextField.layer.cornerRadius = 18;
        _searchTextField.layer.masksToBounds = YES;
        _searchTextField.backgroundColor = DBColorExtension.paleGrayColor;
        _searchTextField.font = DBFontExtension.bodyMediumFont;
        _searchTextField.placeholder = @"输入您喜欢的小说、作者";
     
        _searchTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 0)];
        _searchTextField.leftViewMode = UITextFieldViewModeAlways;
        _searchTextField.returnKeyType = UIReturnKeyDone;
        
        UIImageView *pictureImageView = [[UIImageView alloc] init];
        pictureImageView.image = [UIImage imageNamed:@"jjLensTotem"];
        [_searchTextField addSubview:pictureImageView];
        [pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(12);
            make.width.height.mas_equalTo(14);
        }];
        
        
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 7, 16, 16)];
        [closeButton setImage:[UIImage imageNamed:@"jjCrystallineBarrier"] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(clickCloseAction) forControlEvents:UIControlEventTouchUpInside];
        [rightView addSubview:closeButton];
        _searchTextField.rightView = rightView;
        _searchTextField.rightViewMode = UITextFieldViewModeWhileEditing;
        
        _searchTextField.returnKeyType = UIReturnKeySearch;
        _searchTextField.delegate = self;
    }
    return _searchTextField;
}

- (UIButton *)cancelButton{
    if (!_cancelButton){
        _cancelButton = [[UIButton alloc] init];
        _cancelButton.titleLabel.font = DBFontExtension.pingFangSemiboldLarge;
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:DBColorExtension.charcoalColor forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(clickCancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)changeButton{
    if (!_changeButton){
        _changeButton = [[UIButton alloc] init];
        _changeButton.titleLabel.font = DBFontExtension.bodySmallFont;
        [_changeButton setTitle:@"换一换" forState:UIControlStateNormal];
        [_changeButton setImage:[UIImage imageNamed:@"jjMorphicEmblem"] forState:UIControlStateNormal];
        [_changeButton setTitleColor:DBColorExtension.charcoalColor forState:UIControlStateNormal];
        [_changeButton addTarget:self action:@selector(clickChangeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeButton;
}

- (UIButton *)deleteButton{
    if (!_deleteButton){
        _deleteButton = [[UIButton alloc] init];
        _deleteButton.enlargedEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        _deleteButton.titleLabel.font = DBFontExtension.bodySmallFont;
        [_deleteButton setTitle:@"清空" forState:UIControlStateNormal];
        [_deleteButton setTitleColor:DBColorExtension.charcoalColor forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(clickDeleteAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

- (BOOL)hiddenLeft{
    return YES;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    if (DBColorExtension.userInterfaceStyle) {
        self.gradientColorView.backgroundColor = [UIColor gradientColorSize:self.gradientColorView.size direction:DBColorDirectionVertical startColor:DBColorExtension.espressoColor endColor:DBColorExtension.blackColor];
    }else{
        self.gradientColorView.backgroundColor = [UIColor gradientColorSize:self.gradientColorView.size direction:DBColorDirectionVertical startColor:DBColorExtension.shellPinkColor endColor:DBColorExtension.whiteColor];
    }
}
@end
