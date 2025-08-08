//
//  DBGenderBooksListViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/1.
//

#import "DBGenderBooksListViewController.h"
#import "DBLeaderboardModel.h"
#import "DBLeaderboardTableViewCell.h"
#import "DBLeaderboardBooksTableViewCell.h"
#import "DBBooksDataModel.h"

@interface DBGenderBooksListViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView *booksTableView;
@property (nonatomic, strong) NSArray *booksList;

@property (nonatomic, assign) NSInteger selectIndex;
@end

@implementation DBGenderBooksListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
    [self getDataSource];
    [self loadingTopAdView:YES];
}

- (void)setUpSubViews{
    self.view.backgroundColor = DBColorExtension.noColor;
    self.listRollingView.backgroundColor = DBColorExtension.noColor;
    self.booksTableView.backgroundColor = DBColorExtension.noColor;
    [self.view addSubviews:@[self.listRollingView,self.booksTableView]];
    [self.listRollingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(80);
    }];
    [self.booksTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(self.listRollingView.mas_right);
    }];
    

    DBWeakSelf
    self.booksTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        DBStrongSelfElseReturn
        [self getDataSource];
    }];
    
    
    id value = [NSUserDefaults takeValueForKey:self.getStoreRankCatalogurl];
    if (value){
        DBLeaderboardModel *result = [DBLeaderboardModel yy_modelWithJSON:value];
        self.dataList = self.index > 0 ? result.female : result.male;
        [self setBooksRankId];
    }
}

- (void)loadingTopAdView:(BOOL)reload{
    DBWeakSelf
    [DBUnityAdConfig.manager openBannerAdSpaceType:DBAdSpaceBookCityCategoryTop showAdController:self reload:reload completion:^(UIView * _Nonnull adContainerView) {
        DBStrongSelfElseReturn
        if (!adContainerView) return;
        
        if ([self.adContainerView isEqual:adContainerView]) {
            [self.adContainerView removeFromSuperview];
            [self.listRollingView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
            }];
            [self.booksTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
            }];
            self.adContainerView = nil;
        }else{
            if (self.adContainerView) [self.adContainerView removeFromSuperview];
            
            [self.view addSubview:adContainerView];
            [adContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(0);
                make.size.mas_equalTo(adContainerView.size);
                make.top.mas_equalTo(0);
            }];
            
            [self.listRollingView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(adContainerView.height);
            }];
            [self.booksTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(adContainerView.height);
            }];
            
            self.adContainerView = adContainerView;
        }
    }];
}

- (NSString *)getStoreRankCatalogurl{
    NSString *url = [DBLinkManager combineLinkWithType:DBLinkBookStoreRankCatalog combine:nil];
    return url;
}

- (void)getDataSource{
    [DBAFNetWorking getServiceRequestType:DBLinkBookStoreRankCatalog combine:nil parameInterface:nil modelClass:DBLeaderboardModel.class serviceData:^(BOOL successfulRequest, DBLeaderboardModel *result, NSString * _Nullable message) {
        [self.booksTableView.mj_header endRefreshing];
        if (successfulRequest){
            self.dataList = self.index > 0 ? result.female : result.male;
            
            [self setBooksRankId];
            [NSUserDefaults saveValue:result.yy_modelToJSONString forKey:self.getStoreRankCatalogurl];
        }
    }];
}

- (void)setBooksRankId{
    if (self.selectIndex >= self.dataList.count) self.selectIndex = 0;
    if (self.dataList.count){
        DBLeaderboardItemModel *model = self.dataList[self.selectIndex];
        [self getBooksRankList:model.rank_id];
    }
    [self.listRollingView reloadData];
}

- (void)getBooksRankList:(NSString *)rankId{
    [DBAFNetWorking getServiceRequestType:DBLinkBookStoreRankDetailData combine:rankId parameInterface:nil modelClass:DBBooksDataModel.class serviceData:^(BOOL successfulRequest, NSArray <DBBooksDataModel *>*result, NSString * _Nullable message) {
        [self.view removeHudLoading];
        if (successfulRequest){
            self.booksList = result;
        }else{
            [self.view showAlertText:message];
        }
        self.listRollingView.emptyDataSetSource = self;
        self.listRollingView.emptyDataSetDelegate = self;
        [self.booksTableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [tableView isEqual:self.listRollingView] ? self.dataList.count : self.booksList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.listRollingView]){
        DBLeaderboardTableViewCell *cell = [DBLeaderboardTableViewCell initWithTableView:tableView];
        cell.model = self.dataList[indexPath.row];
        cell.isSelect = indexPath.row == self.selectIndex;
        return cell;
    }else{
        DBLeaderboardBooksTableViewCell *cell = [DBLeaderboardBooksTableViewCell initWithTableView:tableView];
        cell.model = self.booksList[indexPath.row];
        cell.rank = indexPath.row+1;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.listRollingView]){
        self.selectIndex = indexPath.row;

        [self setBooksRankId];
    }else{
        DBBooksDataModel *model = self.booksList[indexPath.row];
        [DBRouter openPageUrl:DBBookDetail params:@{@"bookId":DBSafeString(model.book_id)}];
    }
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    DBEmptyView *emptyView = [[DBEmptyView alloc] init];
    emptyView.imageObj = [UIImage imageNamed:@"jjNullCanvas"];
    emptyView.content = DBConstantString.ks_noRankings;
    emptyView.dataList = self.dataList;
    [scrollView addSubview:emptyView];
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.width.mas_equalTo(UIScreen.screenWidth);
    }];
    
    DBWeakSelf
    emptyView.reloadBlock = ^{
        DBStrongSelfElseReturn
        [self.view showHudLoading];
        [self getDataSource];
    };
    return emptyView;
}

- (UITableView *)booksTableView{
    if (!_booksTableView){
        _booksTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _booksTableView.estimatedSectionHeaderHeight = 0;
        _booksTableView.estimatedSectionFooterHeight = 0;
        _booksTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.screenWidth, 0.01)];
        _booksTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.screenWidth, 0.01)];
        _booksTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _booksTableView.rowHeight = UITableViewAutomaticDimension;
        _booksTableView.showsVerticalScrollIndicator = NO;
        _booksTableView.showsHorizontalScrollIndicator = NO;
        _booksTableView.delegate = self;
        _booksTableView.dataSource = self;
        _booksTableView.backgroundColor = DBColorExtension.noColor;
        _booksTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        if (@available(iOS 15.0, *)) {
            _booksTableView.sectionHeaderTopPadding = 0;
        }
    }
    return _booksTableView;
}

- (UIView *)listView{
    return self.view;
}

- (BOOL)hiddenLeft{
    return YES;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    if (DBColorExtension.userInterfaceStyle) {
        self.view.backgroundColor = DBColorExtension.blackAltColor;
    }else{
        self.view.backgroundColor = DBColorExtension.noColor;
    }
}
@end
