//
//  DBFeedbackInfoViewController.m
//  DeepBooks
//
//  Created by king on 2025/3/26.
//

#import "DBFeedbackInfoViewController.h"
#import "XJInputUtil.h"
@interface DBFeedbackInfoViewController ()<UITextViewDelegate>
@property (nonatomic, strong) DBBaseLabel *titlePageLabel;
@property (nonatomic, strong) DBBaseLabel *feedbackLabel;
@property (nonatomic, strong) UITextView *feedbackTextView;
@property (nonatomic, strong) DBBaseLabel *countLabel;
@property (nonatomic, strong) DBBaseLabel *contentTextLabel;
@property (nonatomic, strong) UITextField *contactTextField;
@property (nonatomic, strong) UIButton *submitButton;

@property (nonatomic, assign) NSInteger maxLen;
@end

@implementation DBFeedbackInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
}

- (void)setUpSubViews{
    self.maxLen = 120;
    [self.view addSubviews:@[self.titlePageLabel,self.feedbackLabel,self.feedbackTextView,self.contentTextLabel,self.contactTextField,self.submitButton,self.countLabel]];
    [self.titlePageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(20);
    }];
    [self.feedbackLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.titlePageLabel.mas_bottom).offset(30);
    }];
    [self.feedbackTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(self.feedbackLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(160);
    }];
    [self.contentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.feedbackTextView.mas_bottom).offset(20);
    }];
    [self.contactTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(self.contentTextLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(44);
    }];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(self.contactTextField.mas_bottom).offset(30);
        make.height.mas_equalTo(48);
    }];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-24);
        make.bottom.mas_equalTo(self.contentTextLabel.mas_bottom).offset(-48);
    }];
    
    [self changeLimit:0];
}

- (void)clickSubmitAction{
    NSString *content = self.feedbackTextView.text.whitespace;
    NSString *contact = self.contactTextField.text.whitespace;
    if (content.length == 0){
        [self.view showAlertText:@"请输入必要内容"];
        return;
    }
    if (contact.length == 0){
        [self.view showAlertText:@"请输入联系方式"];
        return;
    }
    
    NSDictionary *parameInterface = @{@"content":content,@"contact":contact,@"serial":UIDevice.deviceuuidString,@"device":UIDevice.currentDeviceModel,@"os_version":UIDevice.systemVersion,@"app_version":UIApplication.appVersion};
    [DBAFNetWorking postServiceRequestType:DBLinkFeedBackSubmit combine:nil parameInterface:parameInterface serviceData:^(BOOL successfulRequest, id  _Nullable result, NSString * _Nullable message) {
        if (successfulRequest){
            [DBRouter closePage];
        }
        [UIScreen.appWindow showAlertText:message];
    }];
}

- (void)textViewDidChange:(UITextView *)textView{
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    if (!position) {
        NSInteger length = [XJInputUtil getStringShowLengthText:textView.text statisticsType:XJStatisticsNormal];
        if (length <= self.maxLen) {
            [self changeLimit:length];
        }else {
            // 开始裁减了
            NSString *text = textView.text;
            NSString *tobeString = [text substringToIndex:text.length - 1];
            while ([XJInputUtil getStringShowLengthText:tobeString statisticsType:XJStatisticsNormal] > self.maxLen) {
                tobeString = [tobeString substringToIndex:tobeString.length - 1];
            }
            textView.text = tobeString;
            [self changeLimit:self.maxLen];
            [self.view showAlertText:@"已超出最大字数"];
        }
    }
}

- (void)changeLimit:(NSInteger)len{
    self.countLabel.text = [NSString stringWithFormat:@"%ld/%ld",len,self.maxLen];
}

- (void)setDarkModel{
    UIColor *textColor = DBColorExtension.charcoalColor;
    if (DBColorExtension.userInterfaceStyle) {
        textColor = DBColorExtension.lightGrayColor;
    }
    self.feedbackTextView.textColor = textColor;
    self.contactTextField.textColor = textColor;
}

- (DBBaseLabel *)titlePageLabel{
    if (!_titlePageLabel){
        _titlePageLabel = [[DBBaseLabel alloc] init];
        _titlePageLabel.font = DBFontExtension.bodyMediumFont;
        _titlePageLabel.textColor = DBColorExtension.blackAltColor;
        _titlePageLabel.numberOfLines = 0;
        _titlePageLabel.text = @"您好!欢迎您给我们提出使用中遇到的问题或意见! 请详细描述您遇到的问题:比如 哪本小说无法阅读或者其他问题！请勿提交恶意谩骂以及反动词语！谢谢~";
    }
    return _titlePageLabel;
}

- (DBBaseLabel *)feedbackLabel{
    if (!_feedbackLabel){
        _feedbackLabel = [[DBBaseLabel alloc] init];
    }
    return _feedbackLabel;
}

- (UITextView *)feedbackTextView{
    if (!_feedbackTextView){
        _feedbackTextView = [[UITextView alloc] init];
        _feedbackTextView.textAlignment = NSTextAlignmentLeft;
        _feedbackTextView.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5);
        _feedbackTextView.font = DBFontExtension.bodyMediumFont;
        _feedbackTextView.textColor = DBColorExtension.charcoalColor;
        _feedbackTextView.layer.cornerRadius = 4;
        _feedbackTextView.layer.masksToBounds = YES;
        _feedbackTextView.placeholder = @"为更好解决您遇到的问题，请尽量将问题描述详细".textMultilingual;
        _feedbackTextView.delegate = self;
    }
    return _feedbackTextView;
}

- (DBBaseLabel *)countLabel{
    if (!_countLabel){
        _countLabel = [[DBBaseLabel alloc] init];
        _countLabel.font = DBFontExtension.bodySmallFont;
        _countLabel.textColor = DBColorExtension.grayColor;
        _countLabel.textAlignment = NSTextAlignmentRight;
    }
    return _countLabel;
}

- (DBBaseLabel *)contentTextLabel{
    if (!_contentTextLabel){
        _contentTextLabel = [[DBBaseLabel alloc] init];
        _contentTextLabel.font = DBFontExtension.pingFangMediumXLarge;
        _contentTextLabel.textColor = DBColorExtension.charcoalColor;
    }
    return _contentTextLabel;
}

- (UITextField *)contactTextField{
    if (!_contactTextField){
        _contactTextField = [[UITextField alloc] init];
        _contactTextField.layer.cornerRadius = 4;
        _contactTextField.layer.masksToBounds = YES;
        _contactTextField.font = DBFontExtension.bodySixTenFont;
        _contactTextField.textColor = DBColorExtension.blackAltColor;
        if (DBCommonConfig.switchAudit){
            _contactTextField.placeholder = @"请输入手机号";
        }else{
            _contactTextField.placeholder = @"请输入手机号/QQ号";
        }
        _contactTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        _contactTextField.leftViewMode = UITextFieldViewModeAlways;
        _contactTextField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        _contactTextField.rightViewMode = UITextFieldViewModeAlways;
    }
    return _contactTextField;
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

- (UIView *)listView{
    return self.view;
}

- (BOOL)hiddenLeft{
    return YES;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    UIColor *textColor = DBColorExtension.blackAltColor;
    UIColor *backgroundColor = DBColorExtension.paleGrayAltColor;
    if (DBColorExtension.userInterfaceStyle) {
        textColor = DBColorExtension.whiteAltColor;
        backgroundColor = DBColorExtension.jetBlackColor;
    }
    
    _feedbackTextView.backgroundColor = backgroundColor;
    _contactTextField.backgroundColor = backgroundColor;
    _feedbackLabel.attributedText = [NSAttributedString combineAttributeTexts:@[@"我要反馈".textMultilingual,@"（必填）".textMultilingual] colors:@[textColor,DBColorExtension.redColor] fonts:@[DBFontExtension.pingFangMediumXLarge,DBFontExtension.bodyMediumFont]];
    _contentTextLabel.attributedText = [NSAttributedString combineAttributeTexts:@[@"联系方式".textMultilingual,@"（必填）".textMultilingual] colors:@[textColor,DBColorExtension.grayColor] fonts:@[DBFontExtension.pingFangMediumXLarge,DBFontExtension.bodyMediumFont]];
}
@end
