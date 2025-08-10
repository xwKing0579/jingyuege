//
//  DBCollectionIndexViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/8/4.
//

#import "DBCollectionIndexViewController.h"
#import "DBBooksDataModel.h"
#import "DBBooksStyle1TableViewCell.h"

@interface DBCollectionIndexViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@end

@implementation DBCollectionIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
    [self getDataSource];
    [self loadingTopAdView:YES];
}

- (void)setUpSubViews{
    self.currentPage = 1;
    self.view.backgroundColor = DBColorExtension.noColor;
    self.listRollingView.backgroundColor = DBColorExtension.noColor;
    [self.view addSubviews:@[self.listRollingView]];
    [self.listRollingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
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
            [self.listRollingView mas_updateConstraints:^(MASConstraintMaker *make) {
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
            
            self.adContainerView = adContainerView;
        }
    }];
}

- (void)getDataSource{
    NSString *sex = [NSString stringWithFormat:@"%ld",self.index+1];
    NSString *page = [NSString stringWithFormat:@"%ld",self.currentPage];
    NSDictionary *combine = @{@"sex":sex,@"page":page};
    [DBAFNetWorking getServiceRequestType:DBLinkBookThemeCollectMore combine:combine parameInterface:nil modelClass:nil serviceData:^(BOOL successfulRequest, NSDictionary *result, NSString * _Nullable message) {
        [self.listRollingView.mj_header endRefreshing];
        [self.listRollingView.mj_footer endRefreshing];
        if (successfulRequest){
            NSArray *lists = [NSArray modelArrayWithClass:DBBooksDataModel.class json:result[@"lists"]];
            NSMutableArray *dataList = [NSMutableArray arrayWithArray:self.currentPage==1?@[]:self.dataList];
            [dataList addObjectsFromArray:lists];
            self.dataList = dataList;
            
            if (lists.count < 20) {
                [self.listRollingView.mj_footer endRefreshingWithNoMoreData];
            }else{
                self.currentPage++;
            }
            self.listRollingView.mj_footer.hidden = self.dataList.count == 0;
        }else{
            [self.view showAlertText:message];
        }
        
        self.listRollingView.emptyDataSetSource = self;
        self.listRollingView.emptyDataSetDelegate = self;
        [self.listRollingView reloadData];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DBBooksStyle1TableViewCell *cell = [DBBooksStyle1TableViewCell initWithTableView:tableView];
    cell.model = self.dataList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DBBooksDataModel *model = self.dataList[indexPath.row];
    [DBRouter openPageUrl:DBBooksList params:@{@"list_id":DBSafeString(model.list_id)}];
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    DBEmptyView *emptyView = [[DBEmptyView alloc] init];
    emptyView.imageObj = [UIImage imageNamed:@"jjNullCanvas"];
    emptyView.content = DBConstantString.ks_noBooklists;
    emptyView.dataList = self.dataList;
    [scrollView addSubview:emptyView];
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.width.mas_equalTo(UIScreen.screenWidth);
    }];
    
    DBWeakSelf
    emptyView.reloadBlock = ^{
        DBStrongSelfElseReturn
        [self getDataSource];
    };
    return emptyView;
}

- (UIView *)listView{
    return self.view;
}

- (BOOL)hiddenLeft{
    return YES;
}

@end
