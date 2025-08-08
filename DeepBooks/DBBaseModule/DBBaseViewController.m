//
//  DBBaseViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/27.
//

#import "DBBaseViewController.h"


@interface DBBaseViewController ()
@property (nonatomic, strong) UIView *navgationView;
@property (nonatomic, assign) BOOL isLayOut;
@end

@implementation DBBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = DBColorExtension.whiteAltColor;
    self.fd_interactivePopDisabled = NO;
    self.fd_prefersNavigationBarHidden = YES;
    self.navgationView.hidden = self.hiddenLeft;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.leftButton.hidden = self.navigationController.childViewControllers.count == 1 || self.hiddenLeft;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    [self setDarkModel];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    [self.view addSubview:self.leftButton];
}

- (void)setDarkModel{
//    DBWeakSelf
//    [self.view traverseAllSubviewsWithBlock:^(UIView * _Nonnull subview) {
//        DBStrongSelfElseReturn
//        [self changeViewColorProperty:subview];
//    }];
//    [self changeViewColorProperty:UIScreen.appWindow];
  
    if (DBColorExtension.userInterfaceStyle) {
        [_leftButton setImage:[[UIImage imageNamed:@"jjRetreatCompass"] imageWithTintColor:DBColorExtension.whiteColor] forState:UIControlStateNormal];
    }else{
        [_leftButton setImage:[UIImage imageNamed:@"jjRetreatCompass"] forState:UIControlStateNormal];
    }
}

- (void)changeViewColorProperty:(UIView *)subview{
    NSDictionary *textColorDict = DBSkinChangeManager.textColorInvertedDict;
    NSDictionary *backgroundColorDict = DBSkinChangeManager.backgroundColorInvertedDict;
    
    if (DBColorExtension.userInterfaceStyle) {
        textColorDict = DBSkinChangeManager.textColorDict;
        backgroundColorDict = DBSkinChangeManager.backgroundColorDict;
    }
    
    UIColor *currentTextColor;
    UIColor *currentBackgroundColor = subview.backgroundColor;
    if ([subview isKindOfClass:[UILabel class]] || [subview isKindOfClass:[UITextField class]]){
        currentTextColor = ((DBBaseLabel *)subview).textColor;
    }
    
    if (currentTextColor && [textColorDict.allKeys containsObject:currentTextColor]){
        ((DBBaseLabel *)subview).textColor = textColorDict[currentTextColor];
    }
    if (currentBackgroundColor && [backgroundColorDict.allKeys containsObject:currentBackgroundColor]){
        subview.backgroundColor = backgroundColorDict[currentBackgroundColor];
    }
}


- (void)setUpSubViews{
    
}

- (void)getDataSource{
    
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource --
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [UITableViewCell new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return UIView.new;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return UIView.new;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01; 
}

- (DBBaseLabel *)navLabel{
    if (!_navLabel){
        _navLabel = [[DBBaseLabel alloc] init];
        _navLabel.text = self.title;
        _navLabel.font = DBFontExtension.pingFangMediumXLarge;
        _navLabel.textColor = DBColorExtension.blackAltColor;
        _navLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _navLabel;
}

- (UIView *)navgationView{
    if (!_navgationView){
        _navgationView = [[UIView alloc] init];
        _navgationView.backgroundColor = DBColorExtension.whiteAltColor;
        [self.view addSubview:_navgationView];
        [_navgationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.height.mas_equalTo(UIScreen.navbarHeight);
        }];
    }
    return _navgationView;
}

- (DBBaseTableView *)listRollingView{
    if (!_listRollingView){
        _listRollingView = [[DBBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _listRollingView.estimatedSectionHeaderHeight = 0;
        _listRollingView.estimatedSectionFooterHeight = 0;
        _listRollingView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listRollingView.rowHeight = UITableViewAutomaticDimension;
        _listRollingView.showsVerticalScrollIndicator = NO;
        _listRollingView.showsHorizontalScrollIndicator = NO;
        _listRollingView.delegate = self;
        _listRollingView.dataSource = self;
        _listRollingView.backgroundColor = DBColorExtension.noColor;
        _listRollingView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        if (@available(iOS 15.0, *)) {
            _listRollingView.sectionHeaderTopPadding = 0;
        }
    }
    return _listRollingView;
}

- (UIButton *)leftButton{
    if (!_leftButton){
        _leftButton = [[UIButton alloc] init];
        _leftButton.layer.zPosition = 1000;
        [_leftButton setImage:[UIImage imageNamed:@"jjRetreatCompass"] forState:UIControlStateNormal];
  
        [_leftButton addTagetHandler:^(id  _Nonnull sender) {
            [DBRouter closePage];
        } controlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_leftButton];
        [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(6);
            make.top.mas_equalTo(UIScreen.navbarSafeHeight);
            make.width.height.mas_equalTo(UIScreen.navbarNetHeight);
        }];
    }
    return _leftButton;
}

- (BOOL)hiddenLeft{
    return NO;
}

@end
