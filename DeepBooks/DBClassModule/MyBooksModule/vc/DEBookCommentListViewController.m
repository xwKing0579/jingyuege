//
//  DEBookCommentListViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/2.
//

#import "DEBookCommentListViewController.h"
#import "DEBookCommentListTableViewCell.h"
#import "DEBookCommentListModel.h"
@interface DEBookCommentListViewController ()<UIScrollViewDelegate>
@property (nonatomic, assign) BOOL scrollEnable;
@property (nonatomic, assign) CGFloat offsetY;
@end

@implementation DEBookCommentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubViews];
    [self getDataSource];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(tableViewScrollEnable:) name:DBTableViewEnable object:nil];
}

- (void)setUpSubViews{
    self.currentPage = 1;
    self.listRollingView.multipleGestures = YES;
    [self.view addSubview:self.listRollingView];
    [self.listRollingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    DBWeakSelf
    self.listRollingView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        DBStrongSelfElseReturn
        [self resetDataSource];
    }];

    self.listRollingView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        DBStrongSelfElseReturn
        [self getDataSource];
    }];
}

- (void)resetDataSource{
    self.currentPage = 1;
    [self getDataSource];
}

- (void)getDataSource{
    NSString *type = [NSString stringWithFormat:@"%ld",self.index];
    NSString *page = [NSString stringWithFormat:@"%ld",self.currentPage];
    NSDictionary *parameInterface = @{@"book_id":DBSafeString(self.book_id),@"type":type,@"page":page};
    [DBAFNetWorking getServiceRequestType:DBLinkCommentList combine:nil parameInterface:parameInterface modelClass:DEBookCommentListModel.class serviceData:^(BOOL successfulRequest, DEBookCommentListModel *result, NSString * _Nullable message) {
        [self.listRollingView.mj_header endRefreshing];
        [self.listRollingView.mj_footer endRefreshing];
        if (successfulRequest){
            //后端数据异常这里处理一下
            if (result.lists.count == 0){
                [self.listRollingView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            
            NSMutableArray *dataList = [NSMutableArray arrayWithArray:self.currentPage==1?@[]:self.dataList];
            [dataList addObjectsFromArray:result.lists];
            self.dataList = dataList;
            [self.listRollingView reloadData];
            if (self.dataList.count > 0){
                self.currentPage++;
            }else{
                [self.listRollingView.mj_footer endRefreshingWithNoMoreData];
            }
        }else{
            [self.view showAlertText:message];
        }
    }];
}

- (void)tableViewScrollEnable:(NSNotification *)noti{
    self.scrollEnable = [noti.userInfo[@"enable"] boolValue];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!self.scrollEnable){
        [scrollView setContentOffset:CGPointMake(0, self.offsetY) animated:NO];
        return;
    }
    self.offsetY = scrollView.contentOffset.y;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DEBookCommentListTableViewCell *cell = [DEBookCommentListTableViewCell initWithTableView:tableView];
    cell.model = self.dataList[indexPath.row];
    cell.bookName = self.bookName;
    return cell;
}

- (void)setDarkModel{
    [super setDarkModel];
    [self.listRollingView reloadData];
}

- (UIView *)listView{
    return self.view;
}

- (BOOL)hiddenLeft{
    return YES;
}

@end
