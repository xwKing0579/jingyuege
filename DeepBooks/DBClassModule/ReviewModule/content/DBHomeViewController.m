//
//  DBHomeViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/25.
//

#import "DBHomeViewController.h"

@interface DBHomeViewController ()
@property (nonatomic, strong) UIButton *bookselfButton;
@property (nonatomic, strong) UIButton *searchButton;
@end

@implementation DBHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(realodAllChildController)
                                                 name:DBNetReachableChange
                                               object:nil];
  
}

- (void)realodAllChildController{
    for (UIViewController *vc in self.categoryContainerView.validListDict.allValues) {
        [vc dynamicAllusionTomethod:@"getDataSource"];
    }
}

- (void)setUpSubViews{
    [super setUpSubViews];
    [self.view addSubviews:@[self.bookselfButton,self.searchButton]];
    [self.bookselfButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(UIScreen.navbarSafeHeight+5);
        make.width.height.mas_equalTo(34);
    }];
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(self.bookselfButton);
        make.width.height.mas_equalTo(34);
    }];
}

- (void)openBookselfPage{
    [DBRouter openPageUrl:@"DBBookselfViewController"];
}

- (void)openSearchBooksPage{
    
}

- (UIButton *)bookselfButton{
    if (!_bookselfButton){
        _bookselfButton = [[UIButton alloc] init];
        [_bookselfButton setImage:[UIImage imageNamed:@"bookselfImage"] forState:UIControlStateNormal];
        [_bookselfButton addTarget:self action:@selector(openBookselfPage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bookselfButton;
}

- (UIButton *)searchButton{
    if (!_searchButton){
        _searchButton = [[UIButton alloc] init];
        [_searchButton setImage:[UIImage imageNamed:@"searchIcon"] forState:UIControlStateNormal];
        [_searchButton addTarget:self action:@selector(openSearchBooksPage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchButton;
}
@end
