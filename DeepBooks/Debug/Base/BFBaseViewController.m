//
//  BFBaseViewController.m
//  OCProject
//
//  Created by 王祥伟 on 2023/12/5.
//

#import "BFBaseViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "UIColor+Category.h"
#import "UIImage+Category.h"
#import "BFRouter.h"
#import <Masonry/Masonry.h>
#import "UIDevice+Category.h"
@interface BFBaseViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIButton *backBtn;

@end

@implementation BFBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *imageString;
    if (self.navigationController.childViewControllers.count > 1) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backViewController)];
    }else if (self.presentingViewController){
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backViewController)];
    }

    
    self.fd_interactivePopDisabled = [self disableNavigationBar];
    self.fd_prefersNavigationBarHidden = [self hideNavigationBar];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.view.backgroundColor = UIColor.bf_cFFFFFF;
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (![self hideBackButton]) {
        [self.view addSubview:self.backBtn];
    }
}


- (UIButton *)backBtn{
    if (!_backBtn){
        _backBtn = [[UIButton alloc] init];

        [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backViewController) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_backBtn];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(UIDevice.statusBarHeight);
            make.width.height.mas_equalTo(UIDevice.navBarHeight);
        }];
    }
    return _backBtn;
}

///back
- (void)backViewController{
    [BFRouter back];
}

///hidden navbar
- (BOOL)hideNavigationBar{
    return NO;
}

- (BOOL)disableNavigationBar{
    return NO;
}

- (UIColor *)backButtonColor{
    return UIColor.bf_c000000;
}

- (BOOL)hideBackButton{
    return YES;
}
@end
