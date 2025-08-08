//
//  DBFeedbackViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/26.
//

#import "DBFeedbackViewController.h"
#import "DBFeedbackInfoViewController.h"
#import "DBFeedbackListViewController.h"
@interface DBFeedbackViewController ()<JXCategoryViewDelegate,JXCategoryListContainerViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *categoryContainerView;

@end

@implementation DBFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
}

- (void)setUpSubViews{
    [self.view addSubviews:@[self.categoryView,self.categoryContainerView]];
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(UIScreen.navbarSafeHeight);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(280);
    }];
    [self.categoryContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.categoryView.mas_bottom);
    }];
    [self.categoryView reloadData];
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.categoryView.titles.count;
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    if (index == 0){
        return DBFeedbackInfoViewController.new;
    }
    return DBFeedbackListViewController.new;
}

- (JXCategoryTitleView *)categoryView{
    if (!_categoryView){
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectZero];
        _categoryView.delegate = self;
        _categoryView.titleColor = DBColorExtension.charcoalColor;
        _categoryView.titleSelectedColor = DBColorExtension.charcoalColor;
        _categoryView.titleFont = DBFontExtension.bodySixTenFont;
        _categoryView.titleSelectedFont = DBFontExtension.pingFangSemiboldXLarge;
        _categoryView.listContainer = self.categoryContainerView;
        _categoryView.titles = @[DBConstantString.ks_giveFeedback.textMultilingual,DBConstantString.ks_feedbackHistory.textMultilingual];
        
        JXCategoryIndicatorLineView *partingLineView = [[JXCategoryIndicatorLineView alloc] init];
        partingLineView.indicatorColor = DBColorExtension.azureColor;
        partingLineView.indicatorWidth = 30;
        partingLineView.indicatorHeight = 2;
        partingLineView.indicatorCornerRadius = 1;
        partingLineView.verticalMargin = 0;
        _categoryView.indicators = @[partingLineView];
    }
    return _categoryView;
}

- (JXCategoryListContainerView *)categoryContainerView{
    if (!_categoryContainerView){
        _categoryContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
        [_categoryContainerView.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    return _categoryContainerView;
}
@end
