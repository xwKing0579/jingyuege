//
//  DBTypeBooksListViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/22.
//

#import "DBTypeBooksListViewController.h"
#import "DBTypeBooksView.h"
#import "DBTypeBookModel.h"
#import "DBTypeBookTableViewCell.h"
@interface DBTypeBooksListViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) DBTypeBooksView *topView;

@end

@implementation DBTypeBooksListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentPage = 1;
    [self setUpSubViews];
    [self getDataSource];
    [self loadingTopAdView:YES];
}

- (void)setUpSubViews{
    self.title = self.typeModel.ltype_name;
    [self.view addSubviews:@[self.navLabel,self.topView,self.listRollingView]];
    
    [self.navLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(UIScreen.navbarSafeHeight);
        make.height.mas_equalTo(UIScreen.navbarNetHeight);
    }];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.navLabel.mas_bottom);
    }];
    [self.listRollingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.topView.mas_bottom);
    }];
    
    DBWeakSelf
    self.listRollingView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        DBStrongSelfElseReturn
        self.currentPage = 1;
        [self getDataSource];
    }];
    
    self.listRollingView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        DBStrongSelfElseReturn
        [self getDataSource];
    }];
}

- (void)loadingTopAdView:(BOOL)reload{
    DBWeakSelf
    [DBUnityAdConfig.manager openBannerAdSpaceType:DBAdSpaceBookCityCategoryTop showAdController:self reload:reload completion:^(UIView * _Nonnull adContainerView) {
        DBStrongSelfElseReturn
        if (!adContainerView) return;
        
        if ([self.adContainerView isEqual:adContainerView]) {
            [self.adContainerView removeFromSuperview];
            [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.navLabel.mas_bottom);
            }];
            
            self.adContainerView = nil;
        }else{
            if (self.adContainerView) [self.adContainerView removeFromSuperview];
            
            [self.view addSubview:adContainerView];
            [adContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(0);
                make.size.mas_equalTo(adContainerView.size);
                make.top.mas_equalTo(self.navLabel.mas_bottom);
            }];
            
            [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.navLabel.mas_bottom).offset(adContainerView.size.height);
            }];
            
            self.adContainerView = adContainerView;
        }
    }];
}

- (void)getDataSource{
    NSString *page = [NSString stringWithFormat:@"%ld",self.currentPage];
    NSDictionary *combine = @{@"sex":self.sex,@"ltype":DBSafeString(self.typeModel.ltype_id),@"stype":self.topView.stype,@"end":self.topView.end,@"score":self.topView.score,@"page":page};
    [self.view showHudLoading];
    [DBAFNetWorking getServiceRequestType:DBLinkBookClassifyWhole combine:combine parameInterface:nil modelClass:DBTypeBookListModel.class serviceData:^(BOOL successfulRequest, DBTypeBookListModel *result, NSString * _Nullable message) {
        [self.view removeHudLoading];
        [self.listRollingView.mj_header endRefreshing];
        [self.listRollingView.mj_footer endRefreshing];
        if (successfulRequest){
            NSMutableArray *dataList = [NSMutableArray arrayWithArray:self.currentPage==1?@[]:self.dataList];
            [dataList addObjectsFromArray:result.lists];
            self.dataList = dataList;
            self.listRollingView.emptyDataSetSource = self;
            self.listRollingView.emptyDataSetDelegate = self;
            [self.listRollingView reloadData];
            if (DBCommonConfig.switchAudit){
                [self.listRollingView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            if (self.dataList.count > 0){
                self.currentPage++;
            }else{
                [self.listRollingView.mj_footer endRefreshingWithNoMoreData];
            }
            self.listRollingView.mj_footer.hidden = self.dataList.count == 0;
        }else{
            [self.view showAlertText:message];
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DBTypeBookTableViewCell *cell = [DBTypeBookTableViewCell initWithTableView:tableView];
    cell.model = self.dataList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DBTypeBookModel *model = self.dataList[indexPath.row];
    [DBRouter openPageUrl:DBBookDetail params:@{@"bookId":DBSafeString(model.book_id)}];
}

- (DBTypeBooksView *)topView{
    if (!_topView){
        _topView = [[DBTypeBooksView alloc] init];
        _topView.typeModel = self.typeModel;
        
        DBWeakSelf
        _topView.filterBlock = ^{
            DBStrongSelfElseReturn
            self.currentPage = 1;
            [self getDataSource];
        };
    }
    return _topView;
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    DBEmptyView *emptyView = [[DBEmptyView alloc] init];
    emptyView.imageObj = [UIImage imageNamed:@"empty_icon"];
    emptyView.content = @"暂无书籍数据";
    emptyView.dataList = self.dataList;
    [scrollView addSubview:emptyView];
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.width.mas_equalTo(UIScreen.screenWidth);
    }];
    return emptyView;
}
@end
