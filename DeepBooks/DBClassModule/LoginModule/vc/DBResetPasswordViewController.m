//
//  DBResetPasswordViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/23.
//

#import "DBResetPasswordViewController.h"
#import "DBCloseTextField.h"
@interface DBResetPasswordViewController ()
@property (nonatomic, strong) DBBaseLabel *titlePageLabel;
@property (nonatomic, strong) DBCloseTextField *passwordTextField;
@property (nonatomic, strong) DBCloseTextField *newPasswordTextField;
@property (nonatomic, strong) DBCloseTextField *confirmPasswordTextField;
@property (nonatomic, strong) UIButton *confirmButton;
@end

@implementation DBResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
}

- (void)setUpSubViews{
    [self.view addSubviews:@[self.titlePageLabel,self.passwordTextField,self.newPasswordTextField,self.confirmPasswordTextField,self.confirmButton]];
    [self.titlePageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(UIScreen.navbarSafeHeight);
        make.height.mas_equalTo(UIScreen.navbarNetHeight);
    }];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(200);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(50);
    }];
    [self.newPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.passwordTextField.mas_bottom);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(50);
    }];
    [self.confirmPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.newPasswordTextField.mas_bottom);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(50);
    }];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(self.confirmPasswordTextField.mas_bottom).offset(30);
        make.height.mas_equalTo(50);
    }];
}

- (void)clickConfirmAction{
    [self.view endEditing:YES];
    NSString *password = self.passwordTextField.text.whitespace;
    NSString *newPassword1 = self.newPasswordTextField.text.whitespace;
    NSString *newPassword2 = self.confirmPasswordTextField.text.whitespace;
    if (!password.length){
        [self.view showAlertText:@"请输入原密码"];
        return;
    }
    if (!newPassword1.length){
        [self.view showAlertText:@"请输入新密码"];
        return;
    }
    if (!newPassword1.isPassword){
        [self.view showAlertText:@"请输入正确的新密码"];
        return;
    }
    if ([password isEqualToString:newPassword1]){
        [self.view showAlertText:@"旧密码和新密码不能相同"];
        return;
    }
    if (![newPassword1 isEqualToString:newPassword2]){
        [self.view showAlertText:@"输入的两次新密码不一致"];
        return;
    }
    
    [self.view showHudLoading];
    NSDictionary *parameInterface = @{@"password_old":password,@"password":newPassword1,@"password_confirm":newPassword2};
    [DBAFNetWorking postServiceRequestType:DBLinkUserPasswordModify combine:nil parameInterface:parameInterface serviceData:^(BOOL successfulRequest, id  _Nullable result, NSString * _Nullable message) {
        [self.view removeHudLoading];
        if (successfulRequest){
            [UIScreen.appWindow showAlertText:@"修改密码成功"];
            [DBRouter closePage];            
        }else{
            [self.view showAlertText:message];
        }
    }];
}

- (DBBaseLabel *)titlePageLabel{
    if (!_titlePageLabel){
        _titlePageLabel = [[DBBaseLabel alloc] init];
        _titlePageLabel.font = DBFontExtension.bodySixTenFont;
        _titlePageLabel.textColor = DBColorExtension.charcoalColor;
        _titlePageLabel.textAlignment = NSTextAlignmentCenter;
        _titlePageLabel.text = @"修改密码";
    }
    return _titlePageLabel;
}


- (DBCloseTextField *)passwordTextField{
    if (!_passwordTextField){
        _passwordTextField = [[DBCloseTextField alloc] init];
        _passwordTextField.placeholder = @"输入原密码";
        _passwordTextField.textColor = DBColorExtension.charcoalColor;
        _passwordTextField.secureTextEntry = YES;
        
        _passwordTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
        
        UIView *partingLineView = [[UIView alloc] init];
        partingLineView.backgroundColor = DBColorExtension.paleGrayColor;
        [_passwordTextField addSubview:partingLineView];
        [partingLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
    }
    return _passwordTextField;
}

- (DBCloseTextField *)newPasswordTextField{
    if (!_newPasswordTextField){
        _newPasswordTextField = [[DBCloseTextField alloc] init];
        _newPasswordTextField.placeholder = @"请输入新密码";
        _newPasswordTextField.textColor = DBColorExtension.charcoalColor;
        _newPasswordTextField.secureTextEntry = YES;

        _newPasswordTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        _newPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
        
        UIView *partingLineView = [[UIView alloc] init];
        partingLineView.backgroundColor = DBColorExtension.paleGrayColor;
        [_newPasswordTextField addSubview:partingLineView];
        [partingLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
    }
    return _newPasswordTextField;
}

- (DBCloseTextField *)confirmPasswordTextField{
    if (!_confirmPasswordTextField){
        _confirmPasswordTextField = [[DBCloseTextField alloc] init];
        _confirmPasswordTextField.placeholder = @"请输入新密码";
        _confirmPasswordTextField.textColor = DBColorExtension.charcoalColor;
        _confirmPasswordTextField.secureTextEntry = YES;

        _confirmPasswordTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        _confirmPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
        
        UIView *partingLineView = [[UIView alloc] init];
        partingLineView.backgroundColor = DBColorExtension.paleGrayColor;
        [_confirmPasswordTextField addSubview:partingLineView];
        [partingLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
    }
    return _confirmPasswordTextField;
}

- (UIButton *)confirmButton{
    if (!_confirmButton){
        _confirmButton = [[UIButton alloc] init];
        _confirmButton.layer.cornerRadius = 6;
        _confirmButton.layer.masksToBounds = YES;
        _confirmButton.backgroundColor = DBColorExtension.accountThemeColor;
        _confirmButton.titleLabel.font = DBFontExtension.pingFangMediumLarge;
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:DBColorExtension.whiteColor forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(clickConfirmAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}
@end
