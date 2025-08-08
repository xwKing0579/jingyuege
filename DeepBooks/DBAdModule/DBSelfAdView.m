//
//  DBSelfAdView.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/5/20.
//

#import "DBSelfAdView.h"
#import "DBReadBookSetting.h"
#import <SDWebImage/SDWebImage.h>
#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
#import <MediaPlayer/MediaPlayer.h>
@interface DBSelfAdView ()
@property (nonatomic, strong) UIView *containerBoxView;
@property (nonatomic, strong) UIImageView *adImageView;
@property (nonatomic, strong) UIView *bottomContainerView;

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) DBBaseLabel *adTitleLabel;
@property (nonatomic, strong) DBBaseLabel *adSubTitleLabel;

@property (nonatomic, strong) UIButton *voiceButton;
@property (nonatomic, strong) UIButton *clickAdButton;
@property (nonatomic, strong) UIButton *closeAdButton;
@property (nonatomic, strong) UIButton *skipAdButton;
@property (nonatomic, strong) DBBaseLabel *adSignLabel;

@property (nonatomic, strong) ZFPlayerController *avPlayer;
@property (nonatomic, strong) ZFAVPlayerManager *playerManager;

@property (nonatomic, strong) DBSelfAdModel *selfAd;
@property (nonatomic, assign) DBSelfAdType adType;

@property (nonatomic, assign) NSInteger countdownTime;
@end


@implementation DBSelfAdView

- (instancetype)initWithSelfAdModel:(DBSelfAdModel *)selfAd adType:(DBSelfAdType)adType{
    if (self == [super init]){
        [self setUpSubViews:selfAd adType:adType];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(secondsTimeChange) name:DBsecondsTimeChange object:nil];
    }
    return self;
}

- (void)setUpSubViews:(DBSelfAdModel *)selfAd adType:(DBSelfAdType)adType{
    self.selfAd = selfAd;
    self.adType = adType;
    
    if (selfAd.image) {
        [self.adImageView sd_setImageWithURL:[NSURL URLWithString:selfAd.image]];
    }
    
    __block NSInteger time = 0;
    switch (adType) {
        case DBSelfAdLaunch:
        {
            time = 5;
            self.frame = UIScreen.mainScreen.bounds;
            [self addSubviews:@[self.containerBoxView,self.adImageView,self.adSignLabel,self.adTitleLabel,self.clickAdButton,self.skipAdButton]];
            [self.adImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(0);
            }];
            [self.adSignLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(26);
                make.centerY.mas_equalTo(self.skipAdButton);
                make.width.mas_equalTo(34);
                make.height.mas_equalTo(16);
            }];
            [self.adTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(26);
                make.top.mas_equalTo(16+UIScreen.navbarSafeHeight);
                make.right.mas_equalTo(-26);
            }];
            [self.clickAdButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.top.mas_equalTo(UIScreen.navbarHeight);
                make.bottom.mas_equalTo(-UIScreen.tabbarHeight);
            }];
            [self.skipAdButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-26);
                make.bottom.mas_equalTo(-26-UIScreen.tabbarSafeHeight);
                make.width.mas_equalTo(68);
                make.height.mas_equalTo(28);
            }];
        }
            break;
        case DBSelfAdBanner:
        {
            self.size = DBReadBookSetting.setting.canvasAdSize;
            [self addSubviews:@[self.containerBoxView,self.adImageView,self.adSignLabel,self.adTitleLabel,self.clickAdButton,self.closeAdButton]];
            [self.adImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(0);
            }];
            [self.adSignLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-7);
                make.bottom.mas_equalTo(-7);
                make.width.mas_equalTo(22);
                make.height.mas_equalTo(11);
            }];
            [self.adTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(7);
                make.top.mas_equalTo(7);
                make.right.mas_equalTo(-35);
            }];
             [self.clickAdButton mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.edges.mas_equalTo(0);
            }];
            [self.closeAdButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(4);
                make.right.mas_equalTo(-6);
                make.width.height.mas_equalTo(24);
            }];
            
            self.adSignLabel.font = DBFontExtension.captionFont;
            self.closeAdButton.hidden = selfAd.hiddenCloseAd;
        }
            break;
        case DBSelfAdExpress:
        {
            self.size = CGSizeMake(selfAd.adSize.width, MIN(UIScreen.screenHeight, selfAd.adSize.height));
            
            [self addSubviews:@[self.containerBoxView,self.bottomContainerView,self.adImageView,self.clickAdButton,self.closeAdButton]];
            [self.containerBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.mas_equalTo(0);
                make.width.mas_equalTo(UIScreen.screenWidth);
                make.height.mas_equalTo(selfAd.adSize.height-50);
            }];
            [self.bottomContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(0);
                make.top.mas_equalTo(self.containerBoxView.mas_bottom);
                make.height.mas_equalTo(50);
            }];
            [self.adImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(self.containerBoxView);
            }];
            [self.clickAdButton mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.edges.mas_equalTo(0);
            }];
            
            CGFloat adHeight = (self.size.height-(UIScreen.screenHeight-UIScreen.navbarNetHeight*2))*0.5;
            [self.closeAdButton mas_makeConstraints:^(MASConstraintMaker *make) {
                if (adHeight > 0){
                    make.top.mas_equalTo(6+adHeight);
                }else{
                    make.top.mas_equalTo(6);
                }
                make.right.mas_equalTo(-6);
                make.width.height.mas_equalTo(30);
            }];
            
            [self.bottomContainerView addSubviews:@[self.adSignLabel,self.logoImageView,self.adTitleLabel,self.adSubTitleLabel]];
            [self.adSignLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(0);
                make.right.mas_equalTo(-10);
                make.width.mas_equalTo(34);
                make.height.mas_equalTo(16);
            }];
            [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(8);
                make.centerY.mas_equalTo(0);
                make.width.height.mas_equalTo(32);
            }];
            [self.adTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.logoImageView.mas_right).offset(9);
                make.top.mas_equalTo(self.logoImageView.mas_top);
                make.right.mas_equalTo(-50);
            }];
            [self.adSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(self.adTitleLabel);
                make.bottom.mas_equalTo(self.logoImageView.mas_bottom);
            }];
            
            self.logoImageView.imageObj = selfAd.logo;
            self.adTitleLabel.textColor = DBColorExtension.blackColor;
            self.adSubTitleLabel.textColor = DBColorExtension.slateGrayColor;
            self.adTitleLabel.font = DBFontExtension.bodySmallFont;
            self.adSubTitleLabel.font = DBFontExtension.captionFont;
        }
            break;
        case DBSelfAdGrid:
        {
            CGFloat margin = 16;
            CGFloat distance = 16;
            CGFloat bottom = 0;
            
            NSMutableArray *adImageViews = [NSMutableArray array];
            for (int index = 0; index < selfAd.grid.count; index++) {
                NSArray <DBSelfAdModel *> *gridList = selfAd.grid[index];
                CGSize adSize = gridList.firstObject.adSize;
                CGFloat count = MIN(4, gridList.count);
                CGFloat width = (UIScreen.screenWidth-margin*2-(count-1)*distance)/count;
                CGFloat height = width*adSize.height/adSize.width;
                for (int section = 0; section < gridList.count; section++) {
                    DBSelfAdModel *model = gridList[section];
                    UIImageView *adImageView = [[UIImageView alloc] initWithFrame:CGRectMake(margin+(width+distance)*section, bottom, width, height)];
                    adImageView.tag = section+index*10;
                    [adImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
                    
                    adImageView.contentMode = UIViewContentModeScaleAspectFill;
                    adImageView.clipsToBounds = YES;
                    
                    [adImageView addTapGestureTarget:self action:@selector(clickAdViewsAction:)];
                    [adImageViews addObject:adImageView];
                }
                bottom += height + distance;
            }
            self.size = CGSizeMake(UIScreen.screenWidth, bottom+50);
            
            [self addSubviews:@[self.adSignLabel,self.closeAdButton,self.containerBoxView]];
            [self.closeAdButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(6);
                make.right.mas_equalTo(-10);
                make.width.height.mas_equalTo(30);
            }];
            [self.adSignLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(16);
                make.centerY.mas_equalTo(self.closeAdButton);
                make.width.mas_equalTo(34);
                make.height.mas_equalTo(16);
            }];
            
            [self.containerBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(0);
                make.top.mas_equalTo(50);
            }];
            
            [self.containerBoxView addSubviews:adImageViews];
        }
            break;
        case DBSelfAdSlot:
        case DBSelfAdReward:
        {
            self.frame = UIScreen.mainScreen.bounds;
            [self addSubviews:@[self.containerBoxView,self.adImageView,self.adSignLabel,self.adTitleLabel,self.adSubTitleLabel,self.clickAdButton,self.skipAdButton,self.closeAdButton]];
            [self.adImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(0);
            }];
            [self.adSignLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-26);
                make.bottom.mas_equalTo(-26-UIScreen.tabbarSafeHeight);
                make.width.mas_equalTo(34);
                make.height.mas_equalTo(16);
            }];
            [self.adTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(26);
                make.top.mas_equalTo(20+UIScreen.navbarSafeHeight);
                make.right.mas_equalTo(-140);
            }];
            [self.adSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(self.adTitleLabel);
                make.bottom.mas_equalTo(self.adTitleLabel.mas_top).offset(5);
            }];
             [self.clickAdButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.top.mas_equalTo(UIScreen.navbarHeight);
                make.bottom.mas_equalTo(-UIScreen.tabbarHeight);
            }];
            [self.closeAdButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-20);
                make.top.mas_equalTo(20+UIScreen.navbarSafeHeight);
                make.width.height.mas_equalTo(34);
            }];
            [self.skipAdButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-50);
                make.centerY.mas_equalTo(self.closeAdButton);
                make.width.mas_equalTo(68);
                make.height.mas_equalTo(28);
            }];
            
            
            if (adType == DBSelfAdReward){
                time = 5;
                self.closeAdButton.hidden = YES;
                self.skipAdButton.userInteractionEnabled = NO;
            }else{
                self.closeAdButton.hidden = NO;
                self.skipAdButton.hidden = YES;
            }
        }
            break;
        default:
            break;
    }
    
    [self layoutIfNeeded];
    
    self.adTitleLabel.text = selfAd.title;
    self.adSubTitleLabel.text = selfAd.subtitle;

    
    
    if (selfAd.video.length){
        NSURL *videoURL = [DBVideoDownload videoCachePathWithUrl:selfAd.video];
        if (videoURL){
            ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
            self.playerManager = playerManager;
            self.avPlayer = [[ZFPlayerController alloc] initWithPlayerManager:playerManager containerView:self.containerBoxView];
            playerManager.assetURL = videoURL;
            [self.avPlayer playerPrepareToPlay];
            [self.avPlayer playTheIndex:0];
            
            DBWeakSelf
            self.avPlayer.playerLoadStateChanged = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, ZFPlayerLoadState loadState) {
                DBStrongSelfElseReturn
                if (loadState == ZFPlayerLoadStatePlaythroughOK){
                    [self.adImageView removeFromSuperview];
                }
            };
            self.voiceButton.selected = selfAd.muted;
            if (self.voiceButton.selected){
                self.avPlayer.currentPlayerManager.muted = YES;
            }else{
                self.avPlayer.currentPlayerManager.muted = NO;
            }

            [self addSubview:self.voiceButton];
            if (adType == DBSelfAdLaunch) {
                [self.voiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-22);
                    make.centerY.mas_equalTo(self.adTitleLabel);
                    make.width.height.mas_equalTo(30);
                }];
            }else{
                [self.voiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(22);
                    make.centerY.mas_equalTo(self.adSignLabel);
                    make.width.height.mas_equalTo(30);
                }];
            }
        }
    }
    
    
    if (time > 0){
        NSString *secondTime = [NSString stringWithFormat:DBConstantString.ks_skipInSeconds.textMultilingual,time];
        [self.skipAdButton setTitle:secondTime forState:UIControlStateNormal];
        self.countdownTime = time;
    }
}

- (NSTimeInterval)getVideoDurationFromURL:(NSURL *)videoURL {
    AVURLAsset *asset = [AVURLAsset assetWithURL:videoURL];
    CMTime duration = asset.duration;
    return CMTimeGetSeconds(duration);
}

- (void)secondsTimeChange{
    if (self.countdownTime > 1){
        self.countdownTime--;
        NSString *secondTime = [NSString stringWithFormat:DBConstantString.ks_skipInSeconds.textMultilingual,self.countdownTime];
        [self.skipAdButton setTitle:secondTime forState:UIControlStateNormal];
    }else{
        if (self.adType == DBSelfAdReward){
            self.skipAdButton.hidden = YES;
            self.closeAdButton.hidden = NO;
        }else{
            [self.skipAdButton setTitle:DBConstantString.ks_skip forState:UIControlStateNormal];
        }
    }
}

- (void)clickAdViewAction{
    NSString *link = self.selfAd.link;
    if (link.length == 0) return;
    NSURL *url = [NSURL URLWithString:link];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        
        if (self.didClickBlock) self.didClickBlock(self,self.adType);
    }
}

- (void)clickAdViewsAction:(UITapGestureRecognizer *)tap{
    UIView *adContainerView = tap.view;
    NSInteger section = adContainerView.tag/10;
    NSInteger row = adContainerView.tag - section*10;
    DBSelfAdModel *model = self.selfAd.grid[section][row];
    NSString *link = model.link;
    if (link.length == 0) return;
    NSURL *url = [NSURL URLWithString:link];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        
        if (self.didClickBlock) self.didClickBlock(self,self.adType);
    }
}

- (void)clickVoiceAction{
    self.voiceButton.selected = !self.voiceButton.selected;
    if (self.voiceButton.selected){
        self.avPlayer.currentPlayerManager.muted = YES;
    }else{
        self.avPlayer.currentPlayerManager.muted = NO;
    }
}

- (void)clickAdCloseAction{
    if (self.didRemovedBlock) self.didRemovedBlock(self,self.adType);
    [self removeFromSuperview];
    
    if (self.avPlayer){
        [self.avPlayer stop];
    }
}

- (UIImageView *)adImageView{
    if (!_adImageView){
        _adImageView = [[UIImageView alloc] init];
        _adImageView.contentMode = UIViewContentModeScaleAspectFill;
        _adImageView.clipsToBounds = YES;
        _adImageView.userInteractionEnabled = YES;
    }
    return _adImageView;
}

- (UIView *)containerBoxView{
    if (!_containerBoxView){
        _containerBoxView = [[UIView alloc] initWithFrame:self.bounds];
        _containerBoxView.backgroundColor = DBColorExtension.whiteColor;
    }
    return _containerBoxView;
}

- (UIButton *)voiceButton{
    if (!_voiceButton){
        _voiceButton = [[UIButton alloc] init];
        [_voiceButton setImage:[UIImage imageNamed:@"jjSoundlessSeal"] forState:UIControlStateNormal];
        [_voiceButton setImage:[UIImage imageNamed:@"jjHarmonicRipple"] forState:UIControlStateSelected];
        [_voiceButton addTarget:self action:@selector(clickVoiceAction) forControlEvents:UIControlEventTouchUpInside];
        _voiceButton.enlargedEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    }
    return _voiceButton;
}

- (UIButton *)clickAdButton{
    if (!_clickAdButton){
        _clickAdButton = [[UIButton alloc] init];
        [_clickAdButton addTarget:self action:@selector(clickAdViewAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clickAdButton;
}

- (UIView *)bottomContainerView{
    if (!_bottomContainerView){
        _bottomContainerView = [[UIView alloc] init];
        _bottomContainerView.backgroundColor = DBColorExtension.whiteColor;
    }
    return _bottomContainerView;
}

- (UIButton *)closeAdButton{
    if (!_closeAdButton){
        _closeAdButton = [[UIButton alloc] init];
        [_closeAdButton setImage:[UIImage imageNamed:@"jjMistDissipate"] forState:UIControlStateNormal];
        [_closeAdButton addTarget:self action:@selector(clickAdCloseAction) forControlEvents:UIControlEventTouchUpInside];
        _closeAdButton.enlargedEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    }
    return _closeAdButton;
}

- (UIImageView *)logoImageView{
    if (!_logoImageView){
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _logoImageView.clipsToBounds = YES;
        _logoImageView.layer.cornerRadius = 6;
        _logoImageView.layer.masksToBounds = YES;
        _logoImageView.image = [UIImage imageNamed:@"appLogo"];
    }
    return _logoImageView;
}

- (DBBaseLabel *)adTitleLabel{
    if (!_adTitleLabel){
        _adTitleLabel = [[DBBaseLabel alloc] init];
        _adTitleLabel.font = DBFontExtension.bodyMediumFont;
        _adTitleLabel.textColor = DBColorExtension.whiteColor;
    }
    return _adTitleLabel;
}

- (DBBaseLabel *)adSubTitleLabel{
    if (!_adSubTitleLabel){
        _adSubTitleLabel = [[DBBaseLabel alloc] init];
        _adSubTitleLabel.font = DBFontExtension.microFont;
        _adSubTitleLabel.textColor = DBColorExtension.whiteColor;
    }
    return _adSubTitleLabel;
}

- (UIButton *)skipAdButton{
    if (!_skipAdButton){
        _skipAdButton = [[UIButton alloc] init];
        _skipAdButton.titleLabel.font = DBFontExtension.bodySmallFont;
        _skipAdButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        _skipAdButton.layer.cornerRadius = 14;
        _skipAdButton.layer.masksToBounds = YES;
        [_skipAdButton setTitle:DBConstantString.ks_skip forState:UIControlStateNormal];
        [_skipAdButton setTitleColor:DBColorExtension.whiteColor forState:UIControlStateNormal];
        [_skipAdButton addTarget:self action:@selector(clickAdCloseAction) forControlEvents:UIControlEventTouchUpInside];
        _skipAdButton.enlargedEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    }
    return _skipAdButton;
}

- (DBBaseLabel *)adSignLabel{
    if (!_adSignLabel){
        _adSignLabel = [[DBBaseLabel alloc] init];
        _adSignLabel.font = DBFontExtension.microFont;
        _adSignLabel.textColor = DBColorExtension.whiteColor;
        _adSignLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        _adSignLabel.text = DBConstantString.ks_ad;
        _adSignLabel.textAlignment = NSTextAlignmentCenter;
        _adSignLabel.layer.cornerRadius = 5;
        _adSignLabel.layer.masksToBounds = YES;
    }
    return _adSignLabel;
}


@end
