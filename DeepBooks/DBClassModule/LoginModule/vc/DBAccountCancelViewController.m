//
//  DBAccountCancelViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/30.
//

#import "DBAccountCancelViewController.h"
#import "DBCloseTextField.h"
#import "DBContryCodeViewController.h"
@interface DBAccountCancelViewController ()
@property (nonatomic, strong) DBBaseLabel *titlePageLabel;
@property (nonatomic, strong) DBCloseTextField *mobileTextField;
@property (nonatomic, strong) UITextField *codeTextField;
@property (nonatomic, strong) UIButton *codeButton;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) DBBaseLabel *tipLabel;

@property (nonatomic, strong) UIButton *contryCodeButton;
@end

@implementation DBAccountCancelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
}

- (void)setUpSubViews{
    [self.view addSubviews:@[self.titlePageLabel,self.mobileTextField,self.codeTextField,self.submitButton,self.tipLabel]];
    [self.titlePageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(UIScreen.navbarSafeHeight);
        make.height.mas_equalTo(UIScreen.navbarNetHeight);
    }];
    [self.mobileTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(200);
        make.height.mas_equalTo(50);
    }];
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.mobileTextField);
        make.top.mas_equalTo(self.mobileTextField.mas_bottom);
    }];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.mobileTextField);
        make.top.mas_equalTo(self.codeTextField.mas_bottom).offset(30);
    }];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.submitButton);
        make.top.mas_equalTo(self.submitButton.mas_bottom).offset(10);
    }];
}

- (void)clickSubmitAction{
    [self.view endEditing:YES];
    NSString *mobile = DBCommonConfig.userDataInfo.account;
    NSString *code = self.codeTextField.text.whitespace;
    if (code.length == 0){
        [self.view showAlertText:@"请输入验证码"];
        return;
    }
    
    [self.view showHudLoading];
    NSString *tel = [self.contryCodeButton.titleLabel.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSDictionary *parameInterface = @{@"phone":mobile,@"tel":tel,@"code":code,@"type":@"3"};
    if (mobile.isEmail){
        parameInterface = @{@"email":mobile,@"tel":tel,@"code":code,@"type":@"3"};
    }
    [DBAFNetWorking postServiceRequestType:DBLinkUserPhoneCancel combine:nil parameInterface:parameInterface serviceData:^(BOOL successfulRequest, id  _Nullable result, NSString * _Nullable message) {
        [self.view removeHudLoading];
        if (successfulRequest){
            [UIScreen.appWindow showAlertText:@"账号注销成功"];
            
            [DBRouter closePageRoot];
            [DBCommonConfig updateUserInfo:DBUserModel.new];
            [DBBookModel removeAllCollectBooks];
            [DBBookModel removeAllReadingBooks];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UITabBarController *tabbar = (UITabBarController *)UIScreen.appWindow.rootViewController;
                tabbar.selectedIndex = 0;
            });
        }else{
            [self.view showAlertText:message];
        }
    }];
}

- (void)clickCodeAction{
    NSString *mobile = DBCommonConfig.userDataInfo.account;
    NSString *tel = [self.contryCodeButton.titleLabel.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSDictionary *parameInterface = @{@"phone":mobile,@"tel":tel?:@"86"};
    if (mobile.isEmail){
        parameInterface = @{@"email":mobile,@"tel":@"86"};
    }
    [self.view showHudLoading];
    [DBAFNetWorking postServiceRequestType:DBLinkUserPhoneCancelVeriCodeSend combine:nil parameInterface:parameInterface serviceData:^(BOOL successfulRequest, NSDictionary *result, NSString * _Nullable message) {
        [self.view removeHudLoading];
        if (successfulRequest){
            [self.view showAlertText:@"验证码已发送，10分钟内有效"];
            [self mobileCodeCountDown];
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

- (void)clickClearContentAction{
    self.codeTextField.text = nil;
}

- (DBBaseLabel *)titlePageLabel{
    if (!_titlePageLabel){
        _titlePageLabel = [[DBBaseLabel alloc] init];
        _titlePageLabel.font = DBFontExtension.bodySixTenFont;
        _titlePageLabel.textColor = DBColorExtension.charcoalColor;
        _titlePageLabel.textAlignment = NSTextAlignmentCenter;
        _titlePageLabel.text = @"账号注销";
    }
    return _titlePageLabel;
}

- (DBCloseTextField *)mobileTextField{
    if (!_mobileTextField){
        DBUserModel *user = DBCommonConfig.userDataInfo;
        _mobileTextField = [[DBCloseTextField alloc] init];
        _mobileTextField.keyboardType = UIKeyboardTypeNumberPad;
        _mobileTextField.textColor = DBColorExtension.mediumGrayColor;
        _mobileTextField.userInteractionEnabled = NO;
        _mobileTextField.text = user.phone;
        
        DBBaseLabel *mobileLabel = [[DBBaseLabel alloc] init];
        mobileLabel.textColor = DBColorExtension.charcoalColor;
        mobileLabel.font = DBFontExtension.bodySixTenFont;
        mobileLabel.textAlignment = NSTextAlignmentCenter;
        [_mobileTextField addSubview:mobileLabel];
        [mobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(60);
            make.centerY.mas_equalTo(0);
        }];
        NSString *phone = user.phone;

        if ([phone containsString:@"@"]){
          
            mobileLabel.text = @"邮箱";
            
            _mobileTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 0)];
            _mobileTextField.leftViewMode = UITextFieldViewModeAlways;
        }else{
            mobileLabel.text = @"手机号";
            
            _mobileTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 0)];
            _mobileTextField.leftViewMode = UITextFieldViewModeAlways;
            
            UIButton *contryCodeButton = [[UIButton alloc] init];
            contryCodeButton.userInteractionEnabled = NO;
            contryCodeButton.size = CGSizeMake(60, 50);
            contryCodeButton.titleLabel.font = DBFontExtension.pingFangMediumMedium;
            [contryCodeButton setTitle:[NSString stringWithFormat:@"+%@",user.tel] forState:UIControlStateNormal];
            [contryCodeButton setImage:[UIImage imageNamed:@"indicator_up"] forState:UIControlStateNormal];
            [contryCodeButton setTitleColor:DBColorExtension.redColor forState:UIControlStateNormal];
            [_mobileTextField addSubview:contryCodeButton];
            [contryCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(60);
                make.centerY.mas_equalTo(0);
                make.size.mas_equalTo(contryCodeButton.size);
            }];
            [contryCodeButton setTitlePosition:TitlePositionRight spacing:6];
            self.contryCodeButton = contryCodeButton;
            
            UIView *partingLineView = [[UIView alloc] init];
            partingLineView.backgroundColor = DBColorExtension.paleGrayColor;
            [_mobileTextField addSubview:partingLineView];
            [partingLineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(0);
                make.height.mas_equalTo(1);
            }];
        }
       
    }
    return _mobileTextField;
}

- (UITextField *)codeTextField{
    if (!_codeTextField){
        _codeTextField = [[UITextField alloc] init];
        _codeTextField.placeholder = @"请输入验证码";
        _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
        _codeTextField.textColor = DBColorExtension.charcoalColor;
        _codeTextField.secureTextEntry = YES;
        
        _codeTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 0)];
        _codeTextField.leftViewMode = UITextFieldViewModeAlways;
        
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90+40, 50)];
        rightView.backgroundColor = DBColorExtension.noColor;
        UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 40, 40)];
        [clearButton setImage:[UIImage imageNamed:@"close_icon"] forState:UIControlStateNormal];
        [clearButton addTarget:self action:@selector(clickClearContentAction) forControlEvents:UIControlEventTouchUpInside];
        [rightView addSubview:clearButton];
        _codeTextField.rightView = rightView;
        _codeTextField.rightViewMode = UITextFieldViewModeWhileEditing;
        
        DBBaseLabel *codeLabel = [[DBBaseLabel alloc] init];
        codeLabel.text = @"验证码";
        codeLabel.textColor = DBColorExtension.charcoalColor;
        codeLabel.font = DBFontExtension.bodyMediumFont;
        codeLabel.textAlignment = NSTextAlignmentCenter;
        [_codeTextField addSubview:codeLabel];
        [codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(60);
            make.centerY.mas_equalTo(0);
        }];
        
        UIView *partingLineView = [[UIView alloc] init];
        partingLineView.backgroundColor = DBColorExtension.paleGrayColor;
        [_codeTextField addSubview:partingLineView];
        [partingLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        
        UIView *segmentView = [[UIView alloc] init];
        segmentView.backgroundColor = DBColorExtension.paleGrayColor;
        [_codeTextField addSubview:segmentView];
        [segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-90);
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(40);
        }];
        
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

- (UIButton *)submitButton{
    if (!_submitButton){
        _submitButton = [[UIButton alloc] init];
        _submitButton.layer.cornerRadius = 24;
        _submitButton.layer.masksToBounds = YES;
        _submitButton.backgroundColor = DBColorExtension.accountThemeColor;
        _submitButton.titleLabel.font = DBFontExtension.pingFangMediumLarge;
        [_submitButton setTitle:@"注销" forState:UIControlStateNormal];
        
        [_submitButton addTarget:self action:@selector(clickSubmitAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

- (DBBaseLabel *)tipLabel{
    if (!_tipLabel){
        _tipLabel = [[DBBaseLabel alloc] init];
        _tipLabel.font = DBFontExtension.bodyMediumFont;
        _tipLabel.textColor = DBColorExtension.silverColor;
        _tipLabel.textAlignment = NSTextAlignmentLeft;
        _tipLabel.numberOfLines = 0;
        _tipLabel.text = @"账号注销7天内若重新注册，所有数据将自动恢复！\n7天后该账号下相关的所有数据将会永久清空且无法恢复！";
    }
    return _tipLabel;
}

@end
