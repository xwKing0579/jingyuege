//
//  DBAuthorBooksViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/2.
//

#import "DBAuthorBooksViewController.h"
#import "DBAuthorBooksTableViewCell.h"
#import "DBAuthorBooksModel.h"

@interface DBAuthorBooksViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@end

@implementation DBAuthorBooksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
    [self getDataSource];
}

- (void)setUpSubViews{
    self.title = @"作者书单";
    [self.view addSubviews:@[self.navLabel,self.listRollingView]];
    [self.navLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(UIScreen.navbarSafeHeight);
        make.height.mas_equalTo(UIScreen.navbarNetHeight);
    }];
    [self.listRollingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.navLabel.mas_bottom).offset(10);
    }];
}

- (void)getDataSource{
    NSDictionary *parameInterface = @{@"author":DBSafeString(self.autherName),@"form":@"0"};
    [DBAFNetWorking getServiceRequestType:DBLinkBookAuthorRelate combine:nil parameInterface:parameInterface modelClass:DBAuthorBooksModel.class serviceData:^(BOOL successfulRequest, NSArray <DBAuthorBooksModel *> *result, NSString * _Nullable message) {
        if (successfulRequest){
            self.dataList = result;
            self.listRollingView.emptyDataSetSource = self;
            self.listRollingView.emptyDataSetDelegate = self;
            [self.listRollingView reloadData];
        }else{
            [self.view showAlertText:message];
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DBAuthorBooksTableViewCell *cell = [DBAuthorBooksTableViewCell initWithTableView:tableView];
    cell.model = self.dataList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DBAuthorBooksModel *model = self.dataList[indexPath.row];
    [DBRouter openPageUrl:DBBookDetail params:@{@"bookId":DBSafeString(model.book_id)}];
}


- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    DBEmptyView *emptyView = [[DBEmptyView alloc] init];
    emptyView.imageObj = [UIImage imageNamed:@"empty_icon"];
    emptyView.content = @"暂无书单数据";
    emptyView.dataList = self.dataList;
    [scrollView addSubview:emptyView];
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.width.mas_equalTo(UIScreen.screenWidth);
    }];
    return emptyView;
}
@end
