//
//  DBBooksCategoryViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/3.
//

#import "DBBooksCategoryViewController.h"
#import "DBBooksCategoryTableViewCell.h"
#import "DBAuthorBooksModel.h"
@interface DBBooksCategoryViewController ()

@end

@implementation DBBooksCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
    [self.view showHudLoading];
    [self getDataSource];
}

- (void)setUpSubViews{
    self.title = self.nameString;
    self.currentPage = 1;
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
    NSString *sex = [DBCommonConfig bookGenderType:self.index];
    NSDictionary *combine = @{@"sex":sex,@"category":DBSafeString(self.category),@"data_conf":@"2",@"page":page};
    [DBAFNetWorking getServiceRequestType:DBLinkBookQualityChoiceMore combine:combine parameInterface:nil modelClass:DBAuthorBooksModel.class serviceData:^(BOOL successfulRequest, NSArray *result, NSString * _Nullable message) {
        [self.view removeHudLoading];
        [self.listRollingView.mj_footer endRefreshing];
        if (successfulRequest){
            NSMutableArray *dateList = [NSMutableArray arrayWithArray:self.dataList];
            [dateList addObjectsFromArray:result];
            self.dataList = dateList;
            [self.listRollingView reloadData];
            
            if (result.count < 20) {
                [self.listRollingView.mj_footer endRefreshingWithNoMoreData];
            }
            self.currentPage++;
        }else{
            [self.view showAlertText:message];
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DBBooksCategoryTableViewCell *cell = [DBBooksCategoryTableViewCell initWithTableView:tableView];
    cell.model = self.dataList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DBAuthorBooksModel *model = self.dataList[indexPath.row];
    [DBRouter openPageUrl:DBBookDetail params:@{@"bookId":DBSafeString(model.book_id)}];
}


@end
