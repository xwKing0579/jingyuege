//
//  DBMobileSignInViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/21.
//

#import "DBMobileSignInViewController.h"
#import "DBContryCodeViewController.h"
#import "DBCloseTextField.h"
#import "DBUserModel.h"

@interface DBMobileSignInViewController ()<UITextViewDelegate>
@property (nonatomic, strong) DBCloseTextField *mobileTextField;
@property (nonatomic, strong) DBCloseTextField *passwordTextField;
@property (nonatomic, strong) UIButton *loginButton;

@property (nonatomic, strong) UIButton *registerButton;
@property (nonatomic, strong) UIButton *resetPasswordButton;

@property (nonatomic, strong) UIButton *contryCodeButton;

@property (nonatomic, strong) UITextView *privacyTextView;
@end

@implementation DBMobileSignInViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
}

- (void)setUpSubViews{
    [self.view addSubviews:@[self.mobileTextField,self.passwordTextField,self.loginButton,self.registerButton,self.resetPasswordButton,self.privacyTextView]];

    [self.mobileTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(UIScreen.navbarHeight+140);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(50);
    }];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.mobileTextField);
        make.top.mas_equalTo(self.mobileTextField.mas_bottom).offset(20);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.mobileTextField);
        make.height.mas_equalTo(50);
        make.top.mas_equalTo(self.passwordTextField.mas_bottom).offset(60);
    }];
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.loginButton);
        make.top.mas_equalTo(self.loginButton.mas_bottom).offset(8);
    }];
    [self.resetPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.loginButton);
        make.centerY.mas_equalTo(self.registerButton);
    }];
    [self.privacyTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-UIScreen.tabbarSafeHeight-20);
    }];
    [self setPrivacyTextView];
}

- (void)clickLoginAction{
    [self.view endEditing:YES];
    NSString *mobile = self.mobileTextField.text.whitespace;
    NSString *password = self.passwordTextField.text.whitespace;
    if (!mobile.isMobile){
        [self.view showAlertText:@"请输入正确的手机号"];
        return;
    }
    if (!password.isPassword){
        [self.view showAlertText:@"请输入正确的密码"];
        return;
    }
    
    NSString *tel = [self.contryCodeButton.titleLabel.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSDictionary *parameInterface = @{@"login":mobile,@"password":password,@"tel":tel};
    [self.view showHudLoading];
    [DBUserModel loginWithParameters:parameInterface completion:^(BOOL success) {
        [self.view removeHudLoading];
    }];
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    [DBRouter openPageUrl:DBWebView params:@{@"url":URL.absoluteString,@"title":DBSafeString([textView.text substringWithRange:characterRange]).removeBookMarks}];
    return NO;
}

- (void)clickRegisterAction{
    [DBRouter openPageUrl:@"DBMobileRegisterViewController"];
}

- (void)clickResetPasswordAction{
    [DBRouter openPageUrl:@"DBMobileForgetPasswordViewController"];
}

- (DBCloseTextField *)mobileTextField{
    if (!_mobileTextField){
        _mobileTextField = [[DBCloseTextField alloc] init];
        _mobileTextField.placeholder = @"请输入手机号";
        _mobileTextField.keyboardType = UIKeyboardTypeNumberPad;
        _mobileTextField.textColor = DBColorExtension.charcoalColor;

        _mobileTextField.layer.cornerRadius = 6;
        _mobileTextField.layer.masksToBounds = YES;
      
        _mobileTextField.layer.borderWidth = 1;
        _mobileTextField.layer.borderColor = DBColorExtension.lightSilverColor.CGColor;
        
        _mobileTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 0)];
        _mobileTextField.leftViewMode = UITextFieldViewModeAlways;
        
        UIButton *contryCodeButton = [[UIButton alloc] init];
        contryCodeButton.size = CGSizeMake(80, 50);
        contryCodeButton.titleLabel.font = DBFontExtension.pingFangMediumMedium;
        [contryCodeButton setTitle:DBCommonConfig.contryTel forState:UIControlStateNormal];
        [contryCodeButton setImage:[UIImage imageNamed:@"blue_inditor"] forState:UIControlStateNormal];
        [contryCodeButton setTitleColor:DBColorExtension.azureColor forState:UIControlStateNormal];
        [contryCodeButton addTagetHandler:^(UIButton *sender) {
            DBContryCodeViewController *contryCodeVc = (DBContryCodeViewController *)[DBRouter openPageUrl:DBContryCode];
            contryCodeVc.changeContryCodeBlock = ^(NSString * _Nonnull contryCode) {
                [sender setTitle:contryCode forState:UIControlStateNormal];
            };
        } controlEvents:UIControlEventTouchUpInside];
        [_mobileTextField addSubview:contryCodeButton];
        [contryCodeButton setTitlePosition:TitlePositionLeft spacing:6];
        self.contryCodeButton = contryCodeButton;
    }
    return _mobileTextField;
}

- (DBCloseTextField *)passwordTextField{
    if (!_passwordTextField){
        _passwordTextField = [[DBCloseTextField alloc] init];
        _passwordTextField.placeholder = @"请输入密码";
        _passwordTextField.textColor = DBColorExtension.charcoalColor;
        _passwordTextField.secureTextEntry = YES;

        _passwordTextField.layer.cornerRadius = 6;
        _passwordTextField.layer.masksToBounds = YES;
      
        _passwordTextField.layer.borderWidth = 1;
        _passwordTextField.layer.borderColor = DBColorExtension.lightSilverColor.CGColor;
        
        _passwordTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _passwordTextField;
}

- (UIButton *)loginButton{
    if (!_loginButton){
        _loginButton = [[UIButton alloc] init];
        _loginButton.layer.cornerRadius = 24;
        _loginButton.layer.masksToBounds = YES;
        _loginButton.backgroundColor = DBColorExtension.azureColor;
        _loginButton.titleLabel.font = DBFontExtension.pingFangMediumLarge;
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        
        [_loginButton addTarget:self action:@selector(clickLoginAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

- (UIButton *)registerButton{
    if (!_registerButton){
        _registerButton = [[UIButton alloc] init];
        _registerButton.titleLabel.font = DBFontExtension.bodyMediumFont;
        _registerButton.enlargedEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
        [_registerButton setTitleColor:DBColorExtension.azureColor forState:UIControlStateNormal];
        [_registerButton addTarget:self action:@selector(clickRegisterAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
}

- (UIButton *)resetPasswordButton{
    if (!_resetPasswordButton){
        _resetPasswordButton = [[UIButton alloc] init];
        _resetPasswordButton.titleLabel.font = DBFontExtension.bodyMediumFont;
        _resetPasswordButton.enlargedEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [_resetPasswordButton setTitle:@"找回密码" forState:UIControlStateNormal];
        [_resetPasswordButton setTitleColor:DBColorExtension.azureColor forState:UIControlStateNormal];
        [_resetPasswordButton addTarget:self action:@selector(clickResetPasswordAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetPasswordButton;
}

- (UITextView *)privacyTextView{
    if (!_privacyTextView){
        _privacyTextView = [[UITextView alloc] init];
   
        _privacyTextView.linkTextAttributes = @{NSForegroundColorAttributeName:DBColorExtension.azureColor};
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
    [self setPrivacyTextView];
}

- (void)setPrivacyTextView{
    self.privacyTextView.attributedText = [NSAttributedString combineAttributeTexts:@[@"《用户服务协议》".textMultilingual,@"《隐私条款》".textMultilingual] colors:@[DBColorExtension.redColor] fonts:@[DBFontExtension.bodyMediumFont] attrs:@[@{NSLinkAttributeName:UserServiceAgreementURL},@{NSLinkAttributeName:PrivacyAgreementURL}]];
}
@end
