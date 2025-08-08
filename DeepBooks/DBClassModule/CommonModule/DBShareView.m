//
//  DBShareView.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/31.
//

#import "DBShareView.h"
#import <SDWebImage/SDWebImage.h>
#import <DeepBooks-Swift.h>

@interface DBShareView ()
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) DBBaseLabel *titlePageLabel;

@property (nonatomic, strong) UIButton *qrCodeButton;
@property (nonatomic, strong) UIButton *linkCopyButton;

@property (nonatomic, strong) UIView *qrCodeView;
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) DBBaseLabel *saveLabel;
@property (nonatomic, strong) UIImageView *qrCodeImageView;
@property (nonatomic, strong) DBBaseLabel *contentTextLabel;
@property (nonatomic, strong) DBBaseLabel *descTextLabel;

@end

@implementation DBShareView

- (instancetype)init{
    if (self == [super init]){
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{
    self.frame = UIScreen.mainScreen.bounds;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    
    [self addSubview:self.coverView];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.centerY.mas_equalTo(0);
    }];
    [self copyOfficialWebsiteLink];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    [self copyOfficialWebsiteLink];
}

- (void)copyOfficialWebsiteLink{
    NSArray *colors = @[DBColorExtension.charcoalColor,DBColorExtension.redColor];
    if (DBColorExtension.userInterfaceStyle) {
        self.titleTextLabel.textColor = DBColorExtension.lightGrayColor;
        self.contentTextLabel.textColor = DBColorExtension.lightGrayColor;
        self.descTextLabel.textColor = DBColorExtension.lightGrayColor;
        self.qrCodeView.backgroundColor = DBColorExtension.jetBlackColor;
        self.coverView.backgroundColor = DBColorExtension.jetBlackColor;
        colors = @[DBColorExtension.coolGrayColor,DBColorExtension.redColor];
    }else{
        self.titleTextLabel.textColor = DBColorExtension.charcoalColor;
        self.contentTextLabel.textColor = DBColorExtension.charcoalColor;
        self.descTextLabel.textColor = DBColorExtension.charcoalColor;
        self.qrCodeView.backgroundColor = DBColorExtension.whiteColor;
        self.coverView.backgroundColor = DBColorExtension.whiteColor;
    }
    [self.linkCopyButton setAttributedTitle:[NSAttributedString combineAttributeTexts:@[@"2.复制官网链接\n".textMultilingual,DBSafeString(DBCommonConfig.downLinkString)] colors:colors fonts:@[DBFontExtension.bodyMediumFont,DBFontExtension.bodySmallFont]] forState:UIControlStateNormal];
}

- (void)clickQRCodeAction{
    [self addSubview:self.qrCodeView];
    [self.qrCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.centerY.mas_equalTo(0);
    }];
      
    NSString *qrCodeUrl = DBCommonConfig.appConfig.urls.qr_code_url;
    [self.qrCodeImageView sd_setHighlightedImageWithURL:[NSURL URLWithString:qrCodeUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            self.qrCodeImageView.image = image;
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        }
    }];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo: (void *) contextInfo{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (error){
            [UIScreen.appWindow showAlertText:DBConstantString.ks_qrCodeSaveFailed];
        }else{
            [UIScreen.appWindow showAlertText:DBConstantString.ks_qrCodeSaved];
        }
    });
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeFromSuperview];
}

- (void)clickLinkCopyAction{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = DBCommonConfig.downLinkString;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showAlertText:DBConstantString.ks_copiedToShare];
    });
}

- (UIView *)coverView{
    if (!_coverView){
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = DBColorExtension.whiteColor;
        _coverView.layer.cornerRadius = 6;
        _coverView.layer.masksToBounds = YES;
        
        [self.coverView addSubviews:@[self.titlePageLabel,self.qrCodeButton,self.linkCopyButton]];
        [self.titlePageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(15);
        }];
        [self.qrCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(self.titlePageLabel.mas_bottom).offset(15);
            make.height.mas_equalTo(40);
        }];
        [self.linkCopyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(self.qrCodeButton.mas_bottom).offset(15);
            make.height.mas_equalTo(40);
            make.bottom.mas_equalTo(-10);
        }];
    }
    return _coverView;
}

- (DBBaseLabel *)titlePageLabel{
    if (!_titlePageLabel){
        _titlePageLabel = [[DBBaseLabel alloc] init];
        _titlePageLabel.text = DBConstantString.ks_shareVia;
        _titlePageLabel.font = DBFontExtension.pingFangMediumLarge;
        _titlePageLabel.textColor = DBColorExtension.charcoalColor;
        _titlePageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titlePageLabel;
}

- (UIButton *)qrCodeButton{
    if (!_qrCodeButton){
        _qrCodeButton = [[UIButton alloc] init];
        _qrCodeButton.titleLabel.font = DBFontExtension.bodyMediumFont;
        [_qrCodeButton setTitle:DBConstantString.ks_qrInstallStep forState:UIControlStateNormal];
        [_qrCodeButton setTitleColor:DBColorExtension.charcoalColor forState:UIControlStateNormal];
        [_qrCodeButton addTarget:self action:@selector(clickQRCodeAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *partingLineView = [[UIView alloc] init];
        partingLineView.backgroundColor = DBColorExtension.paleGrayColor;
        [_qrCodeButton addSubview:partingLineView];
        [partingLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
    }
    return _qrCodeButton;
}

- (UIButton *)linkCopyButton{
    if (!_linkCopyButton){
        _linkCopyButton = [[UIButton alloc] init];
        _linkCopyButton.titleLabel.font = DBFontExtension.bodyMediumFont;
        _linkCopyButton.titleLabel.numberOfLines = 0;
        _linkCopyButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_linkCopyButton addTarget:self action:@selector(clickLinkCopyAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _linkCopyButton;
}


- (UIView *)qrCodeView{
    if (!_qrCodeView){
        _qrCodeView = [[UIView alloc] init];
        _qrCodeView.backgroundColor = DBColorExtension.whiteColor;
        _qrCodeView.layer.cornerRadius = 6;
        _qrCodeView.layer.masksToBounds = YES;
        
        [_qrCodeView addSubviews:@[self.titleTextLabel,self.saveLabel,self.qrCodeImageView,self.contentTextLabel,self.descTextLabel]];
        [self.titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(15);
        }];
        [self.saveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(self.titleTextLabel.mas_bottom).offset(5);
        }];
        [self.qrCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(self.saveLabel.mas_bottom).offset(15);
            make.size.mas_equalTo(self.qrCodeImageView.size);
        }];
        [self.contentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(self.qrCodeImageView.mas_bottom).offset(15);
        }];
        [self.descTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(self.contentTextLabel.mas_bottom).offset(10);
            make.bottom.mas_equalTo(-20);
        }];
    }
    return _qrCodeView;
}

- (DBBaseLabel *)titleTextLabel{
    if (!_titleTextLabel){
        _titleTextLabel = [[DBBaseLabel alloc] init];
        _titleTextLabel.text = DBConstantString.ks_qrInstall;
        _titleTextLabel.font = DBFontExtension.pingFangMediumLarge;
        _titleTextLabel.textColor = DBColorExtension.charcoalColor;
        _titleTextLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleTextLabel;
}

- (UIView *)saveLabel{
    if (!_saveLabel){
        _saveLabel = [[DBBaseLabel alloc] init];
        _saveLabel.text = DBConstantString.ks_savedToAlbum;
        _saveLabel.font = DBFontExtension.bodyMediumFont;
        _saveLabel.textColor = DBColorExtension.redColor;
        _saveLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _saveLabel;
}

- (UIImageView *)qrCodeImageView{
    if (!_qrCodeImageView){
        _qrCodeImageView = [[UIImageView alloc] init];
        _qrCodeImageView.contentMode = UIViewContentModeScaleAspectFill;
        _qrCodeImageView.size = CGSizeMake(160, 160);
    }
    return _qrCodeImageView;
}

- (UIView *)contentTextLabel{
    if (!_contentTextLabel){
        _contentTextLabel = [[DBBaseLabel alloc] init];
        
        _contentTextLabel.text = [NSString stringWithFormat:DBConstantString.ks_bookTitleFormat,DBCommonConfig.shieldFreeString,UIApplication.appName];
        _contentTextLabel.font = DBFontExtension.bodyMediumFont;
        _contentTextLabel.textColor = DBColorExtension.charcoalColor;
        _contentTextLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _contentTextLabel;
}

- (UIView *)descTextLabel{
    if (!_descTextLabel){
        _descTextLabel = [[DBBaseLabel alloc] init];
        _descTextLabel.text = DBConstantString.ks_qrCodeScanHint;
        _descTextLabel.font = DBFontExtension.bodyMediumFont;
        _descTextLabel.textColor = DBColorExtension.charcoalColor;
        _descTextLabel.textAlignment = NSTextAlignmentCenter;
        _descTextLabel.numberOfLines = 0;
    }
    return _descTextLabel;
}

@end
