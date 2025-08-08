//
//  DBTabBarRootController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/27.
//

#import "DBTabBarRootController.h"
#import "DBMyBooksViewController.h"
#import "DBMyConfigViewController.h"
#import "DBBookTypesViewController.h"
#import "DBAllBooksViewController.h"
#import "DBGenderBooksViewController.h"
#import "DBReadBookSetting.h"
#import "DBReaderSetting.h"

#import "DBGenderSelectView.h"

@interface DBTabBarRootController ()

@end

@implementation DBTabBarRootController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
    [DBCommonConfig toStoreReview];
    [NSObject dynamicAllusionTomethod:@"BFDebugTool".classString action:@"start"];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(tabbarBackgroundColor) name:DBLocalLanguageChange object:nil];
}

- (void)setUpSubViews{
    UIScreen.appWindow.overrideUserInterfaceStyle = UIUserInterfaceStyleUnspecified;
    NSArray *tabNames = @[DBConstantString.ks_shelf,DBConstantString.ks_bookstore,DBConstantString.ks_categories,DBConstantString.ks_me];
    NSArray *tabVcs = @[DBMyBooksViewController.new,
                     DBAllBooksViewController.new,
                     DBBookTypesViewController.new,
                     DBMyConfigViewController.new];
    NSArray *tabImages = @[@"jjAlphaTab",@"jjBetaTab",@"jjGammaTab",@"jjDeltaTab"];
    NSArray *tabSelImages = @[@"jjAlphaActive",@"jjBetaActive",@"jjGammaActive",@"jjDeltaActive"];
    for (NSInteger index = 0; index < tabVcs.count; index++) {
        UINavigationController *nav = [[UINavigationController  alloc] initWithRootViewController:tabVcs[index]];
        nav.tabBarItem.title = tabNames[index];
        UIImage *image = [UIImage imageNamed:tabImages[index]].original;
        nav.tabBarItem.image = image;
        UIImage *imageSel = [UIImage imageNamed:tabSelImages[index]].original;
        nav.tabBarItem.selectedImage = imageSel;
        [self addChildViewController:nav];
    }
    [self tabbarBackgroundColor];

    
    DBAppSetting *setting = DBAppSetting.setting;
    if (!setting.sex && [DBCommonConfig allFunctionSwitchAudit]){
        DBGenderSelectView *selectView = DBGenderSelectView.new;
        [self.view addSubview:selectView];
        [selectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        DBReadBookSetting *setting = DBReadBookSetting.setting;
        if (setting.isEyeShaow || setting.isDark){
            [DBReaderSetting openEyeProtectionMode];
        }else{
            [DBReaderSetting closeEyeProtectionMode];
        }
    });
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [self tabbarBackgroundColor];
}

- (void)tabbarBackgroundColor{
    UIColor *color = DBColorExtension.inactiveTabColor;
    UIColor *selColor = DBColorExtension.activeTabColor;
    UIFont *font = DBFontExtension.bodySmallFont;
    UIColor *backgroundColor = DBColorExtension.whiteColor;
    if (DBColorExtension.userInterfaceStyle) {
        color = DBColorExtension.lightSlateColor;
        backgroundColor = DBColorExtension.blackColor;
    }
    UIImage *shadowImage = DBColorExtension.noColor.toImage;
    
    if (@available (iOS 15.0, *)){
        UITabBarAppearance *appearance = [[UITabBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground];
        appearance.shadowImage = shadowImage;
        appearance.backgroundColor = backgroundColor;
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = @{NSForegroundColorAttributeName:color,
                                                                          NSFontAttributeName:font};
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = @{NSForegroundColorAttributeName:selColor,
                                                                          NSFontAttributeName:font};
        self.tabBar.standardAppearance = appearance;
        self.tabBar.scrollEdgeAppearance = self.tabBar.standardAppearance;
    }else{
        [self.tabBarItem setTitleTextAttributes:
         @{NSForegroundColorAttributeName:color,
                      NSFontAttributeName:font}
                                 forState:UIControlStateNormal];
        [self.tabBarItem setTitleTextAttributes:
         @{NSForegroundColorAttributeName:selColor,
                      NSFontAttributeName:font}
                                 forState:UIControlStateSelected];
        self.tabBar.shadowImage = shadowImage;
        self.tabBar.backgroundColor = backgroundColor;
    }

    for (UIViewController *vc in self.childViewControllers) {
        if ([vc isKindOfClass:[UINavigationController class]]){
            UINavigationController *nav = (UINavigationController *)vc;
            nav.tabBarItem.image = [nav.tabBarItem.image imageWithTintColor:color];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    //更新检测
    [DBAFNetWorking getServiceRequestType:DBLinkAppVserion combine:nil parameInterface:nil modelClass:DBAppVersionModel.class serviceData:^(BOOL successfulRequest, DBAppVersionModel *result, NSString * _Nullable message) {
        if (successfulRequest){
            if (result.url.length && result.content.length){
                if (result.isTrue){
                    LEEAlert.actionsheet.config.LeeTitle(DBConstantString.ks_tip).LeeContent(result.content).
                    LeeAction(DBConstantString.ks_go, ^{
                        [UIApplication.sharedApplication openURL:[NSURL URLWithString:result.url] options:@{} completionHandler:nil];
                    }).LeeShow();
                }else{
                
                    LEEAlert.actionsheet.config.LeeTitle(DBConstantString.ks_tip).LeeContent(result.content).
                    LeeAction(DBConstantString.ks_go, ^{
                        [UIApplication.sharedApplication openURL:[NSURL URLWithString:result.url] options:@{} completionHandler:nil];
                    }).LeeCancelAction(DBConstantString.ks_cancel, ^{
                        
                    }).LeeShow();
                }
            }
        }
    }];
    
    //强制更新
    if (!DBCommonConfig.isNewbie && DBCommonConfig.appConfig.force.update_switch) {
        [DBCommonConfig getAppStoreCompletion:^(BOOL needUpdate) {
            
        }];
    }
    
    [DBAFNetWorking postServiceRequestType:DBLinkUserPlane combine:nil parameInterface:nil serviceData:^(BOOL successfulRequest, id  _Nullable result, NSString * _Nullable message) {
       
    }];
}



@end
