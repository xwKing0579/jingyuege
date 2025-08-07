//
//  DBBestsellerListViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/13.
//

#import "DBBestsellerListViewController.h"
#import "DBBestsellerIndexViewController.h"
@interface DBBestsellerListViewController ()<JXCategoryViewDelegate,JXCategoryListContainerViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *categoryContainerView;
@property (nonatomic, strong) UIView *gradientColorView;

@end

@implementation DBBestsellerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(changeLocalLanguage) name:DBLocalLanguageChange object:nil];
}

- (void)changeLocalLanguage{
    self.categoryView.titles = @[@"男生".textMultilingual,@"女生".textMultilingual];
    [self.categoryView reloadData];
}

- (void)setUpSubViews{
    UIView *gradientColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.screenWidth, UIScreen.navbarHeight+64)];
    self.gradientColorView = gradientColorView;
    [self.view addSubviews:@[gradientColorView,self.categoryView,self.categoryContainerView]];
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(UIScreen.navbarSafeHeight);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(148);
    }];
    [self.categoryContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.categoryView.mas_bottom);
    }];
    gradientColorView.backgroundColor = [UIColor gradientColorSize:gradientColorView.size direction:DBColorDirectionVertical startColor:DBColorExtension.shellPinkColor endColor:DBColorExtension.whiteColor];
    [self.categoryView setDefaultSelectedIndex:self.defaultIndex==2];
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.categoryView.titles.count;
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    DBBestsellerIndexViewController *vc = DBBestsellerIndexViewController.new;
    vc.index = index;
    return vc;
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
        _categoryView.titles = @[@"男生".textMultilingual,@"女生".textMultilingual];
        
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
        [_categoryContainerView.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
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
