//
//  DBAllBooksViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/28.
//

#import "DBAllBooksViewController.h"
#import "DBBooksIndexViewController.h"
#import "DBHotWordsModel.h"
#import "DBSearchTagModel.h"

@interface DBAllBooksViewController ()<JXCategoryViewDelegate,JXCategoryListContainerViewDelegate>
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UIView *gradientColorView;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *categoryContainerView;

@property (nonatomic, assign) BOOL needShowAdView;
@end

@implementation DBAllBooksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubViews];
    [self getDataSource];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(changeLocalLanguage) name:DBLocalLanguageChange object:nil];
}

- (void)changeLocalLanguage{
    self.categoryView.titles = @[@"推荐".textMultilingual,@"男生".textMultilingual,@"女生".textMultilingual];
    [self.categoryView reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self openAdSpaceEnterBookshelfPage];
}

- (void)openAdSpaceEnterBookshelfPage{
    DBAdPosModel *posAdReder = [DBUnityAdConfig adPosWithSpaceType:DBAdSpaceEnterBookCity];
    NSInteger interval = posAdReder.extra.interval;
    NSInteger cumulativeTime = [[DBUnityAdConfig.manager.apperTimeDict valueForKey:NSStringFromClass(self.class)] intValue];
    NSInteger nowTime = DBUnityAdConfig.manager.cumulativeTime;
    if (interval && nowTime - cumulativeTime > interval*10){
        [DBUnityAdConfig.manager openSlotAdSpaceType:DBAdSpaceEnterBookCity showAdController:self completion:^(BOOL removed) {
            if (removed) return;
            [DBUnityAdConfig.manager.apperTimeDict setValue:@(DBUnityAdConfig.manager.cumulativeTime) forKey:NSStringFromClass(self.class)];
        }];
    }
}

- (void)setUpSubViews{
    UIView *gradientColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.screenWidth, UIScreen.navbarHeight+64)];
    self.gradientColorView = gradientColorView;
    [self.view addSubviews:@[gradientColorView,self.categoryContainerView,self.categoryView,self.searchButton]];
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(222);
        make.top.mas_equalTo(UIScreen.navbarSafeHeight);
        make.height.mas_equalTo(UIScreen.navbarNetHeight);
    }];
    [self.categoryContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.categoryView.mas_bottom);
    }];
    
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(self.categoryView);
    }];
    [self.categoryView reloadData];
    
    gradientColorView.backgroundColor = [UIColor gradientColorSize:gradientColorView.size direction:DBColorDirectionVertical startColor:DBColorExtension.shellPinkColor endColor:DBColorExtension.whiteColor];
}

- (void)getDataSource{
    [DBAFNetWorking getServiceRequestType:DBLinkBookSearchHotWords combine:nil parameInterface:@{@"data_conf":@"2"} modelClass:DBHotWordsModel.class serviceData:^(BOOL successfulRequest, DBHotWordsModel *result, NSString * _Nullable message) {
        if (successfulRequest){
            DBAppSetting.setting.tagList = result.book;
            [DBAppSetting.setting reloadSetting];
        }
    }];
}

- (void)clickSearchAction{
    [DBRouter openPageUrl:DBSearchBooks params:@{kDBRouterPathNoAnimation:@1}];
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.categoryView.titles.count;
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    DBBooksIndexViewController *indexVc = DBBooksIndexViewController.new;
    indexVc.index = index;
    return indexVc;
}

- (UIButton *)searchButton{
    if (!_searchButton){
        _searchButton = [[UIButton alloc] init];
        _searchButton.enlargedEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [_searchButton setImage:[UIImage imageNamed:@"searchIcon"] forState:UIControlStateNormal];
        [_searchButton addTarget:self action:@selector(clickSearchAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchButton;
}

- (JXCategoryTitleView *)categoryView{
    if (!_categoryView){
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectZero];
        _categoryView.delegate = self;
        _categoryView.titleColor = DBColorExtension.ashWhiteColor;
        _categoryView.titleSelectedColor = DBColorExtension.blackAltColor;
        _categoryView.titleFont = DBFontExtension.pingFangSemiboldLarge;
        _categoryView.titleSelectedFont = DBFontExtension.pingFangMediumXLarge;
        _categoryView.listContainer = self.categoryContainerView;
        _categoryView.titles = @[@"推荐".textMultilingual,@"男生".textMultilingual,@"女生".textMultilingual];
        _categoryView.backgroundColor = DBColorExtension.noColor;
        
        JXCategoryIndicatorLineView *partingLineView = [[JXCategoryIndicatorLineView alloc] init];
        partingLineView.indicatorColor = DBColorExtension.sunsetOrangeColor;
        partingLineView.indicatorWidth = 34;
        partingLineView.indicatorHeight = 4;
        partingLineView.indicatorCornerRadius = 2;
        partingLineView.verticalMargin = 4;
        _categoryView.indicators = @[partingLineView];
    }
    return _categoryView;
}

- (JXCategoryListContainerView *)categoryContainerView{
    if (!_categoryContainerView){
        _categoryContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
        _categoryContainerView.backgroundColor = DBColorExtension.noColor;
//        [_categoryContainerView.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
//        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    return _categoryContainerView;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    if (DBColorExtension.userInterfaceStyle) {
        self.gradientColorView.backgroundColor = [UIColor gradientColorSize:self.gradientColorView.size direction:DBColorDirectionVertical startColor:DBColorExtension.espressoColor endColor:DBColorExtension.blackColor];
    }else{
        self.gradientColorView.backgroundColor = [UIColor gradientColorSize:self.gradientColorView.size direction:DBColorDirectionVertical startColor:DBColorExtension.shellPinkColor endColor:DBColorExtension.whiteColor];
    }
}

@end
