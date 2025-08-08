//
//  DBPhoneForgetPasswordViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/7.
//

#import "DBPhoneForgetPasswordViewController.h"
#import "DBContryCodeViewController.h"
#import "DBCloseTextField.h"
#import "DBRegisterModel.h"
@interface DBPhoneForgetPasswordViewController ()

@property (nonatomic, strong) DBCloseTextField *mobileTextField;
@property (nonatomic, strong) UITextField *codeTextField;
@property (nonatomic, strong) DBCloseTextField *passwordTextField;
@property (nonatomic, strong) DBCloseTextField *passwordAgainTextField;
@property (nonatomic, strong) UIButton *codeButton;
@property (nonatomic, strong) UIButton *confimButton;

@property (nonatomic, strong) UIButton *contryCodeButton;

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *action_type;
@end

@implementation DBPhoneForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.type = @"5";
    self.action_type = @"0";
    [self setUpSubViews];
}

- (void)setUpSubViews{
    [self.view addSubviews:@[self.mobileTextField,self.codeTextField,self.passwordTextField,self.passwordAgainTextField,self.confimButton]];

    [self.mobileTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(50);
    }];
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.mobileTextField);
        make.top.mas_equalTo(self.mobileTextField.mas_bottom).offset(20);
    }];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.mobileTextField);
        make.top.mas_equalTo(self.codeTextField.mas_bottom).offset(20);
    }];
    [self.passwordAgainTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.mobileTextField);
        make.top.mas_equalTo(self.passwordTextField.mas_bottom).offset(20);
    }];
    [self.confimButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.mobileTextField);
        make.height.mas_equalTo(50);
        make.top.mas_equalTo(self.passwordAgainTextField.mas_bottom).offset(40);
    }];
}

- (void)clickConfirmAction{
    [self.view endEditing:YES];
    NSString *mobile = self.mobileTextField.text.whitespace;
    NSString *password = self.passwordTextField.text.whitespace;
    NSString *passwordAgain = self.passwordAgainTextField.text.whitespace;
    NSString *code = self.codeTextField.text.whitespace;
    if (!mobile.isMobile){
        [self.view showAlertText:DBConstantString.ks_validPhone];
        return;
    }
    if (!password.isPassword){
        [self.view showAlertText:DBConstantString.ks_invalidPassword];
        return;
    }
    if (![password isEqualToString:passwordAgain]){
        [self.view showAlertText:DBConstantString.ks_passwordMismatch];
        return;
    }
    if (code.length == 0){
        [self.view showAlertText:DBConstantString.ks_enterVerificationCode];
        return;
    }
    
    [self.view showHudLoading];
    NSString *tel = [self.contryCodeButton.titleLabel.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSDictionary *parameInterface = @{@"phone":mobile,@"code":code,@"password":password,@"tel":tel};
    [DBAFNetWorking postServiceRequestType:DBLinkUserPasswordForget combine:nil parameInterface:parameInterface serviceData:^(BOOL successfulRequest, id  _Nullable result, NSString * _Nullable message) {
        [self.view removeHudLoading];
        if (successfulRequest){
            [UIScreen.appWindow showAlertText:DBConstantString.ks_passwordRecovered];
            [DBRouter closePage];
        }else{
            [self.view showAlertText:message];
        }
    }];
}

- (void)clickCodeAction{
    [self.view endEditing:YES];
    NSString *mobile = self.mobileTextField.text.whitespace;
    if (!mobile.isMobile){
        [self.view showAlertText:DBConstantString.ks_validPhone];
        return;
    }
    NSString *tel = [self.contryCodeButton.titleLabel.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSDictionary *parameInterface = @{@"phone":mobile,@"type":self.type,@"tel":tel,@"action_type":self.action_type};
    [self.view showHudLoading];
    [DBAFNetWorking postServiceRequestType:DBLinkUserPhoneVeriCodeSend combine:nil parameInterface:parameInterface serviceData:^(BOOL successfulRequest, NSDictionary *result, NSString * _Nullable message) {
        [self.view removeHudLoading];
        if (successfulRequest){
            DBRegisterModel *model = [DBRegisterModel yy_modelWithDictionary:result];
            if (model.type == 1){
                NSString *message = [NSString stringWithFormat:DBConstantString.ks_accountRecoveryEmail,model];
                LEEAlert.alert.config.LeeTitle(DBConstantString.ks_note).
                LeeContent(message).
                LeeCancelAction(DBConstantString.ks_cancel, ^{
                    
                }).LeeAction(DBConstantString.ks_confirm, ^{
                    self.type = @"7";
                    self.action_type = @"1";
                    [self clickCodeAction];
                }).LeeShow();
            }else{
                [self.view showAlertText:DBConstantString.ks_verificationCodeSent];
                [self mobileCodeCountDown];
            }
        }else{
            [self.view showAlertText:message];
        }
    }];
}

- (void)mobileCodeCountDown{
    self.codeButton.userInteractionEnabled = NO;
    self.mobileTextField.userInteractionEnabled = NO;
    __block NSInteger second = 60;
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (second == 0) {
                self.codeButton.userInteractionEnabled = YES;
                self.mobileTextField.userInteractionEnabled = YES;
                [self.codeButton setTitle:DBConstantString.ks_getVerificationCode forState:UIControlStateNormal];
                dispatch_cancel(timer);
            } else {
                [self.codeButton setTitle:[NSString stringWithFormat:@"%02lds",second] forState:UIControlStateNormal];
                second--;
            }
        });
    });
    dispatch_resume(timer);
}

- (DBCloseTextField *)mobileTextField{
    if (!_mobileTextField){
        _mobileTextField = [[DBCloseTextField alloc] init];
        _mobileTextField.placeholder = DBConstantString.ks_enterPhoneNumber;
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
        [contryCodeButton setImage:[UIImage imageNamed:@"jjAscentVector"] forState:UIControlStateNormal];
        [contryCodeButton setTitleColor:DBColorExtension.redColor forState:UIControlStateNormal];
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

- (UITextField *)codeTextField{
    if (!_codeTextField){
        _codeTextField = [[UITextField alloc] init];
        _codeTextField.placeholder = DBConstantString.ks_enterVerificationCode;
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
        [_codeButton setTitle:DBConstantString.ks_getVerificationCode forState:UIControlStateNormal];
        [_codeButton setTitleColor:DBColorExtension.whiteColor forState:UIControlStateNormal];
        [_codeButton addTarget:self action:@selector(clickCodeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _codeButton;
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

- (DBCloseTextField *)passwordAgainTextField{
    if (!_passwordAgainTextField){
        _passwordAgainTextField = [[DBCloseTextField alloc] init];
        _passwordAgainTextField.placeholder = DBConstantString.ks_reenterPassword;
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
        [_confimButton setTitle:DBConstantString.ks_changePassword forState:UIControlStateNormal];
        
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
