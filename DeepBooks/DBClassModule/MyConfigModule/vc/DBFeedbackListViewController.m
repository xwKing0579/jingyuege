//
//  DBFeedbackListViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/26.
//

#import "DBFeedbackListViewController.h"
#import "DBFeedbackListTableViewCell.h"
#import "DBFeedbackModel.h"
@interface DBFeedbackListViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@end

@implementation DBFeedbackListViewController

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
        [self getDataSource];
    }];
}

- (void)getDataSource{
    [self.view showHudLoading];
    [DBAFNetWorking getServiceRequestType:DBLinkFeedBackList combine:nil parameInterface:nil modelClass:DBFeedbackModel.class serviceData:^(BOOL successfulRequest, id result, NSString * _Nullable message) {
        [self.view removeHudLoading];
        [self.listRollingView.mj_header endRefreshing];
        if (successfulRequest){
            self.dataList = result;
            [self.listRollingView reloadData];
        }else{
            [self.view showAlertText:message];
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DBFeedbackListTableViewCell *cell = [DBFeedbackListTableViewCell initWithTableView:tableView];
    cell.model = self.dataList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    DBEmptyView *emptyView = [[DBEmptyView alloc] init];
    emptyView.imageObj = [UIImage imageNamed:@"jjNullCanvas"];
    emptyView.content = DBConstantString.ks_noFeedbackHistory;
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
