//
//  DBMineViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/21.
//

#import "DBMineViewController.h"
#import "DBMyConfigTableViewCell.h"
#import "DBMyConfigModel.h"
#import <StoreKit/StoreKit.h>
#import "DBUserSettingModel.h"
#import "DBAppSwitchModel.h"
#import "DBImagePicker.h"
#import "DBMineIndexViewController.h"
@interface DBMineViewController ()<JXCategoryViewDelegate,JXCategoryListContainerViewDelegate>
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UIImageView *avaterImageView;
@property (nonatomic, strong) NSMutableArray *contentArray;

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *categoryContainerView;
@end

@implementation DBMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
}

- (void)setUpSubViews{
    self.navgationView.backgroundColor = UIColor.clearColor;
    self.view.layer.contents = CFBridgingRelease([UIImage imageNamed:@"jjVoidHorizon"].CGImage);
    [self.view addSubviews:@[self.headerView,self.categoryView,self.categoryContainerView]];

    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.headerView.height);
        make.height.mas_equalTo(50);
    }];
    [self.categoryContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.categoryView.mas_bottom);
    }];
    
    id imageObj = [UIImage imageNamed:@"avaterImage"];
    if (DBCommonConfig.userDataInfo.avatar.length > 0){
        imageObj = [DBLinkManager combineLinkWithType:DBLinkHeaderAvatarUrl combine:DBCommonConfig.userDataInfo.avatar];
    }
    id imageData = [NSUserDefaults takeValueForKey:DBUserAvaterKey];
    if (DBCommonConfig.isLogin){
        self.avaterImageView.imageObj = imageData ?: imageObj;
    }else{
        self.avaterImageView.imageObj = imageObj;
    }
}

- (void)changeAvaterAction{
    DBWeakSelf
    [DBImagePicker showYPImagePickerWithRatio:1 completion:^(UIImage * _Nonnull image) {
        DBStrongSelfElseReturn
        NSData *imageData = [image compressImageMaxSize:200*1024 scale:0.8];
        [NSUserDefaults saveValue:imageData forKey:DBUserAvaterKey];
        self.avaterImageView.imageObj = image;
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSArray *contents = DBMyConfigModel.myConfigContent;
    for (UILabel *label in self.contentArray) {
        NSInteger index = [self.contentArray indexOfObject:label];
        label.text = index ? contents.lastObject : contents.firstObject;
    }
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.categoryView.titles.count;
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    DBMineIndexViewController *indexVc = DBMineIndexViewController.new;
    indexVc.index = index;
    return indexVc;
}

- (UIImageView *)headerView{
    if (!_headerView){
        _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.screenWidth, UIScreen.navbarSafeHeight+100)];
        _headerView.userInteractionEnabled = YES;
        
        [_headerView addSubviews:@[self.avaterImageView]];
        [self.avaterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.bottom.mas_equalTo(-20);
            make.width.height.mas_equalTo(60);
        }];
   
        
        NSArray *titles = @[DBConstantString.ks_readingMinutes,DBConstantString.ks_history];
        NSArray *contents = DBMyConfigModel.myConfigContent;
        NSMutableArray *titleArray = [NSMutableArray array];
        NSMutableArray *contentArray = [NSMutableArray array];
        self.contentArray = contentArray;
        for (NSString *title in titles) {
            DBBaseLabel *titleLabel = [[DBBaseLabel alloc] init];
            titleLabel.font = DBFontExtension.bodyMediumFont;
            titleLabel.textColor = DBColorExtension.whiteColor;
            titleLabel.text = title;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [titleArray addObject:titleLabel];
         
            DBBaseLabel *contentTextLabel = [[DBBaseLabel alloc] init];
            contentTextLabel.font = DBFontExtension.pingFangSemiboldXXLarge;
            contentTextLabel.textColor = DBColorExtension.whiteColor;
            contentTextLabel.textAlignment = NSTextAlignmentCenter;
            [contentArray addObject:contentTextLabel];
            NSInteger index = [titles indexOfObject:title];
            contentTextLabel.text = index ? contents.lastObject : contents.firstObject;
        }
        [_headerView addSubviews:titleArray];
        [_headerView addSubviews:contentArray];

        
        CGFloat space = 6;
        [titleArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:space leadSpacing:110 tailSpacing:30];
        [contentArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:space leadSpacing:110 tailSpacing:30];

        [titleArray mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.avaterImageView).offset(-5);
        }];
        [contentArray mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.avaterImageView).offset(5);
        }];

    }
    return _headerView;
}


- (UIImageView *)avaterImageView{
    if (!_avaterImageView){
        _avaterImageView = [[UIImageView alloc] init];
        _avaterImageView.contentMode = UIViewContentModeScaleAspectFill;
        _avaterImageView.image = [UIImage imageNamed:@"appLogo"];
        _avaterImageView.layer.cornerRadius = 4;
        _avaterImageView.layer.masksToBounds = YES;
        _avaterImageView.imageObj = DBCommonConfig.userCurrentInfo.user_avatar;
        _avaterImageView.userInteractionEnabled = YES;
        [_avaterImageView addTapGestureTarget:self action:@selector(changeAvaterAction)];
    }
    return _avaterImageView;
}


- (JXCategoryTitleView *)categoryView{
    if (!_categoryView){
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectZero];
        _categoryView.delegate = self;
        _categoryView.titleColor = DBColorExtension.whiteColor;
        _categoryView.titleSelectedColor = DBColorExtension.sunsetOrangeColor;
        _categoryView.titleFont = DBFontExtension.pingFangSemiboldRegular;
        _categoryView.titleSelectedFont = DBFontExtension.pingFangMediumMedium;
        _categoryView.listContainer = self.categoryContainerView;
        _categoryView.titles = @[DBConstantString.ks_bookmarks,DBConstantString.ks_history];
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
    }
    return _categoryContainerView;
}


@end
