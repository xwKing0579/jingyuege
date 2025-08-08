//
//  DBEmailSignInViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/7.
//

#import "DBEmailSignInViewController.h"
#import "DBContryCodeViewController.h"
#import "DBCloseTextField.h"
#import "DBUserModel.h"

@interface DBEmailSignInViewController ()
@property (nonatomic, strong) DBCloseTextField *emailTextField;
@property (nonatomic, strong) DBCloseTextField *passwordTextField;
@property (nonatomic, strong) UIButton *loginButton;

@property (nonatomic, strong) UIButton *registerButton;
@property (nonatomic, strong) UIButton *resetPasswordButton;

@end

@implementation DBEmailSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
}

- (void)setUpSubViews{
    [self.view addSubviews:@[self.emailTextField,self.passwordTextField,self.loginButton,self.registerButton,self.resetPasswordButton]];

    [self.emailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(50);
    }];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.emailTextField);
        make.top.mas_equalTo(self.emailTextField.mas_bottom).offset(20);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.emailTextField);
        make.height.mas_equalTo(50);
        make.top.mas_equalTo(self.passwordTextField.mas_bottom).offset(40);
    }];
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.loginButton);
        make.top.mas_equalTo(self.loginButton.mas_bottom).offset(8);
    }];
    [self.resetPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.loginButton);
        make.centerY.mas_equalTo(self.registerButton);
    }];

}

- (void)clickLoginAction{
    [self.view endEditing:YES];
    NSString *email = self.emailTextField.text.whitespace;
    NSString *password = self.passwordTextField.text.whitespace;
    if (!email.isEmail){
        [UIScreen.currentViewController.view showAlertText:DBConstantString.ks_validEmail];
        return;
    }
    if (!password.isPassword){
        [UIScreen.currentViewController.view showAlertText:DBConstantString.ks_invalidPassword];
        return;
    }
    
    NSDictionary *parameInterface = @{@"email":email,@"password":password};
    [UIScreen.currentViewController.view showHudLoading];
    [DBUserModel loginWithParameters:parameInterface completion:^(BOOL success) {
        [UIScreen.currentViewController.view removeHudLoading];
    }];
}

- (void)clickRegisterAction{
    [DBRouter openPageUrl:DBRegister params:@{@"index":@1}];
}

- (void)clickResetPasswordAction{
    [DBRouter openPageUrl:DBFogetPassword params:@{@"index":@1}];
}

- (DBCloseTextField *)emailTextField{
    if (!_emailTextField){
        _emailTextField = [[DBCloseTextField alloc] init];
        _emailTextField.placeholder = DBConstantString.ks_enterEmail;
        _emailTextField.textColor = DBColorExtension.charcoalColor;

        _emailTextField.layer.cornerRadius = 6;
        _emailTextField.layer.masksToBounds = YES;
      
        _emailTextField.layer.borderWidth = 1;
        _emailTextField.layer.borderColor = DBColorExtension.lightSilverColor.CGColor;
        
        _emailTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        _emailTextField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _emailTextField;
}

- (DBCloseTextField *)passwordTextField{
    if (!_passwordTextField){
        _passwordTextField = [[DBCloseTextField alloc] init];
        _passwordTextField.placeholder = DBConstantString.ks_enterPassword;
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
        _loginButton.backgroundColor = DBColorExtension.accountThemeColor;
        _loginButton.titleLabel.font = DBFontExtension.pingFangMediumLarge;
        [_loginButton setTitle:DBConstantString.ks_login forState:UIControlStateNormal];
        
        [_loginButton addTarget:self action:@selector(clickLoginAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

- (UIButton *)registerButton{
    if (!_registerButton){
        _registerButton = [[UIButton alloc] init];
        _registerButton.titleLabel.font = DBFontExtension.bodyMediumFont;
        _registerButton.enlargedEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [_registerButton setTitle:DBConstantString.ks_signUp forState:UIControlStateNormal];
        [_registerButton setTitleColor:DBColorExtension.charcoalColor forState:UIControlStateNormal];
        [_registerButton addTarget:self action:@selector(clickRegisterAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
}

- (UIButton *)resetPasswordButton{
    if (!_resetPasswordButton){
        _resetPasswordButton = [[UIButton alloc] init];
        _resetPasswordButton.titleLabel.font = DBFontExtension.bodyMediumFont;
        _resetPasswordButton.enlargedEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [_resetPasswordButton setTitle:DBConstantString.ks_recoverPassword forState:UIControlStateNormal];
        [_resetPasswordButton setTitleColor:DBColorExtension.charcoalColor forState:UIControlStateNormal];
        [_resetPasswordButton addTarget:self action:@selector(clickResetPasswordAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetPasswordButton;
}
- (BOOL)hiddenLeft{
    return YES;
}

- (UIView *)listView{
    return self.view;
}

@end
