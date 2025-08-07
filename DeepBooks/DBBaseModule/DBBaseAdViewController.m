//
//  DBBaseAdViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/5/22.
//

#import "DBBaseAdViewController.h"

@interface DBBaseAdViewController ()

@end

@implementation DBBaseAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadingTopAdView:YES];
    });
}

- (void)loadingTopAdView:(BOOL)reload{
    DBWeakSelf
    [DBUnityAdConfig.manager openBannerAdSpaceType:DBAdSpaceBookCityCategoryTop showAdController:self reload:reload completion:^(UIView * _Nonnull adContainerView) {
        DBStrongSelfElseReturn
        if (!adContainerView) return;

        if ([self.adContainerView isEqual:adContainerView]) {
            [self.adContainerView removeFromSuperview];
            [self.listRollingView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.navLabel.mas_bottom);
            }];
            
            self.adContainerView = nil;
        }else{
            if (self.adContainerView) [self.adContainerView removeFromSuperview];
            
            [self.view addSubview:adContainerView];
            [adContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(0);
                make.size.mas_equalTo(adContainerView.size);
                make.top.mas_equalTo(self.navLabel.mas_bottom);
            }];
            
            [self.listRollingView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.navLabel.mas_bottom).offset(adContainerView.size.height);
            }];
            
            self.adContainerView = adContainerView;
        }
    }];
}

@end
