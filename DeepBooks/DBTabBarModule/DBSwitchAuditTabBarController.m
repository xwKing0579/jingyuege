//
//  DBSwitchAuditTabBarController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/5.
//

#import "DBSwitchAuditTabBarController.h"

#import "DBReadBookSetting.h"
#import "DBReaderSetting.h"
#import "DBHomeViewController.h"
#import "DBMineViewController.h"

#import "DBGenderSelectView.h"
@interface DBSwitchAuditTabBarController ()

@end

@implementation DBSwitchAuditTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
    [NSObject dynamicAllusionTomethod:@"BFDebugTool".classString action:@"start"];
}

- (void)setUpSubViews{
    NSArray *names = @[@"首页",@"我的"];
    NSArray *tabImages = @[@"jjAlphaTab",@"jjDeltaTab"];
    NSArray *tabSelImages = @[@"jjAlphaActive",@"jjDeltaActive"];
    NSArray *vcs = @[DBHomeViewController.new,DBMineViewController.new];
    for (NSInteger index = 0; index < vcs.count; index++) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vcs[index]];
        nav.tabBarItem.title = names[index];
        UIImage *image = [UIImage imageNamed:tabImages[index]].original;
        nav.tabBarItem.image = image;
        UIImage *imageSel = [UIImage imageNamed:tabSelImages[index]].original;
        nav.tabBarItem.selectedImage = imageSel;
        [self addChildViewController:nav];
    }
    
    [self tabbarBackgroundColor];
    
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
}

@end
