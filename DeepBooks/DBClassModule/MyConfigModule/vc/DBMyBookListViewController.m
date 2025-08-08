//
//  DBMyBookListViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/3.
//

#import "DBMyBookListViewController.h"
#import "DBMyBookListTableViewCell.h"
#import "DBMyBookListModel.h"
#import "DBBooksListModel.h"
@interface DBMyBookListViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@end

@implementation DBMyBookListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubViews];
   
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getDataSource];
}

- (void)setUpSubViews{
    self.title = DBConstantString.ks_myBooklists;
    [self.view addSubviews:@[self.navLabel,self.listRollingView]];
    [self.navLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(UIScreen.navbarSafeHeight);
        make.height.mas_equalTo(UIScreen.navbarNetHeight);
    }];
    [self.listRollingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.navLabel.mas_bottom);
    }];
    
    self.listRollingView.emptyDataSetSource = self;
    self.listRollingView.emptyDataSetDelegate = self;
    
    DBWeakSelf
    self.listRollingView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        DBStrongSelfElseReturn
        [self getDataSource];
    }];
    self.listRollingView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        DBStrongSelfElseReturn
        [self getDataSource];
    }];
}

- (void)getDataSource{
    NSString *page = [NSString stringWithFormat:@"%ld",self.currentPage];
    NSDictionary *parameInterface = @{@"limit":@"20",@"page":page};
    [DBAFNetWorking getServiceRequestType:DBLinkBookThemeCollectList combine:nil parameInterface:parameInterface modelClass:DBBookIdsListModel.class serviceData:^(BOOL successfulRequest, DBBookIdsListModel *result, NSString * _Nullable message) {
        [self.listRollingView.mj_header endRefreshing];
        [self.listRollingView.mj_footer endRefreshing];
        if (successfulRequest){
            [self getBookListWithBookIds:result.lists];
            if (result.lists.count < 20){
                [self.listRollingView.mj_footer endRefreshingWithNoMoreData];
            }else{
                self.currentPage++;
            }
            self.listRollingView.mj_footer.hidden = self.dataList.count == 0;
        }else{
            [self.view showAlertText:message];
        }
    }];
}

- (void)getBookListWithBookIds:(NSArray *)bookIds{
    dispatch_group_t group = dispatch_group_create();
    
    for (DBBookIdModel *idModel in bookIds) {
        dispatch_group_enter(group);
        NSInteger index = [idModel.list_id integerValue]/1000;
        NSDictionary *combine = @{@"list_id":DBSafeString(idModel.list_id),@"index":[NSString stringWithFormat:@"%ld",index]};
        [DBAFNetWorking getServiceRequestType:DBLinkBookThemeDetailData combine:combine parameInterface:nil modelClass:DBBooksListModel.class serviceData:^(BOOL successfulRequest, DBBooksListModel *result, NSString * _Nullable message) {
            if (successfulRequest){
                NSMutableArray *dataList = [NSMutableArray arrayWithArray:self.dataList];
                [dataList addObject:result];
                self.dataList = dataList;
            }else{
                [self.view showAlertText:message];
            }
            dispatch_group_leave(group);
        }];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSMutableArray *dataList = [NSMutableArray array];
        for (DBBookIdModel *idModel in bookIds) {
            for (DBBooksListModel *bookListModel in self.dataList) {
                if ([idModel.list_id isEqualToString:bookListModel.list_id]){
                    [dataList addObject:bookListModel];
                    break;
                }
            }
        }
        self.dataList = dataList;
        [self.listRollingView reloadData];
    });
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DBMyBookListTableViewCell *cell = [DBMyBookListTableViewCell initWithTableView:tableView];
    cell.model = self.dataList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DBBooksListModel *model = self.dataList[indexPath.row];
    [DBRouter openPageUrl:DBBooksList params:@{@"list_id":DBSafeString(model.list_id),@"isCollected":@1}];
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    DBEmptyView *emptyView = [[DBEmptyView alloc] init];
    emptyView.imageObj = [UIImage imageNamed:@"jjNullCanvas"];
    emptyView.content = DBConstantString.ks_noCollections;
    [scrollView addSubview:emptyView];
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.width.mas_equalTo(UIScreen.screenWidth);
    }];
    return emptyView;
}
@end
