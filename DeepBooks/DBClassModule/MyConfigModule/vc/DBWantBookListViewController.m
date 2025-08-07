//
//  DBWantBookListViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/26.
//

#import "DBWantBookListViewController.h"
#import "DBWantBookListTableViewCell.h"
#import "DBWantBookListModel.h"
@interface DBWantBookListViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@end

@implementation DBWantBookListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
    [self getDataSource];
}

- (void)setUpSubViews{
    [self.view addSubviews:@[self.listRollingView]];

    [self.listRollingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.listRollingView.emptyDataSetSource = self;
    self.listRollingView.emptyDataSetDelegate = self;
    
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

- (void)getDataSource{
    NSString *page = [NSString stringWithFormat:@"%ld",self.currentPage];
    NSDictionary *parameInterface = @{@"page":page};
    [self.view showHudLoading];
    [DBAFNetWorking getServiceRequestType:DBLinkUserAskBookList combine:nil parameInterface:parameInterface modelClass:DBWantBookListModel.class serviceData:^(BOOL successfulRequest, DBWantBookListModel *result, NSString * _Nullable message) {
        [self.view removeHudLoading];
        [self.listRollingView.mj_header endRefreshing];
        [self.listRollingView.mj_footer endRefreshing];
        if (successfulRequest){
            NSMutableArray *dataList = [NSMutableArray arrayWithArray:self.currentPage==1?@[]:self.dataList];
            [dataList addObjectsFromArray:result.lists];
            self.dataList = dataList;
            [self.listRollingView reloadData];
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
    DBWantBookListTableViewCell *cell = [DBWantBookListTableViewCell initWithTableView:tableView];
    cell.model = self.dataList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DBWantBookModel *model = self.dataList[indexPath.row];
    if (model.book_id.intValue > 0){
        [DBRouter openPageUrl:DBBookDetail params:@{@"bookId":DBSafeString(model.book_id)}];
    }
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    DBEmptyView *emptyView = [[DBEmptyView alloc] init];
    emptyView.imageObj = [UIImage imageNamed:@"empty_icon"];
    emptyView.content = @"暂无求书历史";
    [scrollView addSubview:emptyView];
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.width.mas_equalTo(UIScreen.screenWidth);
    }];
    return emptyView;
}

- (UIView *)listView{
    return self.view;
}

- (BOOL)hiddenLeft{
    return YES;
}
@end
