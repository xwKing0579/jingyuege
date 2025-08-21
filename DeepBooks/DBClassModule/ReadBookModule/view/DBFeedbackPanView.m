//
//  DBFeedbackPanView.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/3.
//

#import "DBFeedbackPanView.h"
#import "DBBookCatalogModel.h"
@interface DBFeedbackPanView ()
@property (nonatomic, strong) DBBaseLabel *titlePageLabel;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) NSArray *viewList;
@end

@implementation DBFeedbackPanView

- (instancetype)init{
    if (self = [super init]){
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{
    self.frame = UIScreen.mainScreen.bounds;
    
    
    [self addSubviews:@[self.titlePageLabel,self.cancelButton,self.confirmButton]];
    [self.titlePageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(16);
        make.height.mas_equalTo(20);
    }];
    
    CGFloat top = 70;
    CGFloat left = 30;
    CGFloat space = 16;
    CGFloat width = (UIScreen.screenWidth-76)*0.5;
    CGFloat height = 35;
    NSArray *titles = @[DBConstantString.ks_chapterError,DBConstantString.ks_emptyChapter,DBConstantString.ks_chapterListError,DBConstantString.ks_otherError];
    NSMutableArray *viewList = [NSMutableArray array];
    for (NSString *title in titles) {
        UIButton *button = [[UIButton alloc] init];
        NSInteger index = [titles indexOfObject:title];
        button.tag = index;
        button.titleLabel.font = DBFontExtension.bodyMediumFont;
        button.layer.cornerRadius = 6;
        button.layer.masksToBounds = YES;
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:DBColorExtension.charcoalColor forState:UIControlStateNormal];
        [button setBackgroundImage:DBColorExtension.paleGrayColor.toImage forState:UIControlStateNormal];
        [button setBackgroundImage:DBColorExtension.lilacColor.toImage forState:UIControlStateSelected];
        [button addTarget:self action:@selector(clickFeedbackAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [viewList addObject:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
            if (index%2){
                make.left.mas_equalTo(left+width+space);
            }else{
                make.left.mas_equalTo(left);
            }
            if (index/2){
                make.top.mas_equalTo(top+height+space);
            }else{
                make.top.mas_equalTo(top);
            }
        }];
        self.viewList = viewList;
    }
    
    UIView *partingLineView = [[UIView alloc] init];
    partingLineView.backgroundColor = DBColorExtension.paleGrayColor;
    [self addSubview:partingLineView];
    [partingLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(180);
        make.height.mas_equalTo(1);
    }];
    
    UIView *partingLineView2 = [[UIView alloc] init];
    partingLineView2.backgroundColor = DBColorExtension.paleGrayColor;
    [self addSubview:partingLineView2];
    [partingLineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(180);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(1);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(partingLineView2);
        make.height.mas_equalTo(50);
        make.top.mas_equalTo(partingLineView);
    }];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(partingLineView2);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
        make.top.mas_equalTo(partingLineView);
    }];
    
    [self addTapGestureTarget:self action:@selector(clickAction)];
    [self darkColorModel];
}

- (void)clickAction{}

- (void)clickFeedbackAction:(UIButton *)sender{
    for (UIButton *button in self.viewList) {
        button.selected = [button isEqual:sender];
    }
}

- (void)clickConfirmAction{
    NSString *content = @"";
    for (UIButton *button in self.viewList) {
        if (button.selected) content = button.titleLabel.text;
    }
    if (content.length == 0){
        [UIScreen.appWindow showAlertText:DBConstantString.ks_selectTypeFirst];
        return;
    }
    
    [UIScreen.appWindow showHudLoading];
    NSArray <DBBookCatalogModel *>*chapterList = [DBBookCatalogModel getBookCatalogs:self.book.catalogForm];
    DBBookCatalogModel *catalogModel = chapterList[self.book.chapter_index];
    NSString *other_data = [NSString stringWithFormat:@"bookId:%@,book_name:%@,chapter_name:%@,path:%@",self.book.book_id,self.book.name,catalogModel.title,catalogModel.path];
    NSDictionary *parameInterface = @{@"content":content,@"contact":@"无联系方式",@"other_data":other_data,@"serial":UIDevice.deviceuuidString,@"device":UIDevice.currentDeviceModel,@"os_version":UIDevice.systemVersion,@"app_version":UIApplication.appVersion};
    [DBAFNetWorking postServiceRequestType:DBLinkChapterContentSubmit combine:nil parameInterface:parameInterface serviceData:^(BOOL successfulRequest, id  _Nullable result, NSString * _Nullable message) {
        [UIScreen.appWindow removeHudLoading];
        if (successfulRequest){
            [UIScreen.appWindow showAlertText:DBConstantString.ks_submitted];
            [self dismissAnimated:YES completion:^{
                
            }];
        }else{
            [UIScreen.appWindow showAlertText:message];
        }
    }];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [self darkColorModel];
}

- (void)darkColorModel{
    if (DBColorExtension.userInterfaceStyle) {
        self.backgroundColor = DBColorExtension.blackColor;
        self.titlePageLabel.textColor = DBColorExtension.whiteColor;
        [self.cancelButton setTitleColor:DBColorExtension.silverColor forState:UIControlStateNormal];
        [self.confirmButton setTitleColor:DBColorExtension.platinumColor forState:UIControlStateNormal];
        for (UIButton *button in self.viewList) {
            [button setTitleColor:DBColorExtension.blackColor forState:UIControlStateNormal];
        }
    }else{
        self.backgroundColor = DBColorExtension.whiteColor;
        self.titlePageLabel.textColor = DBColorExtension.blackColor;
        [self.cancelButton setTitleColor:DBColorExtension.silverColor forState:UIControlStateNormal];
        [self.confirmButton setTitleColor:DBColorExtension.charcoalColor forState:UIControlStateNormal];
        for (UIButton *button in self.viewList) {
            [button setTitleColor:DBColorExtension.charcoalColor forState:UIControlStateNormal];
        }
    }
}

- (DBBaseLabel *)titlePageLabel{
    if (!_titlePageLabel){
        _titlePageLabel = [[DBBaseLabel alloc] init];
        _titlePageLabel.text = DBConstantString.ks_selectType;
        _titlePageLabel.font = DBFontExtension.pingFangMediumXLarge;
        _titlePageLabel.textColor = DBColorExtension.blackColor;
        _titlePageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titlePageLabel;
}

- (UIButton *)cancelButton{
    if (!_cancelButton){
        _cancelButton = [[UIButton alloc] init];
        _cancelButton.titleLabel.font = DBFontExtension.bodySixTenFont;
        [_cancelButton setTitle:DBConstantString.ks_cancel forState:UIControlStateNormal];
        [_cancelButton setTitleColor:DBColorExtension.silverColor forState:UIControlStateNormal];
        DBWeakSelf
        [_cancelButton addTagetHandler:^(id  _Nonnull sender) {
            DBStrongSelfElseReturn
            [self dismissAnimated:YES completion:^{
                
            }];
        } controlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)confirmButton{
    if (!_confirmButton){
        _confirmButton = [[UIButton alloc] init];
        _confirmButton.titleLabel.font = DBFontExtension.bodySixTenFont;
        [_confirmButton setTitle:DBConstantString.ks_submit forState:UIControlStateNormal];
        [_confirmButton setTitleColor:DBColorExtension.charcoalColor forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(clickConfirmAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (PanModalHeight)longFormHeight{
    return PanModalHeightMake(PanModalHeightTypeContent, UIScreen.tabbarSafeHeight+230);
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
@end
