//
//  DBWantBookInfoViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/26.
//

#import "DBWantBookInfoViewController.h"
#import "DBAdReadSetting.h"

@interface DBWantBookInfoViewController ()
@property (nonatomic, strong) DBBaseLabel *titlePageLabel;
@property (nonatomic, strong) UIButton *bookButton;
@property (nonatomic, strong) DBBaseLabel *contentTextLabel;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *authorTextField;
@property (nonatomic, strong) UITextField *heroTextField;

@property (nonatomic, strong) DBBaseLabel *descTextLabel;
@property (nonatomic, strong) UITextField *netTextField;

@property (nonatomic, strong) UIButton *submitButton;
@end

@implementation DBWantBookInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
    [DBUnityAdConfig.manager preloadingRewardAdPreLoadSpaceType:DBAdSpaceRequestBooks];
}

- (void)setUpSubViews{
    [self.view addSubviews:@[self.titlePageLabel,self.bookButton,self.contentTextLabel,self.nameTextField,self.authorTextField,self.heroTextField,self.descTextLabel,self.netTextField,self.submitButton]];
    
    [self.titlePageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(10);
    }];
    [self.bookButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.titlePageLabel.mas_bottom).offset(10);
        make.size.mas_equalTo(self.bookButton.size);
    }];
    [self.contentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.bookButton.mas_bottom).offset(16);
    }];
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(46);
        make.top.mas_equalTo(self.contentTextLabel.mas_bottom).offset(16);
    }];
    [self.authorTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(46);
        make.top.mas_equalTo(self.nameTextField.mas_bottom).offset(16);
    }];
    [self.heroTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(46);
        make.top.mas_equalTo(self.authorTextField.mas_bottom).offset(16);
    }];
    [self.descTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.heroTextField.mas_bottom).offset(16);
    }];
    [self.netTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(46);
        make.top.mas_equalTo(self.descTextLabel.mas_bottom).offset(16);
    }];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(self.netTextField.mas_bottom).offset(30);
        make.height.mas_equalTo(48);
    }];
}

- (void)clickBookTypeAction{}

- (void)clickSubmitAction{
    [self.view endEditing:YES];
    NSString *name = self.nameTextField.text.whitespace;
    NSString *author = self.authorTextField.text.whitespace;
    NSString *hero = self.heroTextField.text.whitespace;
    NSString *net = self.netTextField.text.whitespace;
    if (name.length == 0){
        [self.view showAlertText:@"请输入小说名"];
        return;
    }
    if (author.length == 0){
        [self.view showAlertText:@"请输入作者名"];
        return;
    }
    if (hero.length == 0){
        [self.view showAlertText:@"请输入主角名"];
        return;
    }
    if (net.length == 0){
        [self.view showAlertText:@"请输入原网站网址"];
        return;
    }
    
    for (DBBookModel *book in DBBookModel.getAllCollectBooks) {
        if ([book.name isEqualToString:name]){
            [self.view showAlertText:@"书架上已经有这本书啦"];
            return;
        }
    }
    
    NSString *remark = [NSString stringWithFormat:@"原网址:%@ 主角名:%@",net,hero];
    NSDictionary *parameInterface = @{@"author":author,@"name":name,@"remark":remark,@"form":@"1"};
   
    
    DBAdPosModel *posAd = [DBUnityAdConfig adPosWithSpaceType:DBAdSpaceRequestBooks];
    if (DBUnityAdConfig.openAd && posAd.ads.count && posAd.extra.free_count > 0){
        DBWeakSelf
        DBAdReadSetting *adSetting = DBAdReadSetting.setting;
        if (!adSetting.isFreeRequestBook){
            adSetting.isFreeRequestBook = YES;
            adSetting.seekingBookCount = posAd.extra.limit;
            [adSetting reloadSetting];
        }
        
        if (adSetting.seekingBookCount <= 0) {
            self.submitButton.backgroundColor = DBColorExtension.grayColor;
            self.submitButton.userInteractionEnabled = NO;
            [DBUnityAdConfig.manager openRewardAdSpaceType:DBAdSpaceRequestBooks completion:^(BOOL removed) {
                DBStrongSelfElseReturn
                self.submitButton.backgroundColor = DBColorExtension.redColor;
                self.submitButton.userInteractionEnabled = YES;
                if (removed) {
                    adSetting.seekingBookCount = MAX(1, posAd.extra.limit);
                    [adSetting reloadSetting];
                    [self clickSubmitActionNext:parameInterface];
                }
            }];
        }else{
            [self clickSubmitActionNext:parameInterface];
        }
    }else{
        [self clickSubmitActionNext:parameInterface];
    }
}

- (void)clickSubmitActionNext:(NSDictionary *)parameInterface{
    [self.view showHudLoading];
    [DBAFNetWorking postServiceRequestType:DBLinkUserAskBook combine:nil parameInterface:parameInterface serviceData:^(BOOL successfulRequest, id  _Nullable result, NSString * _Nullable message) {
        [self.view removeHudLoading];
        if (successfulRequest){
            DBAdReadSetting *adSetting = DBAdReadSetting.setting;
            adSetting.seekingBookCount = MAX(0, adSetting.seekingBookCount-1);
            [adSetting reloadSetting];
            
            [DBRouter closePage];
        }
        [UIScreen.appWindow showAlertText:message];
    }];
}

- (void)setDarkModel{
    UIColor *textColor = DBColorExtension.charcoalColor;
    if (DBColorExtension.userInterfaceStyle) {
        textColor = DBColorExtension.lightGrayColor;
    }
    self.nameTextField.textColor = textColor;
    self.authorTextField.textColor = textColor;
    self.heroTextField.textColor = textColor;
    self.netTextField.textColor = textColor;
}


- (UIView *)listView{
    return self.view;
}

- (DBBaseLabel *)titlePageLabel{
    if (!_titlePageLabel){
        _titlePageLabel = [[DBBaseLabel alloc] init];
        _titlePageLabel.font = DBFontExtension.bodyMediumFont;
        _titlePageLabel.textColor = DBColorExtension.charcoalColor;
        _titlePageLabel.text = @"请选择求书的类型";
    }
    return _titlePageLabel;
}

- (UIButton *)bookButton{
    if (!_bookButton){
        _bookButton = [[UIButton alloc] init];
        _bookButton.titleLabel.font = DBFontExtension.pingFangMediumXLarge;
        _bookButton.size = CGSizeMake(80, 30);
        _bookButton.selected = YES;
        [_bookButton setTitle:@"小说" forState:UIControlStateNormal];
        [_bookButton setTitleColor:DBColorExtension.charcoalColor forState:UIControlStateNormal];
        [_bookButton setTitleColor:DBColorExtension.redColor forState:UIControlStateSelected];
        [_bookButton setImage:[UIImage imageNamed:@"unsel_icon"] forState:UIControlStateNormal];
        [_bookButton setImage:[UIImage imageNamed:@"sel_icon"] forState:UIControlStateSelected];
        [_bookButton addTarget:self action:@selector(clickBookTypeAction) forControlEvents:UIControlEventTouchUpInside];
        [_bookButton setTitlePosition:TitlePositionLeft spacing:8];
    }
    return _bookButton;
}

- (DBBaseLabel *)contentTextLabel{
    if (!_contentTextLabel){
        _contentTextLabel = [[DBBaseLabel alloc] init];
        _contentTextLabel.font = DBFontExtension.bodyMediumFont;
        _contentTextLabel.textColor = DBColorExtension.charcoalColor;
        _contentTextLabel.text = @"请输入以下必要信息";
    }
    return _contentTextLabel;
}

- (UITextField *)nameTextField{
    if (!_nameTextField){
        _nameTextField = [[UITextField alloc] init];
        _nameTextField.layer.cornerRadius = 4;
        _nameTextField.layer.masksToBounds = YES;
        _nameTextField.backgroundColor = DBColorExtension.paleGrayColor;
        _nameTextField.font = DBFontExtension.bodySixTenFont;
        _nameTextField.textColor = DBColorExtension.charcoalColor;
        _nameTextField.placeholder = @"需要求书的小说名(必填)";
        _nameTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        _nameTextField.leftViewMode = UITextFieldViewModeAlways;
        _nameTextField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        _nameTextField.rightViewMode = UITextFieldViewModeAlways;
    }
    return _nameTextField;
}

- (UITextField *)authorTextField{
    if (!_authorTextField){
        _authorTextField = [[UITextField alloc] init];
        _authorTextField.layer.cornerRadius = 4;
        _authorTextField.layer.masksToBounds = YES;
        _authorTextField.backgroundColor = DBColorExtension.paleGrayColor;
        _authorTextField.font = DBFontExtension.bodySixTenFont;
        _authorTextField.textColor = DBColorExtension.charcoalColor;
        _authorTextField.placeholder = @"需要求书的作者名(必填)";
        _authorTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        _authorTextField.leftViewMode = UITextFieldViewModeAlways;
        _authorTextField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        _authorTextField.rightViewMode = UITextFieldViewModeAlways;
    }
    return _authorTextField;
}

- (UITextField *)heroTextField{
    if (!_heroTextField){
        _heroTextField = [[UITextField alloc] init];
        _heroTextField.layer.cornerRadius = 4;
        _heroTextField.layer.masksToBounds = YES;
        _heroTextField.backgroundColor = DBColorExtension.paleGrayColor;
        _heroTextField.font = DBFontExtension.bodySixTenFont;
        _heroTextField.textColor = DBColorExtension.charcoalColor;
        _heroTextField.placeholder = @"需要求书的主角名(必填)";
        _heroTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        _heroTextField.leftViewMode = UITextFieldViewModeAlways;
        _heroTextField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        _heroTextField.rightViewMode = UITextFieldViewModeAlways;
    }
    return _heroTextField;
}

- (DBBaseLabel *)descTextLabel{
    if (!_descTextLabel){
        _descTextLabel = [[DBBaseLabel alloc] init];
        _descTextLabel.font = DBFontExtension.bodyMediumFont;
        _descTextLabel.textColor = DBColorExtension.charcoalColor;
        _descTextLabel.text = @"您是在那个网站知道这本书的";
    }
    return _descTextLabel;
}

- (UITextField *)netTextField{
    if (!_netTextField){
        _netTextField = [[UITextField alloc] init];
        _netTextField.layer.cornerRadius = 4;
        _netTextField.layer.masksToBounds = YES;
        _netTextField.backgroundColor = DBColorExtension.paleGrayColor;
        _netTextField.font = DBFontExtension.bodySixTenFont;
        _netTextField.textColor = DBColorExtension.charcoalColor;
        _netTextField.placeholder = @"请输入求书的网站网址(必填)";
        _netTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        _netTextField.leftViewMode = UITextFieldViewModeAlways;
        _netTextField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        _netTextField.rightViewMode = UITextFieldViewModeAlways;
    }
    return _netTextField;
}

- (UIButton *)submitButton{
    if (!_submitButton){
        _submitButton = [[UIButton alloc] init];
        _submitButton.titleLabel.font = DBFontExtension.bodySixTenFont;
        _submitButton.backgroundColor = DBColorExtension.redColor;
        _submitButton.layer.cornerRadius = 24;
        _submitButton.layer.masksToBounds = YES;
        [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
        [_submitButton setTitleColor:DBColorExtension.whiteColor forState:UIControlStateNormal];
        [_submitButton addTarget:self action:@selector(clickSubmitAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

- (BOOL)hiddenLeft{
    return YES;
}

@end
