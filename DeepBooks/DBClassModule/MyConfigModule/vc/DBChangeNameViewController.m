//
//  DBChangeNameViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/26.
//

#import "DBChangeNameViewController.h"

@interface DBChangeNameViewController ()
@property (nonatomic, strong) UITextField *changeTextField;
@property (nonatomic, strong) UIButton *confirmButton;
@end

@implementation DBChangeNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
}

- (void)setUpSubViews{
    self.title = DBConstantString.ks_changeNickname;
    [self.view addSubviews:@[self.navLabel,self.changeTextField,self.confirmButton]];
    [self.navLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(UIScreen.navbarSafeHeight);
        make.height.mas_equalTo(UIScreen.navbarNetHeight);
    }];
    [self.changeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(self.navLabel.mas_bottom).offset(16);
        make.height.mas_equalTo(50);
    }];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(self.navLabel);
    }];
}

- (void)clickConfirmAction{
    NSString *nickName = self.changeTextField.text.whitespace;
    if (nickName.length == 0){
        [self.view showAlertText:DBConstantString.ks_enterNickname];
        return;
    }
    if ([nickName isEqualToString:DBCommonConfig.userDataInfo.nick]){
        [self.view showAlertText:DBConstantString.ks_uniqueNicknameRequired];
        return;
    }
    if (nickName.length > 20){
        [self.view showAlertText:DBConstantString.ks_nicknameTooLong];
        return;
    }

    [self.view showHudLoading];
    [DBAFNetWorking postServiceRequestType:DBLinkUserNickModify combine:nil parameInterface:@{@"nick":nickName} modelClass:nil serviceData:^(BOOL successfulRequest, id  _Nullable result, NSString * _Nullable message) {
        [self.view removeHudLoading];
        if (successfulRequest){
            DBUserModel *model = DBCommonConfig.userDataInfo;
            model.nick = nickName;
            [DBCommonConfig updateUserInfo:model];
            
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
    self.changeTextField.textColor = textColor;
}

- (UITextField *)changeTextField{
    if (!_changeTextField){
        _changeTextField = [[UITextField alloc] init];
        _changeTextField.layer.cornerRadius = 4;
        _changeTextField.layer.masksToBounds = YES;
        _changeTextField.backgroundColor = DBColorExtension.paleGrayColor;
        _changeTextField.font = DBFontExtension.bodySixTenFont;
        _changeTextField.textColor = DBColorExtension.charcoalColor;
        _changeTextField.placeholder = DBConstantString.ks_newNickname;
        _changeTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        _changeTextField.leftViewMode = UITextFieldViewModeAlways;
        _changeTextField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        _changeTextField.rightViewMode = UITextFieldViewModeAlways;
    }
    return _changeTextField;
}

- (UIButton *)confirmButton{
    if (!_confirmButton){
        _confirmButton = [[UIButton alloc] init];
        _confirmButton.titleLabel.font = DBFontExtension.titleSmallFont;
        _confirmButton.enlargedEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [_confirmButton setTitle:DBConstantString.ks_save forState:UIControlStateNormal];
        [_confirmButton setTitleColor:DBColorExtension.charcoalColor forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(clickConfirmAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}
@end
