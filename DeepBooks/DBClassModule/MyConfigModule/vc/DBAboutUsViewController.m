//
//  DBAboutUsViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/21.
//

#import "DBAboutUsViewController.h"

@interface DBAboutUsViewController ()<UITextViewDelegate>
@property (nonatomic, strong) UIImageView *pictureImageView;
@property (nonatomic, strong) DBBaseLabel *titlePageLabel;
@property (nonatomic, strong) DBBaseLabel *versionLabel;

@property (nonatomic, strong) UITextView *privacyTextView;
@property (nonatomic, strong) DBBaseLabel *dateLabel;
@end

@implementation DBAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
}

- (void)setUpSubViews{
    [self.view addSubviews:@[self.navLabel,self.pictureImageView,self.titlePageLabel,self.versionLabel,self.dateLabel,self.privacyTextView]];
    [self.navLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(UIScreen.navbarSafeHeight);
        make.height.mas_equalTo(UIScreen.navbarNetHeight);
    }];
    [self.pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navLabel.mas_bottom).offset(50);
        make.centerX.mas_equalTo(0);
        make.width.height.mas_equalTo(100);
    }];
    
    [self.titlePageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.pictureImageView.mas_bottom).offset(10);
    }];
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.titlePageLabel.mas_bottom).offset(10);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-UIScreen.navbarSafeHeight-10);
        make.centerX.mas_equalTo(0);
    }];
    [self.privacyTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.dateLabel.mas_top).offset(-10);
        make.centerX.mas_equalTo(0);
    }];
   
    self.titlePageLabel.text = UIApplication.appName.length>0?UIApplication.appName:UIApplication.bundleName;
    self.versionLabel.text = [NSString stringWithFormat:@"版本 %@ (Build %@)",UIApplication.appVersion,UIApplication.appBuild];
    self.dateLabel.text = [NSString stringWithFormat:@"%@ ©%ld",self.titlePageLabel.text,NSDate.new.year];
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    [DBRouter openPageUrl:DBWebView params:@{@"url":URL.absoluteString,@"title":DBSafeString([textView.text substringWithRange:characterRange]).removeBookMarks}];
    return NO;
}

- (UIImageView *)pictureImageView{
    if (!_pictureImageView){
        _pictureImageView = [[UIImageView alloc] init];
        _pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
        _pictureImageView.clipsToBounds = YES;
        _pictureImageView.layer.cornerRadius = 6;
        _pictureImageView.layer.masksToBounds = YES;
        _pictureImageView.layer.borderWidth = 1;
        _pictureImageView.layer.borderColor = DBColorExtension.mediumGrayColor.CGColor;
        _pictureImageView.image = [UIImage imageNamed:@"appLogo"];
    }
    return _pictureImageView;
}

- (DBBaseLabel *)titlePageLabel{
    if (!_titlePageLabel){
        _titlePageLabel = [[DBBaseLabel alloc] init];
        _titlePageLabel.font = DBFontExtension.bodySixTenFont;
        _titlePageLabel.textColor = DBColorExtension.charcoalColor;
    }
    return _titlePageLabel;
}

- (DBBaseLabel *)versionLabel{
    if (!_versionLabel){
        _versionLabel = [[DBBaseLabel alloc] init];
        _versionLabel.font = DBFontExtension.bodyMediumFont;
        _versionLabel.textColor = DBColorExtension.grayColor;
    }
    return _versionLabel;
}

- (DBBaseLabel *)dateLabel{
    if (!_dateLabel){
        _dateLabel = [[DBBaseLabel alloc] init];
        _dateLabel.font = DBFontExtension.bodySmallFont;
        _dateLabel.textColor = DBColorExtension.grayColor;
    }
    return _dateLabel;
}

- (UITextView *)privacyTextView{
    if (!_privacyTextView){
        _privacyTextView = [[UITextView alloc] init];
        _privacyTextView.attributedText = [NSAttributedString combineAttributeTexts:@[@"《用户服务协议》".textMultilingual,@"《隐私条款》".textMultilingual] colors:@[DBColorExtension.redColor] fonts:@[DBFontExtension.bodyMediumFont] attrs:@[@{NSLinkAttributeName:UserServiceAgreementURL},@{NSLinkAttributeName:PrivacyAgreementURL}]];

        _privacyTextView.linkTextAttributes = @{NSForegroundColorAttributeName:DBColorExtension.redColor};
        _privacyTextView.editable = NO;
        _privacyTextView.scrollEnabled = NO;
        _privacyTextView.delegate = self;
        _privacyTextView.textAlignment = NSTextAlignmentLeft;
        _privacyTextView.backgroundColor = DBColorExtension.noColor;
        _privacyTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _privacyTextView;
}
@end
