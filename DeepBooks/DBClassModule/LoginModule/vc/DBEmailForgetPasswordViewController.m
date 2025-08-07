//
//  DBEmailForgetPasswordViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/7.
//

#import "DBEmailForgetPasswordViewController.h"
#import "DBContryCodeViewController.h"
#import "DBCloseTextField.h"
#import "DBRegisterModel.h"
@interface DBEmailForgetPasswordViewController ()
@property (nonatomic, strong) DBCloseTextField *emailTextField;
@property (nonatomic, strong) UITextField *codeTextField;
@property (nonatomic, strong) DBCloseTextField *passwordTextField;
@property (nonatomic, strong) DBCloseTextField *passwordAgainTextField;
@property (nonatomic, strong) UIButton *codeButton;
@property (nonatomic, strong) UIButton *confimButton;

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *action_type;
@end

@implementation DBEmailForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.type = @"5";
    self.action_type = @"0";
    [self setUpSubViews];
}

- (void)setUpSubViews{
    [self.view addSubviews:@[self.emailTextField,self.codeTextField,self.passwordTextField,self.passwordAgainTextField,self.confimButton]];

    [self.emailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(50);
    }];
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.emailTextField);
        make.top.mas_equalTo(self.emailTextField.mas_bottom).offset(20);
    }];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.emailTextField);
        make.top.mas_equalTo(self.codeTextField.mas_bottom).offset(20);
    }];
    [self.passwordAgainTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.emailTextField);
        make.top.mas_equalTo(self.passwordTextField.mas_bottom).offset(20);
    }];
    [self.confimButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.emailTextField);
        make.height.mas_equalTo(50);
        make.top.mas_equalTo(self.passwordAgainTextField.mas_bottom).offset(40);
    }];
}

- (void)clickConfirmAction{
    [self.view endEditing:YES];
    NSString *email = self.emailTextField.text.whitespace;
    NSString *password = self.passwordTextField.text.whitespace;
    NSString *passwordAgain = self.passwordAgainTextField.text.whitespace;
    NSString *code = self.codeTextField.text.whitespace;
    if (!email.isEmail){
        [UIScreen.currentViewController.view showAlertText:@"请输入正确的邮箱"];
        return;
    }
    if (!password.isPassword){
        [UIScreen.currentViewController.view showAlertText:@"请输入正确的密码"];
        return;
    }
    if (![password isEqualToString:passwordAgain]){
        [UIScreen.currentViewController.view showAlertText:@"输入的两次密码不一致"];
        return;
    }
    if (code.length == 0){
        [UIScreen.currentViewController.view showAlertText:@"请输入验证码"];
        return;
    }
    
    [UIScreen.currentViewController.view showHudLoading];
    NSString *tel = @"86";
    NSDictionary *parameInterface = @{@"email":email,@"code":code,@"password":password,@"tel":tel};
    [DBAFNetWorking postServiceRequestType:DBLinkUserPasswordForget combine:nil parameInterface:parameInterface serviceData:^(BOOL successfulRequest, id  _Nullable result, NSString * _Nullable message) {
        [UIScreen.currentViewController.view removeHudLoading];
        if (successfulRequest){
            [UIScreen.appWindow showAlertText:@"找回密码成功"];
            [DBRouter closePage];
        }else{
            [UIScreen.currentViewController.view showAlertText:message];
        }
    }];
}

- (void)clickCodeAction{
    [self.view endEditing:YES];
    NSString *email = self.emailTextField.text.whitespace;
    if (!email.isEmail){
        [UIScreen.currentViewController.view showAlertText:@"请输入正确的邮箱"];
        return;
    }
    NSString *tel = @"86";
    NSDictionary *parameInterface = @{@"email":email,@"type":self.type,@"tel":tel,@"action_type":self.action_type};
    [UIScreen.currentViewController.view showHudLoading];
    [DBAFNetWorking postServiceRequestType:DBLinkUserPhoneVeriCodeSend combine:nil parameInterface:parameInterface serviceData:^(BOOL successfulRequest, NSDictionary *result, NSString * _Nullable message) {
        [UIScreen.currentViewController.view removeHudLoading];
        if (successfulRequest){
            DBRegisterModel *model = [DBRegisterModel yy_modelWithDictionary:result];
            if (model.type == 1){
                NSString *message = [NSString stringWithFormat:@"该用户名已绑定邮箱:%@，可使用“邮箱忘记密码”功能来找回密码。如该邮箱已遗失，可以使用新邮箱来重置密码。",email];
                LEEAlert.alert.config.LeeTitle(@"温馨提示").
                LeeContent(message).
                LeeCancelAction(@"取消", ^{
                    
                }).LeeAction(@"确定", ^{
                    self.type = @"7";
                    self.action_type = @"1";
                    [self clickCodeAction];
                }).LeeShow();
            }else{
                [UIScreen.currentViewController.view showAlertText:@"验证码已发送，10分钟内有效"];
                [self emailCodeCountDown];
            }
        }else{
            [UIScreen.currentViewController.view showAlertText:message];
        }
    }];
}

- (void)emailCodeCountDown{
    self.codeButton.userInteractionEnabled = NO;
    self.emailTextField.userInteractionEnabled = NO;
    __block NSInteger second = 60;
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (second == 0) {
                self.codeButton.userInteractionEnabled = YES;
                self.emailTextField.userInteractionEnabled = YES;
                [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                dispatch_cancel(timer);
            } else {
                [self.codeButton setTitle:[NSString stringWithFormat:@"%02lds",second] forState:UIControlStateNormal];
                second--;
            }
        });
    });
    dispatch_resume(timer);
}

- (DBCloseTextField *)emailTextField{
    if (!_emailTextField){
        _emailTextField = [[DBCloseTextField alloc] init];
        _emailTextField.placeholder = @"请输入邮箱";
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

- (UITextField *)codeTextField{
    if (!_codeTextField){
        _codeTextField = [[UITextField alloc] init];
        _codeTextField.placeholder = @"请输入验证码";
        _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
        _codeTextField.textColor = DBColorExtension.charcoalColor;

        _codeTextField.layer.cornerRadius = 6;
        _codeTextField.layer.masksToBounds = YES;
      
        _codeTextField.layer.borderWidth = 1;
        _codeTextField.layer.borderColor = DBColorExtension.lightSilverColor.CGColor;
        
        _codeTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        _codeTextField.leftViewMode = UITextFieldViewModeAlways;
        _codeTextField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 0)];
        _codeTextField.rightViewMode = UITextFieldViewModeAlways;
        
        [_codeTextField addSubview:self.codeButton];
        [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(36);
            make.centerY.mas_equalTo(0);
        }];
    }
    return _codeTextField;
}

- (UIButton *)codeButton{
    if (!_codeButton){
        _codeButton = [[UIButton alloc] init];
        _codeButton.layer.cornerRadius = 8;
        _codeButton.layer.masksToBounds = YES;
        _codeButton.backgroundColor = DBColorExtension.accountThemeColor;
        _codeButton.titleLabel.font = DBFontExtension.bodySmallFont;
        [_codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_codeButton setTitleColor:DBColorExtension.whiteColor forState:UIControlStateNormal];
        [_codeButton addTarget:self action:@selector(clickCodeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _codeButton;
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

- (DBCloseTextField *)passwordAgainTextField{
    if (!_passwordAgainTextField){
        _passwordAgainTextField = [[DBCloseTextField alloc] init];
        _passwordAgainTextField.placeholder = @"请再次输入密码";
        _passwordAgainTextField.textColor = DBColorExtension.charcoalColor;
        _passwordAgainTextField.secureTextEntry = YES;
        
        _passwordAgainTextField.layer.cornerRadius = 6;
        _passwordAgainTextField.layer.masksToBounds = YES;
      
        _passwordAgainTextField.layer.borderWidth = 1;
        _passwordAgainTextField.layer.borderColor = DBColorExtension.lightSilverColor.CGColor;
        
        _passwordAgainTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        _passwordAgainTextField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _passwordAgainTextField;
}

- (UIButton *)confimButton{
    if (!_confimButton){
        _confimButton = [[UIButton alloc] init];
        _confimButton.layer.cornerRadius = 24;
        _confimButton.layer.masksToBounds = YES;
        _confimButton.backgroundColor = DBColorExtension.accountThemeColor;
        _confimButton.titleLabel.font = DBFontExtension.pingFangMediumLarge;
        [_confimButton setTitle:@"修改密码" forState:UIControlStateNormal];
        
        [_confimButton addTarget:self action:@selector(clickConfirmAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confimButton;
}

- (BOOL)hiddenLeft{
    return YES;
}

- (UIView *)listView{
    return self.view;
}

@end
