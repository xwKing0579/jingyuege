//
//  DBActivityEntranceView.m
//  DeepBooks
//
//  Created by king on 2025/8/14.
//

#import "DBActivityEntranceView.h"
#import "DBUnityAdConfig.h"

@interface DBActivityEntranceView ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) DBBaseLabel *contentTextLabel;
@end

@implementation DBActivityEntranceView

- (instancetype)init{
    if (self == [super init]){
        _activityText = @"免广告";
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{
    self.frame = CGRectMake(UIScreen.screenWidth-88, UIScreen.screenHeight*0.3, 88, 32);
    [self addRoudCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(16, 16)];
    self.backgroundColor = [UIColor gradientColorSize:self.size direction:DBColorDirectionUpwardDiagonalLine startColor:DBColorExtension.pinkLightColor endColor:DBColorExtension.coralColor];
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.image = [[UIImage imageNamed:@"vip_adRemove"] imageWithTintColor:DBColorExtension.whiteColor];
    [self addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(4);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(24);
    }];
    
    DBBaseLabel *contentTextLabel = [[DBBaseLabel alloc] init];
    contentTextLabel.font = DBFontExtension.pingFangMediumRegular;
    contentTextLabel.textColor = DBColorExtension.whiteColor;
    contentTextLabel.numberOfLines = 2;
    contentTextLabel.text = _activityText;
    self.contentTextLabel = contentTextLabel;
    [self addSubview:contentTextLabel];
    [contentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iconImageView.mas_right).offset(8);
        make.right.mas_equalTo(-8);
        make.centerY.mas_equalTo(0);
    }];
    
    
//    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(viewDragable:)];
//    [self addGestureRecognizer:panGesture];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView:)];
    tapGesture.delegate = self;
    [self addGestureRecognizer:tapGesture];
}

- (void)setActivityText:(NSString *)activityText{
    _activityText = activityText;
    
    self.contentTextLabel.text = activityText;
}




- (void)didTapView:(UITapGestureRecognizer *)tapGesture{
    if (!DBCommonConfig.isLogin) {
        [DBCommonConfig toLogin];
        [UIScreen.appWindow showAlertText:@"请先登录以领取免广告时长"];
        return;
    }
    
    [DBUserVipConfig checkFreeVipActivityCompletion:^(DBUserActivityModel * _Nonnull activityModel) {
        [self activityMessage:activityModel];
    }];
}

- (void)activityMessage:(DBUserActivityModel *)activityModel{
    if (activityModel){
        NSString *message = [NSString stringWithFormat:@"观看小视频，即可获得免广告%ld分钟，享受极致的阅读体验。只有在您看完完整视频的情况下，才可以享受无广告阅读哦。",activityModel.rules.free_vip_rules.seconds/60];
        LEEAlert.alert.config.LeeContent(message).
        LeeCancelAction(@"取消", ^{
            
        }).LeeAction(@"确定", ^{
            DBWeakSelf
            [DBUnityAdConfig.manager openRewardAdSpaceType:DBAdSpaceUserFreeVip completion:^(BOOL removed, BOOL reward) {
                DBStrongSelfElseReturn
                if (reward) {
                    [self adRewardFreeVipRepeatCount:0 activityModel:activityModel];
                }
            }];
        }).LeeShow();
    }else{
        [UIScreen.appWindow showAlertText:@"今日免广告次数已用完"];
    }
}

- (void)adRewardFreeVipRepeatCount:(NSInteger)repeatCount activityModel:(DBUserActivityModel *)activityModel{
    if (repeatCount > 3) return;
    __block NSInteger count = repeatCount;
    DBWeakSelf
    [DBAFNetWorking postServiceRequestType:DBLinkActivityReward combine:nil parameInterface:@{@"activityId":DBSafeString(activityModel.idStr)} serviceData:^(BOOL successfulRequest, id  _Nullable result, NSString * _Nullable message) {
        DBStrongSelfElseReturn
        if (successfulRequest){
            [DBUserModel getUserVipInfoCompletion:^(BOOL successfulRequest, DBUserVipModel * _Nonnull model) {
                if (successfulRequest){
                    NSInteger seconds = activityModel.rules.free_vip_rules.seconds;
                    [UIScreen.appWindow showAlertText:[NSString stringWithFormat:@"已获得%ld分钟免广告时长",seconds/60]];
                    if (self.didRewardBlock) self.didRewardBlock(model.free_vip_seconds);
                    [self rewardAdReadTimeTrack:seconds];
                }
            }];
        }
    }];
}

- (void)rewardAdReadTimeTrack:(NSInteger)seconds{
    NSString *duration = [NSString stringWithFormat:@"%ld",seconds];
    [DBAFNetWorking postServiceRequestType:DBLinkTrackAdData combine:nil parameInterface:@{@"action":@"readDuration",@"bookID":DBSafeString(self.bookID),@"duration":duration} serviceData:^(BOOL successfulRequest, id  _Nullable result, NSString * _Nullable message) {
        
    }];
}

//- (void)viewDragable:(UIPanGestureRecognizer *)sender{
//    CGPoint transPoint = [sender translationInView:self];
//    self.transform = CGAffineTransformTranslate(self.transform, transPoint.x, transPoint.y);
//    [sender setTranslation:CGPointZero inView:self];
//    if (sender.state == UIGestureRecognizerStateChanged) {
//        self.x = self.superview.width-self.width;
//        if (self.y < UIScreen.navbarHeight+20) {
//            self.y = UIScreen.navbarHeight+20;
//        }else if (self.y > UIScreen.screenHeight-UIScreen.tabbarHeight-80){
//            self.y = UIScreen.screenHeight-UIScreen.tabbarHeight-80;
//        }
//    }
//}
@end
