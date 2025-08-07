//
//  DBBookMenuPanView.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/31.
//

#import "DBBookMenuPanView.h"
#import "DBBookMenuItemModel.h"
#import "DBBookMenuItemView.h"
#import "DBBookChapterModel.h"


@interface DBBookMenuPanView ()
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIImageView *pictureImageView;
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) DBBaseLabel *contentTextLabel;
@property (nonatomic, strong) UIButton *detailButton;

@property (nonatomic, strong) DBBaseLabel *updateLabel;
@property (nonatomic, strong) UIView *partingLineView;

@property (nonatomic, strong) DBBookMenuItemView *menuView1;
@property (nonatomic, strong) DBBookMenuItemView *menuView2;

@end

@implementation DBBookMenuPanView

- (instancetype)init{
    if (self = [super init]){
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{
    
    [self addSubviews:@[self.headView,self.coverView]];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.headView.mas_bottom);
    }];
    
    [self.coverView addSubviews:@[self.topView,self.pictureImageView,self.titleTextLabel,self.contentTextLabel,self.detailButton,self.updateLabel,self.partingLineView]];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(90);
    }];
    [self.pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(-50);
        make.height.mas_equalTo(120);
        make.width.mas_equalTo(90);
    }];
    
    [self.detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(self.topView).offset(-4);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(28);
    }];
    [self.titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.pictureImageView.mas_right).offset(15);
        make.right.mas_equalTo(self.detailButton.mas_left).offset(-10);
        make.top.mas_equalTo(10);
    }];
    [self.contentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.titleTextLabel);
        make.top.mas_equalTo(self.titleTextLabel.mas_bottom).offset(4);
    }];
    
    [self.updateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(self.topView.mas_bottom).offset(20);
    }];
    [self.partingLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.updateLabel.mas_bottom).offset(20);
        make.height.mas_equalTo(1);
    }];
    
    NSArray *menuList = DBBookMenuItemModel.dataSourceList;
    CGFloat width = UIScreen.screenWidth/4;
    
    UIView *lastView = self.partingLineView;
    for (NSInteger index = 0; index < menuList.count; index++) {
        DBBookMenuItemModel *model = menuList[index];
        DBBookMenuItemView *menuView = [[DBBookMenuItemView alloc] init];
        if (index == 0) self.menuView1 = menuView;
        if (index == 1) self.menuView2 = menuView;
        if (index > 1) [menuView addTapGestureTarget:self action:@selector(clickMenuAction:)];
        menuView.model = model;
        [self.coverView addSubview:menuView];
        
        [menuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(width*(index%4));
            make.width.mas_equalTo(width);
            make.top.mas_equalTo(lastView.mas_bottom).offset(10);
        }];
        
        if (index == 3) lastView = menuView;
    }
    
    DBWeakSelf
    self.menuView1.switchBlock = ^(BOOL isOn) {
        DBStrongSelfElseReturn
        if (DBCommonConfig.isLogin){
            NSDictionary *parameInterface = @{@"book_id":DBSafeString(self.model.book_id),@"form":@"1"};
            [UIScreen.currentViewController.view showHudLoading];
            [DBAFNetWorking postServiceRequestType:isOn?DBLinkBookShelfBookTop:DBLinkBookShelfBookTopCancel combine:nil parameInterface:parameInterface serviceData:^(BOOL successfulRequest, id  _Nullable result, NSString * _Nullable message) {
                [UIScreen.currentViewController.view removeHudLoading];
                if (successfulRequest){
                    [self topBook:isOn];
                }else{
                    self.menuView1.isSwitch = !isOn;
                    [UIScreen.currentViewController.view showAlertText:message];
                }
            }];
        }else{
            [self topBook:isOn];
        }
    };
    
    self.menuView2.switchBlock = ^(BOOL isOn) {
        DBStrongSelfElseReturn
        
        //通知是否开启
        [DBCommonConfig getPushAuthorizationCompletion:^(BOOL open) {
            if (!open){
                DBWeakSelf
                LEEAlert.alert.config.LeeTitle(@"温馨提示").
                LeeContent(@"您尚未开启推送通知，请开启后再重新打开小说更新提醒。").
                LeeCancelAction(@"取消", ^{
                    
                }).LeeAction(@"去打开", ^{
                    DBStrongSelfElseReturn
                    [DBCommonConfig openAppSetting];
                }).LeeShow();
            }else{
                self.model.isClosePush = !isOn;
                [self.model updateCollectBook];
            }
            self.menuView2.isSwitch = isOn && open;
        }];
    };
    
    if (DBColorExtension.userInterfaceStyle) {
        self.topView.backgroundColor = DBColorExtension.jetBlackColor;
        self.coverView.backgroundColor = DBColorExtension.jetBlackColor;
    }else{
        self.topView.backgroundColor = DBColorExtension.whiteColor;
        self.coverView.backgroundColor = DBColorExtension.whiteColor;
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    if (DBColorExtension.userInterfaceStyle) {
        self.topView.backgroundColor = DBColorExtension.jetBlackColor;
        self.coverView.backgroundColor = DBColorExtension.jetBlackColor;
    }else{
        self.topView.backgroundColor = DBColorExtension.whiteColor;
        self.coverView.backgroundColor = DBColorExtension.whiteColor;
    }
}

- (void)topBook:(BOOL)isOn{
    self.model.is_top = isOn;
    self.model.updateTime = NSDate.new.timeStampInterval;
    [self.model updateCollectBook];
    [NSNotificationCenter.defaultCenter postNotificationName:DBUpdateCollectBooks object:nil];
}

- (void)clickMenuAction:(UITapGestureRecognizer *)tap{
    
    DBBookMenuItemView *menuView = (DBBookMenuItemView *)tap.view;
    switch (menuView.model.mid) {
        case 2:
            if (self.clickCatalogsIndex) self.clickCatalogsIndex();
            [self dismiss];
            break;
        case 3:
            [DBRouter openPageUrl:DEBookComment params:@{@"book":self.model}];
            [self dismiss];
            break;
        case 4:
        {
            if (DBCommonConfig.isLogin){
                NSDictionary *parameInterface = @{@"book_id":DBSafeString(self.model.book_id)};
                [UIScreen.currentViewController.view showHudLoading];
                [DBAFNetWorking postServiceRequestType:DBLinkBookShelfBookFeedUp combine:nil parameInterface:parameInterface serviceData:^(BOOL successfulRequest, id  _Nullable result, NSString * _Nullable message) {
                    [UIScreen.currentViewController.view removeHudLoading];
                    if (successfulRequest){
                        [self bookCultivateOrCancel];
                    }else{
                        [UIScreen.currentViewController.view showAlertText:message];
                    }
                }];
            }else{
                [self bookCultivateOrCancel];
            }
            [self dismiss];
        }
            break;
        case 5:
        {
            DBWeakSelf
            LEEAlert.alert.config.LeeTitle(@"是否选择彻底删除此书？").
            LeeCancelAction(@"取消", ^{
                
            }).LeeAction(@"确定", ^{
                DBStrongSelfElseReturn
                [self dismiss];
                if (DBCommonConfig.isLogin){
                    [UIScreen.currentViewController.view showHudLoading];
                    NSDictionary *parameInterface = @{@"book_id":DBSafeString(self.model.book_id),@"form":@"1"};
                    [DBAFNetWorking postServiceRequestType:DBLinkBookShelfBookDelete combine:nil parameInterface:parameInterface serviceData:^(BOOL successfulRequest, id  _Nullable result, NSString * _Nullable message) {
                        [UIScreen.currentViewController.view removeHudLoading];
                        if (successfulRequest){
                            [DBBookModel removeCollectBooksInIds:@[DBSafeString(self.model.book_id)]];
                            [NSNotificationCenter.defaultCenter postNotificationName:DBUpdateCollectBooks object:nil];
                        }else{
                            [UIScreen.currentViewController.view showAlertText:message];
                        }
                    }];
                }else{
                    [DBBookModel removeCollectBooksInIds:@[DBSafeString(self.model.book_id)]];
                    [NSNotificationCenter.defaultCenter postNotificationName:DBUpdateCollectBooks object:nil];
                }
            }).LeeShow();
           
           
        }
            break;
        case 6:
        {
            if ([DBBookChapterModel removeBookChapter:self.model.chapterForm]){
                [UIScreen.currentViewController.view showAlertText:@"缓存已清除"];
            }
            [self dismiss];
        }
            break;
        case 7:
        {
            [DBCommonConfig showShareView];
            [self dismiss];
        }
            break;
        default:
            break;
    }
}

- (void)bookCultivateOrCancel{
    self.model.isCultivate = !self.model.isCultivate;
    [self.model updateCollectBook];
    [NSNotificationCenter.defaultCenter postNotificationName:DBUpdateCollectBooks object:nil];
}

- (void)clickDetailAction{
    [self dismiss];
    [DBRouter openPageUrl:DBBookDetail params:@{@"bookId":DBSafeString(self.model.book_id)}];
}

- (void)dismiss{
    [self dismissAnimated:YES completion:^{
        
    }];
}

- (void)setModel:(DBBookModel *)model{
    _model = model;
    self.pictureImageView.imageObj = model.image;
    self.titleTextLabel.text = model.name;
    self.contentTextLabel.text = model.author;
    self.updateLabel.text = [NSString stringWithFormat:@"最新：%@",model.last_chapter_name];
    
    self.menuView1.isSwitch = model.is_top;
    [DBCommonConfig getPushAuthorizationCompletion:^(BOOL open) {
        self.menuView2.isSwitch = open && !model.isClosePush;
    }];
}

- (UIView *)headView{
    if (!_headView){
        _headView = [[UIView alloc] init];
        _headView.backgroundColor = DBColorExtension.noColor;
    }
    return _headView;
}

- (UIView *)topView{
    if (!_topView){
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = DBColorExtension.paleGrayAltColor;
    }
    return _topView;
}

- (UIView *)coverView{
    if (!_coverView){
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = DBColorExtension.whiteColor;
    }
    return _coverView;
}

- (UIImageView *)pictureImageView{
    if (!_pictureImageView){
        _pictureImageView = [[UIImageView alloc] init];
        _pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
        _pictureImageView.clipsToBounds = YES;
        _pictureImageView.layer.cornerRadius = 6;
        _pictureImageView.layer.masksToBounds = YES;
    }
    return _pictureImageView;
}

- (DBBaseLabel *)titleTextLabel{
    if (!_titleTextLabel){
        _titleTextLabel = [[DBBaseLabel alloc] init];
        _titleTextLabel.font = DBFontExtension.titleSmallFont;
        _titleTextLabel.textColor = DBColorExtension.charcoalColor;
    }
    return _titleTextLabel;
}

- (DBBaseLabel *)contentTextLabel{
    if (!_contentTextLabel){
        _contentTextLabel = [[DBBaseLabel alloc] init];
        _contentTextLabel.font = DBFontExtension.bodyMediumFont;
        _contentTextLabel.textColor = DBColorExtension.grayColor;
    }
    return _contentTextLabel;
}

- (UIButton *)detailButton{
    if (!_detailButton){
        _detailButton = [[UIButton alloc] init];
        _detailButton.layer.cornerRadius = 4;
        _detailButton.layer.masksToBounds = YES;
        _detailButton.layer.borderColor = DBColorExtension.mediumGrayColor.CGColor;
        _detailButton.layer.borderWidth = 1;
        _detailButton.titleLabel.font = DBFontExtension.bodySixTenFont;
        [_detailButton setTitle:@"详情" forState:UIControlStateNormal];
        [_detailButton setTitleColor:DBColorExtension.mediumGrayColor forState:UIControlStateNormal];
        [_detailButton addTarget:self action:@selector(clickDetailAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _detailButton;
}

- (DBBaseLabel *)updateLabel{
    if (!_updateLabel){
        _updateLabel = [[DBBaseLabel alloc] init];
        _updateLabel.font = DBFontExtension.pingFangMediumLarge;
        _updateLabel.textColor = DBColorExtension.charcoalColor;
    }
    return _updateLabel;
}

- (UIView *)partingLineView{
    if (!_partingLineView){
        _partingLineView = [[UIView alloc] init];
        _partingLineView.backgroundColor = DBColorExtension.paleGrayColor;
    }
    return _partingLineView;
}

- (PanModalHeight)longFormHeight{
    return PanModalHeightMake(PanModalHeightTypeContent, UIScreen.tabbarSafeHeight+400);
}

- (CGFloat)cornerRadius{
    return 0;
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
