//
//  DBFogetPasswordViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/3.
//

#import "DBFogetPasswordViewController.h"
#import "DBPhoneForgetPasswordViewController.h"
#import "DBEmailForgetPasswordViewController.h"
@interface DBFogetPasswordViewController ()<JXCategoryViewDelegate,JXCategoryListContainerViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) DBBaseLabel *titlePageLabel;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *categoryContainerView;
@end

@implementation DBFogetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubViews];
}

- (void)setUpSubViews{
    [self.view addSubviews:@[self.titlePageLabel,self.categoryView,self.categoryContainerView]];
    [self.titlePageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(UIScreen.navbarSafeHeight);
        make.height.mas_equalTo(UIScreen.navbarNetHeight);
    }];
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(UIScreen.navbarSafeHeight+100);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(180);
    }];
    [self.categoryContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.categoryView.mas_bottom);
    }];

    [self.categoryView reloadData];
    [self.categoryView selectItemAtIndex:self.index];
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.categoryView.titles.count;
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    if (index){
        return DBEmailForgetPasswordViewController.new;
    }else{
        return DBPhoneForgetPasswordViewController.new;
    }
}


- (DBBaseLabel *)titlePageLabel{
    if (!_titlePageLabel){
        _titlePageLabel = [[DBBaseLabel alloc] init];
        _titlePageLabel.font = DBFontExtension.bodySixTenFont;
        _titlePageLabel.textColor = DBColorExtension.charcoalColor;
        _titlePageLabel.textAlignment = NSTextAlignmentCenter;
        _titlePageLabel.text = @"修改密码";
    }
    return _titlePageLabel;
}

- (JXCategoryTitleView *)categoryView{
    if (!_categoryView){
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectZero];
        _categoryView.delegate = self;
   
        _categoryView.titleColor = DBColorExtension.mediumGrayColor;
        _categoryView.titleSelectedColor = DBColorExtension.whiteColor;
        _categoryView.titleFont = DBFontExtension.bodyMediumFont;
        _categoryView.titleSelectedFont = DBFontExtension.pingFangMediumMedium;
        _categoryView.listContainer = self.categoryContainerView;
        _categoryView.titles = @[@"手机号".textMultilingual,@"邮箱".textMultilingual];
        
        JXCategoryIndicatorBackgroundView *backgroundColorView = [[JXCategoryIndicatorBackgroundView alloc] init];
        backgroundColorView.layer.cornerRadius = 20;
        backgroundColorView.layer.masksToBounds = YES;
        backgroundColorView.indicatorHeight = 40;
        backgroundColorView.indicatorColor = DBColorExtension.accountThemeColor;
        backgroundColorView.indicatorWidthIncrement = 40;
        _categoryView.indicators = @[backgroundColorView];
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
