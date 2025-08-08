//
//  GLDomainSwitchViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/6/3.
//

#import "GLDomainSwitchViewController.h"
#import "UIDevice+Category.h"
#import "DBDomainManager.h"
@interface GLDomainSwitchViewController ()
@property (nonatomic, strong) DBBaseLabel *pageNameLabel;
@property (nonatomic, strong) DBBaseLabel *domainLabel;
@property (nonatomic, strong) UISwitch *domainSwitch;

@property (nonatomic, strong) DBBaseLabel *adLabel;
@property (nonatomic, strong) UISwitch *adSwitch;

@property (nonatomic, strong) DBBaseLabel *reviewLabel;
@property (nonatomic, strong) UISwitch *reviewSwitch;

@property (nonatomic, strong) UITextField *chageDomainTextField;
@property (nonatomic, strong) UIButton *chageDomainButton;

@property (nonatomic, strong) UITextField *chageBundleTextField;
@property (nonatomic, strong) UIButton *chageBundleButton;

@property (nonatomic, strong) NSMutableSet *recordDomain;
@property (nonatomic, strong) NSMutableSet *recordBundle;
@end


NSString *domainCacheKey = @"domainCacheKey";
NSString *BundleCacheKey = @"BundleCacheKey";

@implementation GLDomainSwitchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
}

- (void)setUpSubViews{
    [self.view addSubviews:@[self.pageNameLabel,self.domainLabel,self.domainSwitch,self.adLabel,self.adSwitch,self.chageDomainTextField,self.chageDomainButton,self.chageBundleTextField,self.chageBundleButton]];
    
    [self.pageNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(30);
    }];
    [self.domainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.pageNameLabel);
        make.right.mas_equalTo(-130);
        make.top.mas_equalTo(self.pageNameLabel.mas_bottom).offset(16);
    }];
    [self.domainSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-30);
        make.centerY.mas_equalTo(self.domainLabel);
        make.height.mas_equalTo(34);
    }];
    
    [self.adLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.pageNameLabel);
        make.right.mas_equalTo(-130);
        make.top.mas_equalTo(self.domainLabel.mas_bottom).offset(30);
    }];
    [self.adSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-30);
        make.centerY.mas_equalTo(self.adLabel);
        make.height.mas_equalTo(34);
    }];

    [self.chageDomainTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.top.mas_equalTo(self.adLabel.mas_bottom).offset(30);
        make.right.mas_equalTo(-120);
        make.height.mas_equalTo(44);
    }];
    [self.chageDomainButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(self.chageDomainTextField);
        make.height.mas_equalTo(34);
        make.width.mas_equalTo(80);
    }];
    [self.chageBundleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.top.mas_equalTo(self.chageDomainTextField.mas_bottom).offset(30);
        make.right.mas_equalTo(-120);
        make.height.mas_equalTo(44);
    }];
    [self.chageBundleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(self.chageBundleTextField);
        make.height.mas_equalTo(34);
        make.width.mas_equalTo(80);
    }];
    
    self.domainSwitch.on = [[NSUserDefaults takeValueForKey:@"GLDomainSwitchViewController"] boolValue];
    
    BOOL adSwitch = [[NSUserDefaults takeValueForKey:@"DBAdvertisingSwitch"] boolValue];
    self.adLabel.text = [NSString stringWithFormat:@"广告开关：%@", adSwitch ? @"开" : @"关"];
    self.adSwitch.on = adSwitch;
    
    DBBaseLabel *tipLabel = [[DBBaseLabel alloc] init];
    tipLabel.font = UIFont.font14;
    tipLabel.textColor = UIColor.redColor;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.text = @"修改后请退出登录并重启app";
    [self.view addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-10-UIScreen.tabbarSafeHeight);
    }];
    
 
    [self.view layoutIfNeeded];
    NSArray *domainList = [NSUserDefaults takeValueForKey:domainCacheKey];
    if (domainList.count) [self.recordDomain addObjectsFromArray:domainList];
    
    CGFloat left = 30;
    CGFloat top = self.chageBundleTextField.y+100;
    for (NSString *domainStr in self.recordDomain.allObjects) {
        UIButton *actionButton = [[UIButton alloc] init];
        actionButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
        actionButton.titleLabel.font = UIFont.font12;
        actionButton.layer.cornerRadius = 6;
        actionButton.layer.masksToBounds = YES;
        actionButton.layer.borderColor = UIColor.grayColor.CGColor;
        actionButton.layer.borderWidth = 1;
        [actionButton setTitle:domainStr forState:UIControlStateNormal];
        [actionButton setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
        [actionButton addTarget:self action:@selector(clickOtherDoamin:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:actionButton];
        [actionButton sizeToFit];
        if (left+actionButton.width > UIScreen.screenWidth-30){
            left = 30;
            top += 40;
        }
        
        [actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(left);
            make.top.mas_equalTo(top);
            make.height.mas_equalTo(28);
        }];
        
        left += actionButton.width+12;
    }
    
    NSArray *bundleList = [NSUserDefaults takeValueForKey:BundleCacheKey];
    if (bundleList.count) [self.recordBundle addObjectsFromArray:bundleList];
    
    left = 30;
    top += 60;
    for (NSString *domainStr in self.recordBundle.allObjects) {
        UIButton *actionButton = [[UIButton alloc] init];
        actionButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
        actionButton.titleLabel.font = UIFont.font12;
        actionButton.layer.cornerRadius = 6;
        actionButton.layer.masksToBounds = YES;
        actionButton.layer.borderColor = UIColor.grayColor.CGColor;
        actionButton.layer.borderWidth = 1;
        [actionButton setTitle:domainStr forState:UIControlStateNormal];
        [actionButton setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
        [actionButton addTarget:self action:@selector(clickOtherBundle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:actionButton];
        [actionButton sizeToFit];
        if (left+actionButton.width > UIScreen.screenWidth-30){
            left = 30;
            top += 40;
        }
        
        [actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(left);
            make.top.mas_equalTo(top);
            make.height.mas_equalTo(28);
        }];
        
        left += actionButton.width+12;
    }
}

- (void)clickOtherDoamin:(UIButton *)sender{
    self.chageDomainTextField.text = sender.titleLabel.text;
}

- (void)clickOtherBundle:(UIButton *)sender{
    self.chageBundleTextField.text = sender.titleLabel.text;
}

- (void)clickDomainSwitchAction:(UISwitch *)sender{
    DBWeakSelf
    [self.view showHudLoading];
    [DBDomainManager carryOutBusinessTest:sender.isOn completion:^(BOOL success) {
        [self.view removeHudLoading];
        DBStrongSelfElseReturn
        if (success){
            self.domainLabel.text = [NSString stringWithFormat:@"当前域名：%@",DBBaseAlamofire.domainString];
            [NSUserDefaults saveValue:@(sender.isOn) forKey:@"GLDomainSwitchViewController"];
        }else{
            sender.on = !sender.on;
        }
    }];
}

- (void)changeDomainAction{
    [self.view endEditing:YES];
    NSString *domainStr = self.chageDomainTextField.text.whitespace;
    if (domainStr.length > 0){
        DBAppSetting *setting = DBAppSetting.setting;
        setting.domain = domainStr;
        [setting reloadSetting];
        
        [self.recordDomain addObject:domainStr];
        [NSUserDefaults saveValue:self.recordDomain.allObjects forKey:domainCacheKey];
        [self.view showAlertText:@"修改域名成功，请退出登录并重启"];
    }else{
        [self.view showAlertText:DBConstantString.ks_enterText];
    }
}

- (void)changeBundleAction{
    [self.view endEditing:YES];
    NSString *bundleStr = self.chageBundleTextField.text.whitespace;
    if (bundleStr.length > 0){
        [self.recordBundle addObject:bundleStr];
        [NSUserDefaults saveValue:self.recordBundle.allObjects forKey:BundleCacheKey];
        [NSUserDefaults saveValue:bundleStr forKey:@"changeBundleName"];
        [self.view showAlertText:@"修改包名成功，请退出登录并重启"];
    }else{
        [self.view showAlertText:DBConstantString.ks_enterText];
    }
}

- (void)clickAdSwitchAction:(UISwitch *)sender{
    [NSUserDefaults saveValue:@(sender.isOn) forKey:@"DBAdvertisingSwitch"];
}

- (DBBaseLabel *)pageNameLabel{
    if (!_pageNameLabel){
        _pageNameLabel = [[DBBaseLabel alloc] init];
        _pageNameLabel.font = UIFont.font16;
        _pageNameLabel.textColor = UIColor.bf_c333333;
        _pageNameLabel.text = [NSString stringWithFormat:@"包名：%@ 版本号：%@",UIApplication.appBundle,UIDevice.appVersion];
        _pageNameLabel.numberOfLines = 0;
    }
    return _pageNameLabel;
}

- (DBBaseLabel *)domainLabel{
    if (!_domainLabel){
        _domainLabel = [[DBBaseLabel alloc] init];
        _domainLabel.font = UIFont.font16;
        _domainLabel.textColor = UIColor.bf_c333333;
        _domainLabel.text = [NSString stringWithFormat:@"当前域名：%@",DBBaseAlamofire.domainString];
        _domainLabel.numberOfLines = 0;
    }
    return _domainLabel;
}

- (UISwitch *)domainSwitch{
    if (!_domainSwitch){
        _domainSwitch = [[UISwitch alloc] init];
        [_domainSwitch addTarget:self action:@selector(clickDomainSwitchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _domainSwitch;
}

- (DBBaseLabel *)adLabel{
    if (!_adLabel){
        _adLabel = [[DBBaseLabel alloc] init];
        _adLabel.font = UIFont.font16;
        _adLabel.textColor = UIColor.bf_c333333;
        _adLabel.numberOfLines = 0;
    }
    return _adLabel;
}

- (UISwitch *)adSwitch{
    if (!_adSwitch){
        _adSwitch = [[UISwitch alloc] init];
        [_adSwitch addTarget:self action:@selector(clickAdSwitchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _adSwitch;
}


- (UITextField *)chageDomainTextField{
    if (!_chageDomainTextField){
        _chageDomainTextField = [[UITextField alloc] init];
        _chageDomainTextField.placeholder = @"域名，eg：www.a.appwan.info";
        _chageDomainTextField.font = UIFont.font14;
        _chageDomainTextField.textColor = UIColor.bf_c333333;

        _chageDomainTextField.layer.cornerRadius = 6;
        _chageDomainTextField.layer.masksToBounds = YES;
      
        _chageDomainTextField.layer.borderWidth = 1;
        _chageDomainTextField.layer.borderColor = UIColor.lightGrayColor.CGColor;
        
        _chageDomainTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        _chageDomainTextField.leftViewMode = UITextFieldViewModeAlways;
        _chageDomainTextField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        _chageDomainTextField.rightViewMode = UITextFieldViewModeAlways;
    }
    return _chageDomainTextField;
}

- (UIButton *)chageDomainButton{
    if (!_chageDomainButton){
        _chageDomainButton = [[UIButton alloc] init];
        _chageDomainButton.titleLabel.font = UIFont.font16;
        _chageDomainButton.backgroundColor = UIColor.redColor;
        _chageDomainButton.layer.cornerRadius = 6;
        _chageDomainButton.layer.masksToBounds = YES;
        [_chageDomainButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_chageDomainButton setTitle:@"修改域名" forState:UIControlStateNormal];
        [_chageDomainButton addTarget:self action:@selector(changeDomainAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chageDomainButton;
}

- (UITextField *)chageBundleTextField{
    if (!_chageBundleTextField){
        _chageBundleTextField = [[UITextField alloc] init];
        _chageBundleTextField.placeholder = @"包名，eg：com.wensige.app";
        _chageBundleTextField.font = UIFont.font14;
        _chageBundleTextField.textColor = UIColor.bf_c333333;

        _chageBundleTextField.layer.cornerRadius = 6;
        _chageBundleTextField.layer.masksToBounds = YES;
      
        _chageBundleTextField.layer.borderWidth = 1;
        _chageBundleTextField.layer.borderColor = UIColor.lightGrayColor.CGColor;
        
        _chageBundleTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        _chageBundleTextField.leftViewMode = UITextFieldViewModeAlways;
        _chageBundleTextField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        _chageBundleTextField.rightViewMode = UITextFieldViewModeAlways;
    }
    return _chageBundleTextField;
}

- (UIButton *)chageBundleButton{
    if (!_chageBundleButton){
        _chageBundleButton = [[UIButton alloc] init];
        _chageBundleButton.titleLabel.font = UIFont.font14;
        _chageBundleButton.backgroundColor = UIColor.redColor;
        _chageBundleButton.layer.cornerRadius = 6;
        _chageBundleButton.layer.masksToBounds = YES;
        [_chageBundleButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_chageBundleButton setTitle:@"修改包名" forState:UIControlStateNormal];
        [_chageBundleButton addTarget:self action:@selector(changeBundleAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chageBundleButton;
}

- (NSMutableSet *)recordDomain{
    if (!_recordDomain){
        _recordDomain = [NSMutableSet setWithArray:@[@"www.a.appwan.info",@"conf.firegold.org",]];
    }
    return _recordDomain;
}

- (NSMutableSet *)recordBundle{
    if (!_recordBundle){
        _recordBundle = [NSMutableSet setWithArray:@[@"com.wensige.app",@"com.xixixiaowu.app",@"com.sgewen.technology",@"com.guoguozibook.technology"]];
    }
    return _recordBundle;
}
@end
