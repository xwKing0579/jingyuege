//
//  DBReaderAdViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/7.
//

#import "DBReaderAdViewController.h"
#import "DBReadBookSetting.h"
#import "DBBaseTableView.h"
#import "DBAdBannerTableViewCell.h"


@interface DBReaderAdViewController ()
@property (nonatomic, strong) UIView *adContainerView;
@end

@implementation DBReaderAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
}

- (void)setUpSubViews{
    DBReadBookSetting *setting = DBReadBookSetting.setting;
    UIColor *backgroundColor = setting.backgroundColor;
    UIImage *backgroundImage = backgroundColor.toImage;
    if ([backgroundColor isEqual:DBColorExtension.sandColor]){
        backgroundImage = [UIImage imageNamed:@"art_kraft"];
    }else if ([backgroundColor isEqual:DBColorExtension.wheatColor]){
        backgroundImage = [UIImage imageNamed:@"art_wood"];
    }
    self.view.layer.contents = (id)backgroundImage.CGImage;
}

- (void)setReaderAdType:(DBReaderAdType)readerAdType{
    _readerAdType = readerAdType;
    [self readingAdView];
}

- (void)readingAdView{
    if (self.readerAdType & DBReaderAdPageGrid){
        [DBUnityAdConfig.manager openGridAdSpaceType:DBAdSpaceReaderPageGrid reload:YES completion:^(UIView * _Nonnull adContainerView) {
            [self layoutAdSubview:adContainerView];
        }];
    }
    
    if (self.readerAdType & DBReaderAdPageEndGrid){
        [DBUnityAdConfig.manager openGridAdSpaceType:DBAdSpaceReaderChapterEndGrid reload:YES completion:^(UIView * _Nonnull adContainerView) {
            [self layoutAdSubview:adContainerView];
        }];
    }
    
    if (self.readerAdType & DBReaderAdPageSlot){
        [DBUnityAdConfig.manager openExpressAdsSpaceType:DBAdSpaceReaderPage showAdController:self reload:YES completion:^(NSArray<UIView *> * _Nonnull adViews) {
            [self layoutAdSubview:adViews.firstObject];
        }];
    }
   
    if (self.readerAdType & DBReaderAdPageEndSlot){
        [DBUnityAdConfig.manager openExpressAdsSpaceType:DBAdSpaceReaderChapterEnd showAdController:self reload:YES completion:^(NSArray<UIView *> * _Nonnull adViews) {
            [self layoutAdSubview:adViews.firstObject];
        }];
    }
}

- (void)layoutAdSubview:(UIView *)adContainerView{
    if (!adContainerView || self.adContainerView) return;
    
    if ([self.adContainerView isEqual:adContainerView]){
        [self.adContainerView removeFromSuperview];
        self.adContainerView = nil;
    }else{
        if (self.adContainerView) [self.adContainerView removeFromSuperview];
        self.adContainerView = adContainerView;
        CGFloat height = UIScreen.screenWidth*adContainerView.height/MAX(adContainerView.width, 50);
        self.adContainerView.frame = CGRectMake(0, (UIScreen.screenHeight-height)*0.46, UIScreen.screenWidth, height);
        [self.view addSubview:self.adContainerView];
    }
}


@end
