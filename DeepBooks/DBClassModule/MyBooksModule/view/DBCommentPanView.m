//
//  DBCommentPanView.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/2.
//

#import "DBCommentPanView.h"
#import "DBStarRating.h"

@interface DBCommentPanView ()
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) UIButton *publishButton;
@property (nonatomic, strong) UIView *partingLineView;

@property (nonatomic, strong) DBStarRating *scoreView;
@property (nonatomic, strong) DBBaseLabel *descTextLabel;
@property (nonatomic, strong) UITextView *commentTextView;
@end

@implementation DBCommentPanView

- (instancetype)init{
    if (self = [super init]){
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{

    self.backgroundColor = DBColorExtension.whiteColor;
    [self addSubviews:@[self.closeButton,self.titleTextLabel,self.publishButton,self.partingLineView,self.scoreView,self.descTextLabel,self.commentTextView]];
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
    [self.partingLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.titleTextLabel.mas_bottom).offset(15);
        make.height.mas_equalTo(1);
    }];
    [self.scoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.partingLineView.mas_bottom).offset(20);
        make.size.mas_equalTo(self.scoreView.size);
    }];
    [self.descTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.scoreView.mas_bottom).offset(20);
    }];
    [self.commentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(self.descTextLabel.mas_bottom).offset(20);
        make.bottom.mas_equalTo(-20);
    }];
    [self.commentTextView becomeFirstResponder];
    DBWeakSelf
    self.scoreView.currentScoreChangeBlock = ^(CGFloat score) {
        DBStrongSelfElseReturn
        switch ((int)score) {
            case 1:
                self.descTextLabel.text = @"太差了";
                break;
            case 2:
                self.descTextLabel.text = @"不太好";
                break;
            case 3:
                self.descTextLabel.text = @"一般般";
                break;
            case 4:
                self.descTextLabel.text = @"还不错";
                break;
            case 5:
                self.descTextLabel.text = @"超精彩";
                break;
            default:
                break;
        }
    };
    if (DBColorExtension.userInterfaceStyle) {
        self.backgroundColor = DBColorExtension.jetBlackColor;
        [self.closeButton setImage:[[UIImage imageNamed:@"close_black"] imageWithTintColor:DBColorExtension.whiteColor] forState:UIControlStateNormal];
    }else{
        self.backgroundColor = DBColorExtension.whiteColor;
        [self.closeButton setImage:[UIImage imageNamed:@"close_black"] forState:UIControlStateNormal];
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    if (DBColorExtension.userInterfaceStyle) {
        self.backgroundColor = DBColorExtension.jetBlackColor;
        [self.closeButton setImage:[[UIImage imageNamed:@"close_black"] imageWithTintColor:DBColorExtension.whiteColor] forState:UIControlStateNormal];
    }else{
        self.backgroundColor = DBColorExtension.whiteColor;
        [self.closeButton setImage:[UIImage imageNamed:@"close_black"] forState:UIControlStateNormal];
    }
}

- (void)clickPublishAction{
    [self endEditing:YES];
    CGFloat score = self.scoreView.currentScore;
    if (score == 0){
        [self showAlertText:@"请选择评分再发表"];
        return;
    }
    
    
    NSDictionary *parameInterface = @{@"book_id":DBSafeString(self.book_id),@"content":DBSafeString(self.commentTextView.text.whitespace),@"score":[NSString stringWithFormat:@"%.0lf",score],@"form":self.isComic?@"3":@"1"};
    [self showHudLoading];
    [DBAFNetWorking postServiceRequestType:DBLinkCommentSubmit combine:nil parameInterface:parameInterface serviceData:^(BOOL successfulRequest, id  _Nullable result, NSString * _Nullable message) {
        [self removeHudLoading];
        if (successfulRequest){
            if (self.commentCompletedBlock) self.commentCompletedBlock(YES);
        }
        
        [UIScreen.appWindow showAlertText:message];
        [self dismissAnimated:YES completion:^{
            
        }];
    }];
}

- (void)setScore:(CGFloat)score{
    _score = score;
    self.scoreView.currentScore = score;
}

- (DBBaseLabel *)titleTextLabel{
    if (!_titleTextLabel){
        _titleTextLabel = [[DBBaseLabel alloc] init];
        _titleTextLabel.font = DBFontExtension.titleSmallFont;
        _titleTextLabel.textColor = DBColorExtension.charcoalColor;
        _titleTextLabel.textAlignment = NSTextAlignmentCenter;
        _titleTextLabel.text = @"点评本书";
    }
    return _titleTextLabel;
}

- (UIButton *)closeButton{
    if (!_closeButton){
        _closeButton = [[UIButton alloc] init];
        [_closeButton setImage:[UIImage imageNamed:@"close_black"] forState:UIControlStateNormal];
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
        [_publishButton setTitle:@"发表" forState:UIControlStateNormal];
        [_publishButton setTitleColor:DBColorExtension.redColor forState:UIControlStateNormal];
        [_publishButton addTarget:self action:@selector(clickPublishAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _publishButton;
}

- (UIView *)partingLineView{
    if (!_partingLineView){
        _partingLineView = [[UIView alloc] init];
        _partingLineView.backgroundColor = DBColorExtension.paleGrayColor;
    }
    return _partingLineView;
}

- (DBStarRating *)scoreView{
    if (!_scoreView){
        CGFloat width = 28;
        _scoreView = [[DBStarRating alloc] initWithFrame:CGRectMake(0, 0, width*5+6*4, width)];
        _scoreView.spacing = 6;
        _scoreView.checkedImage = [UIImage imageNamed:@"scoreRed_sel"];
        _scoreView.uncheckedImage = [UIImage imageNamed:@"scoreRed_unsel"];
        _scoreView.minimumScore = 0.0;
        _scoreView.maximumScore = 5.0;
        _scoreView.type = RatingTypeWhole;
        _scoreView.touchEnabled = YES;
    }
    return _scoreView;
}

- (DBBaseLabel *)descTextLabel{
    if (!_descTextLabel){
        _descTextLabel = [[DBBaseLabel alloc] init];
        _descTextLabel.font = DBFontExtension.bodySmallFont;
        _descTextLabel.textColor = DBColorExtension.redColor;
        _descTextLabel.textAlignment = NSTextAlignmentCenter;
        _descTextLabel.text = @"轻点评分";
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
        _commentTextView.placeholder = @"优质书评将会优先展示";
    }
    return _commentTextView;
}

- (PanModalHeight)longFormHeight{
    return PanModalHeightMake(PanModalHeightTypeContent, UIScreen.screenHeight-150);
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
    return -250-UIScreen.tabbarHeight;
}
@end
