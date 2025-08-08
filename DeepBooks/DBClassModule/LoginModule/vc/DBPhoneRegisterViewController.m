//
//  DBPhoneRegisterViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/7.
//

#import "DBPhoneRegisterViewController.h"
#import "DBContryCodeViewController.h"
#import "DBCloseTextField.h"
#import "DBRegisterModel.h"
#import "DBUserModel.h"

@interface DBPhoneRegisterViewController ()
@property (nonatomic, strong) DBCloseTextField *mobileTextField;
@property (nonatomic, strong) UITextField *codeTextField;
@property (nonatomic, strong) DBCloseTextField *passwordTextField;
@property (nonatomic, strong) UIButton *codeButton;
@property (nonatomic, strong) UIButton *registerButton;

@property (nonatomic, strong) UIButton *contryCodeButton;

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *action_type;
@end

@implementation DBPhoneRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.type = @"2";
    self.action_type = @"0";
    [self setUpSubViews];
}

- (void)setUpSubViews{
    [self.view addSubviews:@[self.mobileTextField,self.codeTextField,self.passwordTextField,self.registerButton]];
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
    
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.mobileTextField);
        make.height.mas_equalTo(50);
        make.top.mas_equalTo(self.passwordTextField.mas_bottom).offset(40);
    }];
}

- (void)clickCodeAction{
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
                NSString *message = [NSString stringWithFormat:DBConstantString.ks_accountRecoveryPhone,mobile];
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

- (void)clickRegisterAction{
    [self.view endEditing:YES];
    NSString *mobile = self.mobileTextField.text.whitespace;
    NSString *password = self.passwordTextField.text.whitespace;
    NSString *code = self.codeTextField.text.whitespace;
    if (!mobile.isMobile){
        [self.view showAlertText:DBConstantString.ks_validPhone];
        return;
    }
    if (!password.isPassword){
        [self.view showAlertText:DBConstantString.ks_invalidPassword];
        return;
    }
    if (code.length == 0){
        [self.view showAlertText:DBConstantString.ks_enterVerificationCode];
        return;
    }
    
    NSMutableArray *booksID = [NSMutableArray array];
    for (DBBookModel *book in DBBookModel.getAllCollectBooks) {
        [booksID addObject:@(book.book_id.intValue)];
    }
    NSMutableArray *comicsID = @[];
    
    NSString *ids = @[@{@"form":@"1",@"book_id":booksID},@{@"form":@"3",@"book_id":comicsID}].yy_modelToJSONString;
    NSString *tel = [self.contryCodeButton.titleLabel.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSDictionary *dict = @{@"login":mobile,@"password":password,@"phone_code":code,@"tel":tel,@"sex":DBAppSetting.setting.sex?:@"0",@"ids":ids};
   
    NSMutableDictionary *parameInterface = [NSMutableDictionary dictionaryWithDictionary:dict];
    [parameInterface setValue:@"apple" forKey:@"brand"];
    [parameInterface setValue:@"website" forKey:@"channel"];
    [parameInterface setValue:UIDevice.currentDeviceName forKey:@"device"];
    NSString *vercode = [NSString stringWithFormat:@"%d",UIApplication.appVersion.intValue];
    [parameInterface setValue:vercode forKey:@"vercode"];
    [parameInterface setValue:UIApplication.appVersion forKey:@"version"];
    [parameInterface setValue:UIDevice.deviceuuidString forKey:@"serial"];
    
    [self.view showHudLoading];
    [DBAFNetWorking postServiceRequestType:DBLinkUserRegiste combine:nil parameInterface:parameInterface modelClass:nil serviceData:^(BOOL successfulRequest, id  _Nullable result, NSString * _Nullable message) {
        if (successfulRequest){
            NSDictionary *loginDict = @{@"login":mobile,@"password":password,@"tel":tel};
            [DBUserModel loginWithParameters:loginDict completion:^(BOOL success) {
                [self.view removeHudLoading];
            }];
            [UIScreen.appWindow showAlertText:DBConstantString.ks_registrationSuccess];
        }else{
            [self.view removeHudLoading];
            [self.view showAlertText:message];
        }
    }];
}

- (void)loginWithParameters:(NSDictionary *)parameInterface{
    [self.view showHudLoading];
    [DBUserModel loginWithParameters:parameInterface completion:^(BOOL success) {
        [self.view removeHudLoading];
    }];
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    if ([URL.absoluteString isEqualToString:@"1"]){
        [DBRouter openPageUrl:DBServiceList params:@{@"title":DBConstantString.ks_termsOfService}];
    }else{
        [DBRouter openPageUrl:DBWebView params:@{@"title":DBConstantString.ks_privacyTerms,@"url":URL.absoluteString}];
    }
    return NO;
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

- (UIButton *)registerButton{
    if (!_registerButton){
        _registerButton = [[UIButton alloc] init];
        _registerButton.layer.cornerRadius = 24;
        _registerButton.layer.masksToBounds = YES;
        _registerButton.backgroundColor = DBColorExtension.accountThemeColor;
        _registerButton.titleLabel.font = DBFontExtension.pingFangMediumLarge;
        [_registerButton setTitle:DBConstantString.ks_signUp forState:UIControlStateNormal];
        
        [_registerButton addTarget:self action:@selector(clickRegisterAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
}

- (BOOL)hiddenLeft{
    return YES;
}

- (UIView *)listView{
    return self.view;
}
@end
