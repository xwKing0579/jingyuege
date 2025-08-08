//
//  DEBookCommentViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/2.
//

#import "DEBookCommentViewController.h"
#import "DBCommentPanView.h"
#import "DEBookCommentListViewController.h"
#import "JXPagerView.h"
#import "DEBookCommentHeadView.h"
#import "DBConventionView.h"
@interface DEBookCommentViewController ()<JXCategoryViewDelegate,JXCategoryListContainerViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIScrollView *commentScrollView;
@property (nonatomic, strong) DEBookCommentHeadView *headView;
@property (nonatomic, strong) UIView *topView;


@property (nonatomic, strong) UIButton *editButton;

@property (nonatomic, strong) DBBaseLabel *commentLabel;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *categoryContainerView;

@end

@implementation DEBookCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
}


- (void)setUpSubViews{
    self.commentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, UIScreen.navbarHeight, UIScreen.screenWidth, UIScreen.screenHeight-UIScreen.navbarHeight)];
    self.commentScrollView.showsVerticalScrollIndicator = NO;
    self.commentScrollView.delegate = self;
    
    self.commentScrollView.contentSize = CGSizeMake(UIScreen.screenWidth, UIScreen.screenHeight-UIScreen.navbarHeight+100);
    [self.view addSubviews:@[self.topView,self.commentScrollView,self.editButton]];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(UIScreen.navbarHeight);
    }];
    [self.commentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(UIScreen.screenWidth);
        make.top.mas_equalTo(self.topView.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];
    [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-UIScreen.tabbarSafeHeight-20);
        make.width.height.mas_equalTo(56);
    }];
    
    [self.commentScrollView addSubviews:@[self.headView,self.categoryView,self.categoryContainerView,self.commentLabel]];
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(self.categoryView);
    }];
}

- (void)getDataSource{
    NSObject *vc = self.categoryContainerView.validListDict.allValues[self.categoryView.selectedIndex];
    [vc dynamicAllusionTomethod:@"resetDataSource"];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    self.navLabel.alpha = MIN(1, MAX(0, offsetY/100));
    BOOL enable = YES;
    if (offsetY < 0){
        [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }else if (offsetY >= 0 && offsetY <= 100){
        enable = NO;
    }else if (offsetY > 100){
        [scrollView setContentOffset:CGPointMake(0, 100) animated:NO];
    }
    [NSNotificationCenter.defaultCenter postNotificationName:DBTableViewEnable object:nil userInfo:@{@"enable":@(enable)}];
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.categoryView.titles.count;
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    DEBookCommentListViewController *vc = [[DEBookCommentListViewController alloc] init];
    vc.index = index+1;
    vc.book_id = self.book.book_id;
    vc.bookName = self.book.name;
    return vc;
}

- (UIView *)topView{
    if (!_topView){
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.screenWidth, UIScreen.navbarHeight)];
        _topView.backgroundColor = DBColorExtension.whiteAltColor;
        _topView.layer.zPosition = 999;
        
        [_topView addSubview:self.navLabel];
        self.navLabel.alpha = 0;
        self.navLabel.text = self.book.name;
        [self.navLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(UIScreen.navbarSafeHeight);
            make.bottom.mas_equalTo(0);
        }];
    }
    return _topView;
}

- (DEBookCommentHeadView *)headView{
    if (!_headView){
        _headView = [[DEBookCommentHeadView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.screenWidth, 100)];
        _headView.book = self.book;
    }
    return _headView;
}

- (UIButton *)editButton{
    if (!_editButton){
        _editButton = [[UIButton alloc] init];
        [_editButton setImage:[UIImage imageNamed:@"jjScribeToken"] forState:UIControlStateNormal];
        DBWeakSelf
        [_editButton addTagetHandler:^(id  _Nonnull sender) {
            DBStrongSelfElseReturn
            
            [DBConventionView conventionViewCompletion:^(BOOL finished) {
                DBCommentPanView *commentView = [[DBCommentPanView alloc] init];
                commentView.book_id = self.book.book_id;
                [commentView presentInView:UIScreen.appWindow];
                
                commentView.commentCompletedBlock = ^(BOOL commentCompleted) {
                    [self getDataSource];
                };
            }];
           
        } controlEvents:UIControlEventTouchUpInside];
    }
    return _editButton;
}

- (DBBaseLabel *)commentLabel{
    if (!_commentLabel){
        _commentLabel = [[DBBaseLabel alloc] init];
        _commentLabel.font = DBFontExtension.bodySixTenFont;
        _commentLabel.textColor = DBColorExtension.charcoalColor;
        _commentLabel.text = @"评论";
    }
    return _commentLabel;
}

- (JXCategoryTitleView *)categoryView{
    if (!_categoryView){
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(UIScreen.screenWidth-120, 110, 120, 30)];
        _categoryView.delegate = self;
        _categoryView.titleColor = DBColorExtension.grayColor;
        _categoryView.titleSelectedColor = DBColorExtension.redColor;
        _categoryView.titleFont = DBFontExtension.bodyMediumFont;
        _categoryView.titleSelectedFont = DBFontExtension.bodyMediumFont;
        _categoryView.listContainer = self.categoryContainerView;
        _categoryView.titles = @[@"最新".textMultilingual,@"最热".textMultilingual];
    }
    return _categoryView;
}

- (JXCategoryListContainerView *)categoryContainerView{
    if (!_categoryContainerView){
        _categoryContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
        _categoryContainerView.frame = CGRectMake(0, 140, UIScreen.screenWidth, UIScreen.screenHeight-40-UIScreen.navbarHeight);
        [_categoryContainerView.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    return _categoryContainerView;
}


- (void)setDarkModel{
    if (DBColorExtension.userInterfaceStyle) {
        [_editButton setImage:[[UIImage imageNamed:@"jjScribeToken"] imageWithTintColor:DBColorExtension.inkWashColor] forState:UIControlStateNormal];
    }else{
        [_editButton setImage:[UIImage imageNamed:@"jjScribeToken"] forState:UIControlStateNormal];
    }
}
@end
