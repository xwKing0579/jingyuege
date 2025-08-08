//
//  DBBookCommentPanView.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/9.
//

#import "DBBookCommentPanView.h"

@interface DBBookCommentPanView ()
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) UIButton *publishButton;

@property (nonatomic, strong) DBBaseLabel *descTextLabel;
@property (nonatomic, strong) UITextView *commentTextView;
@end

@implementation DBBookCommentPanView

- (instancetype)init{
    if (self == [super init]){
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{

    self.backgroundColor = DBColorExtension.whiteColor;
    [self addSubviews:@[self.closeButton,self.titleTextLabel,self.publishButton,self.descTextLabel,self.commentTextView]];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.centerY.mas_equalTo(self.titleTextLabel);
        make.width.height.mas_equalTo(26);
    }];
    [self.titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(20);
        make.centerX.mas_equalTo(0);
    }];
    [self.publishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(self.titleTextLabel);
    }];

    [self.descTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(self.titleTextLabel.mas_bottom).offset(20);
    }];
    [self.commentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(self.descTextLabel.mas_bottom).offset(20);
        make.bottom.mas_equalTo(-260);
    }];
    
    [self.commentTextView becomeFirstResponder];
    if (DBColorExtension.userInterfaceStyle) {
        self.backgroundColor = DBColorExtension.jetBlackColor;
        [self.closeButton setImage:[[UIImage imageNamed:@"jjObsidianClasp"] imageWithTintColor:DBColorExtension.whiteColor] forState:UIControlStateNormal];
    }else{
        self.backgroundColor = DBColorExtension.whiteColor;
        [self.closeButton setImage:[UIImage imageNamed:@"jjObsidianClasp"] forState:UIControlStateNormal];
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    if (DBColorExtension.userInterfaceStyle) {
        self.backgroundColor = DBColorExtension.jetBlackColor;
        [self.closeButton setImage:[[UIImage imageNamed:@"jjObsidianClasp"] imageWithTintColor:DBColorExtension.whiteColor] forState:UIControlStateNormal];
    }else{
        self.backgroundColor = DBColorExtension.whiteColor;
        [self.closeButton setImage:[UIImage imageNamed:@"jjObsidianClasp"] forState:UIControlStateNormal];
    }
}

- (void)clickPublishAction{
    [self endEditing:YES];
    NSString *text = self.commentTextView.text;
    if (text.length == 0){
        [UIScreen.appWindow showAlertText:@"请输入内容"];
        return;
    }
    [UIScreen.appWindow showHudLoading];
    NSDictionary *parameInterface = @{@"id":DBSafeString(self.model.comment_id),@"content":DBSafeString(text),@"pid":@"0"};
    [DBAFNetWorking postServiceRequestType:DBLinkCommentReplaySubmit combine:nil parameInterface:parameInterface serviceData:^(BOOL successfulRequest, id  _Nullable result, NSString * _Nullable message) {
        [UIScreen.appWindow removeHudLoading];
        if (successfulRequest){
            [self dismissAnimated:YES completion:^{
                
            }];
            [UIScreen.appWindow showAlertText:@"回复成功"];
            [UIScreen.currentViewController dynamicAllusionTomethod:@"getDataSource"];
        }else{
            [UIScreen.appWindow showAlertText:message];
        }
    }];
}

- (void)setModel:(DBBookCommentModel *)model{
    _model = model;
    self.descTextLabel.attributedText = [NSAttributedString combineAttributeTexts:@[@"回复".textMultilingual,DBSafeString(model.nick),@"的评论".textMultilingual] colors:@[DBColorExtension.coolGrayColor,DBColorExtension.redColor,DBColorExtension.coolGrayColor] fonts:@[DBFontExtension.bodyMediumFont]];
}

- (DBBaseLabel *)titleTextLabel{
    if (!_titleTextLabel){
        _titleTextLabel = [[DBBaseLabel alloc] init];
        _titleTextLabel.font = DBFontExtension.titleSmallFont;
        _titleTextLabel.textColor = DBColorExtension.charcoalColor;
        _titleTextLabel.textAlignment = NSTextAlignmentCenter;
        _titleTextLabel.text = @"回复评论";
    }
    return _titleTextLabel;
}

- (UIButton *)closeButton{
    if (!_closeButton){
        _closeButton = [[UIButton alloc] init];
        [_closeButton setImage:[UIImage imageNamed:@"jjObsidianClasp"] forState:UIControlStateNormal];
        DBWeakSelf
        [_closeButton addTagetHandler:^(id  _Nonnull sender) {
            DBStrongSelfElseReturn
            [self endEditing:YES];
            [self dismissAnimated:YES completion:^{
                
            }];
        } controlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIButton *)publishButton{
    if (!_publishButton){
        _publishButton = [[UIButton alloc] init];
        _publishButton.titleLabel.font = DBFontExtension.pingFangMediumLarge;
        [_publishButton setTitle:@"回复" forState:UIControlStateNormal];
        [_publishButton setTitleColor:DBColorExtension.redColor forState:UIControlStateNormal];
        [_publishButton addTarget:self action:@selector(clickPublishAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _publishButton;
}


- (DBBaseLabel *)descTextLabel{
    if (!_descTextLabel){
        _descTextLabel = [[DBBaseLabel alloc] init];
        _descTextLabel.font = DBFontExtension.bodySmallFont;
        _descTextLabel.textColor = DBColorExtension.redColor;
        _descTextLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _descTextLabel;
}

- (UITextView *)commentTextView{
    if (!_commentTextView){
        _commentTextView = [[UITextView alloc] init];
        _commentTextView.textAlignment = NSTextAlignmentLeft;
        _commentTextView.backgroundColor = DBColorExtension.paleGrayColor;
        _commentTextView.textContainerInset = UIEdgeInsetsMake(6, 6, 6, 6);
        _commentTextView.font = DBFontExtension.bodySixTenFont;
        _commentTextView.placeholder = @"请输入您的评论";
    }
    return _commentTextView;
}

- (PanModalHeight)longFormHeight{
    return PanModalHeightMake(PanModalHeightTypeContent, UIScreen.screenHeight-200);
}

- (CGFloat)cornerRadius{
    return 16;
}

- (HWBackgroundConfig *)backgroundConfig{
    HWBackgroundConfig *config = [HWBackgroundConfig new];
    config.backgroundAlpha = 0.5;
    config.blurTintColor = DBColorExtension.blackColor;
    return config;
}

- (BOOL)showDragIndicator{
    return NO;
}

- (BOOL)allowsDragToDismiss{
    return YES;
}

- (BOOL)allowsPullDownWhenShortState{
    return NO;
}

- (BOOL)allowScreenEdgeInteractive{
    return NO;
}

- (BOOL)allowsTouchEventsPassingThroughTransitionView{
    return NO;
}

- (CGFloat)keyboardOffsetFromInputView{
    return -50-UIScreen.tabbarHeight;
}

@end
